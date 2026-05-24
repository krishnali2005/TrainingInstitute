package com.institute.controller;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String query = request.getParameter("query");
        List<Student> list = studentDAO.getAllStudents();

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Standard loop filter tracking matches
        for (Student s : list) {
            if (query == null || query.trim().isEmpty() || 
                s.getStudentName().toLowerCase().contains(query.toLowerCase()) ||
                s.getCourse().toLowerCase().contains(query.toLowerCase())) {
                
                out.print("<tr>");
                out.print("<td>" + s.getStudentId() + "</td>");
                out.print("<td><strong>" + s.getStudentName() + "</strong></td>");
                out.print("<td>" + s.getEmail() + "</td>");
                out.print("<td>" + s.getCourse() + "</td>");
                out.print("<td>" + s.getPhone() + "</td>");
                out.print("<td><a href='StudentServlet?action=delete&id=" + s.getStudentId() + "' style='color:red; font-weight:bold; text-decoration:none;'>Delete</a></td>");
                out.print("</tr>");
            }
        }
    }
}
