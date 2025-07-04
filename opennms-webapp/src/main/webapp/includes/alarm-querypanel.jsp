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
	import="org.opennms.web.alarm.AlarmUtil"
%>

<form class="form-inline" name="alarm_search" action="alarm/query" method="get" onsubmit="return Blank_TextField_Validator()">
	<div class="input-group">
		<input class="form-control" type="text" name="alarmtext" placeholder="Alarm Text"/>
		<select class="form-control custom-select" id="relativetime" name="relativetime">
			<option value="0" selected><%=AlarmUtil.ANY_RELATIVE_TIMES_OPTION%> Time</option>
			<option value="1">Last hour</option>
			<option value="2">Last 4 hours</option>
			<option value="3">Last 8 hours</option>
			<option value="4">Last 12 hours</option>
			<option value="5">Last day</option>
			<option value="6">Last week</option>
			<option value="7">Last month</option>
		</select>
		<div class="input-group-append">
			<button class="btn btn-secondary" type="submit"><i class="fa fa-search"></i></button>
		</div>
	</div>
</form>
