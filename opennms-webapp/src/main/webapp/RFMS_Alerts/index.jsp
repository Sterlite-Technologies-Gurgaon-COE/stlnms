<%@page language="java"
        contentType="text/html; charset=UTF-8"
            pageEncoding="UTF-8"
%>
<%@ page import="java.sql.*"%>
<%@ page import="com.google.gson.*"%>
         <jsp:include page="/includes/bootstrap.jsp" flush="false">
         <jsp:param name="title" value="RFMS Reports" />
         <jsp:param name="headTitle" value="RFMS" />
         <jsp:param name="breadcrumb" value="RFMS" />
         <jsp:param name="location" value="rfms" />
         </jsp:include>
      <h1>RFMS Demo Table</h1>
      <%
         Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://10.100.101.202:5432/opennms", "postgres", "postgres");
         Statement getFromDb = dbConnection.createStatement();
         ResultSet resultset = getFromDb.executeQuery("SELECT * FROM public.rfms");
      %>
      <link rel="stylesheet" href="RFMS_Alerts/style.css"> 


      <div class="container">
         <h2>Responsive Tables Using LI <small>Triggers on 767px</small></h2>
         <ul class="responsive-table">
           <li class="table-header">
             <div class="col col-2">FMS Id</div>
             <div class="col col-2">Event Time</div>
             <div class="col col-2">Alarm Summary</div>
             <div class="col col-2">Max Fault Position</div>
             <div class="col col-2">Min Fault Position</div>
             <div class="col col-2">Position</div>
             <div class="col col-2">Severity</div>
             <div class="col col-2">Probable Cause</div>
             <div class="col col-2">RTU Id</div>
             <div class="col col-2">RTU Name</div>
           </li>

           <% while(resultset.next()){ %>
           <li class="table-row">
             <div class="col col-2" > <%= resultset.getString(1) %></div>
             <div class="col col-2" > <%= resultset.getString(2) %></div>
             <div class="col col-2" > <%= resultset.getString(3) %></div>
             <div class="col col-2" > <%= resultset.getString(4) %></div>
             <div class="col col-2" > <%= resultset.getString(5) %></div>
             <div class="col col-2" > <%= resultset.getString(6) %></div>
             <div class="col col-2" > <%= resultset.getString(7) %></div>
             <div class="col col-2" > <%= resultset.getString(8) %></div>
             <div class="col col-2" > <%= resultset.getString(9) %></div>
             <div class="col col-2" > <%= resultset.getString(10) %></div>
           </li>
           <% } %>
           
         </ul>
       </div>

       <jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />