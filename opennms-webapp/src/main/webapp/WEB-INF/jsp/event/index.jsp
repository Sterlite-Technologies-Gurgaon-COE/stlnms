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
%>

<%@ page import="java.util.List" %>
<%@ page import="org.opennms.web.filter.NormalizedQueryParameters" %>
<%@ page import="org.opennms.web.tags.filters.EventFilterCallback" %>
<%@ page import="org.opennms.web.tags.filters.FilterCallback" %>
<%@ page import="org.opennms.netmgt.model.OnmsFilterFavorite" %>
<%@ page import="org.opennms.web.filter.Filter" %>
<%@ page import="org.opennms.core.utils.WebSecurityUtils" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Events" />
  <jsp:param name="headTitle" value="Events" />
  <jsp:param name="location" value="event" />  
  <jsp:param name="breadcrumb" value="Events" />
</jsp:include>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="../../taglib.tld" prefix="onms" %>

<div class="row">
  <div class="col-md-6">
      <div class="card">
      <div class="card-header">
      	<span>Event Queries</span>
      </div>
      <div class="card-body">
        <%--<jsp:include page="/includes/event-querypanel.jsp" flush="false" />--%>
        <form action="event/detail.jsp" method="get" role="form" class="form pull-right">
          <div class="form-group">
            <label for="byeventid_id">Event ID</label>
              <div class="input-group">
                  <input type="text" class="form-control" name="id" id="byeventid_id"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </div>                
        </form>

        <ul class="list-unstyled">
            <li><a href="event/list" title="View all outstanding events">All events</a></li>
            <li><a href="event/advsearch.jsp" title="More advanced searching and sorting options">Advanced Search</a></li>
        </ul>
      </div>
    </div>

    <div class="card">
    <div class="card-header">
    	<span>Event Filter Favorites</span>
    </div>
    <div class="card-body">
    <onms:alert/>
        <c:choose>
            <c:when test="${!empty favorites}">
                <!-- Filters -->
                <ul class="list-unstyled mb-0">
                    <c:forEach var="eachFavorite" items="${favorites}">
                      	<%
                      		OnmsFilterFavorite current = (OnmsFilterFavorite) pageContext.getAttribute("eachFavorite");
    						FilterCallback callback = (EventFilterCallback) request.getAttribute("callback");

					    	List<Filter> queryElements = callback.parse(current.getFilter());
					    	
					    	final StringBuilder buf = new StringBuilder("<ul class=\"list-unstyled\">"); 
					    	for(Filter queryElement : queryElements) {
					    	    buf.append("<li>");
					    		buf.append(queryElement.getTextDescription());
							    buf.append("</li>");
					    	}
					    	buf.append("</ul>");

                            pageContext.setAttribute("favTitle", buf.toString());
    					%>
                      
                          <li>
                              <a href="event/list.htm?favoriteId=${eachFavorite.id}&${eachFavorite.filter}" title='<c:out value='${favTitle}'/>' data-html="true" data-toggle="tooltip" data-placement="right">${eachFavorite.name}</a> <a href="event/deleteFavorite?favoriteId=${eachFavorite.id}&redirect=/event/index" title='Delete favorite' data-toggle="tooltip" data-placement="right"><span class="fa fa-remove text-danger"></span></a>
                          </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>No favorites available.</p>
            </c:otherwise>
        </c:choose>
      </div>
      </div>
  </div>

  <div class="col-md-6">
	<div class="card">
	<div class="card-header">
      <span>Outstanding and acknowledged events</span>
 	</div>
 	<div class="card-body">
      <p>Events can be <em>acknowledged</em>, or removed from the view of other users, by
        selecting the event in the <em>Ack</em> check box and clicking the <em>Acknowledge
        Selected Events</em> at the bottom of the page.  Acknowledging an event gives
        users the ability to take personal responsibility for addressing a network
        or systems-related issue.  Any event that has not been acknowledged is
        active in all users' browsers and is considered <em>outstanding</em>.
      </p>
            
      <p>If an event has been acknowledged in error, you can select the 
        <em>View all acknowledged events</em> link, find the event, and <em>unacknowledge</em> it,
        making it available again to all users' views.
      </p>
        
      <p>If you have a specific event identifier for which you want a detailed event
        description, type the identifier into the <em>Get details for Event ID</em> box and
        hit <b>[Enter]</b>.  You will then go to the appropriate details page.
      </p>
    </div>
	</div>
  </div>
</div>

<!--  enable tooltips -->
<script type="text/javascript">
  $(function () {
	  $('[data-toggle="tooltip"]').tooltip()
	});
	
</script>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
