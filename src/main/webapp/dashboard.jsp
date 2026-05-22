<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security Guard: Check if a user session exists. If not, kick them out to login page!
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Training Institute Dashboard</title>
    <style>
        body { font-family: 'Arial', sans-serif; background: #f4f6f9; margin: 0; padding: 0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #ecf0f1; text-decoration: none; font-weight: bold; padding: 8px 15px; border-radius: 4px; background: #c0392b; }
        .container { padding: 40px; max-width: 1000px; margin: 0 auto; }
        .welcome-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .role-badge { display: inline-block; padding: 5px 12px; background: #3498db; color: white; border-radius: 20px; font-size: 14px; text-transform: uppercase; margin-top: 10px; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 30px; }
        .menu-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); text-align: center; text-decoration: none; color: #333; border-top: 4px solid #3498db; transition: transform 0.2s; }
        .menu-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>

    <div class="navbar">
        <h2>Institute Management System</h2>
        <a href="LogoutServlet">Logout</a>
    </div>

    <div class="container">
        <div class="welcome-box">
            <h1>Welcome Back, <%= username %>!</h1>
            <span class="role-badge"><%= role %> Dashboard</span>
        </div>

        <div class="menu-grid">
            <% if ("ADMIN".equals(role)) { %>
                <a href="manage-students.jsp" class="menu-card" style="border-top-color: #2ecc71;">
                    <h3>👥 Student Management</h3>
                    <p>Add, view, edit or delete enrolled student list details.</p>
                </a>
                <a href="manage-courses.jsp" class="menu-card" style="border-top-color: #f1c40f;">
                    <h3>📚 Course Allocation</h3>
                    <p>Manage courses layout plans, duration terms, and structures.</p>
                </a>
                <a href="#" class="menu-card" style="border-top-color: #9b59b6;">
                    <h3>🧑‍🏫 Faculty Management</h3>
                    <p>Assign faculty staff classes and track course lines.</p>
                </a>
            <% } %>

            <% if ("ADMIN".equals(role) || "FACULTY".equals(role)) { %>
                <a href="manage-attendance.jsp" class="menu-card" style="border-top-color: #e67e22;">
                    <h3>📅 Attendance Sheets</h3>
                    <p>Mark daily metrics or check compliance calculations.</p>
                </a>
            <% } %>

            <% if ("ADMIN".equals(role) || "STUDENT".equals(role)) { %>
                <a href="manage-fees.jsp" class="menu-card" style="border-top-color: #1abc9c;">
                    <h3>💳 My Fee Status</h3>
                    <p>Review total outstanding, check receipts or submit files.</p>
                </a>
            <% } %>
        </div>
    </div>

</body>
</html>