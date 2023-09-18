<%@ page contentType="text/html;charset=UTF-8" language="java" import="org.opennms.web.springframework.security.AclUtils"%>
<% pageContext.setAttribute("nodeId", request.getParameter("node")); %>
<% pageContext.setAttribute("nodeLabel", request.getParameter("node")); %>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>

<jsp:include page="/includes/bootstrap.jsp" flush="false">
  <jsp:param name="ngapp" value="onms-assets" />
  <jsp:param name="title" value="Node Templates" />
  <jsp:param name="headTitle" value="Node Templates" />
  <jsp:param name="headTitle" value="ID ${nodeId}" />
  <jsp:param name="location" value="node_templates" />
  <jsp:param name="breadcrumb" value="<a href='element/node.jsp?node=${nodeId}'>Node Id : ${nodeId}</a>" />
  <jsp:param name="breadcrumb" value="Node Templates" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="jquery-ui-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="bootbox-js" />
</jsp:include>
<jsp:include page="/assets/load-assets.jsp" flush="false">
  <jsp:param name="asset" value="onms-assets" />
</jsp:include>


<div id="mainDiv" class="container-fluid" ng-controller="NodeAssetsCtrl" ng-init="init(${nodeId})" style="padding-left: 0px;">
    <div>    
        <h2>
          Templates for NodeLabel: <strong><a href="element/node.jsp?node=${nodeId}">{{nodeLabel}}</a></strong>
        </h2>   
    </div>     
    <script>
        $(document).ready(function () {
            $('#myTable').DataTable();
        });
    </script>


    <link rel="stylesheet" href="./rfms/css/jquery.dataTables.css">
    <script type="text/javascript" src="./rfms/js/jquery.dataTables.js"></script>


    <%
        Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
        Statement getFromDb = dbConnection.createStatement();
        ResultSet resultset = getFromDb.executeQuery("SELECT * FROM public.events ORDER BY eventid ASC LIMIT 20");
    %>


        <br>

        
            <table id="myTable" class="table table-sm severity display"  style="margin: 20px; ">
                <thead>
                    <tr>
                        <th>Column 1</th>
                        <th>Column 2</th>
                        <th>Column 3</th>
                        <th>Column 4</th>
                        <th>Column 5</th>
                        <th>Column 6</th>
                        <th>Column 7</th>
                    </tr>
                </thead>
                <tbody>
                    <% while(resultset.next()){ %>
                    <tr>
                        <td> <%= resultset.getString(1) %></td>
                        <td> <%= resultset.getString(2) %></td>
                        <td> <%= resultset.getString(3) %></td>
                        <td> <%= resultset.getString(4) %></td>
                        <td> <%= resultset.getString(5) %></td>
                        <td> <%= resultset.getString(6) %></td>
                        <td> <%= resultset.getString(7) %></td>

                        <!-- <script>
                            console.log("<%= resultset.getString(1) %>");
                        </script> -->
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <br>

</div> 

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />