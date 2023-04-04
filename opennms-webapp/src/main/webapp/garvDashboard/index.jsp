<%@page language="java"
        contentType="text/html; charset=UTF-8"
            pageEncoding="UTF-8"
%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*"%>
  <jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="title" value="Garv Dashboard" />
    <jsp:param name="headTitle" value="Garv Dashboard" />
    <jsp:param name="breadcrumb" value="Garv Dashboard" />
  </jsp:include>

  <script>
    angular.module('onms-garvDashboard', [])
.controller('garvDashController', ['$scope', '$http', function ($scope, $http) {
      $scope.text = "loading server status";
      $scope.imgSrc = "/images/garv_server_status/load.gif";
      var url = "https://appseksdemo.stlgarv.com/user/check";
      $http.get(url).then(
             function successCallback(response) {
        $scope.text = "server running";
        $scope.imgSrc = "/images/garv_server_status/yes.png";
      },
      function errorCallback(response) {
        console.log("Unable to perform get request");
        $scope.text = "server stopped";
        $scope.imgSrc = "/images/garv_server_status/no.png";
      }
);

  }]);

</script>


<div ng-controller="garvDashController">
<img src="{{imgSrc}}" onmouseover="{{text}}"; style="width: 3%; height: 45px; display: inline-block;">
<h5 style="display: inline-block; padding-left: 5px;"><b>{{text}}</b></h5>
</div>
</div>



<%!
String kioskId = "a";
List<String> kioskIds = new ArrayList<String>();
boolean present(String s){
    return !(s==null || s.trim().isEmpty() || s.trim().equals("select"));
}
String getTimeQuery(String st, String en) {
    if(present(st) && present(en)) {
        return "timecode between '"+st+" 00:00:00+05:30 and '"+en+" 00:00:00:+05:30' ";
    }
    if(present(st)) {
        return "timecode = '" + st + " 00:00:00+05:30' ";
    }
    if(present(en)) {
        return "timecode = '" + en + " 00:00:00+05:30' ";
    }
    return "";

}
%>


<% Connection dbConnection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
   Statement getFromDb = dbConnection.createStatement();
   String ki = request.getParameter("kiosk_id");
   String day1 = request.getParameter("day1");
   String day2 = request.getParameter("day2");
   String temp="hi";
   String query = "select module_name, sum(num_hits) from public.kiosk_count_data group by module_name order by module_name";
   
   if (!present(ki) && !present(day1) && !present(day2)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data group by module_name order by module_name";
       temp = "Total hits of each module till date";
       //out.print(temp);
   } else if (!present(ki) && !present(day2)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where timecode='" + day1 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Module hits on date : " +day1;
       //out.print(temp);
   } else if (!present(ki) && !present(day1)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where timecode='" + day2 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Module hits on date : " +day2;
       //out.print(temp);
   } else if (!present(day2) && !present(day1)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " group by module_name order by module_name";
       temp = "Total Module Hits till date for kioskID : " +ki;
       //out.print(temp);
   } else if (!present(day2)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " and timecode='" + day1 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Module hits for kioskID : "+ki+" on date : "+day1;
       //out.print(temp);
   } else if (!present(day1)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " and timecode='" + day2 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Module hits for kioskID : "+ki+" on date : "+day2;
       //out.print(temp);
   } else if (!present(ki)) {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where timecode between '" + day1 + " 00:00:00+05:30' and '" + day2 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Total Module hits between "+day1+" and "+day2;
       //out.print(temp);
   } else {
       query = "select module_name, sum(num_hits) from public.kiosk_count_data where kiosk_id=" + ki + " and timecode between '" + day1 + " 00:00:00+05:30' and '" + day2 + " 00:00:00+05:30' group by module_name order by module_name";
       temp = "Module hits for kioskID : "+ki+" between "+day1+" and "+day2;
       //out.print(temp);
   }
   Date date = new Date();
      SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd 00:00:00+05:30");
          String curdate = formatter.format(date);
         //curdate = "2023-02-10 00:00:00+05:30";
         //out.print(curdate);
   ResultSet resultset = getFromDb.executeQuery(query);
   ResultSet dropdownvalue = getFromDb.executeQuery("select distinct kiosk_id from public.kiosk_count_data order by kiosk_id");
   ResultSet forPie = getFromDb.executeQuery("SELECT kiosk_id, SUM(num_hits) count FROM public.kiosk_count_data GROUP BY kiosk_id ORDER BY kiosk_id");
   ResultSet todayPie = getFromDb.executeQuery("SELECT kiosk_id, SUM(num_hits) count FROM public.kiosk_count_data WHERE timecode='" + curdate + "' GROUP BY kiosk_id ORDER BY kiosk_id");

      
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


list.clear();

while(todayPie.next()){
map = new HashMap<Object,Object>();
map.put("label", todayPie.getString(1));
map.put("y", Integer.parseInt(todayPie.getString(2)));
list.add(map);
}

String dataPoints3 = gsonObj.toJson(list);
   
boolean isTodayPieShow=list.size()>0;
//out.print(isTodayPieShow);

%>
 
<script type="text/javascript">
window.onload = function() { 
 
var chart = new CanvasJS.Chart("chartContainer", {
	animationEnabled: true,
        //backgroundColor: "#FCF3CF",
        theme: "light2",
	title: {
		text: "Module Hits",
                fontColor: "#2E4053"
	},
        subtitles: [{
                text: "<%= temp %>",
                fontSize: 20,
                fontStyle: "italic",
                fontColor: "#85929E",
                fontWeight: "bold"
        }],
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
		text: "Kiosk Hits Till Date",
                fontColor: "#2E4053"
	},
	/*subtitles: [{
		text: "count of every kioskId"
	}],*/
	data: [{
		type: "doughnut",
		yValueFormatString: "#,##0",
		indexLabel: "kioskId-{label}:count-{y}",
		toolTipContent: "{y}",
		dataPoints : <%out.print(dataPoints2);%>
	}]
});



var chart3 = new CanvasJS.Chart("chartContainer3", {
        animationEnabled: true,
        theme: "light2",
        //backgroundColor: "#F4ECF7",
        title: {
                text: "Kiosk Hits Today",
                fontColor: "#2E4053"
        },
        /*subtitles: [{
                text: "count of every kioskId"
        }],*/
        data: [{
                type: "doughnut",
                yValueFormatString: "#,##0",
                indexLabel: "kioskId-{label}:count-{y}",
                toolTipContent: "{y}",
                dataPoints : <%out.print(dataPoints3);%>
        }]
});


CanvasJS.addColorSet("noDataShades",
                [//colorSet Array

                "#8E8B8B"                
                ]);

var chart4 = new CanvasJS.Chart("chartContainer4",
    {
      animationEnabled: true,
      theme: "light2", 
      colorSet:"noDataShades",
      title:{
        text: "Kiosk Hits Today",
        fontColor: "#2E4053"
      },
      /*subtitles: [{
                text: "No Hits Today"
      }],*/
      data: [
      {
       toolTipContent: "0",
       type: "doughnut",
       indexLabel: "kiosk hits : 0",
       dataPoints: [
       {  y: 1 }
       ]
     }
     ]
});


chart2.render();

<% if(isBarShow) { %>
   chart.render();
<% } else { %>
    document.getElementById("chartContainer").innerHTML = '<h2 style="margin:25px"><b>No data present on given filter</b></h2>';
<% } %>


<% if(isTodayPieShow) { %>
   chart3.render();
<% } else { %>
   chart4.render();
<% } %>

}

</script>

<div>
<div>
<div id="chartContainer2" style="width: 48%; height: 300px; display: inline-block;"></div>

<% if(isTodayPieShow) { %>
   <div id="chartContainer3" style="width: 48%; height: 300px; display: inline-block;"></div>
<% } else { %>
   <div id="chartContainer4" style="width: 48%; height: 300px; display: inline-block;"></div>
<% } %>

</div>

<hr style="height:35px;border-width:0;color:gray;background-color:#e9ecef;margin-top:0;margin-bottom:0;">


<form action="garvDashboard/index.jsp" method="GET" style="width: 100%;">
    <div class="form-row">
     <div class="col" style="padding-top: 10px; padding-left: 30px;">
        <label for="exampleFormControlSelect1">Kiosk ID</label>
        <select class="form-control" id="exampleFormControlSelect1" class="dropdown" id="dd" name="kiosk_id">
            <option value="select"  selected>select</option>
            <% for(int i=0;i<kioskIds.size();i++){ %>
                <option value="<%= kioskIds.get(i) %>" <%if(kioskIds.get(i).equals(ki)){ %> selected <%} %>> <%= kioskIds.get(i) %> </option>
                 <% } %>
        </select>
      </div>
<div class="col" style="padding-top: 10px; padding-left: 30px;">
    <label for="exampleFormControlInput1">From Date</label>
    <input type="date" name="day1" class="form-control" id="exampleFormControlInput1" value="<%= day1 %>">
  </div>
<div class="col" style="padding-top: 10px; padding-left: 30px;">
    <label for="exampleFormControlInput2">To Date</label>
    <input type="date" name="day2" class="form-control" id="exampleFormControlInput2" value="<%= day2 %>">
  </div>
  <div class="col" style="margin-top: 28px; padding-top: 10px; padding-left: 30px;">
    <button type="submit" class="btn btn-primary mb-2" id="fetchResults">Submit</button>
  </div>
  </div>
  </form>


<div id="chartContainer" style="height: 370px; width: 100%; margin-bottom: 10px;"></div>

<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>


<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />

