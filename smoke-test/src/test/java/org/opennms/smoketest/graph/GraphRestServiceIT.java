/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2019-2021 The OpenNMS Group, Inc.
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

package org.opennms.smoketest.graph;

import static com.jayway.awaitility.Awaitility.await;
import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.preemptive;
import static java.util.concurrent.TimeUnit.MINUTES;
import static java.util.concurrent.TimeUnit.SECONDS;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThat;

import java.net.InetAddress;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.hamcrest.Matchers;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.opennms.core.utils.InetAddressUtils;
import org.opennms.netmgt.dao.hibernate.ApplicationDaoHibernate;
import org.opennms.netmgt.dao.hibernate.OutageDaoHibernate;
import org.opennms.netmgt.events.api.EventConstants;
import org.opennms.netmgt.model.OnmsApplication;
import org.opennms.netmgt.model.OnmsEventCollection;
import org.opennms.netmgt.model.OnmsNode;
import org.opennms.netmgt.model.OnmsSeverity;
import org.opennms.netmgt.model.events.EventBuilder;
import org.opennms.netmgt.xml.event.Event;
import org.opennms.smoketest.OpenNMSSeleniumIT;
import org.opennms.smoketest.graphml.GraphmlDocument;
import org.opennms.smoketest.topo.GraphMLTopologyIT;
import org.opennms.smoketest.utils.HibernateDaoFactory;
import org.opennms.smoketest.utils.KarafShell;
import org.opennms.smoketest.utils.RestClient;
import org.openqa.selenium.By;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

public class GraphRestServiceIT extends OpenNMSSeleniumIT {
    private static final Logger LOG = LoggerFactory.getLogger(GraphRestServiceIT.class);
    private static final String CONTAINER_ID = "test";

    private final RestClient restClient = stack.opennms().getRestClient();
    private final KarafShell karafShell = new KarafShell(stack.opennms().getSshAddress());
    private GraphmlDocument graphmlDocument;

    @Before
    public void setUp() {
        RestAssured.baseURI = stack.opennms().getBaseUrlExternal().toString();
        RestAssured.port = stack.opennms().getWebPort();
        RestAssured.basePath = "/opennms/api/v2/graphs";
        RestAssured.authentication = preemptive().basic(BASIC_AUTH_USERNAME, BASIC_AUTH_PASSWORD);

        // Ensure no graph exists
        graphmlDocument = new GraphmlDocument(CONTAINER_ID, "/topology/graphml/test-topology.xml");
        graphmlDocument.delete(restClient);

        cleanUpApplications();
    }

    @After
    public void tearDown() {
        RestAssured.reset();
        graphmlDocument.delete(restClient);

        cleanUpRequisition();
        cleanUpApplications();
    }

    private void cleanUpApplications() {
        final HibernateDaoFactory daoFactory = stack.postgres().getDaoFactory();
        final ApplicationDaoHibernate applicationDao = daoFactory.getDao(ApplicationDaoHibernate.class);
        final OutageDaoHibernate outageDao = daoFactory.getDao(OutageDaoHibernate.class);

        try {
            applicationDao.findAll().forEach(applicationDao::delete);
            applicationDao.flush();
            outageDao.findAll().forEach(outageDao::delete);
            outageDao.flush();
        } catch (final Exception e) {
            LOG.warn("Failed to delete existing application-related data.", e);

        }
    }

    private void cleanUpRequisition() {
        deleteExistingRequisition(OpenNMSSeleniumIT.REQUISITION_NAME);
        deleteExistingForeignSource(OpenNMSSeleniumIT.REQUISITION_NAME);
    }

