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

<%-- 
  This page is included by other JSPs to create a box containing an
  abbreviated list of outages.
  
  It expects that a <base> tag has been set in the including page
  that directs all URLs to be relative to the servlet context.
--%>

<%@page language="java"
        contentType="text/html"
        session="true"
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- outage/servicesdown-box.htm -->
<c:url var="headingLink" value="outage/list.htm"/>
<div class="card">
  <div class="card-header">
    <span><a href="${headingLink}">Nodes with Outages</a></span>
  </div>
  <div class="card-body">
    <c:choose>
      <c:when test="${empty summaries}">
        <p class="mb-0">
          There are no current outages
        </p>
      </c:when>

      <c:otherwise>
        <ul class="list-unstyled mb-0">
          <c:forEach var="summary" items="${summaries}">
            <c:url var="nodeLink" value="element/node.jsp">
              <c:param name="node" value="${summary.nodeId}"/>
            </c:url>
            <li><a href="${nodeLink}"><c:out value="${summary.nodeLabel}"/></a> <span style="white-space:nowrap;">(${summary.fuzzyTimeDown})</span></li>
          </c:forEach>
        </ul>
    
      </c:otherwise>
    </c:choose>
  </div>
  <c:if test="${moreCount > 0}">
    <div class="card-footer text-right">
      <c:url var="moreLink" value="outage/list.htm"/>
      <a href="${moreLink}">${moreCount} more nodes with outages...</a>
    </div>
  </c:if>
</div>
