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
	import="org.opennms.netmgt.config.users.*,
	        org.opennms.netmgt.config.*,
		java.util.*"
%>

<%
	UserManager userFactory;
  	Map<String,User> users = null;
	HashMap<String,String> usersHash = new HashMap<String,String>();
	
	try
    	{
		UserFactory.init();
		userFactory = UserFactory.getInstance();
      		users = userFactory.getUsers();
	}
	catch(Throwable e)
	{
		throw new ServletException("User:list " + e.getMessage());
	}

	for (User curUser : users.values()) {
		usersHash.put(curUser.getUserId(), curUser.getFullName().orElse(null));
	}

%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Roles" />
	<jsp:param name="headTitle" value="Roles" />
	<jsp:param name="breadcrumb" value="Roles" />
</jsp:include>

<script type="text/javascript" >

	function doOperation(op, role) {
		document.roleForm.operation.value=op;
		document.roleForm.role.value=role;
		document.roleForm.submit();
	}
	
	function doView(role) {
		doOperation("view", role);
	}

</script>



<form action="<c:url value='${reqUrl}'/>" method="post" name="roleForm">
	<input type="hidden" name="operation" />
	<input type="hidden" name="role" />
</form>

<div class="card">
  <div class="card-header">
    <span>Roles</span>
  </div>

  <table class="table table-sm severity">
         <tr>
          <th>Name</th>
          <th>Supervisor</th>
          <th>Currently On Call</th>
          <th>Membership Group</th>
          <th>Description</th>

			<c:forEach var="role" items="${roleManager.roles}">
				<c:set var="viewUrl" value="javascript:doView('${role.name}')" />
				
				<tr>
				<td><a href="<c:out value='${viewUrl}'/>"><c:out value="${role.name}"/></a></td>
				<td><c:set var="supervisorUser"><c:out value="${role.defaultUser}"/></c:set><c:set var="fullName"><%= usersHash.get(pageContext.getAttribute("supervisorUser").toString()) %></c:set><span title="<c:out value="${fullName}"/>"><c:out value="${role.defaultUser}"/></span></td>
				<td>
					<c:forEach var="scheduledUser" items="${role.currentUsers}">
						<c:set var="fullName"><%= usersHash.get(pageContext.getAttribute("scheduledUser").toString()) %></c:set>
						<span title="<c:out value="${fullName}"/>"><c:out value="${scheduledUser}"/></span>
					</c:forEach>	
				</td>
				<td><c:out value="${role.membershipGroup}"/></td>
				<td><c:out value="${role.description}"/></td>
				</tr>
			</c:forEach>
		</table>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
