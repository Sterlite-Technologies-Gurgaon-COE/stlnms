<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2016 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2016 The STL-NMS Group, Inc.
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

<%@ page language="java" contentType="text/html" session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- bsm/summary-box.htm -->
<div class="card">
  <div class="card-header">
      <a href="#">Business Services with Pending Problems</a>
  </div>
  <c:choose>
    <c:when test="${empty services}">
      <div class="card-body">
        <p class="mb-0">
          There are no pending problems.
        </p>
      </div>
    </c:when>
    <c:otherwise>
      <table class="table table-sm severity mb-0">
        <c:forEach var="service" items="${services}">
          <c:url var="bsTopoLink" value="topology">
            <c:param name="focus-vertices" value="${service.id}"/>
            <c:param name="szl" value="1"/>
            <c:param name="layout" value="Hierarchy Layout" />
            <c:param name="provider" value="Business Services" />
          </c:url>
          <tr class="severity-${service.operationalStatus.label} nodivider">
            <td class="bright">
              <a href="${bsTopoLink}">${service.name}</a>
            </td>
          </tr>
        </c:forEach>
      </table>
      <c:if test="${more}">
        <div class="card-footer text-right">
          Not all Business Services with Pending Problems are shown.
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</div>