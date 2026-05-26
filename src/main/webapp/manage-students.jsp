<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.dao.CourseDAO, com.institute.model.Student, com.institute.model.Course, java.util.List" %>
<%
    // 1. Session Verification Guard
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equals(role)) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }

    StudentDAO studentDAO = new StudentDAO();
    CourseDAO courseDAO = new CourseDAO();
    
    List<Student> studentList = studentDAO.getAllStudents();
    List<Course> courseList = courseDAO.getAllCourses();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Directory Management</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        
        .grid { display: grid; grid-template-columns: 1fr 2.5fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #3498db; }
        
        .form-group { display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .btn { padding: 10px; background: #3498db; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #2980b9; }
        
        .search-box { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; }
        th { background: #34495e; color: white; }
        
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
        .avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid #ddd; }
        .delete-link { color: #e74c3c; font-weight: bold; text-decoration: none; }
        .delete-link:hover { text-decoration: underline; }
    </style>
    <script>
        // Real-Time AJAX Search Engine Integration
        function searchStudents() {
            let query = document.getElementById("searchBar").value;
            fetch("SearchServlet?query=" + encodeURIComponent(query))
                .then(response => response.text())
                .then(data => {
                    document.getElementById("studentTableBody").innerHTML = data;
                })
                .catch(error => console.error('Error handling AJAX payload loop:', error));
        }
    </script>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>👥 Student Directory Master Control</h2>
    
    <div class="grid">
        <div class="panel">
            <strong>Onboard New Student Profile</strong>
            <form action="StudentServlet" method="POST" enctype="multipart/form-data" class="form-group">
                <input type="hidden" name="action" value="add">
                
                <label>Full Name:</label>
                <input type="text" name="studentName" placeholder="Enter full name" required>
                
                <label>Email Address:</label>
                <input type="email" name="email" placeholder="name@domain.com" required>
                
                <label>Assign Course Curriculum:</label>
                <select name="course" required>
                    <option value="">-- Choose Core Track --</option>
                    <% for(Course c : courseList) { %>
                        <option value="<%= c.getCourseName() %>"><%= c.getCourseName() %> (<%= c.getDuration() %>)</option>
                    <% } %>
                </select>
                
                <label>Contact Number:</label>
                <input type="text" name="phone" placeholder="Phone details">
                
                <label>System Account Login String (Username):</label>
                <input type="text" name="username" placeholder="To link user profile mapping" required>
                
                <label>Profile Avatar (.jpg / .png):</label>
                <input type="file" name="photo" accept="image/*">
                
                <button type="submit" class="btn">Register & Save Student</button>
            </form>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <input type="text" id="searchBar" class="search-box" placeholder="🔍 Search live by student name or tracking course track..." onkeyup="searchStudents()">
            
            <table>
                <thead>
                    <tr>
                        <th>Avatar</th>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Enrolled Course</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="studentTableBody">
                    <% if(studentList.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #7f8c8d; font-style: italic;">No verified student registry indexes mapped on this database instance.</td>
                        </tr>
                    <% } else { 
                        for(Student s : studentList) { 
                    %>
                        <tr>
                            <td>
                                <img src="<%= (s.getPhotoPath() != null && !s.getPhotoPath().trim().isEmpty()) ? s.getPhotoPath() : "uploads/default-avatar.png" %>" class="avatar" alt="Profile">
                            </td>
                            <td>#<%= s.getStudentId() %></td>
                            <td><strong><%= s.getStudentName() %></strong></td>
                            <td><%= s.getEmail() %></td>
                            <td><%= s.getCourse() %></td>
                            <td><%= (s.getPhone() != null) ? s.getPhone() : "-" %></td>
                            <td>
                                <a href="StudentServlet?action=delete&id=<%= s.getStudentId() %>" class="delete-link" onclick="return confirm('Purge this student asset profile? This cascade action cannot be reversed.')">Delete</a>
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