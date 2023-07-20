<%@ page contentType="text/html;charset=UTF-8" language="java" import="org.opennms.web.springframework.security.AclUtils"%>
<% pageContext.setAttribute("nodeId", request.getParameter("node")); %>
<% pageContext.setAttribute("nodeLabel", request.getParameter("node")); %>



<jsp:include page="/includes/bootstrap.jsp" flush="false">
    <jsp:param name="ngapp" value="onms-assets" />
    <jsp:param name="title" value="Configuration Comparison" />
    <jsp:param name="headTitle" value="Configuration Comparison" />
    <jsp:param name="headTitle" value="ID ${nodeId}" />
    <jsp:param name="location" value="configuration_comparison" />
    <jsp:param name="breadcrumb" value="<a href='element/node.jsp?node=${nodeId}'>Node Id : ${nodeId}</a>" />
    <jsp:param name="breadcrumb" value="Configuration Comparison" />
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

<div class="container-fluid" ng-controller="NodeAssetsCtrl" ng-init="init(${nodeId})">

    <div growl></div>

    <h2 style="text-align: left;">
        Node Label: <strong><a href="element/node.jsp?node=${nodeId}">{{nodeLabel}}</a></strong>
    </h2>
</div>

<link rel="stylesheet" type="text/css" href="./element/css/diffview.css" />
<link rel="stylesheet" type="text/css" href="./element/css/google_button.css" />
<link rel="stylesheet" type="text/css" href="./element/css/compare_button.css" />
<link rel="stylesheet" type="text/css" href="./element/css/expand_button.css" />
<script type="text/javascript" src="./element/js/diffview.js"></script>
<script type="text/javascript" src="./element/js/difflib.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<style type="text/css">
    h2 {
        margin: 0.5em 0 0.1em;
        text-align: center;
    }

    .top {
        text-align: center;
    }

    .textInput {
        display: block;
        width: 49%;
        float: left;
    }

    textarea {
        width: 100%;
        height: 300px;
    }

    label:hover {
        text-decoration: underline;
        cursor: pointer;
    }

    .spacer {
        margin-left: 10px;
    }

    .viewType {
        font-size: 16px;
        clear: both;
        text-align: center;
        padding: 1em;
    }

    #diffoutput {
        width: 100%;
        display: flex;
        justify-content: center;
    }

    #bottom-div1 {
        position: absolute;
        bottom: 4%;
        right: 2%;
    }

    #bottom-div2 {
        position: absolute;
        bottom: 4%;
        right: 2%;
    }


    #overlay {
        position: fixed;
        display: none;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 2;
        cursor: pointer;
    }
</style>
<style>
    .fullscreen {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 9999;
        background-color: white;
        padding: 20px;
    }

    .fullscreen textarea {
        width: 100%;
        height: 100%;
        resize: none;
    }
</style>

<script type="text/javascript">
    function diffUsingJS(viewType) {
        "use strict";
        var byId = function (id) {
                return document.getElementById(id);
            },
            base = difflib.stringAsLines(byId("baseText").value),
            newtxt = difflib.stringAsLines(byId("newText").value),
            sm = new difflib.SequenceMatcher(base, newtxt),
            opcodes = sm.get_opcodes(),
            diffoutputdiv = byId("diffoutput"),
            contextSize = null;

        diffoutputdiv.innerHTML = "";
        contextSize = contextSize || null;

        diffoutputdiv.appendChild(diffview.buildView({
            baseTextLines: base,
            newTextLines: newtxt,
            opcodes: opcodes,
            baseTextName: "Base Text",
            newTextName: "New Text",
            contextSize: contextSize,
            viewType: viewType
        }));
    }
</script>

