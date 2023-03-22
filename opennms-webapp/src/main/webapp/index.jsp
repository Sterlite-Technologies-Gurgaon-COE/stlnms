<%@page language="java" contentType="text/html" session="true"  %>
<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2017 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2017 The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is a registered trademark of The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * STL-NMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with STL-NMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     STL-NMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

--%><jsp:include page="/includes/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Web Console" />
	<jsp:param name="useionicons" value="true" />
</jsp:include>

<div class="row">
	<!-- Left Column -->
	<div class="col-md-3" id="index-contentleft">
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

	<!-- Middle Column -->
	<div class="col-md-6" id="index-contentmiddle">
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
	<div class="col-md-3" id="index-contentright">
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
</div>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
