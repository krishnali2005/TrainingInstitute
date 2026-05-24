<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.AttendanceDAO, com.institute.dao.FeeDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null) { response.sendRedirect("index.jsp"); return; }

    StudentDAO sDAO = new StudentDAO();
    AttendanceDAO aDAO = new AttendanceDAO();
    FeeDAO fDAO = new FeeDAO();

    // Aggregating metrics for our visual charts
    int totalStudents = sDAO.getAllStudents().size();
    double totalCollectedFees = fDAO.getAllPayments().stream().mapToDouble(f -> f.getAmountPaid()).sum();
    int totalLogs = aDAO.getAllAttendanceRecords().size();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Academic Command Center</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .navbar { display: flex; justify-content: space-between; align-items: center; background: #2c3e50; padding: 15px 30px; color: white; border-radius: 6px; }
        .navbar a { color: #ecf0f1; text-decoration: none; font-weight: bold; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 20px 0; }
        .stat-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-left: 5px solid #3498db; }
        .stat-card h3 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .stat-card p { margin: 10px 0 0 0; font-size: 28px; font-weight: bold; color: #2c3e50; }
        .chart-container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; max-width: 600px; margin: 20px auto; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 30px; }
        .menu-card { background: white; padding: 20px; border-radius: 8px; text-decoration: none; color: #333; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-top: 4px solid #34495e; transition: transform 0.2s; }
        .menu-card:hover { transform: translateY(-3px); }
        .btn-export { background: #e74c3c; color: white; border: none; padding: 10px 20px; font-weight: bold; border-radius: 4px; cursor: pointer; }
        
        /* TASK 1: PRINT MEDIA QUERY FOR PDF EXPORT */
        @media print {
            .navbar, .menu-grid, .btn-export { display: none !important; }
            body { background: white; padding: 0; }
            .stat-card { border: 1px solid #ccc; box-shadow: none; }
            .chart-container { box-shadow: none; page-break-inside: avoid; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <h2>🎯 Executive Dashboard Overview</h2>
    <div>
        <span>Welcome, <strong><%= username %></strong> (<%= role %>)</span> | 
        <a href="LogoutServlet" style="color: #e74c3c; margin-left: 15px;">Secure Logout</a>
    </div>
</div>

<div class="stats-grid">
    <div class="stat-card" style="border-left-color: #3498db;">
        <h3>Enrolled Student Body</h3>
        <p><%= totalStudents %> Students</p>
    </div>
    <div class="stat-card" style="border-left-color: #2ecc71;">
        <h3>Gross Revenue Collected</h3>
        <p>₹<%= String.format("%.2f", totalCollectedFees) %></p>
    </div>
    <div class="stat-card" style="border-left-color: #f1c40f;">
        <h3>Attendance Logs Processed</h3>
        <p><%= totalLogs %> Records</p>
    </div>
</div>

<div style="text-align: right; margin-bottom: 20px;">
    <button class="btn-export" onclick="window.print()">📥 Export Executive Summary Report to PDF</button>
</div>

<div class="chart-container">
    <h3 style="text-align: center; color:#2c3e50; margin-top:0;">Institute Metric Distributions</h3>
    <canvas id="dashboardChart"></canvas>
</div>

<div class="menu-grid">
    <% if ("ADMIN".equals(role)) { %>
        <a href="manage-students.jsp" class="menu-card" style="border-top-color: #3498db;">
            <h3>👥 Student Directory</h3>
            <p>Onboard, modify, photo upload, or purge student records profiles.</p>
        </a>
    <% } %>
    
    <% if ("ADMIN".equals(role) || "FACULTY".equals(role)) { %>
        <a href="manage-attendance.jsp" class="menu-card" style="border-top-color: #e67e22;">
            <h3>📅 Attendance Sheets</h3>
            <p>Track metrics, evaluate loops, or review compliance warnings.</p>
        </a>
    <% } %>

    <% if ("ADMIN".equals(role) || "STUDENT".equals(role)) { %>
        <a href="manage-fees.jsp" class="menu-card" style="border-top-color: #1abc9c;">
            <h3>💳 Fees Accounting</h3>
            <p>Post financial transactions or view printable dynamic receipts.</p>
        </a>
    <% } %>
</div>

<script>
    // Injecting live server data metrics straight into Chart.js context logic
    const ctx = document.getElementById('dashboardChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Students Account Base', 'Attendance Metrics Logs', 'Transactions Processed'],
            datasets: [{
                label: 'System Distributions',
                data: [<%= totalStudents %>, <%= totalLogs %>, <%= totalLogs %>], 
                backgroundColor: ['#3498db', '#f1c40f', '#1abc9c'],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } }
        }
    });
</script>

</body>
</html>