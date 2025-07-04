<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2014 The STL-NMS Group, Inc.
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
	import="java.util.*,
		org.opennms.web.element.*,
		org.opennms.web.asset.*,
		org.opennms.netmgt.model.monitoringLocations.OnmsMonitoringLocation"%>

<%!
    protected AssetModel model;
    protected String[][] columns;

    public void init() throws ServletException {
        this.model = new AssetModel();
        this.columns = AssetModel.getColumns();
    }
%>

<%
    Map<String,Integer> serviceNameMap = new TreeMap<String,Integer>(NetworkElementFactory.getInstance(getServletContext()).getServiceNameToIdMap());
    List<String> serviceNameList = new ArrayList<String>(serviceNameMap.keySet());
    Collections.sort(serviceNameList);

    List<OnmsMonitoringLocation> monitoringLocations = NetworkElementFactory.getInstance(getServletContext()).getMonitoringLocations();
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Element Search" />
  <jsp:param name="headTitle" value="Element Search" />
  <jsp:param name="location" value="element" />
  <jsp:param name="breadcrumb" value="Search" />
</jsp:include>

<div class="row">
  <div class="col-lg-6 col-md-8">
    <div class="card">
      <div class="card-header">
        <span>Search for Nodes</span>
      </div>
      <div class="card-body">
        <div>
          <ul class="list-unstyled">
            <li><a href="element/nodeList.htm">All nodes</a></li>
            <li><a href="element/nodeList.htm?listInterfaces=true">All nodes and their interfaces</a></li>
          </ul>
        </div>
          <%-- Search by name --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="byname_nodename">Name containing</label>
              <div class="input-group">
                  <input type="text" class="form-control" id="byname_nodename" name="nodename"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

          <%-- Search by ip --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="byip_iplike">TCP/IP Address like</label>
              <div class="input-group">
                  <input type="text" class="form-control" id="byip_iplike" name="iplike" value="" placeholder="*.*.*.* or *:*:*:*:*:*:*:*:*"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

          <%-- Search by mib2 param --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label class="hidden-sm hidden-md hidden-lg">System attribute</label>
              <div class="input-group">
                  <select class="custom-select" name="mib2Parm">
                      <option>sysDescription</option>
                      <option>sysObjectId</option>
                      <option>sysContact</option>
                      <option>sysName</option>
                      <option>sysLocation</option>
                  </select>
                  <select class="custom-select" name="mib2ParmMatchType">
                      <option>contains</option>
                      <option>equals</option>
                  </select>
                  <input type="text" class="form-control" id="bymib2_mib2ParmValue" name="mib2ParmValue"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

        <%-- Search by interface param --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label class="hidden-sm hidden-md hidden-lg">Interface attribute</label>
              <div class="input-group">
                  <select class="custom-select" name="snmpParm">
                      <option>ifAlias</option>
                      <option>ifName</option>
                      <option>ifDescr</option>
                  </select>
                  <select class="custom-select" name="snmpParmMatchType">
                      <option>contains</option>
                      <option>equals</option>
                  </select>
                  <input type="text" class="form-control" id="byif_snmpParmValue" name="snmpParmValue"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

        <%-- Search by location --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="bymonitoringLocation_monitoringLocation">Location:</label>
              <div class="input-group">
                  <select class="custom-select" id="bymonitoringLocation_monitoringLocation" name="monitoringLocation">
                      <% for (OnmsMonitoringLocation monitoringLocation : monitoringLocations) { %>
                      <option value="<%=monitoringLocation.getLocationName()%>"><%=monitoringLocation.getLocationName()%>
                      </option>
                      <% } %>
                  </select>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

        <%-- Search by service --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="byservice_service">Providing service</label>
              <div class="input-group">
                  <select class="custom-select" id="byservice_service" name="service">
                      <% for (String name : serviceNameList) { %>
                      <option value="<%=serviceNameMap.get(name)%>"><%=name%>
                      </option>
                      <% } %>
                  </select>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

        <%-- Search by MAC --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="bymac_maclike">MAC Address like</label>
              <div class="input-group">
                  <input class="form-control" type="text" name="maclike"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

        <%-- Search by foreign source --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="byfs_foreignSource">Foreign Source name like</label>
              <div class="input-group">
                  <input type="text" class="form-control" name="foreignSource"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

          <%-- Search by flow data --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label for="byflows_flows">Flows</label>
              <div class="input-group">
                  <select class="custom-select" id="byflows_flows" name="flows">
                      <option value="true">Nodes with flow data</option>
                      <option value="false">Nodes without flow data</option>
                  </select>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

          <%-- Search by Enhanced Linkd topology data --%>
          <form role="form" class="form-group" action="element/nodeList.htm" method="get">
              <input type="hidden" name="listInterfaces" value="false"/>
              <label class="hidden-sm hidden-md hidden-lg">Enhanced Linkd topology</label>
              <div class="input-group">
                  <input type="text" class="form-control" id="byif_topology" name="topology"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>

      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <span>Search Asset Information</span>
      </div>
      <div class="card-body">
        <div>
            <ul class="list-unstyled">
              <li><a href="asset/nodelist.jsp?column=_allNonEmpty">All nodes with asset info</a></li>
            </ul>
        </div>

        <form role="form" class="form-group" action="asset/nodelist.jsp" method="get">
            <input type="hidden" name="column" value="category"/>
            <label for="bycat_value">Category</label>
            <div class="input-group">
                <select id="bycat_value" class="form-control custom-select" name="searchvalue">
                <% for (int i = 0; i < Asset.CATEGORIES.length; i++) { %>
                    <option><%=Asset.CATEGORIES[i]%>
                    </option>
                <% } %>
                </select>
                <div class="input-group-append">
                    <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                </div>
            </div>
        </form>

            <%-- Search by field --%>
          <form role="form" class="form-group" action="asset/nodelist.jsp" method="get">
              <label for="byfield_column">Field</label>
              <div class="input-group">
                  <select id="byfield_column" class="form-control custom-select" name="column">
                      <% for (int i = 0; i < this.columns.length; i++) { %>
                      <option value="<%=this.columns[i][1]%>"><%=this.columns[i][0]%>
                      </option>
                      <% } %>
                  </select>
                  <input type="text" class="form-control" id="byfield_value" name="searchvalue" placeholder="Containing text"/>
                  <div class="input-group-append">
                      <button type="submit" class="btn btn-secondary"><i class="fa fa-search"></i></button>
                  </div>
              </div>
          </form>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->

  <div class="col-lg-6 col-md-4">
    <div class="card">
      <div class="card-header">
        <span>Search Options</span>
      </div>
      <div class="card-body">
          <p>Searching by name is a case-insensitive, inclusive search. For example,
            searching on <em>serv</em> would find any of <em>serv</em>, <em>Service</em>,
            <em>Reserved</em>, <em>NTSERV</em>, <em>UserVortex</em>, etc. The underscore
            character acts as a single character wildcard. The percent character acts as a multiple
            character wildcard.
          </p>

          <p>Searching by TCP/IP address uses a very flexible search format, allowing you
            to separate the four or eight (in case of IPv6) fields of a TCP/IP address into
            specific searches. An asterisk (*) in place of any octet matches any value for that
            octet. Ranges are indicated by two numbers separated by a dash (-), and
            commas are used for list demarcation.
          </p>

          <p>For example, the following search fields are all valid and would each create
            the same result set--all TCP/IP addresses from 192.168.0.0 through
            192.168.255.255:
          </p>

            <ul>
                <li>192.168.*.*
                <li>192.168.0-255.0-255
                <li>192.168.0,1,2,3-255.*
                <li>2001:6a8:3c80:8000-8fff:*:*:*:*
                <li>fc00,fe80:*:*:*:*:*:*:*
            </ul>

          <p>A search for ifAlias, ifName, or ifDescr "contains" will find nodes with interfaces
            that match the given search string. This is a case-insensitive inclusive search
            similar to the "name" search described above. If the search modifier is "equals" rather
             than "contains" an exact match must be found.
          </p>

          <p>To search by Service, click the down arrow and select the service you would
            like to search for.
          </p>

          <p>Searching by MAC Address allows you to find interfaces with hardware (MAC) addresses
             matching the search string. This is a case-insensitive partial string match. For
             example, you can find all interfaces with a specified manufacturer's code by entering
             the first 6 characters of the mac address. Octet separators (dash or colon) are optional.
          </p>

          <p>Search for Enhanced Linkd topology information allows you to find nodes with CDP/LLDP data
              matching the given search string.
          </p>

          <p>Searching for assets allows you to search for all assets which have been
            associated with a particular category, as well as to select a specific asset
            field (with all available fields listed in the drop-down list box) and
            search for text which matches its current value.  The latter search is very
            similar to the text search for node names described above.
          </p>

          <p>Also note that you can quickly search for all nodes which have asset
            information assigned by clicking the <em>List all nodes with asset info</em> link.
          </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="false"/>
