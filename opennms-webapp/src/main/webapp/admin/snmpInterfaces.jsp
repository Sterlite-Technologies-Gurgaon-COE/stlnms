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

<%@page language="java"	contentType="text/html" session="true"%>
<%
  String nodeId = request.getParameter("node");
  String nodeLabel = request.getParameter("nodelabel");

  if (nodeId == null) {
    throw new org.opennms.web.servlet.MissingParameterException("node");
  }
  if (nodeLabel == null) {
    throw new org.opennms.web.servlet.MissingParameterException("nodelabel");
  }
%>
<jsp:include page="/includes/bootstrap.jsp" flush="false" >
	<jsp:param name="ngapp" value="onms-interfaces-config" />
	<jsp:param name="title" value="Select SNMP Interfaces" />
	<jsp:param name="headTitle" value="Select SNMP Interfaces" />
	<jsp:param name="headTitle" value="Admin"/>
	<jsp:param name="location" value="admin" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
	<jsp:param name="breadcrumb" value="Select SNMP Interfaces" />
</jsp:include>

<jsp:include page="/assets/load-assets.jsp" flush="false">
    <jsp:param name="asset" value="angular-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
    <jsp:param name="asset" value="onms-interfaces-config" />
</jsp:include>

<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        <span>Choose SNMP Interfaces for Data Collection</span>
      </div>
      <div class="card-body">
        <p>
        Listed below are all the known interfaces for the selected node. If
        <strong>snmpStorageFlag</strong> is set to <strong>select</strong> for a collection scheme that includes
        the interface marked as <strong>Primary</strong>, only the interfaces checked below will have
        their collected SNMP data stored. This has no effect if <strong>snmpStorageFlag</strong> is
        set to <strong>primary</strong> or <strong>all</strong>.
        </p>
        <p>
        In order to change what interfaces are scheduled for collection, simply click
        the checkbox shown on the collect column, and the change will immediately update the database.
        </p>
        <p>
	    <strong>Node ID</strong>: <%=nodeId%><br/>
	    <strong>Node Label</strong>: <%=nodeLabel%><br/>
        </p>
        <p>
        <div id="onms-interfaces-config">
          <div growl></div>
          <onms-interfaces-config node="<%=nodeId%>"/>
        </div>
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="true"/>
