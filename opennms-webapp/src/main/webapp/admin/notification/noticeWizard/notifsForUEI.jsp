<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2007-2017 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2017 The STL-NMS Group, Inc.
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
	import="java.util.*,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.notifications.*
	"
%>

<%!
    public void init() throws ServletException {
        try {
            NotificationFactory.init();
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<%
	String uei=request.getParameter("uei");
	Map<String, Notification> allNotifications=NotificationFactory.getInstance().getNotifications();
	List<Notification> notifsForUEI=new ArrayList<>();
	for(String key : allNotifications.keySet()) {
	    Notification notif=allNotifications.get(key);
		if(notif.getUei().equals(uei)) {
		    notifsForUEI.add(notif);
		}
	}
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Choose Event" />
  <jsp:param name="headTitle" value="Choose Event" />
  <jsp:param name="headTitle" value="Admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>Configure Notifications</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/noticeWizard/eventNotices.htm'>Event Notifications</a>" />
  <jsp:param name="breadcrumb" value="Existing notifications for UEI" />
</jsp:include>

<script type="text/javascript" >

    function next()
    {
        if (document.events.uei.selectedIndex==-1)
        {
            alert("Please select a uei to associate with this notification.");
        }
        else
        {
            document.events.submit();
        }
    }
	function submitEditForm(noticeName) {
		document.getElementById("notice").value=noticeName;
		document.editForm.submit();
	}

</script>
<!-- Hidden form that will cause the notification to be edited -->
<form action="admin/notification/noticeWizard/notificationWizard"  method="post" name="editForm">
	<input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_NOTIFS_FOR_UEI%>"/>
	<input type="hidden" name="userAction" value="edit"/>
	<input type="hidden" id="notice" name="notice" value=""/>
</form>

<form action="admin/notification/noticeWizard/notificationWizard"  method="post" name="newNotificationForm">
	<input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_NOTIFS_FOR_UEI%>"/>
	<input type="hidden" name="userAction" value="new"/>
	<input type="hidden" name="uei" value="<%=uei%>"/>
</form>

<div class="card">
  <div class="card-header">
    <span>Existing Notifications for UEI <%=uei%></span>
  </div>
      <table class="table table-sm">
      	 <tr><th>Name</th><th>Description</th><th>Rule</th><th>Destination path</th><th>Varbinds</th><th>Actions</th></tr>
      <% for(Notification notif : notifsForUEI) { 
          	String varbindDescription="";
          	Varbind varbind=notif.getVarbind();
          	if(varbind!=null) {
          		varbindDescription=varbind.getVbname()+"="+varbind.getVbvalue();
          	}
      		%>
	        <tr>
	        	<td><%=notif.getName()%></td>
	        	<td><%=notif.getDescription().orElse("")%></td>
	        	<td><%=notif.getRule()%></td>
	        	<td><%=notif.getDestinationPath()%></td>
	        	<td><%=varbindDescription%></td>
	        	<td><a href="javascript: void submitEditForm('<%=notif.getName()%>');">Edit</a></td>
			</tr>
<% } %>
	  </table>
	<div class="card-footer">
		<a class="btn btn-secondary" href="javascript: document.newNotificationForm.submit()">Create a new notification</a>
	</div>
</div> <!-- panel -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
