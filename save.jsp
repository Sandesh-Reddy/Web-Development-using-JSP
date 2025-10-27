<%@ include file="../../config/database.jsp" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Get form data
        String customerId = request.getParameter("customer_id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String source = request.getParameter("source");
        String value = request.getParameter("value");
        String status = request.getParameter("status");

        // Insert into database
        PreparedStatement pstmt = conn.prepareStatement(
            "INSERT INTO leads (customer_id, title, description, source, value, status) VALUES (?, ?, ?, ?, ?, ?)");
        
        if (customerId != null && !customerId.isEmpty()) {
            pstmt.setInt(1, Integer.parseInt(customerId));
        } else {
            pstmt.setNull(1, java.sql.Types.INTEGER);
        }
        pstmt.setString(2, title);
        pstmt.setString(3, description);
        pstmt.setString(4, source);
        pstmt.setString(5, value);
        pstmt.setString(6, status);
        
        pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        response.sendRedirect("list.jsp?success=1");
    } else {
        response.sendRedirect("add.jsp");
    }
%>