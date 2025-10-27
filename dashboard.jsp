<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../config/database.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="fas fa-chart-bar"></i> Analytics & Reports</h1>
        <p class="page-subtitle">Comprehensive insights into your sales performance</p>
    </div>
    <div class="header-actions">
        <button class="btn btn-outline" onclick="window.print()">
            <i class="fas fa-print"></i> Print Report
        </button>
    </div>
</div>

<!-- Key Metrics -->
<div class="dashboard-cards">
    <%
        // Total customers
        ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM customers");
        rs.next();
        int totalCustomers = rs.getInt("count");
        rs.close();
        
        rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM customers WHERE status='Active'");
        rs.next();
        int activeCustomers = rs.getInt("count");
        rs.close();
        
        // Lead metrics
        rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM leads");
        rs.next();
        int totalLeads = rs.getInt("count");
        rs.close();
        
        rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM leads WHERE status='Qualified'");
        rs.next();
        int qualifiedLeads = rs.getInt("count");
        rs.close();
        
        // Communication metrics
        rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM communications");
        rs.next();
        int totalComms = rs.getInt("count");
        rs.close();
        
        // Total lead value
        rs = conn.createStatement().executeQuery("SELECT SUM(value) as total FROM leads WHERE status IN ('New', 'Contacted', 'Qualified')");
        rs.next();
        double totalValue = rs.getDouble("total");
        if (rs.wasNull()) totalValue = 0;
        rs.close();
    %>
    
    <div class="card">
        <h3><i class="fas fa-users"></i> Total Customers</h3>
        <div class="number"><%= totalCustomers %></div>
        <div class="trend">
            <i class="fas fa-user-check"></i> <%= activeCustomers %> active
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-bullseye"></i> Total Leads</h3>
        <div class="number"><%= totalLeads %></div>
        <div class="trend">
            <i class="fas fa-star"></i> <%= qualifiedLeads %> qualified
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-comments"></i> Communications</h3>
        <div class="number"><%= totalComms %></div>
        <div class="trend">
            <i class="fas fa-clock"></i> All time
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-dollar-sign"></i> Pipeline Value</h3>
        <div class="number">$<%= String.format("%.0f", totalValue) %></div>
        <div class="trend">
            <i class="fas fa-chart-line"></i> Total potential
        </div>
    </div>
</div>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 2rem 0;">
    <!-- Lead Status Distribution -->
    <div class="table-container">
        <div class="table-header">
            <h3><i class="fas fa-chart-pie"></i> Lead Status Distribution</h3>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Count</th>
                    <th>Percentage</th>
                    <th>Progress</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet leadResult = stmt.executeQuery("SELECT status, COUNT(*) as count FROM leads GROUP BY status");
                    
                    while(leadResult.next()) {
                        double percentage = totalLeads > 0 ? (leadResult.getInt("count") * 100.0) / totalLeads : 0;
                        String statusClass = "status-" + leadResult.getString("status").toLowerCase();
                %>
                    <tr>
                        <td><span class="status-badge <%= statusClass %>"><%= leadResult.getString("status") %></span></td>
                        <td><strong><%= leadResult.getInt("count") %></strong></td>
                        <td><%= String.format("%.1f", percentage) %>%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= percentage %>%"></div>
                            </div>
                        </td>
                    </tr>
                <%
                    }
                    leadResult.close();
                %>
            </tbody>
        </table>
    </div>

    <!-- Communication Types -->
    <div class="table-container">
        <div class="table-header">
            <h3><i class="fas fa-comment-dots"></i> Communication Types</h3>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>Type</th>
                    <th>Count</th>
                    <th>Percentage</th>
                    <th>Trend</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ResultSet commResult = stmt.executeQuery("SELECT type, COUNT(*) as count FROM communications GROUP BY type");
                    
                    while(commResult.next()) {
                        double percentage = totalComms > 0 ? (commResult.getInt("count") * 100.0) / totalComms : 0;
                        String typeIcon = "fas fa-" + 
                            (commResult.getString("type").equals("Email") ? "envelope type-email" :
                             commResult.getString("type").equals("Call") ? "phone type-call" :
                             commResult.getString("type").equals("Meeting") ? "handshake type-meeting" : "sticky-note type-note");
                %>
                    <tr>
                        <td><i class="<%= typeIcon %>"></i> <%= commResult.getString("type") %></td>
                        <td><strong><%= commResult.getInt("count") %></strong></td>
                        <td><%= String.format("%.1f", percentage) %>%</td>
                        <td>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= percentage %>%"></div>
                            </div>
                        </td>
                    </tr>
                <%
                    }
                    commResult.close();
                    stmt.close();
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Recent Activities -->
<div class="table-container">
    <div class="table-header">
        <h3><i class="fas fa-history"></i> Recent Customer Activities</h3>
        <div class="table-actions">
            <span class="btn btn-outline btn-sm">
                Last 10 activities
            </span>
        </div>
    </div>
    <table class="table">
        <thead>
            <tr>
                <th>Customer</th>
                <th>Activity Type</th>
                <th>Details</th>
                <th>Date & Time</th>
            </tr>
        </thead>
        <tbody>
            <%
                Statement activityStmt = conn.createStatement();
                ResultSet activityResult = activityStmt.executeQuery(
                    "SELECT c.name as customer_name, com.type, com.subject, com.communication_date " +
                    "FROM communications com " +
                    "JOIN customers c ON com.customer_id = c.id " +
                    "ORDER BY com.communication_date DESC LIMIT 10"
                );
                
                if (!activityResult.isBeforeFirst()) {
            %>
                <tr>
                    <td colspan="4">
                        <div class="empty-state">
                            <i class="fas fa-chart-line" style="font-size: 3rem; color: #bdc3c7;"></i>
                            <h3>No Activities Found</h3>
                            <p>Activities will appear here as you interact with customers.</p>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    while(activityResult.next()) {
                        String activityTypeIcon = "fas fa-" + 
                            (activityResult.getString("type").equals("Email") ? "envelope type-email" :
                             activityResult.getString("type").equals("Call") ? "phone type-call" :
                             activityResult.getString("type").equals("Meeting") ? "handshake type-meeting" : "sticky-note type-note");
            %>
                <tr>
                    <td><strong><%= activityResult.getString("customer_name") %></strong></td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <i class="<%= activityTypeIcon %>"></i>
                            <span><%= activityResult.getString("type") %></span>
                        </div>
                    </td>
                    <td><%= activityResult.getString("subject") %></td>
                    <td>
                        <div><%= activityResult.getTimestamp("communication_date").toString().substring(0, 10) %></div>
                        <small><%= activityResult.getTimestamp("communication_date").toString().substring(11, 16) %></small>
                    </td>
                </tr>
            <%
                    }
                }
                activityResult.close();
                activityStmt.close();
                conn.close();
            %>
        </tbody>
    </table>
</div>

<%@ include file="../../includes/footer.jsp" %>