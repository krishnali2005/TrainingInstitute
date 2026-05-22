<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.CourseDAO, com.institute.model.Course, java.util.List" %>
<%
    // Lock down to logged-in Admins only
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    CourseDAO dao = new CourseDAO();
    List<Course> courseList = dao.getAllCourses();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Course Allocation</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-section { background: #f8f9fa; padding: 20px; border-radius: 6px; margin-bottom: 25px; border-left: 4px solid #f1c40f; }
        .form-group { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px; }
        .form-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; flex: 1; min-width: 150px; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; color: white; cursor: pointer; font-weight: bold; }
        .btn-add { background: #f1c40f; color: #333; }
        .btn-assign { background: #3498db; padding: 6px 12px; font-size: 13px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #34495e; color: white; }
        .inline-assign-form { display: flex; gap: 5px; align-items: center; }
        .inline-assign-form input { padding: 5px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>📚 Course Allocation & Management</h2>
    
    <div class="form-section">
        <strong>Create New Course Profile</strong>
        <form action="CourseServlet" method="POST" class="form-group">
            <input type="hidden" name="action" value="add">
            <input type="text" name="courseName" placeholder="Course Name (e.g. Python Core)" required>
            <input type="text" name="duration" placeholder="Duration (e.g. 3 Months)" required>
            <input type="number" step="0.01" name="fees" placeholder="Tuition Fee Structure Amount" required>
            <input type="text" name="faculty" placeholder="Assign Faculty Name (Optional)">
            <button type="submit" class="btn btn-add">+ Create Course</button>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
                <th>Duration Terms</th>
                <th>Fees Structure</th>
                <th>Assigned Faculty Staff</th>
                <th>Reassign Faculty</th>
            </tr>
        </thead>
        <tbody>
            <% for(Course c : courseList) { %>
            <tr>
                <td><strong><%= c.getCourseId() %></strong></td>
                <td><%= c.getCourseName() %></td>
                <td><%= c.getDuration() %></td>
                <td>₹<%= String.format("%.2f", c.getFees()) %></td>
                <td><span style="color: #2c3e50; font-weight: bold;"><%= c.getFacultyAssigned() %></span></td>
                <td>
                    <form action="CourseServlet" method="POST" class="inline-assign-form">
                        <input type="hidden" name="action" value="assignFaculty">
                        <input type="hidden" name="courseId" value="<%= c.getCourseId() %>">
                        <input type="text" name="facultyName" placeholder="New Faculty Name" required>
                        <button type="submit" class="btn btn-assign">Assign</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>