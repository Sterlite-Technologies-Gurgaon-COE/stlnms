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
	import="org.opennms.web.controller.statisticsReports.*, org.opennms.web.utils.ExceptionUtils"
%>

<%
    StatisticsReportIdNotFoundException e = ExceptionUtils.getRootCause(exception, StatisticsReportIdNotFoundException.class);
%>


<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Error" />
  <jsp:param name="headTitle" value="Statistics Report Not Found" />
  <jsp:param name="headTitle" value="Error" />
  <jsp:param name="breadcrumb" value="Error" />
</jsp:include>

<h1>Statistics Report ID Not Found</h1>
    
<p>
  A statistics report could not be found for the identifier <c:out value="<%=e.getBadID()%>"/>.
</p>

<p>
  You can enter a new identifier here or <a href="statisticsReports/index.htm">browse
  the list of statistics reports</a> to find the one you are looking for.
</p>

<form role="form" method="get" action="statisticsReports/report.htm" class="form mb-4">
  <div class="row">
    <div class="form-group col-md-2">
      <label for="input_id">Get&nbsp;Statistics&nbsp;Report&nbsp;ID</label>
      <input type="text" class="form-control" id="input_id" name="id"/>
    </div>
  </div>
  <button type="submit" class="btn btn-secondary">Search</button>
</form>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
