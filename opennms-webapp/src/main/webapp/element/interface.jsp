<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2014 The STL-NMS Group, Inc.
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

<%@page language="java"
		contentType="text/html"
		session="true"
		import="org.opennms.netmgt.config.PollerConfigFactory,
            org.opennms.netmgt.config.PollerConfig,
            org.opennms.netmgt.config.poller.Package,
            java.util.*,
            java.util.stream.Collectors,
            org.opennms.netmgt.model.OnmsNode,
            org.opennms.netmgt.model.OnmsResource,
            org.opennms.web.api.Authentication,
            org.opennms.web.element.*,
            org.opennms.core.utils.InetAddressUtils,
            org.opennms.netmgt.dao.hibernate.IfLabelDaoImpl"
%>
<%@ page import="org.opennms.netmgt.model.ResourceId" %>
<%@ page import="org.opennms.web.services.ServiceJspUtil" %>
<%@ page import="org.opennms.netmgt.model.monitoringLocations.OnmsMonitoringLocation" %>
<%@ page import="org.opennms.netmgt.model.OnmsOutage" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%!protected int telnetServiceId;
  protected int httpServiceId;
  
  public void init() throws ServletException {
    try {
      this.telnetServiceId = NetworkElementFactory.getInstance(getServletContext()).getServiceIdFromName("Telnet");            
    }
    catch( Exception e ) {
      throw new ServletException( "Could not determine the Telnet service ID", e );
    }
    try {
      this.httpServiceId = NetworkElementFactory.getInstance(getServletContext()).getServiceIdFromName("HTTP");
    }
    catch( Exception e ) {
      throw new ServletException( "Could not determine the HTTP service ID", e );
    }
  }%>

<%
  Interface intf_db = ElementUtil.getInterfaceByParams(request, getServletContext());
  int nodeId = intf_db.getNodeId();
  OnmsNode node = NetworkElementFactory.getInstance(getServletContext()).getNode(nodeId);

  String ipAddr = intf_db.getIpAddress();
	int ifIndex = -1;    
	if (intf_db.getIfIndex() > 0) {
		ifIndex = intf_db.getIfIndex();
	}

  String telnetIp = null;
  Service telnetService = NetworkElementFactory.getInstance(getServletContext()).getService(nodeId, ipAddr, this.telnetServiceId);
  if( telnetService != null  ) {
    telnetIp = ipAddr;
  }    

  String httpIp = null;
  Service httpService = NetworkElementFactory.getInstance(getServletContext()).getService(nodeId, ipAddr, this.httpServiceId);
  if( httpService != null  ) {
    httpIp = ipAddr;
  }

  Service[] services = ElementUtil.getServicesOnInterface(nodeId, ipAddr,getServletContext());

  PollerConfigFactory.init();
  PollerConfig pollerCfgFactory = PollerConfigFactory.getInstance();
  pollerCfgFactory.rebuildPackageIpListMap();    
%>
<c:url var="eventUrl1" value="event/list.htm">
    <c:param name="filter" value='<%="node=" + nodeId%>'/>
    <c:param name="filter" value='<%="interface=" + ipAddr%>'/>
</c:url>
<c:url var="eventUrl2" value="event/list.htm">
    <c:param name="filter" value='<%="node=" + nodeId%>'/>
    <c:param name="filter" value='<%="ifindex=" + ifIndex%>'/>
</c:url>

<%
String nodeBreadCrumb = "<a href='element/node.jsp?node=" + nodeId  + "'>Node</a>";
%>
<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Interface" />
  <jsp:param name="headTitle" value="<%= ipAddr %>" />
  <jsp:param name="headTitle" value="Interface" />
  <jsp:param name="breadcrumb" value="<a href='element/index.jsp'>Search</a>" />
  <jsp:param name="breadcrumb" value="<%= nodeBreadCrumb %>" />
  <jsp:param name="breadcrumb" value="Interface" />
</jsp:include>

<%
if (request.isUserInRole( Authentication.ROLE_ADMIN )) {
%>

<script type="text/javascript" >
  function doDelete() {
    if (confirm("Are you sure you want to proceed? This action will permanently delete this interface and cannot be undone.")) {
      document.forms["delete"].submit();
    }
    return false;
  }
</script>
<%
}
%>

<h4>Interface: <%=intf_db.getIpAddress()%>
  <% if (intf_db.getHostname() != null && !intf_db.getIpAddress().equals(intf_db.getHostname())) { %>
    (<c:out value="<%=intf_db.getHostname()%>"/>)
  <% } %>
