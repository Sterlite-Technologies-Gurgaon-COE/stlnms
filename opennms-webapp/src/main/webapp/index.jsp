<%@page language="java" contentType="text/html" session="true"  %>
<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2002-2017 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2017 The OpenNMS Group, Inc.
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

--%><jsp:include page="/includes/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Web Console" />
	<jsp:param name="useionicons" value="true" />
</jsp:include>

<div id="tst">
<div class="row">
	<!-- Middle Column -->
	<div class="col-md-6" id="index-contentmiddle" style="margin-top: 50px; margin-bottom: 50px;">
		<%
			String centerUrl = System.getProperty("org.opennms.web.console.centerUrl",  "status/status-box.jsp,/includes/categories-box.jsp");
			String[] centerUrlArr = centerUrl.split(",");
			for(String centerUrlItem : centerUrlArr) {
		%>
		<jsp:include page="<%=centerUrlItem%>" flush="false" />
		<%
			}
		%>
	</div>

	<!-- Right Column -->
	<div class="col-md-3" id="index-contentright" style="margin-top: 50px;">
		<!-- notification box -->
		<jsp:include page="/includes/notification-box.jsp" flush="false" />

		<!-- Search box -->
		<jsp:include page="/includes/search-box.jsp" flush="false" />

		<% String showGrafanaBox = System.getProperty("org.opennms.grafanaBox.show", "false");
			if (Boolean.parseBoolean(showGrafanaBox)) { %>
		<jsp:include page="/includes/grafana-box.jsp" flush="false">
                    <jsp:param name="useLimit" value="true" />
                </jsp:include>
		<% } %>

		<!-- Quick Search box -->
		<jsp:include page="/includes/quicksearch-box.jsp" flush="false" />
	</div>

	<!-- Left Column -->
	<div class="col-md-3" id="index-contentleft" style="background-color: cadetblue; border-top-right-radius: 30px; border-bottom-right-radius: 30px;">
		<!-- Situations box -->
		<% String showSituations = System.getProperty("opennms.situations.show", "true");
		   if (Boolean.parseBoolean(showSituations)) { %>
		<jsp:include page="/situation/summary-box.htm" flush="false" />
		<% } %>
		<!-- Problems box -->
		<% String showNodesWithProblems = System.getProperty("opennms.nodesWithProblems.show", "true");
           if (Boolean.parseBoolean(showNodesWithProblems)) { %>
		<jsp:include page="/alarm/summary-box.htm" flush="false" />
        <% } %>
		<!-- Services down box -->
		<% String showNodesWithOutages = System.getProperty("opennms.nodesWithOutages.show", "true");
           if (Boolean.parseBoolean(showNodesWithOutages)) { %>
		<jsp:include page="/outage/servicesdown-box.htm" flush="false" />
        <% } %>
		<!-- Business Services box -->
		<% String showBusinessServicesProblems = System.getProperty("opennms.businessServicesWithProblems.show", "true");
			if (Boolean.parseBoolean(showBusinessServicesProblems)) { %>
		<jsp:include page="/bsm/summary-box.htm" flush="false" />
		<% } %>
		<!-- Applications box -->
		<% String showApplicationsProblems = System.getProperty("opennms.applicationsWithProblems.show", "true");
			if (Boolean.parseBoolean(showApplicationsProblems)) { %>
		<jsp:include page="/application/summary-box.htm" flush="false" />
		<% } %>
	</div>

	
</div>
</div>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />

<style type="text/css">
body {
 background-color: black;
}
#tst {
  background-color: white;
  margin: 30px 60px 30px 40px;
  padding-left: 50px;
  border-radius: 50px;
}

#index-contentright .card { 
  border-radius: 15px;
  box-shadow: 7px 10px 8px -5px lightgray;
}



#index-contentright .card-header {
  border: 0px;
  border-radius: 15px;
  background-color: white;
  text-align: center;
  color: black;
}


#index-contentleft .card-header {
  border: 0px;
  border-radius: 7px;
  background-color: white;
  color: black;
}

#index-contentleft .card {
  border-radius: 7px;
  box-shadow: 7px 10px 8px -5px darkslategrey;

}

#index-contentmiddle .card {
  box-shadow: 7px 10px 8px -5px lightgray;

}

</style>

