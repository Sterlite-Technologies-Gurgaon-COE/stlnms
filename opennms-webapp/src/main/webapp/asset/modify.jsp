<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2016 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2016 The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is a registered trademark of The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * STL-NMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with STL-NMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     STL-NMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="org.opennms.web.springframework.security.AclUtils"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>

<% pageContext.setAttribute("nodeId", request.getParameter("node")); %>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
  <jsp:param name="ngapp" value="onms-assets" />
  <jsp:param name="title" value="Modify Asset" />
  <jsp:param name="headTitle" value="Modify" />
  <jsp:param name="headTitle" value="Asset" />
  <jsp:param name="breadcrumb" value="<a href ='asset/index.jsp'>Assets</a>" />
  <jsp:param name="breadcrumb" value="Modify" />
</jsp:include>

<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="jquery-ui-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="bootbox-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="onms-assets" />
</jsp:include>


<style>
  .divclass {
    margin-top: 2%;
    margin-bottom: 2%;
  }
</style>


<script>
  function showSecondDropdown() {
    var selectedOption = document.getElementById("first-dropdown").value;
    var secondDropdownContainer = document.getElementById("second-dropdown-container");

    // Clear the container
    secondDropdownContainer.innerHTML = "";

    if (selectedOption === "day") {
      // Create hours dropdown
      var hourContainer = document.createElement("div");
      hourContainer.classList.add("dropdown-container");
      var hourLabel = document.createElement("label");
      hourLabel.classList.add("dropdown-label");
      hourLabel.textContent = "Hour: ";
      var hourDropdown = document.createElement("select");
      hourDropdown.id = "hour-dropdown";
      hourDropdown.classList.add("form-control");
      for (var hour = 0; hour < 24; hour++) {
        var option = document.createElement("option");
        option.text = hour < 10 ? "0" + hour : hour;
        hourDropdown.add(option);
      }
      hourContainer.appendChild(hourLabel);
      hourContainer.appendChild(hourDropdown);

      // Create minutes dropdown
      var minuteContainer = document.createElement("div");
      minuteContainer.classList.add("dropdown-container");
      var minuteLabel = document.createElement("label");
      minuteLabel.classList.add("dropdown-label");
      minuteLabel.textContent = "Minute: ";
      var minuteDropdown = document.createElement("select");
      minuteDropdown.id = "minute-dropdown";
      minuteDropdown.classList.add("form-control");
      for (var minute = 0; minute < 60; minute += 15) {
        var option = document.createElement("option");
        option.text = minute < 10 ? "0" + minute : minute;
        minuteDropdown.add(option);
      }
      minuteContainer.appendChild(minuteLabel);
      minuteContainer.appendChild(minuteDropdown);

      secondDropdownContainer.appendChild(hourContainer);
      secondDropdownContainer.appendChild(minuteContainer);
    } else if (selectedOption === "week") {
      // Create label for the week dropdown
      var weekLabel = document.createElement("label");
        weekLabel.classList.add("dropdown-label");
        weekLabel.textContent = "Day: ";
        secondDropdownContainer.appendChild(weekLabel);

        // Create options for days of the week in the second dropdown
        var daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
        var secondDropdown = document.createElement("select");
        secondDropdown.classList.add("form-control");
        for (var i = 0; i < daysOfWeek.length; i++) {
          var option = document.createElement("option");
          option.text = daysOfWeek[i];
          secondDropdown.add(option);
        }
        secondDropdownContainer.appendChild(secondDropdown);
    } else if (selectedOption === "month") {
      // Create options for dates in the month in the second dropdown
      var monthLabel = document.createElement("label");
        monthLabel.classList.add("dropdown-label");
        monthLabel.textContent = "Date: ";
        secondDropdownContainer.appendChild(monthLabel);

        // Create options for dates in the month in the second dropdown
        var secondDropdown = document.createElement("select");
        secondDropdown.classList.add("form-control");
        for (var i = 1; i <= 31; i++) {
          var option = document.createElement("option");
         option.text = i;
          secondDropdown.add(option);
        }
        secondDropdownContainer.appendChild(secondDropdown);
    }
  }
