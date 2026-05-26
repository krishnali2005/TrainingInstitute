<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.FeeDAO, com.institute.model.Student, com.institute.model.Fee, java.util.List, java.util.ArrayList" %>
<%@ page import="com.institute.dao.DBConnection, java.sql.*" %>
<%
    // 1. Session Verification & Security Guard
    String role = (String) session.getAttribute("role");
    String currentUsername = (String) session.getAttribute("username");
    if (role == null) { response.sendRedirect("index.jsp"); return; }

    StudentDAO studentDAO = new StudentDAO();
    FeeDAO feeDAO = new FeeDAO();
    
    List<Student> students = new ArrayList<>();
    List<Fee> payments = new ArrayList<>();
    int resolvedStudentId = -1;

    // 2. Data Scope Partitioning based on User Roles
    if ("ADMIN".equals(role)) {
        // Admins maintain full institutional view access permissions
        students = studentDAO.getAllStudents();
        payments = feeDAO.getAllPayments();
    } else if ("STUDENT".equals(role)) {
        // 🔒 Secure Mapping: Resolve text username to database numerical student_id
        String findIdSql = "SELECT student_id FROM students WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(findIdSql)) {
            stmt.setString(1, currentUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    resolvedStudentId = rs.getInt("student_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Filter the collective master transaction ledger for this specific student only
        if (resolvedStudentId != -1) {
            for (Fee f : feeDAO.getAllPayments()) {
                if (f.getStudentId() == resolvedStudentId) {
                    payments.add(f);
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Fee Accounting Center</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        
        /* Dynamic CSS Grid Adjustment depending on User Access levels */
        .grid { 
            display: grid; 
            <%= "ADMIN".equals(role) ? "grid-template-columns: 1fr 2.2fr;" : "grid-template-columns: 1fr;" %> 
            gap: 30px; 
            margin-top: 20px; 
        }
        
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #1abc9c; }
        .form-group { display: flex; flex-direction: column; gap: 12px; margin-top: 10px; }
        .form-group select, .form-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .btn { padding: 10px; background: #1abc9c; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #16a085; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; }
        th { background: #34495e; color: white; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
        .btn-print { background: #34495e; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .btn-print:hover { background: #2c3e50; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>💳 Institutional Fee Ledger & Transaction Logs</h2>
    
    <div class="grid">
        <% if ("ADMIN".equals(role)) { %>
        <div class="panel">
            <strong>Record Student Fee Transaction</strong>
            <form action="FeeServlet" method="POST" class="form-group">
                <label>Select Student Target Account:</label>
                <select name="studentId" required>
                    <option value="">-- Choose Target Profile --</option>
                    <% for(Student s : students) { %>
                        <option value="<%= s.getStudentId() %>">#<%= s.getStudentId() %> - <%= s.getStudentName() %> (<%= s.getCourse() %>)</option>
                    <% } %>
                </select>
                
                <label>Payment Amnt (INR / ₹):</label>
                <input type="number" step="0.01" name="amount" placeholder="0.00" required>
                
                <label>Payment Posting Date:</label>
                <input type="date" name="paymentDate" required>
                
                <button type="submit" class="btn">Post Transaction Entry</button>
            </form>
        </div>
        <% } %>

        <div class="panel" style="border-top-color: #34495e;">
            <strong><%= "ADMIN".equals(role) ? "Global Institutional Financial Audit Ledger" : "Your Personal Payment Transaction Invoices" %></strong>
            <table>
                <thead>
                    <tr>
                        <th>Receipt ID</th>
                        <th>Student Account Details</th>
                        <th>Amount Credited</th>
                        <th>Posting Date</th>
                        <th>Invoices</th>
                    </tr>
                </thead>
                <tbody>
                    <% if(payments.isEmpty()) { %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #7f8c8d; font-style: italic;">No verified payment processing logs encountered on this workstation.</td>
                        </tr>
                    <% } else { 
                        for(Fee f : payments) { 
                            // Dynamically identify matching student names for clear interface visualization
                            String contextualStudentName = "Student Account #" + f.getStudentId();
                            for(Student s : studentDAO.getAllStudents()) {
                                if(s.getStudentId() == f.getStudentId()) {
                                    contextualStudentName = s.getStudentName();
                                    break;
                                }
                            }
                    %>
                        <tr>
                            <td>#TXN-<%= f.getPaymentId() %></td>
                            <td><strong><%= contextualStudentName %></strong></td>
                            <td style="color: #27ae60; font-weight: bold;">₹<%= String.format("%.2f", f.getAmountPaid()) %></td>
                            <td><%= f.getPaymentDate() %></td>
                            <td>
                                <a href="print-receipt.jsp?id=<%= f.getPaymentId() %>" target="_blank" class="btn-print">📄 View / Print</a>
                            </td>
                        </tr>
                    <%   } 
                       } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>