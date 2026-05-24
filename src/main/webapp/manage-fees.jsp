<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.FeeDAO, com.institute.model.Student, com.institute.model.Fee, java.util.List" %>
<%
    // Security layer: Verify the user session identity role
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
    <title>Fee Accounting Center</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { display: grid; grid-template-columns: 1fr 2.2fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #1abc9c; }
        .form-group { display: flex; flex-direction: column; gap: 12px; margin-top: 10px; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .btn { padding: 10px; background: #1abc9c; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #16a085; }
        table { width: 100%; border-collapse: collapse; margin-top: 5px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; vertical-align: middle; }
        th { background: #34495e; color: white; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
        .badge { background: #e8f8f5; color: #1abc9c; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>💳 Institutional Fee Ledger & Accounting Center</h2>

    <div class="grid">
        <div class="panel">
            <% if ("ADMIN".equals(role)) { %>
                <strong style="font-size: 16px; color: #2c3e50;">Record New Transaction</strong>
                <form action="FeeServlet" method="POST" class="form-group">
                    <label>Select Target Student:</label>
                    <select name="studentId" required>
                        <option value="" disabled selected>Choose a student profile...</option>
                        <% for(Student s : students) { %>
                            <option value="<%= s.getStudentId() %>"><%= s.getStudentName() %> (#<%= s.getStudentId() %>)</option>
                        <% } %>
                    </select>

                    <label>Amount Received (₹):</label>
                    <input type="number" step="0.01" name="amount" placeholder="Enter amount (e.g. 7500.00)" required>

                    <label>Payment Date Log:</label>
                    <input type="date" name="date" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">

                    <button type="submit" class="btn">Post Payment Transaction</button>
                </form>
            <% } else { %>
                <strong style="font-size: 16px; color: #e67e22;">Student Access Account</strong>
                <p style="font-size: 14px; line-height: 1.5; color: #7f8c8d; margin-top: 10px;">
                    Welcome to your personal financial hub. The ledger to the right displays your verified payments recorded by the bursar administration.
                </p>
            <% } %>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <strong style="font-size: 16px; color: #2c3e50;">Receipt Ledger Index</strong>
            <div style="margin-top: 15px; overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Receipt ID</th>
                            <th>Student Name</th>
                            <th>Amount Paid</th>
                            <th>Date Processed</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            boolean recordFound = false;
                            for(Fee f : payments) { 
                                // Dynamic security filtering: Students can ONLY view their own financial ledger lines
                                if("STUDENT".equals(role) && !f.getStudentName().equalsIgnoreCase(currentUsername)) {
                                    continue;
                                }
                                recordFound = true;
                        %>
                        <tr>
                            <td><span class="badge">#<%= f.getPaymentId() %></span></td>
                            <td><strong><%= f.getStudentName() %></strong> <span style="font-size:11px; color:#95a5a6;">(ID: <%= f.getStudentId() %>)</span></td>
                            <td>₹<%= String.format("%.2f", f.getAmountPaid()) %></td>
                            <td><%= f.getPaymentDate() %></td>
                            <td>
                                <a href="print-receipt.jsp?id=<%= f.getPaymentId() %>" target="_blank" 
                                   style="color: #3498db; font-weight: bold; text-decoration: none; font-size: 13px;">📄 View / Print</a>
                            </td>
                        </tr>
                        <% 
                            } 
                            if (!recordFound) {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #95a5a6; padding: 20px;">No historical payment receipts found in this ledger query.</td>
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