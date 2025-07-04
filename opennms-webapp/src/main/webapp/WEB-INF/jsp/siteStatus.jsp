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

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Site Status Page" />
	<jsp:param name="headTitle" value="Site Status" />
	<jsp:param name="breadcrumb" value="Site Status" />
	<jsp:param name="breadcrumb" value="${view.columnValue}" />
</jsp:include>

<div class="card">
  <div class="card-header">
    <span>Site status for nodes in site '${view.columnValue}'</span>
  </div>
  <table class="table table-sm table-bordered severity">
    <thead>
      <tr>
        <th>Device Type</th>
        <th>Nodes Down</th>
      </tr>
    </thead>
    <c:forEach items="${stati}" var="status">
      <tr class="CellStatus" >
        <td>${status.label}</td>
        <td class="bright severity-${status.status}" >
          <c:choose>
            <c:when test="${! empty status.link}">
              <c:url var="statusLink" value="${status.link}"/>
              <a href="${statusLink}">${status.downEntityCount} of ${status.totalEntityCount}</a>
            </c:when>
            <c:otherwise>
              ${status.downEntityCount} of ${status.totalEntityCount}
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
  </table>
</div> <!-- panel -->
  
<div class="card">
  <div class="card-header">
    <span>Site outages</span>
  </div>
  <div class="card-body">
    <c:url var="outagesLink" value="outage/list.htm">
      <c:param name="filter" value="asset.building=${view.columnValue}"/>
    </c:url>
    <p>
      <a href="${outagesLink}">View</a> current site outages.
    </p>
  </div> <!-- card-body -->
</div> <!-- panel -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
