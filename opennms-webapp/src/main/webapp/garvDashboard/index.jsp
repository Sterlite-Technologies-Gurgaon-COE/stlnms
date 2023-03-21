<%@page language="java"
        contentType="text/html; charset=UTF-8"
            pageEncoding="UTF-8"
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*"%>
  <jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="title" value="Garv Dashboard" />
    <jsp:param name="headTitle" value="Garv Dashboard" />
    <jsp:param name="breadcrumb" value="Garv Dashboard" />
  </jsp:include>
<%!
String kioskId = "a";
List<String> kioskIds = new ArrayList<String>();
%>
<% Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
   Statement getFromDb = dbConnection.createStatement();
   String ki = request.getParameter("kiosk_id");
   String day = request.getParameter("day");
   String query = "select module_name, sum(num_hits) from public.kiosk_count_data group by module_name order by module_name";
   if ((ki == null || ki.equals("select")) && (day == null || day.trim().isEmpty())) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data group by module_name order by module_name";
   } else if (ki == null || ki.equals("select")) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where timecode='" + day + " 00:00:00+05:30' group by module_name order by module_name";
   } else if (day == null || day.trim().isEmpty()) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " group by module_name order by module_name";
   } else {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " and timecode='" + day + " 00:00:00+05:30' group by module_name order by module_name";
   }
   ResultSet resultset = getFromDb.executeQuery(query);
   ResultSet dropdownvalue = getFromDb.executeQuery("select distinct kiosk_id from public.kiosk_count_data order by kiosk_id");
   ResultSet forPie = getFromDb.executeQuery("SELECT kiosk_id, SUM(num_hits) count FROM public.kiosk_count_data GROUP BY kiosk_id ORDER BY kiosk_id");
Gson gsonObj = new Gson();
Map<Object,Object> map = null;
List<Map<Object,Object>> list = new ArrayList<Map<Object,Object>>();
while(resultset.next()){
map = new HashMap<Object,Object>();
map.put("label", resultset.getString(1));
map.put("y", Integer.parseInt(resultset.getString(2)));
list.add(map);
}
kioskIds.clear();
while(dropdownvalue.next()){
kioskId = dropdownvalue.getString(1);
kioskIds.add(kioskId);
}
String dataPoints = gsonObj.toJson(list);
boolean isBarShow=list.size()>0;
//out.print(isBarShow);
list.clear();
while(forPie.next()){
map = new HashMap<Object,Object>();
map.put("label", forPie.getString(1));
map.put("y", Integer.parseInt(forPie.getString(2)));
list.add(map);
}
String dataPoints2 = gsonObj.toJson(list);
%>
<script type="text/javascript">
window.onload = function() {
var chart = new CanvasJS.Chart("chartContainer", {
  animationEnabled: true,
        //backgroundColor: "#FCF3CF",
        theme: "light2",
  title: {
    text: "Module Hits"
  },
  axisY: {
    title: "Count",
    includeZero: true
  },
  axisX: {
  },
  data: [{
    type: "column",
    yValueFormatString: "#,##0",
    dataPoints: <% out.print(dataPoints); %>
  }]
});
var chart2 = new CanvasJS.Chart("chartContainer2", {
  animationEnabled: true,
  theme: "light2",
        //backgroundColor: "#F4ECF7",
  title: {
    text: "Kiosk Hits"
  },
  /*legend: {
    verticalAlign: "center",
    horizontalAlign: "right",
                fontSize: 20,
                fontFamily: "tamoha",
                //itemMaxWidth: 150,
                //itemWrap: true
  },*/
  /*subtitles: [{
    text: "count of every kioskId"
  }],*/
  data: [{
    type: "doughnut",
                //showInLegend: true,
                //legendText: "KioskId- {label} : {y}",
    yValueFormatString: "#,##0",
    indexLabel: "kioskId-{label}:count-{y}",
    toolTipContent: "{y}",
                //toolTipContent: "<b>{label}</b>: {y}%",
    dataPoints : <%out.print(dataPoints2);%>
  }]
});
chart2.render();
chart.render();
}
</script>
<div id="chartContainer2" style="height: 350px; width: 90%;"></div>
<hr style="height:35px;border-width:0;color:gray;background-color:#e9ecef;margin-top:0;margin-bottom:0;">
<form action="garvDashboard/index.jsp" method="GET" style="width: 100%;">
    <div class="form-row">
     <div class="col" style="padding-top: 10px; padding-left: 30px;">
        <label for="exampleFormControlSelect1">Pick Kiosk ID</label>
        <select class="form-control" id="exampleFormControlSelect1" class="dropdown" id="dd" name="kiosk_id">
            <option value="select"  selected>select</option>
            <% for(int i=0;i<kioskIds.size();i++){ %>
                <option value="<%= kioskIds.get(i) %>" <%if(kioskIds.get(i).equals(ki)){ %> selected <%} %>> <%= kioskIds.get(i) %> </option>
                 <% } %>
        </select>
      </div>
<div class="col" style="padding-top: 10px; padding-left: 30px;">
    <label for="exampleFormControlInput1">Pick Date</label>
    <input type="date" name="day" class="form-control" id="exampleFormControlInput1" value="<%= day %>">
  </div>
  <div class="col" style="margin-top: 28px; padding-top: 10px; padding-left: 30px;">
    <button type="submit" class="btn btn-primary mb-2" id="fetchResults">Submit</button>
  </div>
  </div>
  </form>
<% if(isBarShow){ %>
<div id="chartContainer" style="height: 370px; width: 100%; margin-bottom: 10px;"></div>
<% } else { %>
<div style="padding-left: 25px; padding-top: 15px; padding-bottom: 15px;">
<h2>No data present on given filter </h2>
</div>
<% } %>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />