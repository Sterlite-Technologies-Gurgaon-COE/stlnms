<%@ page contentType="text/html;charset=UTF-8" language="java" 
  import="
    org.opennms.web.api.Authentication,
    org.springframework.security.core.GrantedAuthority,
    org.springframework.security.core.context.SecurityContextHolder"
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="title" value="RFMS Data" />
    <jsp:param name="headTitle" value="RFMS" />
    <jsp:param name="location" value="rfms" />
    <jsp:param name="breadcrumb" value="RFMS Table" />
</jsp:include>


<div class="container-fluid" style="padding-left: 0px;">

    <script>
        $(document).ready(function () {
            $('#myTable').DataTable();
        });
    </script>



    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.css" />
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.js"></script>

    <%
        Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
        Statement getFromDb = dbConnection.createStatement();
        ResultSet resultset = getFromDb.executeQuery("SELECT * FROM PUBLIC.rfms LIMIT 50");

    %>
        <br>
        
            <table id="myTable" class="table table-sm severity display"  style="margin: 20px;">
                <thead>
                    <tr>
                        <th>RTU ID</th>
                        <th>RTU Name</th>
                        <th>RTU SiteName</th>
                        <th>FMS ID</th>
                        <th>Severity</th>
                        <th>Initial Event Time</th>
                        <th>Alarms Summary</th>
                        <th>MAX Fault Position</th>
                        <th>Min Fault Position</th>
                        <th>Position</th>
                        <th>Probable Cause</th>
                        <th>Measurement ID</th>
                    </tr>
                </thead>
                <tbody>
                    <% while(resultset.next()){ %>
                        <tr>
                            <td> <%= resultset.getString(9) %></td>
                            <td> <%= resultset.getString(10) %></td>
                            <td> <%= resultset.getString(11) %></td>
                            <td> <%= resultset.getString(1) %></td>
                            <td style="color:red ; font-weight: bold;"> <%= resultset.getString(7) %></td>
                            <td> <%= resultset.getString(2) %></td>
                            <td> <%= resultset.getString(3) %></td>
                            <td> <%= resultset.getString(4) %></td>
                            <td> <%= resultset.getString(5) %></td>
                            <td> <%= resultset.getString(6) %></td>
                            <td> <%= resultset.getString(8) %></td>
                            <td> <%= resultset.getString(12) %></td>
                        </tr>
                        <% } %>
                </tbody>
            </table>
        <br>

</div> 



<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
