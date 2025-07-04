<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2021 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2021 The STL-NMS Group, Inc.
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

<%-- 
  This page is included by other JSPs to create a box containing a tree of 
  service level availability information for the services of a given interface.
  
  It expects that a <base> tag has been set in the including page
  that directs all URLs to be relative to the servlet context.
--%>

<%@page language="java"
	contentType="text/html"
	session="true"
	import="org.opennms.web.category.*,
		org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.*,
		java.util.Date
	"
%>
<%@ page import="org.opennms.web.outage.Outage" %>
<%@ page import="org.opennms.web.outage.OutageModel" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%!
    protected CategoryModel model;
    
    protected double normalThreshold;
    protected double warningThreshold; 
    
    public void init() throws ServletException {
        try {
            this.model = CategoryModel.getInstance();
            
            this.normalThreshold = this.model.getCategoryNormalThreshold(CategoryModel.OVERALL_AVAILABILITY_CATEGORY);
            this.warningThreshold = this.model.getCategoryWarningThreshold(CategoryModel.OVERALL_AVAILABILITY_CATEGORY);
        }
        catch( java.io.IOException e ) {
            throw new ServletException("Could not instantiate the CategoryModel", e);
        }
    }
%>

<%
    String requestNode = request.getParameter("node");
    String ipAddr = request.getParameter("ipAddr");
    String overallStatusString = request.getParameter("interfaceStatus");
	String overallStatus = "Indeterminate";

	int nodeId = -1;
	
	if ( requestNode != null ) {
		nodeId = WebSecurityUtils.safeParseInt(requestNode);
	}

    //get the child services (in alphabetical order)
    Service[] services = ElementUtil.getServicesOnInterface(nodeId, ipAddr,getServletContext());

    //get the interface's overall service level availiability for the last 24 hrs
    double overallRtcValue = this.model.getInterfaceAvailability(nodeId, ipAddr);

    if (services.length < 1) {
    	overallStatusString = "Not Monitored";
 	} else {
     	overallStatus = CategoryUtil.getCategoryClass(this.normalThreshold, this.warningThreshold, overallRtcValue);
     	overallStatusString = CategoryUtil.formatValue(overallRtcValue) + "%";
 	}

    long timelineEnd = new Date().getTime() / 1000;
    long timelineStart = timelineEnd - 3600 * 24;
    String timelineHeaderUrl = "/stlnms/rest/timeline/header/" + timelineStart + "/" + timelineEnd + "/";
    String timelineEmptyUrl = "/stlnms/rest/timeline/empty/" + timelineStart + "/" + timelineEnd + "/";

    Outage[] outages = OutageModel.getCurrentOutagesForNode(nodeId);
%>

<div id="availability-box" class="card">
<div class="card-header">
<span>Availability</span>
</div>
<table class="table table-sm severity">
  <tr class="CellStatus">
    <td class="severity-Cleared nobright interface address" colspan="2"><%=ipAddr%></td>
    <td class="severity-Cleared nobright interface header"><img src="#" data-imgsrc="<%=timelineHeaderUrl%>"></td>
    <td class="severity-<%= overallStatus %> nobright interface percent"><%= overallStatusString %></td>
  </tr>

  <% for( int i=0; i < services.length; i++ ) { %>
    <tr class="CellStatus">

    <% Service service = services[i]; %>
    <%
        if (i==0) {
    %>
    <td class="severity-Cleared nobright spacer" rowspan="<%=services.length%>"></td>
    <%
        }
        double svcValue = 0;

        String warnClass = service.isManaged() ? "Normal" : "Indeterminate";

        for(int o=0;o<outages.length;o++) {
            if (outages[o].getIpAddress().equals(ipAddr) && outages[o].getServiceName().equals(service.getServiceName())) {
                warnClass = "Critical";
                break;
            }
        }

        String timelineUrl = "/stlnms/rest/timeline/html/" + String.valueOf(nodeId) + "/" + java.net.URLEncoder.encode(ipAddr, "UTF-8") + "/" + java.net.URLEncoder.encode(service.getServiceName(), "UTF-8") + "/" + timelineStart + "/" + timelineEnd + "/";
    %>
    <%
      String serviceClass;

      if( service.isManaged() ) {
        svcValue = CategoryModel.getServiceAvailability(nodeId, ipAddr, service.getServiceId());
        serviceClass = CategoryUtil.getCategoryClass(this.normalThreshold, this.warningThreshold, svcValue);
      } else {
        serviceClass = "Indeterminate";
      }
    %>
    <c:url var="serviceLink" value="element/service.jsp">
      <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
      <c:param name="intf" value="<%=ipAddr%>"/>
      <c:param name="service" value="<%=String.valueOf(service.getServiceId())%>"/>
    </c:url>
    <td class="severity-<%=warnClass%> bright service name"><a href="<c:out value="${serviceLink}"/>"><c:out value="<%=service.getServiceName()%>"/></a></td>
    <% if( service.isManaged() ) { %>
      <td class="severity-Cleared nobright service timeline">
        <span data-src="<%=timelineUrl%>"></span>
      </td>
      <td class="severity-<%=serviceClass%> nobright"><%=CategoryUtil.formatValue(svcValue)%>%</td>
    <% } else { %>
      <td class="severity-Cleared nobright"><img src="#" data-imgsrc="<%=timelineEmptyUrl%>"></td>
      <td class="severity-<%=serviceClass%> nobright service percent"><%=ElementUtil.getServiceStatusString(service)%></td>
    <% } %>
    </tr>
  <% } %>
</table>
</div>

<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="timeline-resize" />
</jsp:include>