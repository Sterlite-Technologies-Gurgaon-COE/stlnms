<%@ page contentType="text/html;charset=UTF-8" language="java" 
  import="
    org.opennms.web.api.Authentication,
    org.springframework.security.core.GrantedAuthority,
    org.springframework.security.core.context.SecurityContextHolder"
%>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>



<%
    Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
    Statement getFromDb = dbConnection.createStatement();
    
   

    ResultSet forchart2 = getFromDb.executeQuery(" SELECT severity,\"rtuName\", COUNT(\"rtuName\") as count FROM PUBLIC.rfms GROUP BY severity,\"rtuName\" ORDER BY count ASC ");
    ArrayList Severity2 = new ArrayList();
    ArrayList RTUName2 = new ArrayList();
    ArrayList Count2 = new ArrayList();
    while(forchart2.next()){
        String str4 = forchart2.getString(1);
        Severity2.add(str4);
        String str5 = forchart2.getString(2);
        RTUName2.add(str5);
        String str6 = forchart2.getString(3);
        Count2.add(str6);
    }

%>

<script>
    window.onload = function () {

        var severity2 = [<% for (int i = 0; i < Severity2.size(); i++) { %>"<%= Severity2.get(i) %>"<%= i + 1 < Severity2.size() ? ",":"" %><% } %>]
        var rtuname2 = [<% for (int i = 0; i < RTUName2.size(); i++) { %>"<%= RTUName2.get(i) %>"<%= i + 1 < RTUName2.size() ? ",":"" %><% } %>]
        var count2 = [<% for (int i = 0; i < Count2.size(); i++) { %>"<%= Count2.get(i) %>"<%= i + 1 < Count2.size() ? ",":"" %><% } %>]
        count2  = count2.map((x) =>parseInt(x));


       

        var chart2_datapoints = [];
        var chart2 = new CanvasJS.Chart("chartContainer2", {
            animationEnabled: true,
            theme: "light2",

            title:{
                text: "RTU Severity",
                dockInsidePlotArea: true,
                verticalAlign: "center",
                maxWidth: 140,
                fontSize: 22
            },
            data: [{
                type: "doughnut",
                startAngle: 60,
                //innerRadius: 60,
                radius: "90%",

                indexLabelFontSize: 17,
                indexLabel: "{name}",
                dataPoints: chart2_datapoints
            }]
        });

        let i2=0;
        let len2=rtuname2.length;
        while(i2<len2){
            chart2_datapoints.push({
                y: count2[i2],
                label: severity2[i2],
                name:rtuname2[i2],
                toolTipContent:"<h5><strong><span style='\"'color: {color};'\"'>{label}</span></strong></h5>"+" Alerts: <span style='\"'color: red;'\"'><strong>{y}</strong></span> <br/>"
            });
            i2++;
        }
        console.log(chart2_datapoints)
        chart2.render();
    }
</script>



<div align="center" style="height:99%; width:100%; border-radius:25px">
    <div  style="height: 100%;width: 95%;display: inline-block; margin:1%" >
        <div style="height:10%;width:100%;">
            <span style="font-weight: 600; font-size:x-large; color:#5A5A5A;"><a href="rfms/index.jsp">RFMS Severity</a></span>
        </div>
        <div style="height:90%;width:100%" id="chartContainer2"  ></div>
    </div>

</div>

<script type="text/javascript" src="./rfms/js/canvasjs.min.js"></script>