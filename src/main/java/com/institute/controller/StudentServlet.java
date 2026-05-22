package com.institute.controller;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Student s = new Student();
            s.setStudentName(request.getParameter("name"));
            s.setEmail(request.getParameter("email"));
            s.setCourse(request.getParameter("course"));
            s.setPhone(request.getParameter("phone"));
            
            studentDAO.addStudent(s);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            studentDAO.deleteStudent(id);
        } else if ("update".equals(action)) {
            Student s = new Student();
            s.setStudentId(Integer.parseInt(request.getParameter("id")));
            s.setStudentName(request.getParameter("name"));
            s.setEmail(request.getParameter("email"));
            s.setCourse(request.getParameter("course"));
            s.setPhone(request.getParameter("phone"));
            
            studentDAO.updateStudent(s);
        }

        response.sendRedirect("manage-students.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
