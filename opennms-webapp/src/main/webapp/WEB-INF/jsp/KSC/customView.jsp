<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2007-2014 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2014 The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is a registered trademark of The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * STL-NMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with STL-NMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     STL-NMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

--%>

<%@page language="java"
    contentType="text/html"
    session="true"
    import="
    org.opennms.web.controller.ksc.FormProcViewController
"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% final String baseHref = org.opennms.web.api.Util.calculateUrlBase( request ); %>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Key SNMP Customized Performance Reports" />
  <jsp:param name="headTitle" value="Performance" />
  <jsp:param name="headTitle" value="Reports" />
  <jsp:param name="headTitle" value="KSC" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>Reports</a>" />
  <jsp:param name="breadcrumb" value="<a href='KSC/index.jsp'>KSC Reports</a>" />
  <jsp:param name="breadcrumb" value="Custom View" />
  <jsp:param name="renderGraphs" value="true" />
</jsp:include>

<%-- A script to Save the file --%>
<script type="text/javascript">
  function customizeReport()
  {
    document.view_form.action.value = "<c:out value="<%=FormProcViewController.Actions.Customize.toString()%>"/>"; 
    document.view_form.submit();
  }

  function updateReport()
  {
    document.view_form.action.value = "<c:out value="<%=FormProcViewController.Actions.Update.toString()%>"/>"; 
    document.view_form.submit();
  }

  function exitReport()
  {
    document.view_form.action.value = "<c:out value="<%=FormProcViewController.Actions.Exit.toString()%>"/>"; 
    document.view_form.submit();
  }
</script>





