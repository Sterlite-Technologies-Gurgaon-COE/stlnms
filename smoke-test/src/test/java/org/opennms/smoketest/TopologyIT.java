/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2016-2021 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2021 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

package org.opennms.smoketest;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.not;
import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.opennms.features.topology.link.Layout;
import org.opennms.features.topology.link.TopologyProvider;
import org.opennms.netmgt.events.api.EventConstants;
import org.opennms.netmgt.model.events.EventBuilder;
import org.opennms.smoketest.selenium.AbstractOpenNMSSeleniumHelper;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.base.MoreObjects;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

/**
 * Generic tests for the Topology UI that do not require any elements
 * to be present in the database.
 *
 * Provides utilities that can be used for more specific tests.
 *
 * @author jwhite
 */
public class TopologyIT extends OpenNMSSeleniumIT {

    private static final Logger LOG = LoggerFactory.getLogger(TopologyIT.class);

    private static final int DEFAULT_MENU_RETRIES = 3;
    public static int IMPLICIT_WAIT_SECONDS = 2;

    private TopologyUIPage topologyUiPage;

    /**
     * Represents a vertex that is focused using
     * criteria listed bellow the search bar.
     */
    public static class FocusedVertex {
        private final TopologyUIPage ui;
        private final String namespace;
        private final String label;

        public FocusedVertex(TopologyUIPage ui, String namespace, String label) {
            this.ui = Objects.requireNonNull(ui);
            this.namespace = Objects.requireNonNull(namespace);
            this.label = Objects.requireNonNull(label);
        }

        public String getNamespace() {
            return namespace;
        }

        public String getLabel() {
            return label;
        }

        public void centerOnMap() {
            getElement().findElement(By.xpath("//a[@class='icon-location-arrow']")).click();
            waitForTransition(ui.testCase);
        }

        public void removeFromFocus() {
            try {
                ui.testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                getElement().findElement(By.xpath("//a[@class='icon-remove']")).click();
                waitForTransition(ui.testCase);
            } finally {
                ui.testCase.setImplicitWait();
            }
        }

        public void expand() throws NoSuchElementException {
            try {
                ui.testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                getElement().findElement(By.xpath("//a[@class='gwt-Anchor icon-plus']")).click();
                waitForTransition(ui.testCase);
            } finally {
                ui.testCase.setImplicitWait();
            }
        }

        public void collapse() throws NoSuchElementException {
            try {
                ui.testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                getElement().findElement(By.xpath("//a[@class='gwt-Anchor icon-minus']")).click();
                waitForTransition(ui.testCase);
            } finally {
                ui.testCase.setImplicitWait();
            }
        }

        private WebElement getElement() {
            return ui.testCase.findElementByXpath("//*/table[@class='search-token-field']"
                    + "//div[@class='search-token-label' and contains(text(),'" + label + "')]");
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == null) {
                return false;
            }
            if (obj == this) {
                return true;
            }
            if (obj instanceof FocusedVertex) {
                FocusedVertex other = (FocusedVertex) obj;
                boolean equals = Objects.equals(getNamespace(), other.getNamespace())
                        && Objects.equals(getLabel(), other.getLabel())
                        && Objects.equals(ui, other.ui);
                return equals;
            }
            return false;
        }

        @Override
        public int hashCode() {
            return Objects.hash(ui, namespace, label);
        }

