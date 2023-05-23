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
    <jsp:param name="title" value="RFMS Data Analytics" />
    <jsp:param name="headTitle" value="RFMS" />
    <jsp:param name="location" value="rfms" />
    <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>Reports</a>" />
    <jsp:param name="breadcrumb" value="RFMS Analytics" />
</jsp:include>

<%
    Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
    Statement getFromDb = dbConnection.createStatement();
    
    ResultSet forchart3 = getFromDb.executeQuery("SELECT \"rtuName\",\"rtuSiteName\",COUNT(*) as count FROM PUBLIC.rfms GROUP BY \"rtuName\",\"rtuSiteName\" ORDER BY count ASC ");
    ArrayList RTUName3 = new ArrayList();
    ArrayList RTUSiteName3 = new ArrayList();
    ArrayList Count3 = new ArrayList();
    while(forchart3.next()){
        String str1 = forchart3.getString(1);
        RTUName3.add(str1);
        String str2=forchart3.getString(2);
        RTUSiteName3.add(str2);
        String str3 = forchart3.getString(3);
        Count3.add(str3);
    }

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

    ResultSet table1 = getFromDb.executeQuery("SELECT * FROM public.rfms ORDER BY \"measurementId\" DESC LIMIT 5;");

    ResultSet box1 = getFromDb.executeQuery("select count(*) as total_count, count(case when severity='critical' then 1 else null end) as A_count, count(case when severity='major' then 1 else null end) as B_count from rfms;");
    String Total1="";
    String critical="";
    String major="";
    while(box1.next()){
        Total1 = box1.getString(1);
        critical = box1.getString(2);
        major = box1.getString(3);
    }

    ResultSet box2 = getFromDb.executeQuery("SELECT COUNT(DISTINCT \"rtuName\") FROM public.rfms;");
    String Total2="";
    while(box2.next()){
        Total2 = box2.getString(1);
    }

    ResultSet lastrtu = getFromDb.executeQuery("SELECT \"rtuName\" FROM public.rfms ORDER BY \"measurementId\" DESC LIMIT 1");
    String lastRTU="";
    while(lastrtu.next()){
        lastRTU = lastrtu.getString(1);
    }
%>
<link href='https://fonts.googleapis.com/css?family=Roboto:400,100,300,700' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">	
<link rel="stylesheet" href="./rfms/css/style.css">
<style>
    th{
        padding-top:20px !important;
    }
    td{
        padding: 6px !important;
    }
</style>

<script>
    window.onload = function () {

        var severity2 = [<% for (int i = 0; i < Severity2.size(); i++) { %>"<%= Severity2.get(i) %>"<%= i + 1 < Severity2.size() ? ",":"" %><% } %>]
        var rtuname2 = [<% for (int i = 0; i < RTUName2.size(); i++) { %>"<%= RTUName2.get(i) %>"<%= i + 1 < RTUName2.size() ? ",":"" %><% } %>]
        var count2 = [<% for (int i = 0; i < Count2.size(); i++) { %>"<%= Count2.get(i) %>"<%= i + 1 < Count2.size() ? ",":"" %><% } %>]
        count2  = count2.map((x) =>parseInt(x));


        var rtuname3 = [<% for (int i = 0; i < RTUName3.size(); i++) { %>"<%= RTUName3.get(i) %>"<%= i + 1 < RTUName3.size() ? ",":"" %><% } %>]
        var rtusitename3 = [<% for (int i = 0; i < RTUSiteName3.size(); i++) { %>"<%= RTUSiteName3.get(i) %>"<%= i + 1 < RTUSiteName3.size() ? ",":"" %><% } %>]
        var count3 = [<% for (int i = 0; i < Count3.size(); i++) { %>"<%= Count3.get(i) %>"<%= i + 1 < Count3.size() ? ",":"" %><% } %>]
        count3  = count3.map((x) =>parseInt(x));

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
        let len2=rtuname3.length;
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


        var chart3_datapoints = [];
        var chart3 = new CanvasJS.Chart("chartContainer3", {
            animationEnabled: true,
            theme: "light2",
            toolTip: {
                shared: true 
            },
            
            title:{
                text:"Remote Terminal Unit Alerts"
            },
            axisX:{
                interval: 1
            },
            axisY2:{
                interlacedColor: "rgba(1,77,101,.2)",
                gridColor: "rgba(1,77,101,.1)",
                title: "Alerts"
            },
            
            
            data: [{
                type: "bar",
                name: "Total Alerts",
                axisYType: "secondary",
                color: "#014D65",
                dataPoints: chart3_datapoints 
            }]
        });


        let i=0;
        let len=rtuname3.length;
        while(i<len){
            chart3_datapoints.push({
                y: count3[i],
                label: rtuname3[i],
                location:rtusitename3[i],
                toolTipContent:"<h5><strong><span style='\"'color: {color};'\"'>{label}</span></strong></h5> " +" SiteName:<span style='\"'color: green;'\"'><strong>{location}</strong></span>   <br/>"+" Alerts: <span style='\"'color: red;'\"'><strong>{y}</strong></span> <br/>"

            });
            i++;
        }
        console.log(chart3_datapoints)
        chart3.render();
    }
