<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2006-2021 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2021 The STL-NMS Group, Inc.
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Applications" />
	<jsp:param name="headTitle" value="Applications" />
	<jsp:param name="breadcrumb"
		value="<a href='admin/index.jsp'>Admin</a>" />
	<jsp:param name="breadcrumb" value="Applications" />
</jsp:include>

      <div class="card-header">
        <span>Applications</span>
      </div>
      <table class="table table-sm table-responsive">
        <tr>
          <th>Delete</th>
          <th>Edit</th>
          <th>Application</th>
        </tr>
        <c:forEach items="${applications}" var="app">
        <tr>
          <td><a href="admin/applications.htm?removeApplicationId=${app.id}"><i class="fa fa-trash-o fa-2x"></i></a></td>
          <td><a href="admin/applications.htm?applicationid=${app.id}&edit=services"><i class="fa fa-edit fa-2x"></i></a></td>
          <td><a href="admin/applications.htm?applicationid=${app.id}">${fn:escapeXml(app.name)}</a></td>
        </tr>
        </c:forEach>
        <tr>
          <td colspan="3">
            <form class="form-inline mt-4" action="admin/applications.htm">
              <div class="form-group">
                <input type="textfield" class="form-control" placeholder="Application name" name="newApplicationName" size="40"/>
              </div>
              <button type="submit" name="newApplicationSubmit" class="btn btn-secondary ml-2"><i class="fa fa-plus"></i> Add New Application</button>
            </form>
          </td>
        </tr>
      </table>
    </div> <!-- panel -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
