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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Resource Graphs" />
  <jsp:param name="ngapp" value="onms-resources" />
  <jsp:param name="headTitle" value="Resource Graphs" />
  <jsp:param name="headTitle" value="Reports" />
  <jsp:param name="location" value="performance" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>Reports</a>" />
  <jsp:param name="breadcrumb" value="Resource Graphs" />
</jsp:include>

<div class="container-fluid" ng-controller="NodeListCtrl">

  <div growl></div>

  <div class="jumbotron" ng-show="!loaded">
    <div class="container">
      <h1>Loading Resources</h1>
      <p>Please wait while all the resources are loaded into your browser.</p>
      <p>This could take time, depending on the number of resources for this node.</p>
    </div>
  </div>

  <div class="jumbotron" ng-show="loaded && !hasResources">
    <div class="container">
      <h1>There is no collected data</h1>
    </div>
  </div>

  <div class="row" ng-show="hasResources">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <span>Resources</span>
        </div>
        <div class="card-body">
          <div class="radio">
            <label>
              <input type="radio" name="reportTarget" value="graph/results.htm" ng-model="endUrl"/>
              Standard Resource Performance Reports
            </label>
            <br/>
            <br/>
            <label>
              <input type="radio" name="reportTarget" value="graph/adhoc2.jsp" ng-model="endUrl"/>
              Custom Resource Performance Reports
            </label>
            <br/>
            <br/>
          </div>
          <div class="table-responsive">
            <div class="input-group">
              <div class="input-group-prepend">
                <div class="input-group-text">
                  <i class="fa fa-search"></i>
                </div>

              </div>
              <input class="form-control" type="text" placeholder="Search/Filter Resources" ng-model="resourceFilter"></input>
            </div>

            <table class="table table-striped table-sm table-hover">
              <thead>
                <tr>
                  <th>Resources</th>
                </tr>
              </thead>
              <tbody>
                <tr ng-repeat="resource in filteredResources | startFrom:(currentPage-1)*pageSize | limitTo:pageSize">
                  <td>
                    <a ng-click="goTo(resource.id)" href>{{ resource.label }}</a>
                  </td>
                </tr>
             </tbody>
            </table>
          </div>
          <ul uib-pagination class="pagination-sm"
            total-items="totalItems"
            num-pages="numPages"
            ng-model="currentPage"
            max-size="maxSize"
            boundary-links="true"
            ng-show="filteredResources.length > pageSize"></ul>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <span>Network Performance Data</span>
        </div>
        <div class="card-body">
          <p>
          The <strong>Standard Performance Reports</strong> provide a stock way to
          easily visualize the critical SNMP data collected from managed nodes
          and interfaces throughout your network.
          </p>
          <p>
          <strong>Custom Performance Reports</strong> can be used to produce a
          single graph that contains the data of your choice from a single
          interface or node.  You can select the timeframe, line colors, line
           styles, and title of the graph.
          </p>
        </div>
      </div>
    </div>
  </div>

</div>

<jsp:include page="/assets/load-assets.jsp" flush="false">
    <jsp:param name="asset" value="angular-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
    <jsp:param name="asset" value="onms-resources" />
</jsp:include>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
