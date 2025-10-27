<%@ include file="../../config/database.jsp" %>
<%
    String id = request.getParameter("id");
    if (id != null) {
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM leads WHERE id = ?");
        pstmt.setString(1, id);
        pstmt.executeUpdate();
        pstmt.close();
        conn.close();
    }
    response.sendRedirect("list.jsp");
%>