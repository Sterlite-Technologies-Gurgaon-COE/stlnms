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
	isErrorPage="true"
	import="org.opennms.web.alarm.*, org.opennms.web.utils.ExceptionUtils"
%>

<%
    AlarmIdNotFoundException einfe = ExceptionUtils.getRootCause(exception, AlarmIdNotFoundException.class);
%>


<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Error" />
  <jsp:param name="headTitle" value="Alarm ID Not Found" />
  <jsp:param name="headTitle" value="Error" />
  <jsp:param name="breadcrumb" value="Error" />
</jsp:include>

<h1>Alarm ID Not Found</h1>

<p>
  The alarm ID <%=einfe.getBadID()%> is invalid. <%=einfe.getMessage()%>
  <br/>
  You can re-enter it here or <a href="alarm/list.htm?acktyp=unack">browse all
  of the alarms</a> to find the alarm you are looking for.
</p>

<form role="form" method="get" action="alarm/detail.htm" class="form mb-4">
  <div class="row">
    <div class="form-group col-md-2">
      <label for="input_id">Get&nbsp;details&nbsp;for&nbsp;Alarm&nbsp;ID</label>
      <input type="text" class="form-control" id="input_id" name="id"/>
    </div>
  </div>
  <button type="submit" class="btn btn-secondary">Search</button>
</form>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
