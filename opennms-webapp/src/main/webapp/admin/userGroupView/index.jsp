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
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Configure Users and Groups" />
  <jsp:param name="headTitle" value="Users and Groups" />
  <jsp:param name="headTitle" value="Admin" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="Users and Groups" />
</jsp:include>

<div class="row">
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Users and Groups</span>
      </div>
      <div class="card-body">
        <p>
          <a HREF="admin/userGroupView/users/list.jsp">Configure Users</a>
        </p>
        <p>
          <a HREF="admin/userGroupView/groups/list.htm">Configure Groups</a>
        </p>
        <p>
          <a HREF="admin/userGroupView/roles">Configure On-Call Roles</a>
        </p>
        <!--
        <p>
          <a HREF="admin/userGroupView/views/list.jsp">Configure Views</a>
        </p>
        -->
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->

  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Users</span>
      </div>
      <div class="card-body">
        <p>
          Add new <em>Users</em>, change user names and passwords, and edit notification information.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->

    <div class="card">
      <div class="card-header">
        <span>Groups</span>
      </div>
      <div class="card-body">
        <p>
          Assign and unassign <em>Users</em> to <em>Groups</em>.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->

    <div class="card">
      <div class="card-header">
        <span>Roles</span>
      </div>
      <div class="card-body">
        <p>
          Configure Roles that define On Call schedules for users.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="true"/>
