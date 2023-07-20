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

<link rel="stylesheet" type="text/css" href="./element/css/template_submit_button.css" />
<link rel="stylesheet" type="text/css" href="./element/css/template_list.css" />

<link rel="stylesheet" type="text/css" href="./element/css/google_button.css" />
<link rel="stylesheet" type="text/css" href="./element/css/expand_button.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Raleway:wght@700&amp;display=swap'>
<link href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark@4/dark.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>

<style>
  #mainDiv {
    margin-bottom: 1%;
    margin-top: 1%;
    width: 100%;
    height: 75vh;
    border: 1px solid rgba(0, 0, 0, .125);
    border-radius: 20px;
    padding: 2%;
  }
</style>

<div id="mainDiv" class="container-fluid" ng-controller="NodeAssetsCtrl" ng-init="init(${nodeId})">
  <div style="height: 100%; display:inline-block;float: left; width: 40%; margin-right: 0.5%;">
    <div style="height: 10%;width: 98%;text-align: center;">
      <h2>
        List of Template Description
      </h2>
    </div>
    <div style="height: 89%;width: 98%;overflow-x: hidden; overflow-y: auto; text-align:justify;">
      <div class="container" style="width:90%">
        <div class="nav"><a href="#"><i class="fal fa-home"></i></a><a href="https://twitter.com/collinscode_"
            target="_blank"><i class="fab fa-twitter"></i></a><a href="https://github.com/cmdeveloped"
            target="_blank"><i class="fab fa-github"></i></a><a href="https://codepen.io/collinscode" target="_blank"><i
              class="fab fa-codepen"></i></a></div>
        <div class="list" id="listContainer"></div>
      </div>
    </div>
  </div>
  <div style="height: 100%; display:inline-block;float: right;width: 59%; margin-left: 0.5%;">
    <div style="height: 10%;text-align: center;margin-top: 1%;font-size: 27px;">
      <h2>
        Templates for NodeLabel: <strong><a href="element/node.jsp?node=${nodeId}">{{nodeLabel}}</a></strong>
      </h2>
    </div>
    <textarea id="contentField" class="button-17"
      style="height: 89%; width: 100%;resize: none; border:1px solid rgba(0,0,0,.125); border-radius: 25px;padding:2%;text-align: left;"
      placeholder="Templates will load here..."></textarea>
  </div>
</div>
<div style="height: 8vh;">
  <div style="height:100%; width: 50%;display: inline;font-size: x-large;">
    Selected List Template Description:
    <div id="selectListDiv"
      style="height:100%; width: 50%;display: inline;font-size: x-large;color:rgb(48, 48, 235);font-weight: 700;">
    </div>
  </div>
  <div style="height:100%; width: 49%;display: inline;">
    <button type="submit" style="background: white;float:right; margin-top:0;" class="button" onclick="postData()">Submit</button>
  </div>
</div>

<script>
  const divsList = document.getElementById('listContainer');
  const textarea = document.getElementById('contentField');

  let selectedDiv = null;

  const xhr = new XMLHttpRequest();
  const url = 'http://localhost:8080/api/findAll';
  xhr.open('GET', url, true);
  xhr.responseType = 'json';

  xhr.onload = function () {
    if (xhr.status === 200) {
      const responseData = xhr.response;
      const dataArray=[];
      if (typeof responseData === 'object') {
        for(let node in responseData){
        const data = responseData[node];
        dataArray.push({
          title: data.nodeId,
          description: data.nodeName
        });

      }
        divsList.innerHTML = '';
        dataArray.forEach((item, index) => {
          const div = document.createElement('div');
          div.classList.add('num');

          const numberSpan = document.createElement('span');
          numberSpan.classList.add('number');
          numberSpan.innerText = (index + 1).toString();
          numberSpan.style.fontSize = '4rem';
          numberSpan.style.fontWeight = 'bold';
          numberSpan.style.color = '#000';
          numberSpan.style.width = '2rem';
          numberSpan.style.opacity = '0.05';
          numberSpan.style.transition = '0.25s';

          div.appendChild(numberSpan);

          const titleSpan = document.createElement('h5');
          titleSpan.innerText = item.title;
          titleSpan.style.paddingLeft = '10px';

          div.appendChild(titleSpan);

          div.addEventListener('click', function () {
            textarea.value = item.description;
            console.log(textarea.value);

            if (selectedDiv) {
              selectedDiv.style.backgroundColor = 'initial';
            }
            div.style.backgroundColor = '#ADD8E6';
            selectedDiv = div;

            var divElement = document.getElementById("selectListDiv");
            divElement.innerHTML = "";
            var textNode = document.createTextNode(item.title);
            divElement.appendChild(textNode);
          });
          divsList.appendChild(div);
        });
      } else {
        console.error('Invalid response format. "Templates" array not found.');
      }
    } else {
      console.error('Request failed. Status:', xhr.status);
    }
  };

  xhr.send();
</script>


<script>
  function postData(){
    let textareaData = document.getElementById("contentField").value;
    console.log(textareaData);
    $.ajax({
      url: "http://localhost:8080/api/addNode",
      type: "POST",
      data: {
        // "nodeId": 109,
        nodeName: textareaData,
        hostName: "temp3",
        userName: "temp1",
        password: "temp"
      },
      success: function(response){
          console.log(response);
          alert("Successfully Done");
          // alert("Successfully Done2");

          // showPopup()
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        alert("some error");
      }
    });
  }

</script>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />