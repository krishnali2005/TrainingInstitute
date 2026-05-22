<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.institute.dao.StudentDAO, com.institute.model.Student, java.util.List" %>
<%
    // Lock down to logged-in Admins only
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    StudentDAO dao = new StudentDAO();
    List<Student> studentList = dao.getAllStudents();
    
    // Check if we are currently editing a specific student
    String editIdStr = request.getParameter("editId");
    Student studentToEdit = null;
    if (editIdStr != null) {
        int editId = Integer.parseInt(editIdStr);
        for (Student s : studentList) {
            if (s.getStudentId() == editId) {
                studentToEdit = s;
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Students</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-section { background: #f8f9fa; padding: 20px; border-radius: 6px; margin-bottom: 20px; border-left: 4px solid #3498db; }
        .form-section.edit-mode { border-left-color: #e67e22; background: #fffcf9; }
        .form-group { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px; }
        .form-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; flex: 1; min-width: 150px; }
        .search-box { width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #ddd; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; color: white; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn-add { background: #2ecc71; }
        .btn-update { background: #e67e22; }
        .btn-cancel { background: #7f8c8d; }
        .btn-edit { background: #3498db; padding: 5px 10px; font-size: 12px; margin-right: 5px; }
        .btn-delete { background: #e74c3c; padding: 5px 10px; font-size: 12px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #34495e; color: white; }
        .back-link { display: inline-block; margin-bottom: 15px; color: #3498db; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    <h2>👥 Student Management</h2>
    
    <% if (studentToEdit == null) { %>
        <div class="form-section">
            <strong>Add New Student</strong>
            <form action="StudentServlet" method="POST" class="form-group">
                <input type="hidden" name="action" value="add">
                <input type="text" name="name" placeholder="Student Name" required>
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="text" name="course" placeholder="Assigned Course" required>
                <input type="text" name="phone" placeholder="Phone Number" required>
                <button type="submit" class="btn btn-add">+ Add Student</button>
            </form>
        </div>
    <% } else { %>
        <div class="form-section edit-mode">
            <strong>📝 Editing Student Details (ID: <%= studentToEdit.getStudentId() %>)</strong>
            <form action="StudentServlet" method="POST" class="form-group">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= studentToEdit.getStudentId() %>">
                <input type="text" name="name" value="<%= studentToEdit.getStudentName() %>" required>
                <input type="email" name="email" value="<%= studentToEdit.getEmail() %>" required>
                <input type="text" name="course" value="<%= studentToEdit.getCourse() %>" required>
                <input type="text" name="phone" value="<%= studentToEdit.getPhone() %>" required>
                <button type="submit" class="btn btn-update">Update Details</button>
                <a href="manage-students.jsp" class="btn btn-cancel">Cancel</a>
            </form>
        </div>
    <% } %>

    <input type="text" id="searchInput" class="search-box" onkeyup="filterStudents()" placeholder="🔍 Search students by name, email, or course...">

    <table id="studentTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Course</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for(Student s : studentList) { %>
            <tr>
                <td><%= s.getStudentId() %></td>
                <td><%= s.getStudentName() %></td>
                <td><%= s.getEmail() %></td>
                <td><%= s.getCourse() %></td>
                <td><%= s.getPhone() %></td>
                <td>
                    <a href="manage-students.jsp?editId=<%= s.getStudentId() %>" class="btn btn-edit">Edit</a>
                    <a href="StudentServlet?action=delete&id=<%= s.getStudentId() %>" 
                       class="btn btn-delete" 
                       onclick="return confirm('Are you sure you want to delete this student?');">Delete</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<script>
function filterStudents() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let table = document.getElementById("studentTable");
    let trs = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

    for (let i = 0; i < trs.length; i++) {
        let cells = trs[i].getElementsByTagName("td");
        let matchFound = false;
        
        // Loop through Name (idx 1), Email (idx 2), and Course (idx 3) columns
        for (let j = 1; j <= 3; j++) {
            if (cells[j] && cells[j].innerText.toLowerCase().indexOf(input) > -1) {
                matchFound = true;
                break;
            }
        }
        trs[i].style.display = matchFound ? "" : "none";
    }
}
</script>

</body>
</html>