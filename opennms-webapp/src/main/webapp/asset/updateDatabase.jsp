<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    int nodeId = Integer.parseInt(request.getParameter("nodeId"));
    boolean checkboxValue = Boolean.parseBoolean(request.getParameter("checkboxValue"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
        String sql = "UPDATE node SET config_flag = ? WHERE nodeid = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setBoolean(1, checkboxValue);
        pstmt.setInt(2, nodeId);
        pstmt.executeUpdate();
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("Database updated successfully!");
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("An error occurred while updating the database: " + e.getMessage());
    } finally {
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
