<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../config/database.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="fas fa-plus-circle"></i> Add New Lead</h1>
        <p class="page-subtitle">Create a new sales lead</p>
    </div>
    <a href="list.jsp" class="btn btn-outline">
        <i class="fas fa-arrow-left"></i> Back to List
    </a>
</div>

<div class="form-container">
    <form action="save.jsp" method="post">
        <div class="form-group">
            <label for="customer_id">Customer:</label>
            <select id="customer_id" name="customer_id" class="form-control">
                <option value="">-- Select Customer --</option>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet customers = stmt.executeQuery("SELECT id, name FROM customers WHERE status='Active' ORDER BY name");
                    while(customers.next()) {
                %>
                    <option value="<%= customers.getInt("id") %>"><%= customers.getString("name") %></option>
                <%
                    }
                    customers.close();
                    stmt.close();
                %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="title">Lead Title: *</label>
            <input type="text" id="title" name="title" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" class="form-control"></textarea>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="source">Source:</label>
                <input type="text" id="source" name="source" class="form-control">
            </div>
            
            <div class="form-group">
                <label for="value">Value ($):</label>
                <input type="number" id="value" name="value" step="0.01" min="0" class="form-control">
            </div>
        </div>
        
        <div class="form-group">
            <label for="status">Status:</label>
            <select id="status" name="status" class="form-control">
                <option value="New">New</option>
                <option value="Contacted">Contacted</option>
                <option value="Qualified">Qualified</option>
                <option value="Lost">Lost</option>
            </select>
        </div>
        
        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Save Lead
            </button>
            <a href="list.jsp" class="btn btn-danger">
                <i class="fas fa-times"></i> Cancel
            </a>
        </div>
    </form>
</div>

<%
    conn.close();
%>

<%@ include file="../../includes/footer.jsp" %>