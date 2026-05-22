package com.institute.controller;

import com.institute.dao.UserDAO;
import com.institute.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userTyped = request.getParameter("username");
        String passTyped = request.getParameter("password");
        
        User authenticatedUser = userDAO.validateUser(userTyped, passTyped);
        
        if (authenticatedUser != null) {
            // Module 1 Requirement: Establish a Session
            HttpSession session = request.getSession();
            session.setAttribute("username", authenticatedUser.getUsername());
            session.setAttribute("role", authenticatedUser.getRole());
            
            // Redirect smoothly to the main dashboard layout
            response.sendRedirect("dashboard.jsp");
        } else {
            // Fail safely back to index page with an error flag
            response.sendRedirect("index.jsp?error=invalid");
        }
    }
}