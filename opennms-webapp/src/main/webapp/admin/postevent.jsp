<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2012-2014 The STL-NMS Group, Inc.
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
	import="
		java.util.*,
                org.opennms.web.api.Util,org.opennms.netmgt.events.api.EventConstants,
                org.opennms.netmgt.xml.event.Event,
                org.opennms.netmgt.xml.event.Parm,
                org.opennms.netmgt.xml.event.Value,
                org.opennms.core.xml.JaxbUtils,
                org.apache.commons.lang.StringUtils
	"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String uei = StringUtils.trimToEmpty(request.getParameter("uei"));
    if (StringUtils.isBlank(uei)) {
        response.sendRedirect("sendevent.jsp");
        return;
    }

    Event event = new Event();
    event.setSource("Web UI");
    event.setUei(uei);
    event.setTime(new java.util.Date());

    String nodeID = StringUtils.trimToEmpty(request.getParameter("nodeid"));
    if (StringUtils.isNotBlank(nodeID)) {
        try {
            long nodeid = Long.parseLong(nodeID);
            event.setNodeid(nodeid);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid node id value: " + nodeID, e);
        }
    }

    String host = StringUtils.trimToEmpty(request.getParameter("host"));
    if (StringUtils.isNotBlank(host)) {
        event.setHost(host);
    }

    String intface = StringUtils.trimToEmpty(request.getParameter("interface"));
    if (StringUtils.isNotBlank(intface)) {
        event.setInterface(intface);
    }

    String service = StringUtils.trimToEmpty(request.getParameter("service"));
    if (StringUtils.isNotBlank(service)) {
        event.setService(service);
    }

    String severity = StringUtils.trimToEmpty(request.getParameter("severity"));
    if (StringUtils.isNotBlank(severity)) {
        event.setSeverity(severity);
    }

    String description = StringUtils.trimToEmpty(request.getParameter("description"));
    if (StringUtils.isNotBlank(description)) {
        event.setDescr(description);
    }

    String operinstruct = StringUtils.trimToEmpty(request.getParameter("operinstruct"));
    if (StringUtils.isNotBlank(operinstruct)) {
        event.setOperinstruct(operinstruct);
    }

    String uuid = StringUtils.trimToEmpty(request.getParameter("uuid"));
    if (StringUtils.isNotBlank(uuid)) {
        event.setUuid(uuid);
    }

    StringBuffer sb = new StringBuffer();

    Enumeration<String> pNames = request.getParameterNames();
    for(String pName : Collections.list(pNames)) {
        if (pName.matches("^parm(\\d+)\\.name$")) {
            String parmName = StringUtils.trimToEmpty(request.getParameter(pName));
            if (StringUtils.isNotBlank(parmName)) {
                String vName = pName.replaceAll("\\.name$", ".value");
                String parmValue = StringUtils.trimToEmpty(request.getParameter(vName));
                sb.append("  &lt;parm name=\""+parmName+"\" value=\""+parmValue+"\" /&gt;\n");

                final Value value = new Value();
                value.setContent(parmValue);

                final Parm parm = new Parm();
                parm.setParmName(parmName);
                parm.setValue(value);

                event.addParm(parm);
            }
        }
    }

    try {
        Util.createEventProxy().send(event);
    } catch (Throwable e) {
        throw new ServletException("Could not send event " + event.getUei(), e);
    }
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Post Event" />
  <jsp:param name="headTitle" value="Post Event" />
  <jsp:param name="headTitle" value="Admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="Post Event" />
</jsp:include>

<%
    String eventXml = JaxbUtils.marshal(event);
    // Strip off xml version string
    eventXml = eventXml.replaceFirst("^<\\?xml[^\\>]+\\?\\>\\s*", "");
%>

<div class="card">
  <div class="card-header">
    <span>Event Sent...</span>
  </div>
  <div class="card-body">
    <pre><c:out value="<%=eventXml%>" /></pre>
  </div> <!-- card-body -->
</div> <!-- panel -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