</h4>

<%
if (request.isUserInRole( Authentication.ROLE_ADMIN )) {
%>
<form method="post" name="delete" action="admin/deleteInterface">
  <input type="hidden" name="node" value="<%=nodeId%>"/>
  <input type="hidden" name="ifindex" value="<%=(ifIndex == -1 ? "" : "" + ifIndex)%>"/>
  <input type="hidden" name="intf" value="<c:out value="<%=ipAddr%>"/>"/>
<%
}
%>

<ul class="list-inline">
  <% if (! ipAddr.equals("0.0.0.0")) { %>
    <li class="list-inline-item">
      <a href="<c:out value="${eventUrl1}"/>">View Events by IP Address</a>
    </li>
  <% } %>
  <% if (ifIndex > 0 ) { %>
    <li class="list-inline-item">
      <a href="<c:out value="${eventUrl2}"/>">View Events by ifIndex</a>
    </li>
  <% } %>
  <% if( telnetIp != null ) { %>
    <li class="list-inline-item">
      <a href="telnet://<%=telnetIp%>">Telnet</a>
    </li>
  <% } %>
  <% if( httpIp != null ) { %>
    <li class="list-inline-item">
      <a href="http://<%=httpIp%>">HTTP</a>
    </li>
  <% } %>
  <%
    String ifLabel;
    if (ifIndex != -1) {
      ifLabel = IfLabelDaoImpl.getInstance().getIfLabelfromIfIndex(nodeId, InetAddressUtils.addr(ipAddr), ifIndex);
    } else {
      ifLabel = IfLabelDaoImpl.getInstance().getIfLabel(nodeId, InetAddressUtils.addr(ipAddr));
    }
    // TODO In order to show the following links only when there are metrics, an inexpensive
    //      method has to be implemented on either ResourceService or ResourceDao
    ResourceId ipaddrResourceId = ResourceId.get("node", Integer.toString(nodeId)).resolve("responseTime", ipAddr);
    ResourceId snmpintfResourceId = ResourceId.get("node", Integer.toString(nodeId)).resolve("interfaceSnmp", ifLabel);
  %>
    <c:url var="ipaddrGraphLink" value="graph/results.htm">
      <c:param name="reports" value="all"/>
      <c:param name="resourceId" value="<%=ipaddrResourceId.toString()%>"/>
    </c:url>
    <li class="list-inline-item">
      <a href="<c:out value="${ipaddrGraphLink}"/>">Response Time Graphs</a>
    </li>
    <c:url var="snmpintfGraphLink" value="graph/results.htm">
      <c:param name="reports" value="all"/>
      <c:param name="resourceId" value="<%=snmpintfResourceId.toString()%>"/>
    </c:url>
    <li class="list-inline-item">
      <a href="<c:out value="${snmpintfGraphLink}"/>">SNMP Interface Data Graphs</a>
    </li>

    <c:url var="metaDataLink" value="element/interface-metadata.jsp">
      <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
      <c:param name="ipAddr" value="<%=ipAddr%>"/>
    </c:url>
    <li class="list-inline-item">
      <a href="<c:out value="${metaDataLink}"/>">Meta-Data</a>
    </li>

  <% if (request.isUserInRole( Authentication.ROLE_ADMIN )) { %>
    <li class="list-inline-item">
      <a href="admin/deleteInterface" onClick="return doDelete()">Delete</a>
    </li>
  <% } %>
  <% if (request.isUserInRole( Authentication.ROLE_ADMIN )) { %>
    <li class="list-inline-item">
      <c:url var="rescanUrl" value="element/rescan.jsp">
        <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
        <c:param name="ipaddr" value="<%=ipAddr%>"/>
      </c:url>
      <a href="<c:out value="${rescanUrl}"/>">Rescan</a>
    </li>
  <% } %>
  <% if (request.isUserInRole( Authentication.ROLE_ADMIN )) { %>
    <li class="list-inline-item">
      <c:url var="schedOutageUrl" value="admin/sched-outages/editoutage.jsp">
        <c:param name="newName" value="<%=ipAddr%>"/>
        <c:param name="addNew" value="true"/>
        <c:param name="ipAddr" value="<%=ipAddr%>"/>
      </c:url>
      <a href="<c:out value="${schedOutageUrl}"/>">Schedule Outage</a>      
    </li>
  <% } %>
</ul>

