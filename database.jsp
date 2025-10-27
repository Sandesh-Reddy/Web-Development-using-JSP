<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {
        // Try older driver name first (more compatible)
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e1) {
            // If older driver not found, try new driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        }
        
        // Create connection
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crm_system", "root", "");
        
    } catch(Exception e) {
        out.println("<div style='background: #f8d7da; color: #721c24; padding: 1rem; margin: 1rem; border-radius: 5px;'>");
        out.println("<strong>Database Error:</strong> " + e.getMessage());
        out.println("<br><strong>Solution:</strong> Download MySQL Connector/J from:");
        out.println("<br>https://dev.mysql.com/downloads/connector/j/");
        out.println("<br>Extract and copy mysql-connector-j-8.x.x.jar to C:\\xampp\\tomcat\\lib\\");
        out.println("</div>");
    }
%>