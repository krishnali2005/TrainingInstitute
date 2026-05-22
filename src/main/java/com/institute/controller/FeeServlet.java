package com.institute.controller;

import com.institute.dao.FeeDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FeeServlet")
public class FeeServlet extends HttpServlet {
    private FeeDAO feeDAO = new FeeDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");

        feeDAO.recordPayment(studentId, amount, date);

        response.sendRedirect("manage-fees.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
