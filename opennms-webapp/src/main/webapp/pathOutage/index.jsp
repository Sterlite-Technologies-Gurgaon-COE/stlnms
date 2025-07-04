<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2006-2014 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2014 The STL-NMS Group, Inc.
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

--%>

<%@page language="java" contentType="text/html" session="true"
	import="
		java.net.InetAddress,
		java.util.List,
		org.opennms.core.utils.InetAddressUtils,
		org.opennms.features.topology.link.Layout,
		org.opennms.features.topology.link.TopologyLinkBuilder"
%>
<%@ page import="org.opennms.features.topology.link.TopologyProvider" %>
<%@ page import="org.opennms.netmgt.dao.hibernate.PathOutageManagerDaoImpl" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
  <jsp:param name="title" value="Path Outages" />
  <jsp:param name="headTitle" value="Path Outages" />
  <jsp:param name="location" value="pathOutage" />
  <jsp:param name="breadcrumb" value="Path Outages" />
</jsp:include>

<%
        List<String[]> testPaths = PathOutageManagerDaoImpl.getInstance().getAllCriticalPaths();
        InetAddress dcpip = PathOutageManagerDaoImpl.getInstance().getDefaultCriticalPathIp();
        String dcpipString = dcpip != null ? InetAddressUtils.toIpAddrString(dcpip) : null;
        String[] pthData = PathOutageManagerDaoImpl.getInstance().getCriticalPathData(dcpipString, "ICMP");
%>
<% if (dcpip != null) { %>
	<p>The default critical path is service ICMP on interface <%= dcpipString %>.</p>
<% } %>

<div class="card fix-subpixel">
	<div class="card-header">
		<span>All Path Outages</span>
	</div>
	<table class="table table-sm severity">
			<tr>
				<th>Critical Path Node</th>
				<th>Critical Path IP</th>
				<th>Critical Path Service</th>
				<th>Number of Nodes</th>
				<th>Actions</th>
			</tr>
		<% for (String[] pth : testPaths) {
			pthData = PathOutageManagerDaoImpl.getInstance().getCriticalPathData(pth[1], pth[2]); %>
		<tr>
			<% if((pthData[0] == null) || (pthData[0].equals(""))) { %>
			<td>(Interface not in database)</td>
			<% } else if (pthData[0].indexOf("nodes have this IP") > -1) { %>
			<td><a href="element/nodeList.htm?iplike=<%= pth[1] %>"><%= pthData[0] %></a></td>
			<% } else { %>
			<td><a href="element/node.jsp?node=<%= pthData[1] %>"><%= pthData[0] %></a></td>
			<% } %>
			<td><%= pth[1] %></td>
			<td class="severity-<%= pthData[3] %> bright"><%= pth[2] %></td>
			<td><a href="pathOutage/showNodes.jsp?critIp=<%= pth[1] %>&critSvc=<%= pth[2] %>"><%= pthData[2] %></a></td>
			<%
				final String topologyLink = new TopologyLinkBuilder()
						.focus(pthData[1])
						.szl(0)
						.layout(Layout.HIERARCHY)
						.provider(TopologyProvider.PATH_OUTAGE)
						.getLink();
			%>
			<td><a href="<%= topologyLink%>"><i class="fa fa-external-link-square"></i> View in Topology</a></td>
		</tr>
		<% } %>
	</table>
</div>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