<form method="POST" th:object="${ops}">
    <div class="top" style="font-size: 50px;"> Configuration Comparison</div>
    <br>
    <br>
    <div class="textInput">
        <div class="date_entered">
            <h2 style="display: inline;"><label for="first">Comparison Date1:&nbsp;&nbsp;</label></h2>
            <select class="form-control custom-select" id="nodeSelect1" onchange="updateNodeName()" style="width:25%; border-radius: 30px;text-align: center;font-size: large;font-weight: 700;border-width: 2px;">
                <option value="" selected hidden disabled>Select Date</option>
            </select>
        </div>
        </br>

        <textarea class="button-17" id="baseText" readonly placeholder="Select the date from dropdown for Configuration..." style="resize:none;text-align: left !important;width:100%;height: 400px!important; padding-top: 24px; padding-bottom: 24px;border: 1px solid;border-color: #b1b7bd;"></textarea>
        <a id="btn1" onclick="openNav(this.id)" href="" style="font-size: medium; float: right;">Expand&nbsp;&nbsp;<i
                class='fa fa-expand'></i></a>
    </div>
    <div class="textInput spacer" style="float: right;">
        <div class="date_entered">
            <h2 style="display: inline;"><label for="second">Comparison Date2:&nbsp;&nbsp;</label></h2>
            <select class="form-control custom-select" id="nodeSelect2" onchange="updateNodeName()" style="width:25%; border-radius: 30px;text-align: center;font-size: large;font-weight: 700;border-width: 2px;">
                <option value="" selected hidden disabled>Select Date</option>
            </select>




        </div>
        </br>
        <textarea class="button-17" id="newText" readonly placeholder="Select the date from dropdown for Configuration..." style="resize: none; text-align: left !important;width:100%;height: 400px; padding-top: 24px; padding-bottom: 24px;border: 1px solid;border-color: #b1b7bd;"></textarea>
        <a id="btn2" onclick="openNav(this.id)" href="" style="font-size: medium; float: right;">Expand&nbsp;&nbsp;<i
                class='fa fa-expand'></i></a>
    </div>
    <br>

    <div class="viewType">
            <div class="container" style="height: 100%;">
                <a class="button" onclick="diffUsingJS(0);">
                  <div class="button__line"></div>
                  <div class="button__line"></div>
                  <div class="button__text">COMPARE</div>
                  <div class="button__drow1"></div>
                  <div class="button__drow2"></div>
                </a>
              </div>
    </div>
    <br>
    <br>

    <div id="diffoutput"> </div>
    <br>
</form>


<div id="myNav" class="overlay">
    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
    <div class="overlay-content" id="result" style="font-size: 20px;">
    </div>
</div>
<script>
    function openNav(btnID) {
        document.getElementById("myNav").style.width = "100%";
        let html = null;
        if (btnID == "btn1") {
            html = document.getElementById("baseText").value;
        } else {
            html = document.getElementById("newText").value;
        }
        document.getElementById("result").innerHTML = html;
    }

    function closeNav() {
        document.getElementById("myNav").style.width = "0%";
    }

    fetch('http://localhost:8080/api/findAll')
        .then(response => response.json())
        .then(data => {
            const select1 = document.getElementById('nodeSelect1');
            const select2 = document.getElementById('nodeSelect2');
            data.forEach(node => {
                const option1 = document.createElement('option');
                option1.classList.add('button-17');
                option1.value = node.nodeId;
                option1.text = node.nodeId;
                option1.dataset.nodeName = node.nodeName;
                select1.appendChild(option1);

                const option2 = document.createElement('option');
                option2.value = node.nodeId;
                option2.text = node.nodeId;
                option2.dataset.nodeName = node.nodeName;
                select2.appendChild(option2);
            });
        })
        .catch(error => {
            console.error('Error:', error);
        });

    function updateNodeName() {
        const select1 = document.getElementById('nodeSelect1');
        const textarea1 = document.getElementById('baseText');
        const selectedOption1 = select1.options[select1.selectedIndex];
        const nodeName1 = selectedOption1.dataset.nodeName;
        textarea1.value = nodeName1;

        const select2 = document.getElementById('nodeSelect2');
        const textarea2 = document.getElementById('newText');
        const selectedOption2 = select2.options[select2.selectedIndex];
        const nodeName2 = selectedOption2.dataset.nodeName;
        textarea2.value = nodeName2;
    }
</script>
<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />