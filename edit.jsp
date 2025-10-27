<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../config/database.jsp" %>

<%
    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    
    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM leads WHERE id = ?");
    pstmt.setString(1, id);
    ResultSet rs = pstmt.executeQuery();
    
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
%>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="fas fa-edit"></i> Edit Lead</h1>
        <p class="page-subtitle">Update lead information</p>
    </div>
    <a href="list.jsp" class="btn btn-outline">
        <i class="fas fa-arrow-left"></i> Back to List
    </a>
</div>

<div class="form-container">
    <form action="save.jsp" method="post">
        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
        
        <div class="form-group">
            <label for="customer_id">Customer:</label>
            <select id="customer_id" name="customer_id" class="form-control">
                <option value="">-- Select Customer --</option>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet customers = stmt.executeQuery("SELECT id, name FROM customers WHERE status='Active' ORDER BY name");
                    while(customers.next()) {
                        boolean selected = rs.getInt("customer_id") == customers.getInt("id");
                %>
                    <option value="<%= customers.getInt("id") %>" <%= selected ? "selected" : "" %>>
                        <%= customers.getString("name") %>
                    </option>
                <%
                    }
                    customers.close();
                    stmt.close();
                %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="title">Lead Title: *</label>
            <input type="text" id="title" name="title" class="form-control" value="<%= rs.getString("title") %>" required>
        </div>
        
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" class="form-control"><%= rs.getString("description") != null ? rs.getString("description") : "" %></textarea>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="source">Source:</label>
                <input type="text" id="source" name="source" class="form-control" value="<%= rs.getString("source") != null ? rs.getString("source") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="value">Value ($):</label>
                <input type="number" id="value" name="value" step="0.01" min="0" class="form-control" value="<%= rs.getDouble("value") %>">
            </div>
        </div>
        
        <div class="form-group">
            <label for="status">Status:</label>
            <select id="status" name="status" class="form-control">
                <option value="New" <%= "New".equals(rs.getString("status")) ? "selected" : "" %>>New</option>
                <option value="Contacted" <%= "Contacted".equals(rs.getString("status")) ? "selected" : "" %>>Contacted</option>
                <option value="Qualified" <%= "Qualified".equals(rs.getString("status")) ? "selected" : "" %>>Qualified</option>
                <option value="Lost" <%= "Lost".equals(rs.getString("status")) ? "selected" : "" %>>Lost</option>
            </select>
        </div>
        
        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Update Lead
            </button>
            <a href="list.jsp" class="btn btn-danger">
                <i class="fas fa-times"></i> Cancel
            </a>
        </div>
    </form>
</div>

<%
    rs.close();
    pstmt.close();
    conn.close();
%>

<%@ include file="../../includes/footer.jsp" %>