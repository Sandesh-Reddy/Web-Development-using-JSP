<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../config/database.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="fas fa-bullseye"></i> Sales Leads</h1>
        <p class="page-subtitle">Track and manage your sales pipeline</p>
    </div>
    <a href="add.jsp" class="btn btn-primary">
        <i class="fas fa-plus"></i> Add New Lead
    </a>
</div>

<div class="dashboard-cards">
    <%
        Statement countStmt = conn.createStatement();
        ResultSet countRs = countStmt.executeQuery(
            "SELECT status, COUNT(*) as count FROM leads GROUP BY status"
        );
        
        java.util.Map<String, Integer> statusCounts = new java.util.HashMap<>();
        int totalLeads = 0;
        
        while(countRs.next()) {
            statusCounts.put(countRs.getString("status"), countRs.getInt("count"));
            totalLeads += countRs.getInt("count");
        }
        countRs.close();
        countStmt.close();
        
        String[] statuses = {"New", "Contacted", "Qualified", "Lost"};
        for(String status : statuses) {
            int count = statusCounts.getOrDefault(status, 0);
            double percentage = totalLeads > 0 ? (count * 100.0) / totalLeads : 0;
    %>
    <div class="card">
        <h3><%= status %> Leads</h3>
        <div class="number"><%= count %></div>
        <div class="progress-bar">
            <div class="progress-fill" style="width: <%= percentage %>%"></div>
        </div>
    </div>
    <%
        }
    %>
</div>

<div class="table-container">
    <div class="table-header">
        <h3><i class="fas fa-list"></i> All Leads</h3>
        <div class="table-actions">
            <span class="btn btn-outline btn-sm">
                Total: <%= totalLeads %> leads
            </span>
        </div>
    </div>
    
    <table class="table">
        <thead>
            <tr>
                <th><i class="fas fa-hashtag"></i> ID</th>
                <th><i class="fas fa-user"></i> Customer</th>
                <th><i class="fas fa-tag"></i> Lead Details</th>
                <th><i class="fas fa-dollar-sign"></i> Value</th>
                <th><i class="fas fa-chart-line"></i> Status</th>
                <th><i class="fas fa-calendar"></i> Created</th>
                <th><i class="fas fa-cogs"></i> Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(
                    "SELECT l.*, c.name as customer_name FROM leads l " +
                    "LEFT JOIN customers c ON l.customer_id = c.id " +
                    "ORDER BY l.created_date DESC"
                );
                
                if (!rs.isBeforeFirst()) {
            %>
                <tr>
                    <td colspan="7">
                        <div class="empty-state">
                            <i class="fas fa-bullseye" style="font-size: 3rem; color: #bdc3c7;"></i>
                            <h3>No Leads Found</h3>
                            <p>Start building your sales pipeline by adding your first lead.</p>
                            <a href="add.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                                <i class="fas fa-plus"></i> Add First Lead
                            </a>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    while(rs.next()) {
                        String statusClass = "status-" + rs.getString("status").toLowerCase();
            %>
                <tr>
                    <td><strong>#<%= rs.getInt("id") %></strong></td>
                    <td><%= rs.getString("customer_name") != null ? rs.getString("customer_name") : "<em>No customer</em>" %></td>
                    <td>
                        <div style="font-weight: 600;"><%= rs.getString("title") %></div>
                        <small style="color: #666;">Source: <%= rs.getString("source") != null ? rs.getString("source") : "Not specified" %></small>
                    </td>
                    <td style="font-weight: 700; color: #27ae60;">$<%= String.format("%.2f", rs.getDouble("value")) %></td>
                    <td><span class="status-badge <%= statusClass %>"><%= rs.getString("status") %></span></td>
                    <td><%= rs.getTimestamp("created_date") %></td>
                    <td>
                        <a href="edit.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary btn-sm">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                    </td>
                </tr>
            <%
                    }
                }
                rs.close();
                stmt.close();
                conn.close();
            %>
        </tbody>
    </table>
</div>

<%@ include file="../../includes/footer.jsp" %>