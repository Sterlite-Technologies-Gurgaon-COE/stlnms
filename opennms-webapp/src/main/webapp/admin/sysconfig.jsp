<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2008-2021 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2021 The STL-NMS Group, Inc.
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
%>
<%@page import="org.opennms.core.resource.Vault"%>
<%@page import="org.opennms.core.spring.BeanUtils"%>
<%@page import="org.opennms.netmgt.config.SyslogdConfigFactory"%>
<%@page import="org.opennms.netmgt.config.TrapdConfigFactory"%>
<%@page import="java.time.Instant"%>
<%@taglib uri="../WEB-INF/taglib.tld" prefix="onms" %>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="STL-NMS System Configuration" />
  <jsp:param name="headTitle" value="System Configuration" />
  <jsp:param name="headTitle" value="Admin" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="System Configuration" />
</jsp:include>

<script type="text/javascript">
        function cancel()
        {
                document.snmpConfigForm.action="admin/index.jsp";
                document.snmpConfigForm.submit();
        }

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function readystatechange() {
            try {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                    var config = JSON.parse(xhr.responseText);
                    console.debug('got config:', config);
                    var services = document.getElementById('services');
                    var contents = [];
                    for (var key of Object.keys(config.services).sort()) {
                        if (config.services[key] == 'running') {
                            contents.push(key);
                        }
                    }
                    services.innerHTML = contents.join('<br>');
                }
            } catch (err) {
                console.error('Failed to get service info: ' + err);
                document.getElementById('services').innerHTML = 'Unknown';
            }
        };
        xhr.open('GET', 'rest/info');
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
</script>

<%
   String trapPort = "Unknown";
   try {
       TrapdConfigFactory.init();
       trapPort = String.valueOf(TrapdConfigFactory.getInstance().getSnmpTrapPort());
   } catch (Throwable e) {
       // if factory can't be initialized, status is already 'Unknown'
   }

   String syslogPort = "Unknown";
   try {
       SyslogdConfigFactory syslogdConfig = BeanUtils.getBean("commonContext", "syslogdConfigFactory", SyslogdConfigFactory.class);
       syslogPort = String.valueOf(syslogdConfig.getSyslogPort());
   } catch (Throwable e) {
       // if factory can't be initialized, status is already 'Unknown'
   }
%>

<div class="row">
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>STL-NMS Configuration</span>
      </div>
      <table class="table table-sm">
        <tr>
          <th>STL-NMS Version:</th>
          <td><%=Vault.getProperty("version.display")%></td>
        </tr>
        <tr>
          <th>Home Directory:</th>
          <td><%=Vault.getProperty("opennms.home")%></td>
        </tr>
        <tr>
          <th>RRD store by group enabled?</th>
          <td><%=(Boolean.valueOf(Vault.getProperty("org.opennms.rrd.storeByGroup")) ? "True" : "False")%></td>
        </tr>
        <tr>
          <th>RRD store by foreign source enabled?</th>
          <td><%=(Boolean.valueOf(Vault.getProperty("org.opennms.rrd.storeByForeignSource")) ? "True" : "False")%></td>
        </tr>
        <tr>
          <th>Reports directory:</th>
          <td><%=Vault.getProperty("opennms.report.dir")%></td>
        </tr>
        <tr>
          <th>Jetty HTTP host:</th>
          <td><%=Vault.getProperty("org.opennms.netmgt.jetty.host") == null ? "<i>Unspecified</i>" : Vault.getProperty("org.opennms.netmgt.jetty.host")%></td>
        </tr>
        <tr>
          <th>Jetty HTTP port:</th>
          <td><%=Vault.getProperty("org.opennms.netmgt.jetty.port") == null ? "<i>Unspecified</i>" : Vault.getProperty("org.opennms.netmgt.jetty.port")%></td>
        </tr>
         <tr>
          <th>Jetty HTTPS host:</th>
          <td><%=Vault.getProperty("org.opennms.netmgt.jetty.https-host") == null ? "<i>Unspecified</i>" : Vault.getProperty("org.opennms.netmgt.jetty.https-host")%></td>
        </tr>
        <tr>
          <th>Jetty HTTPS port:</th>
          <td><%=Vault.getProperty("org.opennms.netmgt.jetty.https-port") == null ? "<i>Unspecified</i>" : Vault.getProperty("org.opennms.netmgt.jetty.https-port")%></td>
        </tr>
        <tr>
          <th>SNMP trap port:</th>
          <td><%=trapPort%></td>
        </tr>
        <tr>
          <th>Syslog port:</th>
          <td><%=syslogPort%></td>
        </tr>
        <tr>
            <th>Running services:</th>
            <td id="services"></td>
        </tr>
      </table>
    </div> <!-- panel -->
  </div> <!-- column -->
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>System Configuration</span>
      </div>
      <table class="table table-sm">
        <tr>
          <th>Server&nbsp;Time:</th>
          <td><onms:datetime instant="${Instant.now()}"/></td>
        </tr>
        <tr>
          <th>Client&nbsp;Time:</th>
          <td><script type="text/javascript"> document.write( new Date().toString()) </script></td>
        </tr>
        <tr>
          <th>Java&nbsp;Version:</th>
          <td><%=System.getProperty( "java.version" )%> <%=System.getProperty( "java.vendor" )%></td>
        </tr>
        <tr>
          <th>Java&nbsp;Virtual&nbsp;Machine:</th>
          <td><%=System.getProperty( "java.vm.version" )%> <%=System.getProperty( "java.vm.vendor" )%></td>
        </tr>
        <tr>
          <th>Operating&nbsp;System:</th>
          <td><%=System.getProperty( "os.name" )%> <%=System.getProperty( "os.version" )%> (<%=System.getProperty( "os.arch" )%>)</td>
        </tr>
        <tr>
          <th>OSGi&nbsp;Container:</th>
          <td>Apache Karaf <%=System.getProperty( "karaf.version" )%></td>
        </tr>
        <tr>
          <th>Servlet&nbsp;Container:</th>
          <td><%=application.getServerInfo()%> (Servlet Spec <%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>)</td>
        </tr>
        <tr>
          <th>User&nbsp;Agent:</th>
          <td><%=request.getHeader( "User-Agent" )%></td>
        </tr>
      </table>
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false" />
