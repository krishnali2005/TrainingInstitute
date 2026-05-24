<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.FeeDAO, com.institute.model.Fee" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { response.sendRedirect("index.jsp"); return; }

    int targetId = Integer.parseInt(request.getParameter("id"));
    FeeDAO dao = new FeeDAO();
    Fee targetFee = null;

    // Search for the specific matching transaction record
    for (Fee f : dao.getAllPayments()) {
        if (f.getPaymentId() == targetId) {
            targetFee = f;
            break;
        }
    }

    if (targetFee == null) {
        out.print("<h3>Receipt Record Not Found.</h3>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Receipt #<%= targetFee.getPaymentId() %></title>
    <style>
        body { font-family: 'Courier New', monospace; padding: 40px; color: #333; background: #fff; }
        .receipt-box { max-width: 600px; margin: auto; border: 2px dashed #333; padding: 30px; }
        .text-center { text-align: center; }
        .flex-row { display: flex; justify-content: space-between; margin: 15px 0; }
        .btn-print { background: #2c3e50; color: white; padding: 10px 20px; border: none; cursor: pointer; font-weight: bold; margin-top: 20px; display: block; margin: 20px auto 0 auto; }
        /* Hides the print button natively when generating the PDF printing sheet */
        @media print { .btn-print { display: none; } body { padding: 0; } .receipt-box { border: none; } }
    </style>
</head>
<body>

<div class="receipt-box">
    <h2 class="text-center">🎯 APEX TRAINING INSTITUTE</h2>
    <p class="text-center">Official Payment Confirmation Invoice</p>
    <hr style="border-top: 1px dashed #333;">
    
    <div class="flex-row">
        <span><strong>Receipt ID:</strong> #<%= targetFee.getPaymentId() %></span>
        <span><strong>Date:</strong> <%= targetFee.getPaymentDate() %></span>
    </div>
    
    <div class="flex-row">
        <span><strong>Student Name:</strong> <%= targetFee.getStudentName() %></span>
        <span><strong>Student ID:</strong> #<%= targetFee.getStudentId() %></span>
    </div>
    
    <hr style="border-top: 1px dashed #333;">
    
    <div class="flex-row" style="font-size: 20px;">
        <strong>TOTAL PAID:</strong>
        <strong>₹<%= String.format("%.2f", targetFee.getAmountPaid()) %></strong>
    </div>
    
    <hr style="border-top: 1px dashed #333;">
    <p class="text-center" style="font-size: 11px; color: #7f8c8d;">This is an authenticated computer-generated billing receipt wrapper.</p>
    
    <button class="btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
</div>

</body>
</html>