</script>


<%!
  Boolean tempvalue = false;
  String checkedAttribute = null;
  Integer nodeId = null;
  
%>

<%
  AclUtils.NodeAccessChecker accessChecker = AclUtils.getNodeAccessChecker(getServletContext());
  nodeId = Integer.valueOf(request.getParameter("node"));

  try {

    Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
    PreparedStatement st = dbConnection.prepareStatement("SELECT * FROM public.node WHERE nodeId = ?");
  

    st.setInt(1, nodeId);
    ResultSet rs = st.executeQuery();

    while (rs.next()) {
      tempvalue = rs.getBoolean("config_flag");

    }
    rs.close(); 
    st.close();
    
    String hint="h1";
    checkedAttribute = tempvalue ? "checked" : "";
    
  } catch (NumberFormatException e) {
%>



<h2>Error parsing node parameter.</h2>
<%
  }

  if (nodeId != null) {
    if (accessChecker.isNodeAccessible(nodeId)) {
%>


<div class="container-fluid" ng-controller="NodeAssetsCtrl" ng-init="init(${nodeId})" style=" white-space: normal;">

  <div growl></div>

  <h4>
    Node: <strong><a href="element/node.jsp?node=${nodeId}">{{ nodeLabel }}</a></strong>
  </h4>
  <p>
    Last modified by {{ (master['lastModifiedBy'] || 'no one') }} at {{ master['lastModifiedDate'] | onmsDate }}
  </p>

  <form name="assetForm" novalidate action="<%= request.getContextPath() %>/updateCheckbox.jsp">
    <div class="row">
      <div class="col">
        <div class="btn-toolbar mb-4" role="toolbar">
          <button name="submit" type="button" class="btn btn-secondary mr-2" ng-click="save()" id="save-asset"
            ng-disabled="assetForm.$invalid">
            <i class="fa fa-save"></i> Save
          </button>
          <button type="button" class="btn btn-secondary" ng-click="reset()" id="reset-asset">
            <i class="fa fa-refresh"></i> Reset
          </button>
        </div>
      </div>
    </div>

    <div class="row" ng-repeat="row in config.rows">
      <div ng-class="col.class" ng-repeat="col in row.columns">
        <div class="card" ng-repeat="panel in col.panels">
          <div class="card-header">
            <span>{{ panel.title }}</span>
          </div>
          <div class="card-body">
            <div class="form-horizontal" ng-repeat="field in panel.fields">
              <div class="form-group">
                <label class="col-form-label col-md-3" for="{{ field.model }}"
                  uib-tooltip="{{ field.tooltip  }}">{{ field.label }}
                  <span class="badge badge-secondary ml-2"
                    ng-show="(assetForm[field.model].$dirty && !(assetForm[field.model].$invalid && !assetForm[field.model].$pristine))">modified</span>
                </label>
                <div class="col-md-9">
                  <%-- Static/ReadOnly fields --%>
                  <p class="form-control-plaintext" ng-if="field.type=='static'">{{ asset[field.model] }}</p>
                  <%-- Standard fields with typeahead suggestions --%>
                  <input type="text" class="form-control" id="{{ field.model }}" name="{{ field.model }}"
                    ng-model="asset[field.model]" ng-if="field.type=='text'" typeahead-editable="true"
                    typeahead-min-length="0" ng-pattern="field.pattern"
                    uib-typeahead="suggestion for suggestion in getSuggestions(field.model) | filter:$viewValue"
                    ng-class="{ 'is-invalid': assetForm[field.model].$invalid && !assetForm[field.model].$pristine }">
                  <%-- Password fields --%>
                  <input type="password" class="form-control" name="field.model" ng-model="asset[field.model]"
                    ng-if="field.type=='password'"
                    ng-class="{ 'is-invalid': assetForm[field.model].$invalid && !assetForm[field.model].$pristine}">
                  <%-- Textarea fields --%>
                  <textarea class="form-control" style="height: 20em;" ng-model="asset[field.model]"
                    ng-if="field.type=='textarea'"
                    ng-class="{ 'is-invalid': assetForm[field.model].$invalid && !assetForm[field.model].$pristine}"></textarea>
                  <%-- Date fields with Popup Picker --%>
                  <div class="{ 'is-invalid': assetForm[field.model].$invalid && !assetForm[field.model].$pristine}">
                    <option ng-repeat="value in field.options">{{value}}</option>
                  </select>
                  <%-- Boolean fields --%>

                  <div class="input-group" ng-if="field.type=='boolean'" style=" margin: 20px;">
                    <label for="config_flag"> </label>
                    <input id="configCheckbox" type="checkbox" class="form-control" name="config"
                      onchange="configuration()" <%= checkedAttribute %> />
                    <br>
                    <br>

                    <div id="contentDiv" style=" display: none; margin: 2%;">
                      <h4>Back Up Settings</h4>
                      <label for="first-dropdown">Backup Type:</label>
                      <select class="form-control custom-select pull-right" id="first-dropdown"
                        onchange="showSecondDropdown()" style="margin-bottom: 2%;">
                        <option value="" selected hidden disabled>Select BackUp Type (Day /Week /Month)</option>
                        <option value="day">Day (Backup every day on Specific Time)</option>
                        <option value="week">Week (Backup every week on Specific day)</option>
                        <option value="month">Month (Backup every month on Specific date) </option>
                      </select>
                      <br>
                      <label for="first-dropdown">Backup Time:</label>

                      <div class="divclass" id="second-dropdown-container">
                        <select class="form-control custom-select pull-right">
                          <option value="" selected hidden disabled>Select Backup Time</option>
                        </select>
                        <br>
                      </div>
                      <br>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  </form>

</div>



<script>
  $(document).ready(function () {
    var checkbox = $("#configCheckbox");
    var contentDiv = $("#contentDiv");

    // Show/hide the div based on the initial state of the checkbox
    if (checkbox.is(":checked")) {
      contentDiv.show();
    } else {
      contentDiv.hide();
    }

    // Update the div visibility dynamically when the checkbox value changes
    checkbox.change(function () {
      if (checkbox.is(":checked")) {
        contentDiv.show();
      } else {
        contentDiv.hide();
      }
    });
  });
</script>



<script>
  function getTimeStamp() {
    var date = new Date();
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear() - 2000;

    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;

    const currentDate = new Date();
    const currentTime = currentDate.toLocaleTimeString();

    var today = year + "-" + month + "-" + day + " " + currentTime;
    return today;
  }



  function configuration() {
    let checkbox = document.getElementById("configCheckbox")
    if (checkbox.checked) {
      let current_timestamp = getTimeStamp();
      var username = document.getElementById("username").value;
      if (username === "") {
        alert("Please Enter Username, Password and Enable Password for Configuration");
      }
    }
  }
</script>


<script type="text/javascript" src="element/js/jquery.min.js"></script>
<script>
  $(document).ready(function () {
    var nodeId = <%= Integer.valueOf(request.getParameter("node")) %> ;
    console.log(nodeId);

    $("#save-asset").click(function () {
      var checkboxValue = $("#configCheckbox").is(":checked");
      // console.log(checkboxValue);

      $.ajax({
        url: "./asset/updateDatabase.jsp",
        method: "POST",
        data: {
          nodeId: nodeId,
          checkboxValue: checkboxValue
        },
        success: function (response) {
          // alert(response);
          console.log(response);
        },
        error: function (xhr, status, error) {
          console.log("An error occurred while updating the database: " + error);
        }
      });
    });
  });
</script>

<%
    } else {
%>
<h2>Access denied.</h2>
<%
    }
  }
%>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />