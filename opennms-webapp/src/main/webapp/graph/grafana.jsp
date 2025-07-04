<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2017 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2017 The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is a registered trademark of The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * STL-NMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with STL-NMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     STL-NMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Grafana Dashboard List" />
  <jsp:param name="headTitle" value="Grafana Dashboard List" />
</jsp:include>

<div class="card">

    <% String showGrafanaBox = System.getProperty("org.opennms.grafanaBox.show", "false");
       if (Boolean.parseBoolean(showGrafanaBox)) { %>
           <jsp:include page="/includes/grafana-box.jsp" flush="false">
               <jsp:param name="useLimit" value="false" />
           </jsp:include>
    <% } %>
</div>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>