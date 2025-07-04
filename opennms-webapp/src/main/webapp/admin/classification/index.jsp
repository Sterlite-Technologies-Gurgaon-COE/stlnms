<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2018-2018 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2018 The STL-NMS Group, Inc.
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
<jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="norequirejs" value="true" />

    <jsp:param name="title" value="Flow Classification" />
    <jsp:param name="ngapp" value="onms.classifications" />
    <jsp:param name="headTitle" value="Flow Classification" />
    <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
    <jsp:param name="breadcrumb" value="Flow Classification" />
</jsp:include>

<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="onms-classifications" />
</jsp:include>

<div ui-view>

</div>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
