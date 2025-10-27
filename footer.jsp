    </div>
    <div class="footer">
        <div class="footer-content">
            <p>&copy; 2024 CRM System - JSP Version. Built with <i class="fas fa-heart" style="color: #e74c3c;"></i></p>
            <p class="footer-links">
                <a href="../index.jsp">Dashboard</a> • 
                <a href="../pages/customers/list.jsp">Customers</a> • 
                <a href="../pages/leads/list.jsp">Sales Leads</a> • 
                <a href="../pages/communications/list.jsp">Communications</a> • 
                <a href="../pages/reports/dashboard.jsp">Reports</a>
            </p>
        </div>
    </div>
    
    <script>
        // Add smooth scrolling and animations
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading animation to cards
            const cards = document.querySelectorAll('.card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
            
            // Add confirmation for delete actions
            const deleteButtons = document.querySelectorAll('a[href*="delete"]');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>