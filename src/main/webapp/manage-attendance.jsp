<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.AttendanceDAO, com.institute.model.Student, com.institute.model.Attendance, java.util.List" %>
<%
    // Lock access down to ADMIN and FACULTY only as per Module 1 rules
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role) && !"FACULTY".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    StudentDAO studentDAO = new StudentDAO();
    AttendanceDAO attendanceDAO = new AttendanceDAO();
    
    List<Student> students = studentDAO.getAllStudents();
    List<Attendance> attendanceRecords = attendanceDAO.getAllAttendanceRecords();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Attendance Management</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { display: grid; grid-template-columns: 1fr 2fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #e67e22; }
        .form-group { display: flex; flex-direction: column; gap: 15px; margin-top: 15px; }
        .form-group select, .form-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .btn { padding: 10px; border: none; border-radius: 4px; color: white; cursor: pointer; font-weight: bold; background: #e67e22; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; }
        th { background: #34495e; color: white; }
        .badge { padding: 4px 8px; border-radius: 12px; font-weight: bold; font-size: 12px; }
        .badge-present { background: #d4edda; color: #155724; }
        .badge-absent { background: #f8d7da; color: #721c24; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>📅 Attendance Sheets & Reporting</h2>

    <div class="grid">
        <div class="panel">
            <strong>Mark Daily Attendance</strong>
            <form action="AttendanceServlet" method="POST" class="form-group">
                <label>Select Enrolled Student:</label>
                <select name="studentId" required>
                    <% for(Student s : students) { 
                        double pct = attendanceDAO.calculateAttendancePercentage(s.getStudentId());
                    %>
                        <option value="<%= s.getStudentId() %>">
                            <%= s.getStudentName() %> (Current: <%= String.format("%.1f", pct) %>%)
                        </option>
                    <% } %>
                </select>

                <label>Select Date:</label>
                <input type="date" name="date" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">

                <label>Status:</label>
                <select name="status" required>
                    <option value="Present">Present</option>
                    <option value="Absent">Absent</option>
                </select>

                <button type="submit" class="btn">Submit Attendance Log</button>
            </form>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <strong>Recent Attendance Log Ledger</strong>
            <div style="max-height: 400px; overflow-y: auto; margin-top: 15px;">
                <table>
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Date Tracked</th>
                            <th>Status Metric</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Attendance a : attendanceRecords) { %>
                        <tr>
                            <td><strong><%= a.getStudentName() %></strong></td>
                            <td><%= a.getDate() %></td>
                            <td>
                                <span class="badge <%= "Present".equals(a.getStatus()) ? "badge-present" : "badge-absent" %>">
                                    <%= a.getStatus() %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>