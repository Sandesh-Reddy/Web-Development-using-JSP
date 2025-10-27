<%@ include file="includes/header.jsp" %>
<%@ include file="config/database.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title"><i class="fas fa-tachometer-alt"></i> CRM Dashboard</h1>
        <p class="page-subtitle">Welcome to your Customer Relationship Management System</p>
    </div>
</div>

<%
    // Check if database connection is available
    if (conn == null || conn.isClosed()) {
%>
        <div style="background: #fff3cd; color: #856404; padding: 1rem; border-radius: 8px; margin: 2rem 0; border-left: 4px solid #ffc107;">
            <h3><i class="fas fa-exclamation-triangle"></i> Database Connection Issue</h3>
            <p>Unable to connect to the database. Please check:</p>
            <ul>
                <li>MySQL server is running</li>
                <li>Database 'crm_system' exists</li>
                <li>MySQL connector is in Tomcat lib folder</li>
            </ul>
            <p><a href="test.jsp" class="btn btn-warning">Test Database Connection</a></p>
        </div>
<%
    } else {
        // Database connection is available - proceed with queries
%>

<div class="dashboard-cards">
    <%
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM customers");
            rs.next();
            int customerCount = rs.getInt("count");
            
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM leads");
            rs.next();
            int leadCount = rs.getInt("count");
            
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM leads WHERE status='New'");
            rs.next();
            int newLeads = rs.getInt("count");
            
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM communications");
            rs.next();
            int commCount = rs.getInt("count");
    %>
    
    <div class="card">
        <h3><i class="fas fa-users"></i> Total Customers</h3>
        <div class="number"><%= customerCount %></div>
        <div class="trend">
            <i class="fas fa-chart-line"></i> All customers
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-bullseye"></i> Total Leads</h3>
        <div class="number"><%= leadCount %></div>
        <div class="trend">
            <i class="fas fa-star"></i> <%= newLeads %> new leads
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-comments"></i> Communications</h3>
        <div class="number"><%= commCount %></div>
        <div class="trend">
            <i class="fas fa-history"></i> All interactions
        </div>
    </div>
    
    <div class="card">
        <h3><i class="fas fa-chart-bar"></i> Reports</h3>
        <div class="number">4</div>
        <div class="trend">
            <i class="fas fa-eye"></i> View analytics
        </div>
    </div>
</div>

<h3 style="margin: 2rem 0 1rem 0;"><i class="fas fa-history"></i> Recent Activities</h3>
<div class="table-container">
    <table class="table">
        <thead>
            <tr>
                <th>Customer</th>
                <th>Activity</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <%
                rs = stmt.executeQuery("SELECT c.name, com.type, com.subject, com.communication_date " +
                                      "FROM communications com " +
                                      "JOIN customers c ON com.customer_id = c.id " +
                                      "ORDER BY com.communication_date DESC LIMIT 5");
                if (!rs.isBeforeFirst()) {
            %>
                <tr>
                    <td colspan="3" style="text-align: center; color: #666;">
                        <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                        No recent activities
                    </td>
                </tr>
            <%
                } else {
                    while(rs.next()) {
            %>
                <tr>
                    <td><strong><%= rs.getString("name") %></strong></td>
                    <td>
                        <i class="fas fa-<%= rs.getString("type").equals("Email") ? "envelope" : 
                                           rs.getString("type").equals("Call") ? "phone" : 
                                           rs.getString("type").equals("Meeting") ? "handshake" : "sticky-note" %>"></i>
                        <%= rs.getString("type") %>: <%= rs.getString("subject") %>
                    </td>
                    <td><%= rs.getTimestamp("communication_date") %></td>
                </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</div>

<%
        } catch(SQLException e) {
            out.println("<div style='background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 8px; margin: 2rem 0;'>");
            out.println("<strong>Database Query Error:</strong> " + e.getMessage());
            out.println("</div>");
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch(SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch(SQLException e) {}
            if (conn != null) try { conn.close(); } catch(SQLException e) {}
        }
    }
%>

<%@ include file="includes/footer.jsp" %>