<c:choose>
  <c:when test="${fn:length(resultSets) <= 0}">
  <div class="card">
    <div class="card-header">
      <span>No graphs defined</span>
    </div>
    <div class="card-body">
      <p>There are no graphs defined for this report.</p>
    </div>
  </div>
  
  </c:when>

  

  <c:otherwise>
    <div class="card">
      <div class="card-header">
        
        <span>Custom View: ${title}</span>
      </div>
      <div class="card-body">


        <form class="form-horizontal" name="view_form" method="get" action="<%= baseHref %>KSC/formProcView.htm">
          <input type="hidden" name="<%=FormProcViewController.Parameters.type%>" value="${reportType}" >
          <input type="hidden" name="<%=FormProcViewController.Parameters.action%>" value="none">
          <c:if test="${!empty report}">
            <input type="hidden" name="<%=FormProcViewController.Parameters.report%>" value="${report}">
          </c:if>



        <div style="margin-top: 1%;margin-left: 0.5%;">
          <!-- Select Timespan Input --> 
          <c:if test="${!empty timeSpan}">
            <div class="form-group" style="display: inline-flex;width: 48%;">
              <label class="col-md-2 label-control" style="max-width:100% ;flex: 0 0 25%;">Override Graph Timespan</label>
              <div class="col-md-4" style="max-width:100% ;flex: 0 0 50%;">
                <select class="form-control custom-select" name="timespan">
                  <c:forEach var="option" items="${timeSpans}">
                    <c:choose>
                      <c:when test="${timeSpan == option.key}">
                        <c:set var="selected">selected="selected"</c:set>
                      </c:when>
                      <c:otherwise>
                        <c:set var="selected" value=""/>
                      </c:otherwise>
                    </c:choose>
                    <option value="${option.key}" ${selected}>${option.value.replaceAll("_", " ")}</option>
                  </c:forEach>
                </select>
                <span class="form-text text-muted">Press update button to reflect option changes to ALL graphs</span>
              </div>
            </div>
          </c:if>

          <!-- Select Graph Type --> 
          <c:if test="${!empty graphType}">
            <div class="form-group" style="display: inline-flex;width: 48%;">
              <label class="col-md-2 label-control" style="max-width:100% ;flex: 0 0 25%;">Override Graph Type</label>
              <div class="col-md-4" style="max-width:100% ;flex: 0 0 50%;">
                <select class="form-control custom-select" name="graphtype">
                  <c:forEach var="option" items="${graphTypes}">
                    <c:choose>
                      <c:when test="${graphType == option.key}">
                        <c:set var="selected">selected="selected"</c:set>
                      </c:when>
                      <c:otherwise>
                        <c:set var="selected" value=""/>
                      </c:otherwise>
                    </c:choose>
                    <option value="${option.key}" ${selected}>${option.value}</option>
                  </c:forEach>
                </select>
                <span class="form-text text-muted">Press update button to reflect option changes to ALL graphs</span>
              </div>
            </div>
          </c:if>
        </div>


          <!-- Button bar -->
          <div class="btn-group" style="margin: 1%;">
            <button id="printButton" class="btn btn-secondary" onclick="handleButtonClick()" type="button">Print Report</button>
            <button class="btn btn-secondary" type="button" onclick="exitReport()">Exit Report Viewer</button>
            <c:if test="${!empty timeSpan || !empty graphType}">
              <button class="btn btn-secondary" type="button" onclick="updateReport()">Update Report View</button>
            </c:if>
            <c:if test="${showCustomizeButton}">
              <button class="btn btn-secondary" type="button" onclick="customizeReport()">Customize This Report</button>
            </c:if>
            
          </div>
          <!-- target/stlnms-27.2.0/jetty-webapps/stlnms/WEB-INF/jsp/KSC/company-logo.png -->



         
          <table id="graph-results" class="table table-sm" align="center">
            <c:set var="graphNum" value="0"/>
            <c:set var="showFootnote1" value="false"/>
            <%-- Loop over each row in the table --%>
            <c:forEach begin="0" end="${(fn:length(resultSets) / graphsPerLine)}">
              <tr>
                <%-- Then loop over each column in the row --%>
                <c:forEach begin="1" end="${graphsPerLine}">
                  <%-- Since a row might not be full, check to see if we've run out of graphs --%>
                  <c:if test="${graphNum < fn:length(resultSets)}">
                    <c:set var="resultSet" value="${resultSets[graphNum]}"/>
                    <td align="center">
                      <table class="table table-sm">
                        <tr>
                          <th>
                            ${resultSet.title} <br/>
                            From: ${resultSet.start} <br/>
                            To: ${resultSet.end}
                          </th>
                          <th>
                            <c:if test="${!empty resultSet.resource.parent}">
                              ${resultSet.resource.parent.resourceType.label}:
                              <c:choose>
                                <c:when test="${(!empty resultSet.resource.parent.link) && loggedIn}">
                                  <a href="<c:url value='${resultSet.resource.parent.link}'/>">${resultSet.resource.parent.label}</a>
                                </c:when>
                                <c:otherwise>
                                  ${resultSet.resource.parent.label}
                                </c:otherwise>
                              </c:choose>
                              <br />
                            </c:if>
                            <c:choose>
                              <c:when test="${fn:contains(resultSet.resource.label,'(*)')}">
                                <c:set var="showFootnote1" value="true"/>
                                Resource:
                              </c:when>
                              <c:otherwise>
                                ${resultSet.resource.resourceType.label}:
                              </c:otherwise>
                            </c:choose>
                            <c:choose>
                              <c:when test="${(!empty resultSet.resource.link) && loggedIn}">
                                <a href="<c:url value='${resultSet.resource.link}'/>">${resultSet.resource.label}</a>
                              </c:when>
                              <c:otherwise>
                                ${resultSet.resource.label}
                              </c:otherwise>
                            </c:choose>
                            <c:url var="detailUrl" value="${baseHref}graph/results.htm">
                              <c:param name="resourceId" value="${resultSet.resource.id}"/>
                              <c:param name="reports" value="all"/>
                              <c:param name="start" value="${resultSet.start.time}"/>
                              <c:param name="end" value="${resultSet.end.time}"/>
                            </c:url>
                            <a href="${detailUrl}">Detail</a>                            
                          </th>
                        </tr>
                      </table>
                      <div class="graph-container" data-graph-zoomable="true" data-resource-id="${resultSet.resource.id}" data-graph-name="${resultSet.prefabGraph.name}" data-graph-title="${resultSet.prefabGraph.title}" data-graph-start="${resultSet.start.time}" data-graph-end="${resultSet.end.time}"></div>
                    </td>
                    <c:set var="graphNum" value="${graphNum + 1}"/>
                  </c:if>
                </c:forEach>
              </tr>
            </c:forEach>
          </table>
        </form>        
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css" href="element/css/fontVarelaRouncs.css" />
<script type="text/javascript" src="element/js/html2pdf.bundle.min.js"></script>
<script>
  
  function printDivAsPDF() {
    return new Promise((resolve, reject) => {
      const graphDiv = document.getElementById('graph-results');
      const button = document.getElementById('printButton');
      const pdf = new window.html2pdf();
      const options = {
        margin: 10,
        filename: "${title}",
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'mm', format: 'a2', orientation: 'landscape' },
      };

      const pdfContentDiv = document.createElement('div');
      const headerDiv = document.createElement('div');
      headerDiv.setAttribute('id','headerDiv');
      headerDiv.innerHTML = `
        <div id="header1" style="display:inline;font-size: xxx-large;">Report Name: ${title} </div>
        <div id="picDiv" style="font-family: 'Varela Round';display:inline;margin-right:1%;float:right;font-size: 100px;color:blue; font-weight:900;">STL<a style="color:green;font-weight:2000;font-size:50px;"></a></div>
        </br>
      `;

        var x = document.getElementById("header1");
        console.log(headerDiv.innerText);
      pdfContentDiv.appendChild(headerDiv);
      const graphDivClone = graphDiv;
      pdfContentDiv.appendChild(graphDivClone);

     
      button.disabled = true;
      pdf.from(pdfContentDiv).set(options).save().then(() => {
        button.disabled = false;

      });
      
      setTimeout(() => {
        console.log("Function work is done");
        resolve();
      }, 3000);
    });
  }

  async function handleButtonClick() {
    try {
      await printDivAsPDF();
      window.location.reload();
    } catch (error) {
      console.error("Error occurred:", error);
    }
  }
</script>
<c:if test="${showFootnote1 == true}">
  <jsp:include page="/includes/footnote1.jsp" flush="false" />
</c:if>

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
