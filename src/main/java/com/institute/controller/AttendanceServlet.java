package com.institute.controller;

import com.institute.dao.AttendanceDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String date = request.getParameter("date");
        String status = request.getParameter("status");

        attendanceDAO.markAttendance(studentId, date, status);

        response.sendRedirect("manage-attendance.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