    @Test
    public void verifyContainerListInfos() {
        // Explicitly ask for json
        given().accept(ContentType.JSON).then().statusCode(204);

        // Verify without content type
        given().then().statusCode(204);

        // Post a Graph
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Verify creation if asked explicitly for JSON
        given().accept(ContentType.JSON).get()
                .then().statusCode(200)
                .contentType(ContentType.JSON)
                .content("[0].id", Matchers.is("application"))
                .content("[0].label", Matchers.is("Application Graph"))
                .content("[0].graphs.size()", Matchers.is(1))
                .content("[0].graphs[0].namespace", Matchers.is("application"))
                .content("[0].graphs[0].label", Matchers.is("Application Graph"))
                .content("[0].graphs[0].description", Matchers.is("Displays all defined applications and their calculated states."))

                .content("[1].id", Matchers.is("bsm"))
                .content("[1].label", Matchers.is("Business Service Graph"))
                .content("[1].graphs.size()", Matchers.is(1))
                .content("[1].graphs[0].namespace", Matchers.is("bsm"))
                .content("[1].graphs[0].label", Matchers.is("Business Service Graph"))
                .content("[1].graphs[0].description", Matchers.is("Displays the hierarchy of the defined Business Services and their computed operational states."))

                .content("[2].id", Matchers.is("nodes"))
                .content("[2].label", Matchers.is("Enhanced Linkd Topology Provider"))
                .content("[2].graphs.size()", Matchers.is(1))
                .content("[2].graphs[0].namespace", Matchers.is("nodes"))
                .content("[2].graphs[0].label", Matchers.is("Enhanced Linkd Topology Provider"))
                .content("[2].graphs[0].description", Matchers.is("This Topology Provider displays the topology information discovered by the Enhanced Linkd daemon. It uses the SNMP information of several protocols like OSPF, ISIS, LLDP and CDP to generate an overall topology."))

                .content("[3].id", Matchers.is(CONTAINER_ID))
                .content("[3].label", Matchers.is(GraphMLTopologyIT.LABEL))
                .content("[3].graphs.size()", Matchers.is(2))
                .content("[3].graphs[0].namespace", Matchers.is("acme:markets"))
                .content("[3].graphs[0].label", Matchers.is("Markets"))
                .content("[3].graphs[0].description", Matchers.is("The Markets Layer"))
                .content("[3].graphs[1].namespace", Matchers.is("acme:regions"))

                .content("[4].id", Matchers.is("vmware"))
                .content("[4].label", Matchers.is("VMware Topology Provider"))
                .content("[4].graphs.size()", Matchers.is(1))
                .content("[4].graphs[0].namespace", Matchers.is("vmware"))
                .content("[4].graphs[0].label", Matchers.is("VMware Topology Provider"))
                .content("[4].graphs[0].description", Matchers.is("The VMware Topology Provider displays the infrastructure information gathered by the VMware Provisioning process."))
                ;
    }

    @Test
    public void verifyGetContainer() {
        createGraphMLAndWaitUntilDone(graphmlDocument);
        given().get(CONTAINER_ID).then()
                .contentType(ContentType.JSON)
                .content("graphs", Matchers.hasSize(2))
                .content("graphs[0].id", Matchers.is("markets"))
                .content("graphs[0].namespace", Matchers.is("acme:markets"))
                .content("graphs[0].defaultFocus.type", Matchers.is("SELECTION"))
                .content("graphs[0].defaultFocus.vertexIds.size()", Matchers.is(1))
                .content("graphs[0].defaultFocus.vertexIds[0].id", Matchers.is("north.4"))
                .content("graphs[0].vertices", Matchers.hasSize(16))
                .content("graphs[0].edges", Matchers.hasSize(0))

                .content("graphs[1].id", Matchers.is("regions"))
                .content("graphs[1].namespace", Matchers.is("acme:regions"))
                .content("graphs[1].defaultFocus.type", Matchers.is("ALL"))
                .content("graphs[1].defaultFocus.vertexIds.size()", Matchers.is(4))
                .content("graphs[1].vertices", Matchers.hasSize(4))
                .content("graphs[1].edges", Matchers.hasSize(16));
    }

