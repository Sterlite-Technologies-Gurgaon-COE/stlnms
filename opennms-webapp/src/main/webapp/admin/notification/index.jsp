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

--%>

<%@page language="java"
	contentType="text/html"
	session="true"
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Configure Notifications" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="Configure Notifications" />
</jsp:include>

<div class="row">
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Configure Notifications</span>
      </div>
      <div class="card-body">
        <p>
          <a href="admin/notification/noticeWizard/eventNotices.htm">Configure Event Notifications</a>
        </p>
        <p>
          <a href="admin/notification/destinationPaths.jsp">Configure Destination Paths</a>
        </p>
        <p>
          <a href="admin/notification/noticeWizard/buildPathOutage.jsp?newRule=IPADDR+IPLIKE+*.*.*.*&showNodes=on">Configure Path Outages</a>
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->

  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Event Notifications</span>
      </div>
      <div class="card-body">
        <p>
          Each event can be configured to send a notification whenever that event is
          triggered. This wizard will walk you through the steps needed for
          configuring an event to send a notification.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->

    <div class="card">
      <div class="card-header">
        <span>Destination Paths</span>
      </div>
      <div class="card-body">
        <p>
          A destination path describes what users or groups will receive
          notifications, how the notifications will be sent, and who to notify
          if escalation is needed. This wizard will walk you through setting up
          a resuable list of who to contact and how to contact them, 
          which are used in the event configuration.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->

    <div class="card">
      <div class="card-header">
        <span>Path Outages</span>
      </div>
      <div class="card-body">
        <p>
          Configuring a path outage consists of selecting an IP address/service pair
          which defines the critical path to a group of nodes.  When a node down
          condition occurs for a node in the group, the critical path will be tested.
          If it fails to respond, the node down notifications will be suppressed. The
          critical path service is typically ICMP, and at this time ICMP is the only
          critical path service supported.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