<% if (request.isUserInRole( Authentication.ROLE_ADMIN )) { %>
</form>
<% } %>

<div class="row">

  <div class="col-md-6"> <!-- content-right -->

    <div class="card">
      <div class="card-header">
        <span>General</span>
      </div>
      <!-- general info box -->
      <table class="table table-sm">
        <tr>
          <th>Node</th>
          <td><a href="element/node.jsp?node=<%=intf_db.getNodeId()%>"><%=node.getLabel()%></a></td>
        </tr>
        <tr> 
          <th>Polling Status</th>
          <td><%=ElementUtil.getInterfaceStatusString(intf_db)%></td>
        </tr>
        <% if(ElementUtil.getInterfaceStatusString(intf_db).equals("Managed") && request.isUserInRole( Authentication.ROLE_ADMIN )) {
          List<String> inPkgs = pollerCfgFactory.getAllPackageMatches(ipAddr);
          Collections.sort(inPkgs);
          for (String pkgName : inPkgs) {
            Package pkg = pollerCfgFactory.getPackage(pkgName);
            List<String> svcs = new ArrayList<>();
            for (Service svc : services) {
              if (pollerCfgFactory.isServiceInPackageAndEnabled(svc.getServiceName(), pkg)) {
                svcs.add(svc.getServiceName());
                continue;
              }
            }
            String pkgInfo = pkgName + (svcs.isEmpty() ? "" : (": " + svcs.stream().collect(Collectors.joining(", ")))); %>
            <tr>
              <th>Polling Package</th>
              <td><%= pkgInfo%></td>
            </tr>
          <% } %>
        <% } %>
        <tr>
          <th>Interface Index</th>
          <td>
            <% if( ifIndex != -1 ) {  %>
              <%=ifIndex%>
            <% } else { %>
              &nbsp;
            <% } %>
          </td>
        </tr>
        <tr> 
          <th>Last Service Scan</th>
          <td><%=(intf_db.getLastCapsdPoll() == null) ? "&nbsp;" : intf_db.getLastCapsdPoll()%></td>
        </tr>              
      </table>
    </div> <!-- panel -->
          
    <!-- Availability box -->
    <jsp:include page="/includes/interfaceAvailability-box.jsp" flush="false">
      <jsp:param name="node" value="<%=nodeId%>" />
      <jsp:param name="ipAddr" value="<%=ipAddr%>" />
      <jsp:param name="interfaceStatus" value="<%=ElementUtil.getInterfaceStatusString(intf_db)%>" />
    </jsp:include>

  </div> <!-- content-left -->

  <div class="col-md-6"> <!-- content-right -->

    <!-- interface desktop information box -->

    <!-- events list box 1 using ipaddress-->
    <% if (!ipAddr.equals("0.0.0.0")) { %>
      <c:set var="eventHeader1">
        <a href="<c:out value="${eventUrl1}"/>">Recent Events (Using Filter IP Address: <c:out value="<%=ipAddr%>"/>)</a>
      </c:set>
      <jsp:include page="/includes/eventlist.jsp" flush="false" >
        <jsp:param name="node" value="<%=nodeId%>" />
        <jsp:param name="ipAddr" value="<%=ipAddr%>" />
        <jsp:param name="throttle" value="5" />
        <jsp:param name="header" value="${eventHeader1}" />
        <jsp:param name="moreUrl" value="${eventUrl1}" />
      </jsp:include>
    <% } %>
    <!-- events list box 2 using ifindex -->
    <% if (ifIndex > 0 ) { %>
      <c:set var="eventHeader2">
        <a href="<c:out value="${eventUrl2}"/>">Recent Events (Using Filter ifIndex: <c:out value="<%=ifIndex%>"/>)</a>
      </c:set>
      <jsp:include page="/includes/eventlist.jsp" flush="false" >
        <jsp:param name="node" value="<%=nodeId%>" />
        <jsp:param name="throttle" value="5" />
        <jsp:param name="header" value="${eventHeader2}" />
        <jsp:param name="moreUrl" value="${eventUrl2}" />
        <jsp:param name="ifIndex" value="<%=ifIndex%>" />
      </jsp:include>
    <% } %>
    <!-- Recent outages box -->
    <jsp:include page="/outage/interfaceOutages-box.htm" flush="false">
        <jsp:param name="node" value="<%=nodeId%>" />
        <jsp:param name="ipAddr" value="<%=ipAddr%>" />
    </jsp:include>         

  </div> <!-- content-right -->

</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
