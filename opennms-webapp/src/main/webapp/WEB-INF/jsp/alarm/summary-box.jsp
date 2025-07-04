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
  abbreviated list of alarms.
  
  It expects that a <base> tag has been set in the including page
  that directs all URLs to be relative to the servlet context.
--%>

<%@page language="java"
        contentType="text/html"
        session="true"
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- alarm/summary-box.htm -->
<c:url var="headingLink" value="alarm/list.htm"/>
<div class="card">
  <div class="card-header">
    <span><a href="${headingLink}">Nodes with Pending Problems</a></span>
  </div>
  <c:choose>
    <c:when test="${empty summaries}">
      <div class="card-body">
        <p class="mb-0">
          There are no pending problems.
        </p>
      </div>
    </c:when>
    <c:otherwise>
      <table class="table table-sm severity mb-0">
        <c:forEach var="summary" items="${summaries}">
          <c:url var="nodeLink" value="element/node.jsp">
            <c:param name="node" value="${summary.nodeId}"/>
          </c:url>
          <tr class="severity-${summary.maxSeverity.label} nodivider"><td class="bright">
              <a href="${nodeLink}"><c:out value="${summary.nodeLabel}"/></a> has
              <a href="alarm/list.htm?sortby=id&acktype=unack&limit=20&display=short&filter=node%3D${summary.nodeId}">${summary.alarmCount}&nbsp;alarm${summary.alarmCount > 1 ? "s" : ""}</a>
              <span style="white-space:nowrap;">(${summary.fuzzyTimeDown})</span>
          </td></tr>
        </c:forEach>
      </table>
      <c:if test="${moreCount > 0}">
        <div class="card-footer text-right">
          <c:url var="moreLink" value="alarm/list.htm"/>
          <a href="${moreLink}">All pending problems...</a>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</div>
