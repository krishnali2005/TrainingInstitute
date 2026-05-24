<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.model.Student, java.util.List" %>
<%
    // Ensure the current user is logged in and authorized as an ADMIN
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    StudentDAO studentDAO = new StudentDAO();
    List<Student> students = studentDAO.getAllStudents();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Management Directory</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { display: grid; grid-template-columns: 1fr 2.5fr; gap: 30px; margin-top: 20px; }
        .panel { background: #f8f9fa; padding: 20px; border-radius: 6px; border-top: 4px solid #3498db; }
        .form-group { display: flex; flex-direction: column; gap: 12px; margin-top: 10px; }
        .form-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .btn { padding: 10px; background: #3498db; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 14px; margin-top: 5px; }
        .btn:hover { background: #2980b9; }
        .search-bar { width: 100%; padding: 12px; border: 2px solid #3498db; border-radius: 4px; font-size: 14px; margin-bottom: 20px; box-sizing: border-box; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; vertical-align: middle; }
        th { background: #34495e; color: white; }
        .avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid #ccc; display: block; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>👥 Student Records & Management Directory</h2>

    <div class="grid">
        <div class="panel">
            <strong style="font-size: 16px; color: #2c3e50;">Onboard New Student Profile</strong>
            <form action="StudentServlet" method="POST" enctype="multipart/form-data" class="form-group">
                <label>Student Name:</label>
                <input type="text" name="name" placeholder="Enter full name" required>
                
                <label>Email Address:</label>
                <input type="email" name="email" placeholder="student@email.com" required>
                
                <label>Course Allocation:</label>
                <input type="text" name="course" placeholder="e.g. Full Stack Java Development" required>
                
                <label>Phone Number:</label>
                <input type="text" name="phone" placeholder="e.g. +91 9876543210" required>
                
                <label>Upload Profile Photo Identification Image:</label>
                <input type="file" name="photo" accept="image/*">
                
                <button type="submit" class="btn">Register & Deploy Profile</button>
            </form>
        </div>

        <div class="panel" style="border-top-color: #34495e;">
            <strong style="font-size: 16px; color: #2c3e50;">Registered Student Body Index</strong>
            <p style="font-size: 12px; color: #7f8c8d; margin: 5px 0 15px 0;">Type a keyword below to scan names or courses dynamically without refreshing the workspace.</p>
            
            <input type="text" id="ajaxSearch" class="search-bar" placeholder="🔍 Start typing name or course to filter entries instantly...">

            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Photo</th>
                            <th>ID</th>
                            <th>Student Name</th>
                            <th>Email Address</th>
                            <th>Course</th>
                            <th>Phone Number</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Student s : students) { %>
                        <tr>
                            <td>
                                <img src="<%= (s.getPhotoPath() != null && !s.getPhotoPath().isEmpty()) ? s.getPhotoPath() : "uploads/default-avatar.png" %>" class="avatar" alt="Profile Picture">
                            </td>
                            <td>#<%= s.getStudentId() %></td>
                            <td><strong><%= s.getStudentName() %></strong></td>
                            <td><%= s.getEmail() %></td>
                            <td><%= s.getCourse() %></td>
                            <td><%= s.getPhone() %></td>
                            <td>
                                <a href="StudentServlet?action=delete&id=<%= s.getStudentId() %>" 
                                   style="color:#e74c3c; font-weight:bold; text-decoration:none;"
                                   onclick="return confirm('Are you sure you want to permanently delete this student record? This action will also revoke their login credentials.');">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('ajaxSearch').addEventListener('input', function() {
    // Corrected variable initialization format from Java 'String' to proper JavaScript 'const'
    const keywordValue = this.value;
    
    // Dispatch query to our lightweight SearchServlet endpoint
    fetch('SearchServlet?query=' + encodeURIComponent(keywordValue))
        .then(response => response.text())
        .then(htmlOutputData => {
            // Hot-swap out table body container rows live without hard-refreshing the web app
            document.querySelector('table tbody').innerHTML = htmlOutputData;
        })
        .catch(error => console.error('Error fetching search indices profiles:', error));
});
</script>

</body>
</html>