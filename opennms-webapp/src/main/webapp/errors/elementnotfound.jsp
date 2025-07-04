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
	import="org.opennms.web.element.*"
%>
<%@page import="org.opennms.core.utils.WebSecurityUtils" %>

<%!
    public ElementNotFoundException findElementNotFoundException(Throwable throwable) {
        if (throwable == null) {
            return null;
        }
        if (throwable instanceof ElementNotFoundException) {
            return (ElementNotFoundException) throwable;
        }
        return findElementNotFoundException(throwable.getCause());
    }
%>
<%
    final ElementNotFoundException enfe = findElementNotFoundException(exception);
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Error" />
  <jsp:param name="headTitle" value="Element Not Found" />
  <jsp:param name="headTitle" value="Error" />
  <jsp:param name="breadcrumb" value="Error" />
</jsp:include>

<h1><%=enfe.getElemType(true)%>  Not Found</h1>

<p>
  The <%=enfe.getElemType()%> is invalid. <%=WebSecurityUtils.sanitizeString(enfe.getMessage())%>
  <br/>
  <% if (enfe.getDetailUri() != null) { %>
  <p>
  To search again by <%=enfe.getElemType()%> ID, enter the ID here:
  </p>
  <form role="form" method="get" action="<%=enfe.getDetailUri()%>" class="form">
    <div class="row">
      <div class="form-group col-md-2">
        <label for="input_text">Get&nbsp;details&nbsp;for&nbsp;<%=enfe.getElemType()%></label>
        <input type="text" class="form-control" id="input_text" name="<%=enfe.getDetailParam()%>"/>
      </div>
    </div>
    <button type="submit" class="btn btn-secondary">Search</button>
  </form>
  <% } %>
  
  <% if (enfe.getBrowseUri() != null) { %>
  <p>
  To find the <%=enfe.getElemType()%> you are looking for, you can
  browse the <a href="<%=enfe.getBrowseUri()%>"><%=enfe.getElemType()%> list</a>.
  </p>
  <% } %>
</p>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
