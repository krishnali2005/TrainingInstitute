package com.institute.controller;

import com.institute.dao.StudentDAO;
import com.institute.model.Student;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/StudentServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB cache buffers allocation
    maxFileSize = 1024 * 1024 * 10,      // 10MB max bounds limit
    maxRequestSize = 1024 * 1024 * 50
)
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        String phone = request.getParameter("phone");
        
        // Handling Binary Part Processing Assets
        Part filePart = request.getPart("photo");
        String fileName = "default-avatar.png";
        
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = filePart.getSubmittedFileName();
            fileName = System.currentTimeMillis() + "_" + submittedFileName; // Unique file mapping rename
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            filePart.write(uploadPath + File.separator + fileName);
        }

        Student student = new Student();
        student.setStudentName(name);
        student.setEmail(email);
        student.setCourse(course);
        student.setPhone(phone);
        student.setPhotoPath("uploads/" + fileName);

        studentDAO.addStudent(student);
        response.sendRedirect("manage-students.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            studentDAO.deleteStudent(id);
        }
        response.sendRedirect("manage-students.jsp");
    }
}
