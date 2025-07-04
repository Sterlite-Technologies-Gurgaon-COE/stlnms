<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2016 The STL-NMS Group, Inc.
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

<%-- 
  This page is included by other JSPs to create a table containing
  a row for each event passed in.  
  
  This page has one required parameter: node, a node identifier.
  Without this parameter, this page will throw a ServletException.

  It expects that a <base> tag has been set in the including page
  that directs all URLs to be relative to the servlet context.
--%>

<%@page language="java"
	contentType="text/html"
	session="true"
	import="org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.event.*,
		org.opennms.web.api.Authentication,
		org.opennms.web.servlet.MissingParameterException
	"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="/WEB-INF/taglib.tld" prefix="onms" %>

<%
    //required parameter: node
    String nodeIdString = request.getParameter("node");

    if( nodeIdString == null ) {
        throw new MissingParameterException("node");
   }

    int nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
    
    //optional parameters: ipAddr, service
    String ipAddr = request.getParameter("ipAddr");
    String serviceIdString = request.getParameter("service");
    
    //optional parameter: throttle
   String throttleString = request.getParameter( "throttle" );
    int throttle = 0;  //less than one means no throttle

   if( throttleString != null ) {
        try {
           throttle = WebSecurityUtils.safeParseInt( throttleString );
        }
        catch( NumberFormatException e ) {}
   }

   String ifIndexString = request.getParameter("ifIndex");
   int ifIndex = -1;
   if (ifIndexString != null ) {
	   ifIndex= WebSecurityUtils.safeParseInt(ifIndexString);
   }
    //optional parameter: header 
   String header = request.getParameter( "header" );
   if( header == null ) {
        header = "Event List";
   }

   //optional parameter moreUrl, can be null
   String moreUrl = request.getParameter( "moreUrl" );   
    
    Event[] events = new Event[0];

    //sort by event id    
    SortStyle sortStyle = SortStyle.ID;
    
    //include only unacknowledged (outstanding) events
    AcknowledgeType ackType = AcknowledgeType.UNACKNOWLEDGED;    
    
    //throttle from the beginning of the result set
    int offset = 0;
    
    if( ipAddr != null && ! ipAddr.equals("0.0.0.0")) {
        if( serviceIdString != null ) {
            int serviceId = WebSecurityUtils.safeParseInt(serviceIdString);
            events = EventFactory.getEventsForService(nodeId, ipAddr, serviceId, sortStyle, ackType, throttle, offset, getServletContext());
        }
        else {
            events = EventFactory.getEventsForInterface(nodeId, ipAddr, sortStyle, ackType, throttle, offset, getServletContext());
        }
    } else if (ifIndex != -1 ) {
        events = EventFactory.getEventsForInterface(nodeId, ifIndex, sortStyle, ackType, throttle, offset, getServletContext());
    }
    else {
        events = EventFactory.getEventsForNode(nodeId, sortStyle, ackType, throttle, offset, getServletContext());            
    }
%>

<script type="text/javascript" >
    
    function submitAck()
    {
        var isChecked = false
        
        if (document.acknowledge_form.event.length)
        {
            for( i = 0; i < document.acknowledge_form.event.length; i++ ) 
            {
              //make sure something is checked before proceeding
              if (document.acknowledge_form.event[i].checked)
              {
                isChecked=true;
              }
            }
            
            if (isChecked)
            {
              document.acknowledge_form.submit();
            }
            else
            {
              alert("Please check the events that you would like to acknowledge.");
            }
        }
        else
        {
            if (document.acknowledge_form.event.checked)
            {
                document.acknowledge_form.submit();
            }
            else
            {
                alert("Please check the events that you would like to acknowledge.");
            }
        }
    }
</script>

<% if( request.isUserInRole( Authentication.ROLE_ADMIN ) || !request.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
    <form action="event/acknowledge" method="post" name="acknowledge_form">
    <input type="hidden" name="redirect" value="<c:out value='<%= request.getServletPath() + "?" + request.getQueryString()%>'/>" />
    <input type="hidden" name="actionCode" value="<%=org.opennms.web.event.AcknowledgeType.ACKNOWLEDGED.getShortName() %>" />
<% } %>

<div id="include-eventlist" class="card">

<div class="card-header">
<span><%=header%></span>
</div>
<table class="table table-sm severity">

<%
   String acknowledgeEvent = System.getProperty("opennms.eventlist.acknowledge");
   for( int i=0; i < events.length; i++ ) {
       Event event = events[i];
       pageContext.setAttribute("event", event);
%>
     <tr class="severity-<%= event.getSeverity().getLabel() %>">
       <% if( request.isUserInRole( Authentication.ROLE_ADMIN ) || !request.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
           <td class="divider">
             <nobr>
               <% if ("true".equals(acknowledgeEvent)) { %>
               <input type="checkbox" name="event" value="<%=event.getId()%>" />
               <% } %>
               <a href="event/detail.jsp?id=<%=event.getId()%>"><%=event.getId()%></a>
             </nobr>
           </td>
       <% } %>
       <td class="divider"><onms:datetime date="${event.time}"/></td>
       <td class="divider bright"><%= event.getSeverity().getLabel() %></td>
       <td class="divider"><%=WebSecurityUtils.sanitizeString(event.getLogMessage(),true)%></td>
     </tr>
<% } %>

<% if( (request.isUserInRole( Authentication.ROLE_ADMIN ) || !request.isUserInRole( Authentication.ROLE_READONLY )) && "true".equals(acknowledgeEvent)) { %>
     <tr>
       <td class="standard" colspan="2">
           <nobr>
             <input type="button" class="btn btn-secondary" value="Acknowledge" onclick="submitAck()">
             <input TYPE="reset" class="btn btn-secondary" />
           </nobr>
       </td>

     </tr>
<% } %>
      
</table>

<% if( moreUrl != null ) { %>
  <div class="card-footer">
    <a href="<c:out value="<%=moreUrl%>"/>">More...</a>
  </div>
<% } %>

</div>
</form>
