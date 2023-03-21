<%@page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*"%>
<jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="title" value="Garv EC2 Instance" />
    <jsp:param name="headTitle" value="Garv EC2 Graph" />
    <jsp:param name="breadcrumb" value="Garv EC2 Instance" />
    <jsp:param name="location" value="garvgraph" />
</jsp:include>
<html>
<body>
    <link rel="stylesheet" href="garvgraph/button.css">    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    <div style="float:right;">
        <form action="" method="POST">
            <input id="postdate" class="button-17" type="date" name="date" required>
            <button onclick="click()" class="button-17" type="submit" id="submit1">Submit</button>
        </form>
    </div>
    <script>
        document.getElementById("postdate").addEventListener("input", () => console.log(document.getElementById(
            "postdate").value));
    </script>
    <%
        String dateParam = request.getParameter("date");
        String outputDate;
        if (dateParam == null || dateParam.isEmpty()) {
            Date currentDate = new Date();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            outputDate = dateFormat.format(currentDate);
        } else {
            outputDate = dateParam;
        }
        Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
        Statement getFromDb = dbConnection.createStatement();
        ResultSet resultset = getFromDb.executeQuery("SELECT * FROM public.garv_ec2 WHERE DATE(timecode) = '%"+outputDate+"%' ");
       
        ArrayList ar=new ArrayList();
        ArrayList ar1=new ArrayList();
        while(resultset.next())
        {
            String str = resultset.getString(4);
            String str1 = resultset.getString(2);
            ar.add(str);
            ar1.add(str1);
        }
    %>
    <script type="text/javascript">
        window.onload = function () {
            var x = new Date();
            var dateString = new Date(x.getTime() - (x.getTimezoneOffset() * 60000))
                .toISOString()
                .split("T")[0];
            console.log(x);
            console.log(dateString);
            var dateInput = document.getElementById("postdate");
            dateInput.value = '<%=outputDate%>'
            if (dateInput.value === "") {
                dateInput.value = dateString;
            }
            var cpuvalue, timeval;
            var cpuvalue = [<% for (int i = 0; i < ar.size(); i++) { %>"<%= ar.get(i) %>"<%= i + 1 < ar.size() ? ",":"" %><% } %>]
            var timeval = [<% for (int i = 0; i < ar1.size(); i++) { %>"<%= ar1.get(i) %>"<%= i + 1 < ar1.size() ? ",":"" %><% } %>]
            var lt = cpuvalue.length;
            console.log(cpuvalue);
            console.log(timeval);
            var dp_cpu = []; // dataPoints
            var chart = new CanvasJS.Chart("realtimechart", {
                toolTip: {
                    fontcolor: "red",
                    backgroundColor: "#F4D5A6",
                    shared: true
                },
                theme: "light2",
                title: {
                    text: "CPU Utilization Data",
                    fontFamily: "tahoma",
                },
                axisX: {
                    valueFormatString: "HH:mm TT",
                    title: "Time",
                    gridThickness: 1
                },
                axisY: {
                    suffix: "%",
                    minimum: -5,
                    maximum: 100,
                    gridThickness: 1
                },
                data: [{
                    name: "CPU Usage",
                    type: "splineArea",
                    color: "rgba(54,158,173,.7)",
                    dataPoints: dp_cpu
                }],
            });
            var xVal;
            var yValcpu;
            var updateInterval = 5000;
            var dataLength = 10; // number of dataPoints visible at any point
            for (var j = 1; j < 1441;) {
                var tempx = timeval[j - 1];
                var tempcpu = cpuvalue[j - 1];
                var _date_ = new Date(tempx);
                xVal = _date_;
                yValcpu = parseInt(tempcpu);
                dp_cpu.push({
                    x: xVal,
                    y: yValcpu
                });
                j = j + 60;
            }
            console.log(dp_cpu);
            chart.render();
        };
    </script>
    <div id="realtimechart" style="height: 370px; width: 100%;margin-top: 6.5%;"></div>
    
    <br>
    <br>

</body>
</html>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