</script>

    <div style="height: 400px;margin-top: 20px;">
        <div style="display:inline-block;height:100%; width: 23%; margin-right: 0.4%;">
            <div style="height:49%;margin-bottom: 2%;">
                <div style="float:left;height:98%;width:48%;margin-right:1.5%; border-radius: 25px;">
                    <div style="height:90%;width:100%;">
                        <div class="card card-stats" style="border-radius: 25px;">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <h5 class="card-title text-uppercase text-muted mb-0">Total  Alerts</h5>
                                        <span class="h2 font-weight-bold mb-0"><%=Total1%></span>
                                    </div>
                                </div>
    
                                <p class="mt-3 mb-0 text-sm">
                                    <span class="text-success mr-2" style="color:#CC0000!important"><i class="fa fa-square" style="color:#CC0000;"></i> Critical: <%=critical%></span>
                                    <span class="text-nowrap text-success mr-2" style="color:#FF3300!important" ><i class="fa fa-square" style="color:#FF3300;"></i> Major: <%=major%></span>
                                </p>

                            </div>
                        </div>                        
                    </div>
                </div>
                
                <div style="float: left;height:98%;width:48%;margin-left:2%;border-radius: 25px;">
                    <div style="height:90%;width:100%; ">
                        <div class="card card-stats" style="border-radius: 25px;">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <h5 class="card-title text-uppercase text-muted mb-0">Total RTUs</h5>
                                        <span class="h2 font-weight-bold mb-0"><%=Total2%></span>
                                    </div>
                                
                                    <div class="col-auto">
                                        <div class="icon icon-shape bg-gradient-red text-white rounded-circle shadow">
                                            <i class="ni ni-active-40"></i>
                                        </div>
                                    </div>
                                </div>
    
                                <p class="mt-3 mb-0 text-sm">
                                    <span class="text-success mr-2 font-weight-bold"></i><%=lastRTU%></span>
                                    <span class="text-nowrap">Last Alert RTU</span>
                                </p>
                            </div>
                        </div> 
                    </div>
                </div>
            </div>

            <div style="height:49%;">  
                
                <div style="float: left;height:98%;width:48%;margin-right:1.5%;border-radius: 25px;">
                    <div style="height:90%;width:100%">
                        <div class="card card-stats" style="border-radius: 25px;">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <h5 class="card-title text-uppercase text-muted mb-0">RTU DATA</h5>
                                        <span class="h2 font-weight-bold mb-0">350,897</span>
                                    </div>
                                
                                    <div class="col-auto">
                                        <div class="icon icon-shape bg-gradient-red text-white rounded-circle shadow">
                                            <i class="ni ni-active-40"></i>
                                        </div>
                                    </div>
                                </div>
    
                                <p class="mt-3 mb-0 text-sm">
                                    <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 3.48%</span>
                                    <span class="text-nowrap">RTU TEMP DATA</span>
                                </p>
                            </div>
                        </div>     
                        
                    </div>
                </div>
                <div style="float: left;height:98%;width:48%;margin-left:2%;border-radius: 25px;">
                    <div style="height:90%;width:100%">
                        <div class="card card-stats" style="border-radius: 25px;">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <h5 class="card-title text-uppercase text-muted mb-0">RTU DATA</h5>
                                        <span class="h2 font-weight-bold mb-0">350,897</span>
                                    </div>
                                
                                    <div class="col-auto">
                                        <div class="icon icon-shape bg-gradient-red text-white rounded-circle shadow">
                                            <i class="ni ni-active-40"></i>
                                        </div>
                                    </div>
                                </div>
    
                                <p class="mt-3 mb-0 text-sm">
                                    <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 3.48%</span>
                                    <span class="text-nowrap">RTU TEMP DATA</span>
                                </p>
                            </div>
                        </div>     
                    </div>
                </div>

            </div>
        </div>
        <div style="display:inline-block;height:100%; width: 76%;border:1px solid rgba(0,0,0,.125);" id="chartContainer3" ></div>
    </div>

<div style=" margin-bottom: 10px;margin-top: 10px;">
    <div class="card fix-subpixel" style="height: 450px;width: 54%;display: inline-block;border:1px solid rgba(0,0,0,.125);margin-right: 10px;margin-top: 10px;margin-left: 10px;margin-bottom: 0px;" >
        <div class="card-header" style="border-bottom:0px!important;">
            <span style="font-weight: bold; color:#5A5A5A;">Top Alerts</span>
        </div>
        <div >
            <table class="table myaccordion table-hover">
                <tr>
                    <th>RTU Id</th>    
                    <th>RTU Name</th>    
                    <th>Severity</th>    
                    <th>Probable Cause</th> 
                    <th>Alarm Summary</th> 
                    <th>Position</th>                    

                </tr>
                <% while(table1.next()){ %>
                <tr>
                    <td><%= table1.getString(9) %></td>
                    <td><%= table1.getString(10) %></td>
                    <td><%= table1.getString(7) %></td>
                    <td><%= table1.getString(8) %></td>
                    <td><%= table1.getString(3) %></td>
                    <td><%= table1.getString(6) %></td>


                    <script>
                        console.log("<%= table1.getString(1) %>");
                    </script>
                </tr>
                <% } %>
            </table>



        </div>
    </div>
    <div style="height: 450px;width: 43.5%;display: inline-block;border:1px solid rgba(0,0,0,.125);margin-right: 10px;margin-top: 10px;margin-left: 10px;margin-bottom: 0px;" >
        <div class="card-header" style="border-bottom:0px!important;">
            <span style="font-weight: bold; color:#5A5A5A;">Severity Overview</span>
        </div>
        <div style="height:90%;width:100%" id="chartContainer2"  ></div>
    </div>

</div>




<script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
