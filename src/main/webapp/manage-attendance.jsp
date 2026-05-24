<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.AttendanceDAO, com.institute.model.Student, com.institute.model.Attendance, java.util.List" %>
<%
    // Security layer: Restrict view to ADMIN and FACULTY credentials only
    String role = (String) session.getAttribute("role");
    if (role == null || (!"ADMIN".equals(role) && !"FACULTY".equals(role))) {
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
    <title>Attendance Tracking Sheets</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { display: grid; grid-template-columns: 1fr 2.2fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #e67e22; }
        .form-group { display: flex; flex-direction: column; gap: 12px; margin-top: 10px; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .radio-group { display: flex; gap: 15px; padding: 5px 0; }
        .radio-label { display: flex; align-items: center; gap: 5px; font-size: 14px; cursor: pointer; }
        .btn { padding: 10px; background: #e67e22; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #d35400; }
        table { width: 100%; border-collapse: collapse; margin-top: 5px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; vertical-align: middle; }
        th { background: #34495e; color: white; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
        
        /* TASK C: WARNING STYLE SIGNALS */
        .badge-present { background: #d4edda; color: #155724; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
        .badge-absent { background: #f8d7da; color: #721c24; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
        .alert-text { color: #e74c3c; font-weight: bold; font-size: 11px; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>📅 Institutional Attendance Sheets & Compliance Rosters</h2>

    <div class="grid">
        <div class="panel">
            <strong style="font-size: 16px; color: #2c3e50;">Log Class Status</strong>
            <form action="AttendanceServlet" method="POST" class="form-group">
                <label>Select Student Roster:</label>
                <select name="studentId" required>
                    <option value="" disabled selected>Choose a student profile...</option>
                    <% 
                        for(Student s : students) { 
                            // TASK C: Dynamic Evaluation Check Hook from your updated AttendanceDAO
                            double rate = attendanceDAO.getAttendancePercentage(s.getStudentId());
                            String alertString = (rate < 75.0) ? " ⚠️ LOW COMPLIANCE" : "";
                    %>
                        <option value="<%= s.getStudentId() %>">
                            <%= s.getStudentName() %> (Avg: <%= String.format("%.1f", rate) %>%<%= alertString %>)
                        </option>
                    <% } %>
                </select>

                <label>Attendance Status Option:</label>
                <div class="radio-group">
                    <label class="radio-label">
                        <input type="radio" name="status" value="Present" checked> Present
                    </label>
                    <label class="radio-label">
                        <input type="radio" name="status" value="Absent"> Absent
                    </label>
                </div>

                <label>Log Session Date:</label>
                <input type="date" name="date" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">

                <button type="submit" class="btn">Post Attendance Log</button>
            </form>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <strong style="font-size: 16px; color: #2c3e50;">Historical Metric Log Ledger</strong>
            <div style="margin-top: 15px; overflow-y: auto; max-height: 450px;">
                <table>
                    <thead>
                        <tr>
                            <th>Log ID</th>
                            <th>Student Name</th>
                            <th>Recorded Status</th>
                            <th>Session Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if(attendanceRecords == null || attendanceRecords.isEmpty()) { 
                        %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: #95a5a6; padding: 20px;">No attendance tracks recorded in the current database query layout.</td>
                        </tr>
                        <% 
                            } else { 
                                for(Attendance a : attendanceRecords) { 
                        %>
                        <tr>
                            <td>#<%= a.getAttendanceId() %></td>
                            <td>
                                <strong><%= a.getStudentName() %></strong> 
                                <span style="font-size: 11px; color:#95a5a6;">(ID: <%= a.getStudentId() %>)</span>
                            </td>
                            <td>
                                <% if("Present".equalsIgnoreCase(a.getStatus())) { %>
                                    <span class="badge-present">✔ Present</span>
                                <% } else { %>
                                    <span class="badge-absent">❌ Absent</span>
                                <% } %>
                            </td>
                            <td><%= a.getDate() %></td>
                        </tr>
                        <% 
                                } 
                            } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>