    @Test
    public void verifyGetGraph() {
        createGraphMLAndWaitUntilDone(graphmlDocument);
        given().get(CONTAINER_ID + "/{namespace}", "acme:markets")
                .then()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("markets"))
                .content("defaultFocus.type", Matchers.is("SELECTION"))
                .content("defaultFocus.vertexIds.size()", Matchers.is(1))
                .content("defaultFocus.vertexIds[0].id", Matchers.is("north.4"))
                .content("vertices", Matchers.hasSize(16))
                .content("edges", Matchers.hasSize(0));
        given().get(CONTAINER_ID + "/{namespace}", "acme:regions")
                .then()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("regions"))
                .content("namespace", Matchers.is("acme:regions"))
                .content("defaultFocus.type", Matchers.is("ALL"))
                .content("defaultFocus.vertexIds.size()", Matchers.is(4))
                .content("vertices", Matchers.hasSize(4))
                .content("edges", Matchers.hasSize(16));
    }

    @Test
    public void verifySuggest() {
    	createGraphMLAndWaitUntilDone(graphmlDocument);
        given().log().ifValidationFails()
               .params("s", "unknown")
               .accept(ContentType.JSON)
               .get("/search/suggestions/{namespace}/", "acme:regions")
               .then().log().ifValidationFails()
               .statusCode(204);

        given().log().ifValidationFails()
               .params("s", "North Region")
               .accept(ContentType.JSON)
               .get("/search/suggestions/{namespace}/", "acme:regions")
               .then().log().ifValidationFails()
               .statusCode(200)
               .contentType(ContentType.JSON)
               .content("[0].context", Matchers.is("GenericVertex"))
               .content("[0].label", Matchers.is("North Region"))      
               .content("[0].provider", Matchers.is("LabelSearchProvider"))
               .content("", Matchers.hasSize(1));
    }

    @Test
    public void verifySearch() {
    	createGraphMLAndWaitUntilDone(graphmlDocument);
        given().log().ifValidationFails()
               .params("providerId", "LabelSearchProvider")
               .params("criteria", "unknown")
               .accept(ContentType.JSON)
               .get("/search/results/{namespace}", "acme:regions")
               .then().log().ifValidationFails()
               .statusCode(204);

        given().log().ifValidationFails()
               .params("providerId", "LabelSearchProvider")
               .params("criteria", "North Region")
               .accept(ContentType.JSON)
               .get("/search/results/{namespace}/", "acme:regions")
               .then().log().ifValidationFails()
               .statusCode(200)
               .contentType(ContentType.JSON)
               .content("[0].namespace", Matchers.is("acme:regions"))
               .content("[0].id", Matchers.is("north"))
               .content("", Matchers.hasSize(1));
    }

    @Test
    public void verifyDefaultFocus() {
        // Use a different graph and create it
        graphmlDocument = new GraphmlDocument(CONTAINER_ID, "/topology/graphml/test-topology-2.xml");
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Verify default focus
        given().log().ifValidationFails()
                .contentType(ContentType.JSON)
                .body("{}")
                .post(CONTAINER_ID + "/{namespace}", "test")
                .then()
                .log().ifValidationFails()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("test"))
                .content("namespace", Matchers.is("test"))
                .content("focus.semanticZoomLevel", Matchers.is(1))
                .content("focus.vertices", Matchers.hasSize(1))
                .content("vertices", Matchers.hasSize(2))
                .content("edges", Matchers.hasSize(1))
                .content("vertices[0].id", Matchers.is("v1.1"))
                .content("vertices[1].id", Matchers.is("v1.1.2"));
    }

    @Test
    public void verifyCustomFocus() {
        // Use a different graph and create it
        graphmlDocument = new GraphmlDocument(CONTAINER_ID, "/topology/graphml/test-topology-2.xml");
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Verify custom focus
        final JSONObject query = new JSONObject()
                .put("semanticZoomLevel", 1)
                .put("verticesInFocus", new JSONArray().put("v1.1.1"));
        given().log().ifValidationFails()
                .contentType(ContentType.JSON)
                .body(query.toString())
                .post(CONTAINER_ID + "/{namespace}", "test")
                .then()
                .log().ifValidationFails()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("test"))
                .content("namespace", Matchers.is("test"))
                .content("vertices", Matchers.hasSize(2))
                .content("edges", Matchers.hasSize(1))
                .content("vertices[0].id", Matchers.is("v1.1"))
                .content("vertices[1].id", Matchers.is("v1.1.1"));

        //  Increase SZL
        query.put("semanticZoomLevel", 2);
        given().log().ifValidationFails()
                .contentType(ContentType.JSON)
                .body(query.toString())
                .post(CONTAINER_ID + "/{namespace}", "test")
                .then()
                .log().ifValidationFails()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("test"))
                .content("namespace", Matchers.is("test"))
                .content("vertices", Matchers.hasSize(4))
                .content("edges", Matchers.hasSize(3))
                .content("vertices[0].id", Matchers.is("v1"))
                .content("vertices[1].id", Matchers.is("v1.1"))
                .content("vertices[2].id", Matchers.is("v1.1.1"))
                .content("vertices[3].id", Matchers.is("v1.1.2"));
    }

    @Test
    public void verifyNodeSearch() {
        // Set up test data
        createRequisition();
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Verify suggestions
        final String response = given().log().ifValidationFails()
                .accept(ContentType.JSON)
                .params("s", "Node A")
                .get("/search/suggestions/{namespace}", "acme:markets")
                .then().log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .content("[0].context", Matchers.is("Node"))
                .content("[0].label", Matchers.is("Node A"))
                .content("[0].provider", Matchers.is("NodeSearchProvider"))
                .content("", Matchers.hasSize(1))
                .extract().response().asString();
        final JSONArray result = new JSONArray(new JSONTokener(response));
        assertThat(result.length(), Matchers.is(1));
        final String id = result.getJSONObject(0).getString("id");
        assertNotNull(id);

        // Verify resolution
        given().log().ifValidationFails()
                .params("providerId", "NodeSearchProvider")
                .params("criteria", id)
                .accept(ContentType.JSON)
                .get("/search/results/{namespace}/", "acme:markets")
                .then().log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .content("[0].namespace", Matchers.is("acme:markets"))
                .content("[0].id", Matchers.is("north.2"))
                .content("", Matchers.hasSize(1));
    }

    @Test
    public void verifyNodeEnrichment() throws InterruptedException {
        // Set up test data
        createRequisition();
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Fetch data
        final JSONObject query = new JSONObject()
                .put("semanticZoomLevel", 0)
                .put("verticesInFocus", new JSONArray().put("north.1").put("north.2").put("north.3"));
        given().log().ifValidationFails()
                .body(query.toString())
                .contentType(ContentType.JSON)
                .post(CONTAINER_ID + "/{namespace}", "acme:markets")
                .then()
                .log().ifValidationFails()
                .contentType(ContentType.JSON)
                .content("id", Matchers.is("markets"))
                .content("namespace", Matchers.is("acme:markets"))
                .content("vertices", Matchers.hasSize(3))
                .content("edges", Matchers.hasSize(0))
                .content("vertices[0].id", Matchers.is("north.1"))
                .content("vertices[1].id", Matchers.is("north.2"))
                .content("vertices[1].nodeInfo.foreignSource", Matchers.is(REQUISITION_NAME))
                .content("vertices[1].nodeInfo.foreignId", Matchers.is("node1"))
                .content("vertices[1].nodeInfo.label", Matchers.is("Node A"))
                .content("vertices[1].nodeInfo.categories", Matchers.hasItems("Test", "Server"))
                .content("vertices[2].id", Matchers.is("north.3"))
                .content("vertices[2].nodeInfo.foreignSource", Matchers.is(REQUISITION_NAME))
                .content("vertices[2].nodeInfo.foreignId", Matchers.is("node2"))
                .content("vertices[2].nodeInfo.label", Matchers.is("Node B"))
                .content("vertices[2].nodeInfo.categories", Matchers.hasItems("Test", "Node"));
    }

    @Test
    public void verifyStatusExposureBsm() {
        try {
            karafShell.runCommand("opennms:bsm-generate-hierarchies 5 2");

            // Fetch data
            final JSONObject query = new JSONObject().put("semanticZoomLevel", 1);
            given().log().ifValidationFails()
                    .body(query.toString())
                    .contentType(ContentType.JSON)
                    .post("{container_id}/{namespace}", "bsm", "bsm")
                    .then()
                    .log().ifValidationFails()
                    .statusCode(200)
                    .contentType(ContentType.JSON)
                    .content("vertices", Matchers.hasSize(1))
                    .content("vertices[0].status", Matchers.is("Normal"));
        } finally {
            karafShell.runCommand("opennms:bsm-delete-generated-hierarchies");
        }
    }

    @Test
    public void verifyStatusEnrichmentApplication() throws InterruptedException {
        final String applicationName = "StatusEnrichmentTest";

        final InetAddress localhost = InetAddressUtils.getInetAddress("127.0.0.1");
        final String perspectiveKey = "perspective";
        final String perspectiveName = "Default";

        final String testServiceName = "ICMP";
        final String minorSeverity = OnmsSeverity.MINOR.getLabel();
        final String criticalSeverity = OnmsSeverity.CRITICAL.getLabel();

        // Set up test data
        createRequisition();

        adminPage();
        findElementByLink("Manage Applications").click();

        // create the application
        waitForElement(By.name("newApplicationName"));
        enterText(By.name("newApplicationName"), applicationName);
        clickElement(By.cssSelector("form[action='admin/applications.htm'] > button"));

        // browse to the application page
        clickElement(By.linkText(applicationName));

        clickElement(By.linkText("Edit application"));
        // make sure the forms have loaded
        waitForElement(By.id("input_toAdd"));

        // add the services
        clickElement(By.xpath("//select[@id='input_toAdd']/option[contains(text(), 'Node A / 127.0.0.1 / ICMP')]"));
        clickElement(By.id("input_addService"));
        clickElement(By.xpath("//select[@id='input_toAdd']/option[contains(text(), 'Node B / 127.0.0.1 / ICMP')]"));
        clickElement(By.id("input_addService"));

        // add the default location
        clickElement(By.xpath("//select[@id='input_locationAdd']/option[@value='Default']"));
        clickElement(By.id("input_addLocation"));

        // get the application
        final List<OnmsApplication> applications = restClient.getApplications();
        System.err.println("applications=" + applications);
        final Optional<OnmsApplication> app = applications.stream().filter(a -> applicationName.equals(a.getName())).findFirst();
        if (!app.isPresent()) {
            throw new IllegalStateException("Failed to retrieve application '" + applicationName + "'");
        }
        final OnmsApplication application = app.get();

        // Force application provider to reload (otherwise we have to wait until cache is invalidated)
        awaitForApplicationStatus(application, "Normal");

        final List<OnmsNode> nodes = restClient.getNodes();
        final int nodeId1 = nodes.stream().filter(n -> "Node A".equals(n.getLabel())).findFirst().get().getId();
        final int nodeId2 = nodes.stream().filter(n -> "Node B".equals(n.getLabel())).findFirst().get().getId();

        // Fetch data nothing down
        final JSONObject query = new JSONObject()
                .put("semanticZoomLevel", 1)
                .put("verticesInFocus", Lists.newArrayList(String.format("Application:%s", application.getId())));
        given().log().ifValidationFails()
                .body(query.toString())
                .contentType(ContentType.JSON)
                .post("{container_id}/{namespace}", "application", "application")
                .then()
                .log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .content("vertices", Matchers.hasSize(3))
                .content("vertices[0].status.severity", Matchers.is("Normal"))
                .content("vertices[1].status.severity", Matchers.is("Normal"))
                .content("vertices[2].status.severity", Matchers.is("Normal"))
                .content("vertices[0].status.count", Matchers.is(0))
                .content("vertices[1].status.count", Matchers.is(0))
                .content("vertices[2].status.count", Matchers.is(0));

        // Prepare simulated outages
        final Event nodeLostServiceEvent = new EventBuilder(EventConstants.PERSPECTIVE_NODE_LOST_SERVICE_UEI, getClass().getSimpleName())
                .setNodeid(nodeId1)
                .setInterface(localhost)
                .setService(testServiceName)
                .setParam(perspectiveKey, perspectiveName)
                .setSeverity(minorSeverity)
                .getEvent();
        final Event nodeLostServiceEventApp2 = new EventBuilder(EventConstants.PERSPECTIVE_NODE_LOST_SERVICE_UEI, getClass().getSimpleName())
                .setNodeid(nodeId2)
                .setInterface(localhost)
                .setService(testServiceName)
                .setParam(perspectiveKey, perspectiveName)
                .setSeverity(criticalSeverity)
                .getEvent();

        getDriver().get(getBaseUrlInternal() + "stlnms/topology");
        waitForElement(By.xpath("//span[@class='v-menubar-menuitem-caption' and contains(text(), 'View')]"));

        clickElement(By.xpath("//span[@class='v-menubar-menuitem-caption' and contains(text(), 'View')]"));
        clickElement(By.xpath("//span[@class='v-menubar-menuitem-caption' and contains(text(), 'Application')]"));

        // Waiting for perspective poller to detect services as UP
        await().atMost(2, MINUTES)
               .until(() -> this.restClient.getEventsForNodeByEventUei(nodeId1, EventConstants.PERSPECTIVE_NODE_REGAINED_SERVICE_UEI).getTotalCount(),
                      Matchers.greaterThan(0));

        await().atMost(2, MINUTES)
               .until(() -> this.restClient.getEventsForNodeByEventUei(nodeId2, EventConstants.PERSPECTIVE_NODE_REGAINED_SERVICE_UEI).getTotalCount(),
                      Matchers.greaterThan(0));

        // Take service down, reload graph and verify
        restClient.sendEvent(nodeLostServiceEvent);
        awaitForApplicationStatus(application, "Minor");

        final Response response = getApplicationViewResponse(query.toString());
        final ApplicationViewResponse applicationViewResponse = new ApplicationViewResponse(response);
        assertThat(applicationViewResponse.length(), Matchers.is(3));
        verifyStatus(applicationViewResponse.getVertexByApplicationId(application.getId()), "Minor", 1);
        verifyStatus(applicationViewResponse.getVertexByNodeId(nodeId1), "Minor", 1);
        verifyStatus(applicationViewResponse.getVertexByNodeId(nodeId2), "Normal", 0);

        // Take service down with severity higher than Major
        restClient.sendEvent(nodeLostServiceEventApp2);
        awaitForApplicationStatus(application, "Critical");

        final Response response2 = getApplicationViewResponse(query.toString());
        final ApplicationViewResponse applicationViewResponse2 = new ApplicationViewResponse(response2);
        assertThat(applicationViewResponse2.length(), Matchers.is(3));
        verifyStatus(applicationViewResponse2.getVertexByApplicationId(application.getId()), "Critical", 2);
        verifyStatus(applicationViewResponse2.getVertexByNodeId(nodeId1), "Minor", 1);
        verifyStatus(applicationViewResponse2.getVertexByNodeId(nodeId2), "Critical", 1); // we expect the same severity as the interface with the highest severity
    }

    private void awaitForApplicationStatus(final OnmsApplication application, final String severity) {
        final JSONObject query = new JSONObject()
                .put("semanticZoomLevel", 1)
                .put("verticesInFocus", Lists.newArrayList(String.format("Application:%s", application.getId())));
        await()
                .atMost(2, MINUTES)
                .until(() -> {
                    karafShell.runCommand("opennms:graph-force-reload --container application");
                    final String status = new ApplicationViewResponse(getApplicationViewResponse(query.toString()))
                            .getVertexByApplicationId(application.getId())
                            .getJSONObject("status")
                            .getString("severity");
                    LOG.debug("application {} status={}", application.getId(), status);
                    return status;
                }, equalTo(severity));
    }

    private Response getApplicationViewResponse(final String query) {
        return given().log().ifValidationFails()
                .body(query)
                .contentType(ContentType.JSON)
                .post("{container_id}/{namespace}", "application", "application")
                .then()
                .log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .extract().response();
    }

    @Test
    // Here we test, that the name of the file and the container id may be different
    public void verifyContainerId() {
        final String graphmlName = "test-graph";
        final String containerId = CONTAINER_ID;
        graphmlDocument = new GraphmlDocument(graphmlName, "/topology/graphml/test-topology.xml");
        createGraphMLAndWaitUntilDone(graphmlDocument);

        // Verify container can be fetched by container id
        given().log().ifValidationFails()
                .get(containerId)
                .then()
                .log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON);

        // Verify container can not be fetched by graph name
        given().log().ifValidationFails()
                .get(graphmlName)
                .then()
                .log().ifValidationFails()
                .statusCode(404);

        // Verify graphml can be fetched by name
        given().log().ifValidationFails()
                .basePath("/opennms/rest")
                .get("graphml/{name}", graphmlName)
                .then()
                .log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.XML);

        // Verify graphml can not be fetched by container id
        given().log().ifValidationFails()
                .basePath("/opennms/rest")
                .get("graphml/{name}", containerId)
                .then()
                .log().ifValidationFails()
                .statusCode(404);
    }

    // If the reduceFunction is exposed properly, it means bsm provider is exposing custom json renderers
    @Test
    public void verifyCustomJsonRenderer() {
        try {
            karafShell.runCommand("opennms:bsm-generate-hierarchies 5 2");
            given().log().ifValidationFails()
                .get("{container_id}/{namespace}", "bsm", "bsm")
                .then()
                .log().ifValidationFails()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .content("vertices", Matchers.hasSize(5))
                .content("vertices[0].reduceFunction.type", Matchers.is("highestseverity"))
                .content("vertices[1].reduceFunction.type", Matchers.is("highestseverity"))
                .content("vertices[2].reduceFunction.type", Matchers.is("highestseverity"))
                .content("vertices[3].reduceFunction.type", Matchers.is("highestseverity"))
                .content("vertices[4].reduceFunction.type", Matchers.is("highestseverity"));
        } finally {
            karafShell.runCommand("opennms:bsm-delete-generated-hierarchies");
        }
    }

    private void createGraphMLAndWaitUntilDone(GraphmlDocument graphmlDocument) {
        graphmlDocument.create(restClient);
    	await().atMost(30, TimeUnit.SECONDS).pollInterval(5, TimeUnit.SECONDS).until(() -> {
            given().accept(ContentType.JSON).get()
                    .then().statusCode(200)
                    .contentType(ContentType.JSON)
                    .content("[0].id", Matchers.is("application"))
                    .content("[1].id", Matchers.is("bsm"))
                    .content("[2].id", Matchers.is("nodes"))
                    .content("[3].id", Matchers.is(CONTAINER_ID))
                    .content("[4].id", Matchers.is("vmware"));
        });
    }
    private void createRequisition() {
        // Create nodes in OpenNMS
        final String foreignSourceXML = "<foreign-source name=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">\n" +
                "<scan-interval>1d</scan-interval>\n" +
                "<detectors/>\n" +
                "<policies/>\n" +
                "</foreign-source>";
        createForeignSource(REQUISITION_NAME, foreignSourceXML);
        final String requisitionXML = "<model-import foreign-source=\"" + OpenNMSSeleniumIT.REQUISITION_NAME + "\">" +
                "   <node foreign-id=\"node1\" node-label=\"Node A\">" +
                "       <interface ip-addr=\"::1\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "       <interface ip-addr=\"127.0.0.1\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "       <category name=\"Test\" />" +
                "       <category name=\"Server\" />" +
                "   </node>" +
                "   <node foreign-id=\"node2\" node-label=\"Node B\">" +
                "       <interface ip-addr=\"::1\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "       <interface ip-addr=\"127.0.0.1\" status=\"1\" snmp-primary=\"N\">" +
                "           <monitored-service service-name=\"ICMP\"/>" +
                "       </interface>" +
                "       <category name=\"Test\" />" +
                "       <category name=\"Node\" />" +
                "   </node>" +
                "</model-import>";
        createRequisition(REQUISITION_NAME, requisitionXML, 2);
    }

    private static void verifyStatus(JSONObject vertex, String expectedStatus, int expectedCount) {
        final JSONObject status = vertex.getJSONObject("status");
        assertThat(status.getString("severity"), Matchers.is(expectedStatus));
        assertThat(status.getInt("count"), Matchers.is(expectedCount));
    }

    private static class ApplicationViewResponse {
        private final JSONArray vertices;

        private ApplicationViewResponse(final Response response) {
            Objects.requireNonNull(response);
            final JSONTokener jsonTokener = new JSONTokener(response.getBody().asString());
            final JSONObject jsonObject = new JSONObject(jsonTokener);
            this.vertices = jsonObject.getJSONArray("vertices");
        }

        public int length() {
            return vertices.length();
        }

        public JSONObject getVertexByApplicationId(int applicationId) {
            for (int i=0; i<vertices.length(); i++) {
                final JSONObject eachVertex = vertices.getJSONObject(i);
                if (eachVertex.has("applicationId")
                        && Objects.equals(eachVertex.getString("applicationId"), Integer.toString(applicationId))) {
                    return eachVertex;
                }
            }
            throw new NoSuchElementException("No Vertex with applicationId '" + applicationId + "' found");
        }

        public JSONObject getVertexByNodeId(int nodeId) {
            for (int i=0; i<vertices.length(); i++) {
                final JSONObject eachVertex = vertices.getJSONObject(i);
                if (eachVertex.has("nodeCriteria")
                        && Objects.equals(eachVertex.getString("nodeCriteria"), Integer.toString(nodeId))) {
                    return eachVertex;
                }
            }
            throw new NoSuchElementException("No Vertex with nodeCriteria '" + nodeId + "' found");
        }

    }
}
