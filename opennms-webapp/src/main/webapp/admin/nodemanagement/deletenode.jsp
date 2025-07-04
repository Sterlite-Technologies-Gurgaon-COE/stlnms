<%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2004-2014 The STL-NMS Group, Inc.
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
		org.opennms.netmgt.model.OnmsNode,
		org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.servlet.MissingParameterException
	"
%>

<%
    int nodeId = -1;
    String nodeIdString = request.getParameter("node");

    if (nodeIdString == null) {
        throw new MissingParameterException("node");
    }

    try {
        nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
    } catch (NumberFormatException numE)  {
        throw new ServletException(numE);
    }
    
    if (nodeId < 0) {
        throw new ServletException("Invalid node ID.");
    }
        
    //get the database node info
    OnmsNode node_db = NetworkElementFactory.getInstance(getServletContext()).getNode(nodeId);
    if (node_db == null) {
        throw new ServletException("No such node in database.");
    }
%>

<jsp:include page="/includes/bootstrap.jsp" flush="false" >
  <jsp:param name="title" value="Delete Node" />
  <jsp:param name="headTitle" value="Node Management" />
  <jsp:param name="headTitle" value="Admin" />
  <jsp:param name="location" value="Node Management" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>Admin</a>" />
  <jsp:param name="breadcrumb" value="Node Management" />
</jsp:include>

<script type="text/javascript" >

  function applyChanges()
  {
        var hasCheckedItems = false;
        for (var i = 0; i < document.deleteNode.elements.length; i++)
        {
                if (document.deleteNode.elements[i].type == "checkbox")
                {
                        if (document.deleteNode.elements[i].checked)
                        {
                                hasCheckedItems = true;
                                break;
                        }
                }
        }
                
        if (hasCheckedItems)
        {
                // Return true if we want the form to submit, false otherwise
                return confirm("Are you sure you want to proceed? This action will permanently delete the checked items and cannot be undone.");
        }
        else
        {
                alert("No node or data item is selected!");
                // Return false so that the form is not submitted
                return false;
        }
  }
</script>

<div class="row">
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Node: <%=node_db.getLabel()%></span>
      </div>
      <div class="card-body">
        <form method="post" name="deleteNode" action="admin/deleteSelNodes" onSubmit="return applyChanges();">
          <div class="form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="nodeCheck" id="nodeCheck" value='<%= nodeId %>'>
              <label class="form-check-label" for="nodeCheck">Node</label>
            </div>
          </div>

          <div class="form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="nodeData" id="nodeData" value='<%= nodeId %>'>
              <label class="form-check-label" for="nodeData">Data</label>
            </div>
          </div>

          <div class="form-group">
            <input type="submit" class="btn btn-secondary" value="Delete">
            <a href="admin/nodemanagement/index.jsp?node=<%=nodeId%>" class="btn btn-secondary">Cancel</a>
          </div>
        </form>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
  
  <div class="col-md-6">
    <div class="card">
      <div class="card-header">
        <span>Node: <%=node_db.getLabel()%></span>
      </div>
      <div class="card-body">
        <p>
          To permanently delete a node (and all associated interfaces, services,
          outages, events and notifications), check the "Node" box and select "Delete".
        </p>

        <p>
          Checking the "Data" box will delete the SNMP performance and response
          time directories from the system as well.  Note that it is possible for
          the directory to be deleted <i>before</i> the fact that the node has been
          removed has fully propagated through the system. Thus the system may
          recreate the directory for a single update after this action. In that
          case, the directory will need to be removed manually.
        </p>

        <p>
          <strong>Note:</strong> If the IP address of any of the node's interfaces
          is still configured for discovery and still responding to pings, the node will
          be discovered again. To prevent this, either remove the IP address from the
          discovery range or unmanage the device instead of deleting it.
        </p>
      </div> <!-- card-body -->
    </div> <!-- panel -->
  </div> <!-- column -->
</div> <!-- row -->

<jsp:include page="/includes/bootstrap-footer.jsp" flush="true"/>
