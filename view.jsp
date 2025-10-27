<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../config/database.jsp" %>

<%
    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    
    PreparedStatement pstmt = conn.prepareStatement(
        "SELECT com.*, c.name as customer_name, c.email, c.phone " +
        "FROM communications com " +
        "JOIN customers c ON com.customer_id = c.id " +
        "WHERE com.id = ?");
    pstmt.setString(1, id);
    ResultSet rs = pstmt.executeQuery();
    
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
    
    String typeIcon = "fas fa-" + 
        (rs.getString("type").equals("Email") ? "envelope type-email" :
         rs.getString("type").equals("Call") ? "phone type-call" :
         rs.getString("type").equals("Meeting") ? "handshake type-meeting" : "sticky-note type-note");
%>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="<%= typeIcon %>"></i> Communication Details</h1>
        <p class="page-subtitle">View communication information</p>
    </div>
    <a href="list.jsp" class="btn btn-outline">
        <i class="fas fa-arrow-left"></i> Back to List
    </a>
</div>

<div class="form-container">
    <div style="margin-bottom: 2rem;">
        <h3 style="color: var(--secondary); margin-bottom: 1rem;">Customer Information</h3>
        <div style="background: var(--light); padding: 1.5rem; border-radius: var(--radius);">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div>
                    <strong>Name:</strong> <%= rs.getString("customer_name") %>
                </div>
                <div>
                    <strong>Email:</strong> <%= rs.getString("email") != null ? rs.getString("email") : "N/A" %>
                </div>
                <div>
                    <strong>Phone:</strong> <%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %>
                </div>
                <div>
                    <strong>Date:</strong> <%= rs.getTimestamp("communication_date") %>
                </div>
            </div>
        </div>
    </div>
    
    <div class="form-group">
        <label>Communication Type:</label>
        <div style="padding: 0.75rem; background: var(--light); border-radius: var(--radius);">
            <i class="<%= typeIcon %>"></i> <%= rs.getString("type") %>
        </div>
    </div>
    
    <div class="form-group">
        <label>Subject:</label>
        <div style="padding: 0.75rem; background: var(--light); border-radius: var(--radius); font-weight: 600;">
            <%= rs.getString("subject") %>
        </div>
    </div>
    
    <div class="form-group">
        <label>Message/Notes:</label>
        <div style="padding: 1rem; background: var(--light); border-radius: var(--radius); min-height: 150px; white-space: pre-wrap;">
            <%= rs.getString("message") %>
        </div>
    </div>
    
    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
        <a href="list.jsp" class="btn btn-primary">
            <i class="fas fa-arrow-left"></i> Back to List
        </a>
        <a href="delete.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger" 
           onclick="return confirm('Are you sure you want to delete this communication?')">
            <i class="fas fa-trash"></i> Delete
        </a>
    </div>
</div>

<%
    rs.close();
    pstmt.close();
    conn.close();
%>

<%@ include file="../../includes/footer.jsp" %>