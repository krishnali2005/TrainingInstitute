<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.FeeDAO, com.institute.model.Student, com.institute.model.Fee, java.util.List" %>
<%
    // Safety check: ensure the user is logged in
    String role = (String) session.getAttribute("role");
    String currentUsername = (String) session.getAttribute("username");
    if (role == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    StudentDAO studentDAO = new StudentDAO();
    FeeDAO feeDAO = new FeeDAO();
    
    List<Student> students = studentDAO.getAllStudents();
    List<Fee> payments = feeDAO.getAllPayments();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Fee Management</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { display: grid; grid-template-columns: 1fr 2fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #1abc9c; }
        .form-group { display: flex; flex-direction: column; gap: 12px; margin-top: 10px; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .btn { padding: 10px; background: #1abc9c; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; }
        th { background: #34495e; color: white; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>💳 Fee Management & Receipt Ledger</h2>

    <div class="grid">
        <div class="panel">
            <% if ("ADMIN".equals(role)) { %>
                <strong>Record Student Payment</strong>
                <form action="FeeServlet" method="POST" class="form-group">
                    <label>Select Student:</label>
                    <select name="studentId" required>
                        <% for(Student s : students) { %>
                            <option value="<%= s.getStudentId() %>"><%= s.getStudentName() %></option>
                        <% } %>
                    </select>

                    <label>Amount Paid (₹):</label>
                    <input type="number" step="0.01" name="amount" placeholder="e.g. 5000.00" required>

                    <label>Payment Date:</label>
                    <input type="date" name="date" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">

                    <button type="submit" class="btn">Post Payment Transaction</button>
                </form>
            <% } else { %>
                <strong>Notice</strong>
                <p>Read-only access mode enabled for your user profile role (<%= role %>).</p>
            <% } %>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <strong>Transaction Receipt Log Ledger</strong>
            <div style="margin-top: 15px; max-height: 400px; overflow-y: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Receipt ID</th>
                            <th>Student Name</th>
                            <th>Amount Received</th>
                            <th>Date Recorded</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for(Fee f : payments) { 
                                // If logged in as a student, only show their own payments!
                                if("STUDENT".equals(role) && !f.getStudentName().equalsIgnoreCase(currentUsername)) {
                                    continue;
                                }
                        %>
                        <tr>
                            <td>#<%= f.getPaymentId() %></td>
                            <td><strong><%= f.getStudentName() %></strong></td>
                            <td>₹<%= String.format("%.2f", f.getAmountPaid()) %></td>
                            <td><%= f.getPaymentDate() %></td>
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