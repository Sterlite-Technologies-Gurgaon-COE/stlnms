<%@ page contentType="text/html;charset=UTF-8" language="java"
  import="
    org.opennms.web.api.Authentication,
    org.springframework.security.core.GrantedAuthority,
    org.springframework.security.core.context.SecurityContextHolder"
%>

<% pageContext.setAttribute("nodeId", request.getParameter("node")); %>
<% pageContext.setAttribute("nodeLabel", request.getParameter("node")); %>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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




<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" type="text/css" href="./element/css/template_submit_button.css" />
    <link rel="stylesheet" type="text/css" href="./element/css/template_list.css" />
    <link rel="stylesheet" type="text/css" href="./element/css/google_button.css" />
    <link rel="stylesheet" type="text/css" href="./element/css/expand_button.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Raleway:wght@700&amp;display=swap'>
    <link href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark@4/dark.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
    <script type="text/javascript" src="./element/js/beautify.js"></script>


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
        #contentField {
            font-size: 1rem;
            line-height: 1.5em;
            font-family: 'Roboto';
        }
        .container .list .num:nth-child(n):before {
            content: attr(data-number);
            font-size: 4rem;
            font-weight: bold;
            color: #011274;
            width: 2rem;
            opacity: 0.1;
            transition: 0.25s;
        }
        .row{
          display:grid;
        }

    </style>


    <script>
      function showTemplate(selectedValue, clickedDiv) {
          var divs = document.querySelectorAll('.num');
          
          for (var i = 0; i < divs.length; i++) {
              divs[i].style.backgroundColor = '';
          }
          clickedDiv.style.backgroundColor = '#ADD8E6';

          var templateMapping = {};
          <c:forEach var="template" items="${templateList}">
              templateMapping["${template.templateDescription}"] = "${template.template}";
          </c:forEach>
          
          var templateTextArea = document.getElementById("contentField");
          templateTextArea.value = vkbeautify.xml(templateMapping[selectedValue]);
          // console.log(templateMapping[selectedValue]);

          var divElement = document.getElementById("selectListDiv");
          divElement.innerHTML = "";
          var textNode = document.createTextNode(selectedValue);
          divElement.appendChild(textNode); 
      }
    
      function postData(){
        var sshRadio = document.getElementById("sshRadio");
          var netconfRadio = document.getElementById("netconfRadio");
          let selectedOption = null;
          if (sshRadio.checked) {
            console.log("SSH radio is selected");
            selectedOption = "SSH";
            console.log(selectedOption);
          } else if (netconfRadio.checked) {
              console.log("NETCONF radio is selected");
              selectedOption = "NETCONF";
          } else {
              console.log("No radio is selected");
          }

          let nodeId = "${nodeId}";
          // console.log(nodeId);


          let textareaData = document.getElementById("contentField").value;
          // console.log(textareaData);

          var condensedHtml = textareaData.replace(/\n/g, '').replace(/\s+/g, ' ');
          // console.log(condensedHtml);
      
          var xhr = new XMLHttpRequest();
      
          xhr.open("POST", "element/postTemplate", true);
          xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      
          xhr.onreadystatechange = function() {
              if (xhr.readyState === 4 ){
                if(xhr.status === 200) {
                  console.log(xhr.responseText);
                  var responseBody = xhr.responseText.split("Response Body: ")[1];
                  console.log(responseBody);
                  alert("Posted SuccessFully " + '<br>' + "Response : "+ responseBody + '<br>' + "with Status :")
                }else{
                  console.error("Request failed with status:", xhr.status);
              }
            }
          };
      
          var data = "textareaContent=" + encodeURIComponent(condensedHtml) + "&selectedOption=" + encodeURIComponent(selectedOption) + "&nodeId=" + encodeURIComponent(nodeId);
          xhr.send(data);
      }
    </script>
  
</head>

<body >
        <div id="mainDiv" class="container-fluid" ng-controller="NodeAssetsCtrl" ng-init="init(${nodeId})">
            <div style="height: 100%; display:inline-block;float: left; width: 40%; margin-right: 0.5%;">
            <div class="heading" style="height: 10%;width: 98%;text-align: center;">
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
        
                <div class="list">
                    <div id="templateDiv">
                    <c:forEach var="template" items="${templateList}" varStatus="loop">
                        <c:choose>
                        <c:when test="${empty template.templateDescription}">
                            <div class="num no-template-description" style="color: gray;"
                            onclick="showTemplate('${template.templateDescription}', this)"
                            data-number="<c:out value='${loop.index + 1}' />">
                            No Template Description Available
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="num templateDescription" onclick="showTemplate('${template.templateDescription}', this)"
                            data-number="<c:out value='${loop.index + 1}' />">
                            <h3>${template.templateDescription}</h3>
                            </div>
                        </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    </div>
                </div>
                </div>
            </div>
            </div>
        
            <div style="height: 100%; display:inline-block;float: right;width: 59%; margin-left: 0.5%;">
              <div class="row" style="height: 10%;width:100%; margin: 1%;">
                <div class="col" style="max-width:50%">
                  <h3>
                    Select Template Preference : 
                  </h3>
                </div>
                <div class="col" style="max-width:20%">
                <input  type="radio" name="radioOptions" id="sshRadio" checked="checked"> <a style="font-size: large;">SSH</a>
              </div>

                <div class="col" style="max-width:20%">

                <input type="radio" name="radioOptions" id="netconfRadio"> <a style="font-size: large;">NETCONF</a>

                </div>
                
                 
                </div>
                <div class="row" style="height: 10%;text-align: center;margin-top: 1%;font-size: 27px;">
                    <h2>
                    Templates for NodeLabel: <strong><a href="element/node.jsp?node=${nodeId}">{{nodeLabel}}</a></strong>
                    </h2>
                </div>
                <div class="row" style="height: 100%; width: 100%;">
                  <textarea id="contentField" class="button-17"
                    style="height: 75%; width: 100%;resize: none; border:1px solid rgba(0,0,0,.125); border-radius: 25px;padding:2%;text-align: left;"
                    placeholder="Templates will load here..."></textarea>
                </div>
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
            <button type="submit" style="background: white;float:right; margin-top:0;" class="button" onclick="postData()"
                value="Submit">Submit</button>
            </div>
        </div>
   

</body>
</html>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />