package com.institute.controller;

import com.institute.dao.CourseDAO;
import com.institute.model.Course;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Course c = new Course();
            c.setCourseName(request.getParameter("courseName"));
            c.setDuration(request.getParameter("duration"));
            c.setFees(Double.parseDouble(request.getParameter("fees")));
            
            String faculty = request.getParameter("faculty");
            if(faculty == null || faculty.trim().isEmpty()) {
                faculty = "Not Assigned";
            }
            c.setFacultyAssigned(faculty);
            
            courseDAO.addCourse(c);
        } else if ("assignFaculty".equals(action)) {
            int id = Integer.parseInt(request.getParameter("courseId"));
            String facultyName = request.getParameter("facultyName");
            
            courseDAO.assignFaculty(id, facultyName);
        }

        response.sendRedirect("manage-courses.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