        @Override
        public String toString() {
            return MoreObjects.toStringHelper(this)
                    .add("namespace", getNamespace())
                    .add("label", getLabel())
                    .toString();
        }
    }

    /**
     * Represents a vertex that is currently visible on the map.
     */
    public static class VisibleVertex {
        private final AbstractOpenNMSSeleniumHelper testCase;
        private final String label;

        public VisibleVertex(AbstractOpenNMSSeleniumHelper testCase, String label) {
            this.testCase = Objects.requireNonNull(testCase);
            this.label = Objects.requireNonNull(label);
        }

        public String getLabel() {
            return label;
        }

        public Point getLocation() {
            return getElement().getLocation();
        }

        public String getIconName() {
            final String IconXpathExpression = "//*[@id='TopologyComponent']//*[@class='vertex-label' and text()='" +getLabel()+"']/../*[@class='icon-container']/*[@class='upIcon']";
            String iconName = testCase.findElementByXpath(IconXpathExpression).getAttribute("href");
            iconName = iconName.substring(1); // remove the leading '#'
            return iconName;
        }

        public void select() {
            try {
                testCase.setImplicitWait(5, TimeUnit.SECONDS);
                final String iconOverlayXpath = ".//*[@class='svgIconOverlay']";
                getElement().findElement(By.xpath(iconOverlayXpath)).click();

                // Wait until vertex is actually selected before continuing
                new WebDriverWait(testCase.getDriver(), 30).until(input -> {
                    final WebElement element = getElement().findElement(By.xpath(iconOverlayXpath + "/.."));
                    return element.getAttribute("class").contains("selected");
                });
            } finally {
                testCase.setImplicitWait();
            }
        }

        private WebElement getElement() {
            return testCase.findElementByXpath("//*[@id='TopologyComponent']//*[@class='vertex-label' and text()='" + label + "']/..");
        }

        @Override
        public String toString() {
            return String.format("VisibleVertex[label='%s']", label);
        }

        public ContextMenu contextMenu() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                Actions action = new Actions(testCase.getDriver());
                action.contextClick(getElement());
                action.build().perform();
                return new ContextMenu(testCase);
            } finally {
                testCase.setImplicitWait();
            }
        }

        public void changeIcon(String iconName) {
            Objects.requireNonNull(iconName);

            final String oldIconName = getIconName();
            if (!oldIconName.equals(iconName)) {
                this.contextMenu().click("Change Icon");
                final String iconXpath = "//*[name()='title' and text()='" + iconName + "']/../*[name()='rect']";
                try {
                    testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                    testCase.findElementByXpath("//*[contains(text(), 'Change Icon')]");
                    testCase.findElementByXpath(iconXpath).click();
                    new WebDriverWait(testCase.getDriver(), 10).until(input -> {
                        final WebElement elementByXpath = testCase.findElementByXpath(iconXpath);
                        return elementByXpath.getAttribute("class").contains("selected");
                    });
                    testCase.findElementById("iconSelectionDialog.button.ok").click();
                    waitForTransition(testCase);
                } finally {
                    testCase.setImplicitWait();
                }
            }
        }
    }

    public static class PingWindow {
        private final AbstractOpenNMSSeleniumHelper testCase;
        private final ContextMenu contextMenu;

        private PingWindow(AbstractOpenNMSSeleniumHelper testCase, ContextMenu contextMenu) {
            this.testCase = Objects.requireNonNull(testCase);
            this.contextMenu = Objects.requireNonNull(contextMenu);
        }

        private PingWindow open() {
            contextMenu.click("Ping");
            testCase.findElementByXpath("//div[@class='popupContent']//div[@class='v-window-header' and contains(text(), 'Ping')]");
            return this;
        }

        public void close() {
            testCase.findElementByXpath("//div[@class='v-window-closebox']").click();
        }
    }

    /**
     * Represents the Context Menu
     */
    public static class ContextMenu {

        private final AbstractOpenNMSSeleniumHelper testCase;

        public ContextMenu(AbstractOpenNMSSeleniumHelper testCase) {
            this.testCase = Objects.requireNonNull(testCase);
        }

        /**
         * Closes the context menu without clicking on an item
         */
        public void close() {
            testCase.getDriver().findElement(By.id("TopologyComponent")).click();
        }

        public void click(String... menuPath) {
            if (menuPath != null && menuPath.length > 0) {
                try {
                    testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                    for (int i = 0; i < menuPath.length; i++) {
                        final String eachPath = menuPath[i];
                        final WebElement menuElement = testCase.findElementByXpath("//*[@class='v-menubar-popup']//*[@class='v-menubar-submenu']//*[text()='" + eachPath + "']");

                        // If sub-menu selection, navigate to each element in the
                        // menu, until the last one
                        if (i < menuPath.length - 1) {
                            Actions actions = new Actions(testCase.getDriver());
                            actions.moveToElement(menuElement);
                            actions.build().perform();
                        } else { // last element
                            menuElement.click();
                        }
                    }
                    waitForTransition(testCase);
                } finally {
                    testCase.setImplicitWait();
                }
            }
        }

        public void addToFocus() {
            click("Add To Focus");
        }

        public void setAsFocus() {
            click("Set As Focal Point");
        }

        public PingWindow ping() {
            return new PingWindow(testCase, this).open();
        }
    }

    /**
     * Represents the Breadcrumbs
     */
    public static class Breadcrumbs {

        private final AbstractOpenNMSSeleniumHelper testCase;

        public Breadcrumbs(AbstractOpenNMSSeleniumHelper testCase) {
            this.testCase = Objects.requireNonNull(testCase);
        }

        public List<String> getLabels() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                List<WebElement> breadcrumbs = testCase.getDriver().findElements(By.xpath("//*[@id='breadcrumbs']//span[@class='v-button-caption']"));
                return breadcrumbs.stream().map(eachBreadcrumb -> eachBreadcrumb.getText()).collect(Collectors.toList());
            } finally {
                testCase.setImplicitWait();
            }
        }

        public void click(String label) {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                WebElement element = testCase.findElementByXpath("//*[@id='breadcrumbs']//*[contains(text(), '" + label + "')]");
                element.click();
                waitForTransition(testCase);
            } finally {
                testCase.setImplicitWait();
            }
        }
    }

    /**
     * The information of the Topology
     */
    public static class TopologyInfo {
        private final AbstractOpenNMSSeleniumHelper testCase;

        public TopologyInfo(AbstractOpenNMSSeleniumHelper testCase) {
            this.testCase = Objects.requireNonNull(testCase);
        }

        public String getTitle() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                return testCase.findElementByXpath("//*[@id='topologyInfo']/*[1]").getText();
            } finally {
                testCase.setImplicitWait();
            }
        }

        public String getDescription() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                return testCase.findElementByXpath("//*[@id='topologyInfo']/*[2]").getText();
            } finally {
                testCase.setImplicitWait();
            }
        }
    }

    /**
     * Controls the workflow of the "Topology UI" Page
     */
    public static class TopologyUIPage {
        private final AbstractOpenNMSSeleniumHelper testCase;
        private final String topologyUiUrl;

        public TopologyUIPage(AbstractOpenNMSSeleniumHelper testCase, String baseUrl) {
            this.testCase = Objects.requireNonNull(testCase);
            this.topologyUiUrl = Objects.requireNonNull(baseUrl) + "stlnms/topology";
        }

        public TopologyUIPage open() {
            testCase.getDriver().get(topologyUiUrl);
            // Wait for the "View" menu to be clickable and the loading indicator to be gone before
            // returning control to the test in order to make sure that the page is fully loaded
            testCase.wait.until(ExpectedConditions.elementToBeClickable(getCriteriaForMenubarElement("View")));
            testCase.wait.until(ExpectedConditions.invisibilityOfElementLocated(By.className("v-loading-indicator")));
            return this;
        }
 
        public TopologyUIPage clickOnMenuItemsWithLabels(String... labels) {
            return clickOnMenuItemsWithLabelsWithRetries(DEFAULT_MENU_RETRIES, labels);
        }

        private TopologyUIPage clickOnMenuItemsWithLabelsWithRetries(int retries, String... labels) {
            resetMenu();
            Actions actions = new Actions(testCase.getDriver());
            for (String label : labels) {
                try {
                    // we should wait, otherwise the menu has not yet updated
                    waitForTransition(testCase);
                    WebElement menuElement = getMenubarElement(label);
                    actions.moveToElement(menuElement);
                    menuElement.click();
                } catch (NoSuchElementException e) {
                    if (retries > 0) {
                        LOG.info("Failed to click on menu bar element with label: {} in path: {}. Retrying.",
                                label, Arrays.toString(labels));
                        clickOnMenuItemsWithLabelsWithRetries(retries-1, label);
                    } else {
                        throw e;
                    }
                } catch (Throwable e) {
                    LOG.error("Unexpected exception while clicking on menu item {}", label, e);
                    throw e;
                }
            }
            // Wait to give the menu a chance to update
            waitForTransition(testCase);
            return this;
        }

        public TopologyUIPage selectLayout(Layout layout) {
            clickOnMenuItemsWithLabels("View", layout.getLabel());
            waitForTransition(testCase);
            return this;
        }

        public TopologyUIPage selectTopologyProvider(TopologyProvider topologyProvider) {
            Objects.requireNonNull(topologyProvider);
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                clickOnMenuItemsWithLabels("View", topologyProvider.getLabel());
                waitForTransition(testCase); // we have to wait for the UI to re-settle
                return this;
            } finally {
                testCase.setImplicitWait();
            }
        }

        public TopologyUIPage setAutomaticRefresh(boolean enabled) {
            LOG.info("setAutomaticRefresh: {} refresh", enabled ? "enabling" : "disabling");
            boolean alreadyEnabled = isMenuItemChecked("Automatic Refresh", "View");
            if ((alreadyEnabled && !enabled) || (!alreadyEnabled && enabled)) {
                LOG.info("setAutomaticRefresh: toggling setting to {} refresh", enabled ? "enable" : "disable");
                clickOnMenuItemsWithLabels("View", "Automatic Refresh");
            } else {
                LOG.info("setAutomaticRefresh: refresh is already {}", enabled ? "enabled" : "disabled");
                resetMenu(); // ensure menu is reset, otherwise test may fail
            }
            return this;
        }

        public TopologyUIPage refreshNow() {
            testCase.findElementById("refreshNow").click();
            waitForTransition(testCase);
            return this;
        }

        public TopologyUIPage showEntireMap() {
            getShowEntireMapElement().click();
            waitForTransition(testCase);
            return this;
        }

        public TopologyUISearchResults search(String query) {
            testCase.enterText(By.xpath("//*[@id='info-panel-component']//input[@type='text']"), query);
            waitForTransition(testCase);
            return new TopologyUISearchResults(this);
        }

        public List<FocusedVertex> getFocusedVertices() {
            final List<FocusedVertex> verticesInFocus = Lists.newArrayList();
            try {
                // Reduce the timeout so we don't wait around for too long if there are no vertices in focus
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                for (WebElement el : testCase.getDriver().findElements(By.xpath("//*/table[@class='search-token-field']"))) {
                    final String namespace = el.findElement(By.xpath(".//div[@class='search-token-namespace']")).getText();
                    final String label = el.findElement(By.xpath(".//div[@class='search-token-label']")).getText();
                    verticesInFocus.add(new FocusedVertex(this, namespace, label));
                }
            } finally {
                testCase.setImplicitWait();
            }
            return verticesInFocus;
        }

        public List<VisibleVertex> getNotFocusedVertices() {
            final List<FocusedVertex> focusedVertices = getFocusedVertices();
            final List<VisibleVertex> notFocusedVertices = getVisibleVertices()
                    .stream()
                    // Remove all vertices from "visible vertices list" if it is already in focus
                    .filter(visibleVertex ->
                        !focusedVertices.stream()
                                .filter(focusedVertex -> focusedVertex.getLabel().equals(visibleVertex.getLabel()))
                                .findAny()
                                .isPresent())
                    .collect(Collectors.toList());
            return notFocusedVertices;
        }

        public List<VisibleVertex> getVisibleVertices() {
            final List<VisibleVertex> visibleVertices = Lists.newArrayList();
            try {
                // Reduce the timeout so we don't wait around for too long if there are no visible vertices
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                for (WebElement el : testCase.getDriver().findElements(By.xpath("//*[@id='TopologyComponent']//*[@class='vertex-label']"))) {
                    visibleVertices.add(new VisibleVertex(testCase, el.getText()));
                }
            } finally {
                testCase.setImplicitWait();
            }
            return visibleVertices;
        }

        public int getSzl() {
            return Integer.parseInt(testCase.findElementById("szlInputLabel").getText());
        }

        public TopologyUIPage setSzl(int szl) {
            Preconditions.checkArgument(szl >= 0, "The semantic zoom level must be >= 0");
            int currentSzl = Integer.valueOf(testCase.findElementById("szlInputLabel").getText()).intValue();
            if (szl != currentSzl) {
                boolean shouldIncrease = currentSzl - szl< 0;
                WebElement button = testCase.findElementById(shouldIncrease ? "szlInBtn" : "szlOutBtn");
                for (int i=0; i < Math.abs(szl - currentSzl); i++) {
                    button.click();
                }
                waitForTransition(testCase);
            }
            return this;
        }

        /**
         * Convenient method to clear the focus.
         */
        public void clearFocus() {
            for (TopologyIT.FocusedVertex focusedVerted : getFocusedVertices()) {
                focusedVerted.removeFromFocus();
            }
	    testCase.wait.until(ExpectedConditions.invisibilityOfElementLocated(By.className("v-loading-indicator")));
            assertEquals(0, getFocusedVertices().size());
        }

        public Layout getSelectedLayout() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                clickOnMenuItemsWithLabels("View"); // we have to click the View menubar, otherwise the menu elements are NOT visible
                List<WebElement> elements = testCase.getDriver().findElements(By.xpath("//span[@class='v-menubar-menuitem v-menubar-menuitem-checked']"));
                for (WebElement eachElement : elements) {
                    Layout layout = Layout.createFromLabel(eachElement.getText());
                    if (layout != null) {
                        return layout;
                    }
                }
                throw new RuntimeException("No Layout is selected. This should not be possible");
            } finally {
                resetMenu(); // finally reset the menu
                testCase.setImplicitWait();
            }
        }

        public void selectLayer(String layerName) {
            Objects.requireNonNull(layerName, "The layer name cannot be null");
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                openLayerSelectionComponent();
                WebElement layerElement = testCase.findElementById("layerComponent").findElement(By.xpath("//div[text() = '" + layerName + "']"));
                layerElement.click();
                waitForTransition(testCase);
            } finally {
                testCase.setImplicitWait();
            }
        }

        public VisibleVertex findVertex(String label) {
            return getVisibleVertices().stream().filter(eachVertex -> eachVertex.getLabel().equals(label)).findFirst().orElse(null);
        }

        public String getSelectedLayer() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                openLayerSelectionComponent();
                WebElement selectedLayer = testCase.findElementByXpath("//div[@id='layerComponent']//div[contains(@class, 'selected')]//div[contains(@class, 'v-label')]");
                if (selectedLayer != null) {
                    return selectedLayer.getText();
                }
                return null;
            } finally {
                testCase.setImplicitWait();
            }
        }

        public Breadcrumbs getBreadcrumbs() {
            return new Breadcrumbs(testCase);
        }

        private void openLayerSelectionComponent() {
            if (!isLayoutComponentVisible()) {
                testCase.findElementById("layerToggleButton").click();
            }
        }

        /**
         * Returns if the layerToggleButton has been pressed already and the layers are visible.
         *
         * @return true if the layerToggleButton has been pressed already and the layers are visible, otherwise false
         */
        private boolean isLayoutComponentVisible() {
            WebElement layerToggleButton = testCase.findElementById("layerToggleButton");
            return layerToggleButton.getCssValue("class").contains("expanded");
        }

        private WebElement getMenubarElement(String itemName) {
            return testCase.getDriver().findElement(getCriteriaForMenubarElement(itemName));
        }

        private By getCriteriaForMenubarElement(String itemName) {
            return By.xpath("//span[@class='v-menubar-menuitem-caption' and text()='" + itemName + "']/parent::*");
        }

        private WebElement getShowEntireMapElement() {
            return testCase.findElementById("showEntireMapBtn");
        }

        private void resetMenu() {
            // The menu can act weirdly if we're already hovering over it so we mouse-over to
            // a known element off of the menu, and click a couples times just to make sure
            WebElement showEntireMap = getShowEntireMapElement();
            Actions actions = new Actions(testCase.getDriver());
            actions.moveToElement(showEntireMap);
            actions.clickAndHold();
            waitForTransition(testCase);
            actions.release();
            showEntireMap.click();
        }

        private boolean isMenuItemChecked(String itemName, String... path) {
            return isMenuItemCheckedWithRetries(DEFAULT_MENU_RETRIES, itemName, path);
        }

        private boolean isMenuItemCheckedWithRetries(int retries, String itemName, String... path) {
            try {
                // Disable retries, since we're already in a retry loop
                clickOnMenuItemsWithLabelsWithRetries(0, path);

                final WebElement automaticRefresh = getMenubarElement(itemName);
                final String cssClasses = automaticRefresh.getAttribute("class");
                if (cssClasses != null) {
                    if (cssClasses.contains("-unchecked")) {
                        return false;
                    } else if (cssClasses.contains("-checked")) {
                        return true;
                    } else {
                        throw new RuntimeException("Unknown CSS classes '" + cssClasses + "'."
                                    + " Unable to determine if the item is checked or unchecked.");
                    }
                } else {
                    throw new RuntimeException("Element has no CSS classes!"
                            + " Unable to determine if the item is checked or unchecked.");
                }
            } catch (NoSuchElementException e) {
                if (retries > 0) {
                    LOG.info("Failed to find one or more elements in menu path: {} for item: {}. Retrying.",
                            Arrays.toString(path), itemName);
                    return isMenuItemCheckedWithRetries(retries-1, itemName, path);
                } else {
                    throw e;
                }
            }
        }

        public void defaultFocus() {
            clearFocus();
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                testCase.findElementById("defaultFocusBtn").click();
                waitForTransition(testCase);
            } finally {
                testCase.setImplicitWait();
            }
        }

        public SaveLayoutButton getSaveLayoutButton() {
            return new SaveLayoutButton(testCase);
        }

        public boolean isSimulationModeEnabled() {
            try {
                testCase.setImplicitWait(IMPLICIT_WAIT_SECONDS, TimeUnit.SECONDS);
                testCase.findElementByXpath("//*[@id='info-panel-component']//div[text() = 'Simulation Mode Enabled']");
                return true;
            } catch (NoSuchElementException e) {
                return false;
            } finally {
                testCase.setImplicitWait();
            }
        }

        public TopologyInfo getTopologyInfo() {
            return new TopologyInfo(testCase);
        }

        public TopologyUIPage searchAndSelect(String query) {
            search(query).selectItemThatContains(query);
            return this;
        }

        public NoFocusDefinedWindow getNoFocusDefinedWindow() {
            return new NoFocusDefinedWindow(testCase);
        }

        public BrowserTab getTab(String tab) {
            return new BrowserTab(testCase, tab);
        }
    }

    public interface Tabs {
        String Alarms = "Alarms";
        String Nodes = "Nodes";
        String BusinessServices = "Business Services";
        String Applications = "Applications";
    }

    public static class BrowserTab {
        private final AbstractOpenNMSSeleniumHelper testCase;
        private final String tab;

        private BrowserTab(AbstractOpenNMSSeleniumHelper testCase, String tab) {
            this.tab = Objects.requireNonNull(tab);
            this.testCase = Objects.requireNonNull(testCase);
        }

        private WebElement getElement() {
            String xpath = String.format("//*[@class='v-captiontext' and text() = '%s']", tab);
            final WebElement tabElement = testCase.findElementByXpath(xpath);
            if (!tabElement.isDisplayed()) {
                throw new IllegalStateException("You are trying to access a non visible Browser Tab. Bailing");
            }
            return tabElement;
        }

        public void click() {
            getElement().click();
        }

        public BrowserRow getRowByLabel(String label) {
            return new BrowserRow(this, label);
        }
    }

    public static class BrowserRow {

        private final BrowserTab tab;
        private final String label;

        public BrowserRow(BrowserTab tab, String label) {
            this.tab = Objects.requireNonNull(tab);
            this.label = Objects.requireNonNull(label);
        }

        private WebElement getElement() {
            String xpath = String.format("//table//td//*[text() = '%s']", label);
            final WebElement labelElement = tab.testCase.findElementByXpath(xpath);
            return labelElement;
        }

        public void click() {
            getElement().click();
        }
    }

    public static class NoFocusDefinedWindow {
        private final AbstractOpenNMSSeleniumHelper testCase;

        private NoFocusDefinedWindow(AbstractOpenNMSSeleniumHelper testCase) {
            this.testCase = Objects.requireNonNull(testCase);
        }

        private WebElement getElement() {
            try {
                // Reduce the timeout so we don't wait around for too long if there are no vertices in focus
                testCase.setImplicitWait(5, TimeUnit.SECONDS);
                return testCase.findElementById("no-focus-defined-window");
            } finally {
                testCase.setImplicitWait();
            }
        }

        public boolean isVisible() {
            try {
                return getElement().isDisplayed();
            } catch (NoSuchElementException e) {
                return false;
            }
        }

        public boolean isNoVerticesFoundTextVisible() {
            try {
                testCase.setImplicitWait(5, TimeUnit.SECONDS);
                getElement().findElement(By.xpath((".//*[contains(text(), 'No vertices found')]")));
                return true;
            } catch (NoSuchElementException e) {
                return false;
            } finally {
                testCase.setImplicitWait();
            }
        }
    }

    public static class SaveLayoutButton {
        private final AbstractOpenNMSSeleniumHelper testCase;

        private SaveLayoutButton(AbstractOpenNMSSeleniumHelper testCase) {
            this.testCase = Objects.requireNonNull(testCase);
        }

        public boolean isEnabled() {
            String disabled = getButton().getAttribute("aria-disabled");
            return !"true".equalsIgnoreCase(disabled);
        }

        public void click() {
            getButton().click();
            waitForTransition(testCase);
        }

        private WebElement getButton() {
            WebElement saveLayerButton = testCase.findElementById("saveLayerButton");
            Objects.requireNonNull(saveLayerButton);
            return saveLayerButton;
        }
    }

    public static class TopologyUISearchResults {
        private static final String XPATH = "//*/td[@role='menuitem']/div[contains(text(),'%s')]";

        private final TopologyUIPage ui;

        public TopologyUISearchResults(TopologyUIPage ui) {
            this.ui = Objects.requireNonNull(ui);
        }

        public TopologyUIPage selectItemThatContains(String substring) {
            ui.testCase.findElementByXpath(String.format(XPATH, substring)).click();
            waitForTransition(ui.testCase);
            return ui;
        }

        public long countItemsThatContain(String substring) {
            return ui.testCase.getDriver().findElements(By.xpath(String.format(XPATH, substring))).size();
        }
    }

    public static class TopologyReloadEvent {
        // Send an event to force reload of topology
        public void send() throws InterruptedException, IOException {
            final EventBuilder builder = new EventBuilder(EventConstants.RELOAD_TOPOLOGY_UEI, getClass().getSimpleName());
            builder.setParam(EventConstants.PARAM_TOPOLOGY_NAMESPACE, "all");
            OpenNMSSeleniumIT.stack.opennms().getRestClient().sendEvent(builder.getEvent());
            Thread.sleep(5000); // Wait to allow the event to be processed
        }
    }

    @Before
    public void setUp() {
        topologyUiPage = new TopologyUIPage(this, getBaseUrlInternal());
        topologyUiPage.open();
        topologyUiPage.setAutomaticRefresh(false);
        topologyUiPage.defaultFocus();
    }

    @Test
    public void canSelectKnownLayouts() throws InterruptedException {
        for (Layout layout : Layout.values()) {
            topologyUiPage.selectLayout(layout);
        }
    }

    @Test
    public void canSelectKnownTopologyProviders() throws InterruptedException {
        for (Field eachField : TopologyProvider.class.getDeclaredFields()) {
            try {
                TopologyProvider topologyProvider = (TopologyProvider) eachField.get(null);
                topologyUiPage.selectTopologyProvider(topologyProvider);
            } catch (final IllegalAccessException e) {
                throw new IllegalStateException(e);
            }
        }
    }

    @Test
    public void canToggleAutomaticRefresh() {
        // Disable
        topologyUiPage.setAutomaticRefresh(false)
            .setAutomaticRefresh(false)
            .setAutomaticRefresh(false);

        // Enable
        topologyUiPage.setAutomaticRefresh(true)
            .setAutomaticRefresh(true)
            .setAutomaticRefresh(true);

        // Enable/Disable
        topologyUiPage.setAutomaticRefresh(false)
            .setAutomaticRefresh(true)
            .setAutomaticRefresh(false)
            .setAutomaticRefresh(true);
    }

    // Verifies that the ping operation is available. See NMS-9019
    @Test
    public void verifyPingOperation() throws InterruptedException, IOException {
        createDummyNode();

        // Find Node and try select ping from context menu
        topologyUiPage.selectTopologyProvider(TopologyProvider.ENLINKD);
        topologyUiPage.clearFocus();
        topologyUiPage.refreshNow();
        topologyUiPage.search("Dummy Node").selectItemThatContains("Dummy Node");
        PingWindow pingWindow = topologyUiPage.findVertex("Dummy Node").contextMenu().ping();
        pingWindow.close();
    }

    @Test
    public void verifyCollapsibleCriteriaPersistence() throws IOException, InterruptedException {
        createDummyNode();

        // Search for category and select
        topologyUiPage.search("Routers").selectItemThatContains("Routers");
        List<FocusedVertex> focusedVertices = topologyUiPage.getFocusedVertices();
        Assert.assertNotNull(focusedVertices);
        Assert.assertEquals(1, focusedVertices.size());

        logout();
        login();

        topologyUiPage.open();
        focusedVertices = topologyUiPage.getFocusedVertices();
        Assert.assertNotNull(focusedVertices);
        Assert.assertEquals(1, focusedVertices.size());
        Assert.assertEquals("Routers", focusedVertices.get(0).getLabel());

        topologyUiPage.clearFocus();
    }

    /**
     * Verifies that the ip-like search produces no duplicates
     * (issue NMS-9265 - by typing a complete ip address in the search box IpLikeSearchProvider returned 2 identical items)
     */
    @Test
    public void verifyIpLikeSearchNoDuplicates() throws IOException, InterruptedException {
        createDummyNode();
        Assert.assertEquals(1, topologyUiPage.search("127.0.0.1").countItemsThatContain("127.0.0.1"));
        Assert.assertEquals(1, topologyUiPage.search("127.0.0.*").countItemsThatContain("127.0.0.*"));
        Assert.assertEquals(1, topologyUiPage.search("127.0.0.*").countItemsThatContain("127.0.0.1"));
    }

    /**
     * This method allows to test whether the PathOutageProvider correctly reacts to changes of the SemanticZoomLevel
     */
    @Test
    public void verifyPathOutageSemanticZoomLevel() throws IOException, InterruptedException {
        final String foreignSourceXML = "<foreign-source name=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">\n" +
                "<scan-interval>1d</scan-interval>\n" +
                "<detectors/>\n" +
                "<policies/>\n" +
                "</foreign-source>";
        createForeignSource(REQUISITION_NAME, foreignSourceXML);
        final String requisitionXML = "<model-import foreign-source=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">" +
                "   <node foreign-id=\"tests-1\" node-label=\"Node-1\">" +
                "       <interface ip-addr=\"8.8.8.8\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "   </node>" +
                "   <node foreign-id=\"tests-2\" node-label=\"Node-2\" parent-node-label=\"Node-1\">" +
                "       <interface ip-addr=\"250.25.86.11\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "   </node>" +
                "   <node foreign-id=\"tests-3\" node-label=\"Node-3\" parent-node-label=\"Node-2\">" +
                "       <interface ip-addr=\"77.15.8.98\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "   </node>" +
                "   <node foreign-id=\"tests-4\" node-label=\"Node-4\" parent-node-label=\"Node-2\">" +
                "       <interface ip-addr=\"11.100.32.32\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "   </node>" +
                "   <node foreign-id=\"tests-5\" node-label=\"Node-5\" parent-node-label=\"Node-3\">" +
                "       <interface ip-addr=\"94.37.11.135\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "   </node>" +
                "</model-import>";
        createRequisition(REQUISITION_NAME, requisitionXML, 5);
        new TopologyReloadEvent().send();

        topologyUiPage.selectTopologyProvider(TopologyProvider.PATH_OUTAGE);
        topologyUiPage.clearFocus();
        topologyUiPage.setSzl(1);
        topologyUiPage.search("Node-3").selectItemThatContains("Node-3");
        int numFocusVertices_szl1 = topologyUiPage.getVisibleVertices().size();
        topologyUiPage.setSzl(2);
        int numFocusVertices_szl2 = topologyUiPage.getVisibleVertices().size();
        Assert.assertNotEquals(numFocusVertices_szl1, numFocusVertices_szl2);
    }

    @Test
    public void verifyPathOutageTopologyInfo() {
        topologyUiPage.selectTopologyProvider(TopologyProvider.PATH_OUTAGE);
        Assert.assertThat(topologyUiPage.getTopologyInfo().getTitle(), not(containsString("Undefined")));
        Assert.assertThat(topologyUiPage.getTopologyInfo().getDescription(), not(containsString("No description available")));
    }

    /**
     * This method tests that selecting an empty category does not cause a default "No focus defined" window to pop up.
     * <p>
     *     Temporary solution which only works if the category name is unused
     * </p>
     */
    @Test
    public void verifyCollapsibleCriteriaNoDefaultFocusWindow() throws IOException, InterruptedException {
        topologyUiPage.clearFocus();
        Assert.assertThat(topologyUiPage.getNoFocusDefinedWindow().isVisible(), is(true));

        topologyUiPage.searchAndSelect("Servers");
        Assert.assertThat(topologyUiPage.getFocusedVertices(), hasSize(1));
        Assert.assertThat(topologyUiPage.getVisibleVertices(), hasSize(0));
        Assert.assertThat(topologyUiPage.getNoFocusDefinedWindow().isVisible(), is(false));

        topologyUiPage.getFocusedVertices().get(0).collapse();
        Assert.assertThat(topologyUiPage.getFocusedVertices(), hasSize(1));
        Assert.assertThat(topologyUiPage.getVisibleVertices(), hasSize(1));
        Assert.assertThat(topologyUiPage.getNoFocusDefinedWindow().isVisible(), is(false));
    }

    // See NMS-10453
    @Test
    public void verifyNoVerticesFoundTextIsShown() {
        topologyUiPage.defaultFocus();
        Assert.assertEquals(Boolean.TRUE, topologyUiPage.getNoFocusDefinedWindow().isVisible());
        Assert.assertEquals(Boolean.TRUE, topologyUiPage.getNoFocusDefinedWindow().isNoVerticesFoundTextVisible());
    }

    /**
     * This method is used to block and wait for any transitions to occur.
     * This should be used after adding or removing vertices from focus and/or
     * changing the SZL.
     */
    public static void waitForTransition(final AbstractOpenNMSSeleniumHelper testCase) {
        try {
            // TODO: Find a better way that does not require an explicit sleep
            Thread.sleep(4000);
	    testCase.wait.until(ExpectedConditions.invisibilityOfElementLocated(By.className("v-loading-indicator")));
        } catch (final InterruptedException e) {
            throw new IllegalStateException(e);
        }
    }

    private void createDummyNode() throws InterruptedException, IOException {
        // Create Dummy Node
        final String foreignSourceXML = "<foreign-source name=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">\n" +
                "<scan-interval>1d</scan-interval>\n" +
                "<detectors/>\n" +
                "<policies/>\n" +
                "</foreign-source>";
        createForeignSource(REQUISITION_NAME, foreignSourceXML);
        final String requisitionXML = "<model-import foreign-source=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">" +
                "   <node foreign-id=\"tests\" node-label=\"Dummy Node\">" +
                "       <interface ip-addr=\"127.0.0.1\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "       <category name=\"Routers\" />" +
                "   </node>" +
                "</model-import>";
        createRequisition(REQUISITION_NAME, requisitionXML, 1);
        new TopologyReloadEvent().send();
    }
}
