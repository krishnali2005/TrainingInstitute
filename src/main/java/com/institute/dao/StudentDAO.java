package com.institute.dao;

import com.institute.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // 1. ADD STUDENT
    public boolean addStudent(Student student) {
    String userQuery = "INSERT INTO users (username, password, role) VALUES (?, ?, 'STUDENT')";
    String studentQuery = "INSERT INTO students (student_name, email, course, phone, username) VALUES (?, ?, ?, ?, ?)";
    
    Connection conn = null;
    PreparedStatement stmtUser = null;
    PreparedStatement stmtStudent = null;
    
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); // Start SQL Transaction transaction

        // 1. Create the Login Account automatically (Username is their email, Password defaults to 'password123')
        stmtUser = conn.prepareStatement(userQuery);
        stmtUser.setString(1, student.getEmail()); 
        stmtUser.setString(2, "password123"); 
        stmtUser.executeUpdate();

        // 2. Insert into the Students Information Table
        stmtStudent = conn.prepareStatement(studentQuery);
        stmtStudent.setString(1, student.getStudentName());
        stmtStudent.setString(2, student.getEmail());
        stmtStudent.setString(3, student.getCourse());
        stmtStudent.setString(4, student.getPhone());
        stmtStudent.setString(5, student.getEmail()); // Link them via the email/username
        stmtStudent.executeUpdate();

        conn.commit();
        // Sends the automated registration email seamlessly
EmailService.sendWelcomeEmail(student.getEmail(), student.getStudentName()); // Commit both safely
        return true;
    } catch (SQLException e) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        e.printStackTrace();
        return false;
    } finally {
        try {
            if (stmtUser != null) stmtUser.close();
            if (stmtStudent != null) stmtStudent.close();
            if (conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}

    // 2. VIEW ALL STUDENTS
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String query = "SELECT * FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Student s = new Student();
                s.setStudentId(rs.getInt("student_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setEmail(rs.getString("email"));
                s.setCourse(rs.getString("course"));
                s.setPhone(rs.getString("phone"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. DELETE STUDENT
    public boolean deleteStudent(int id) {
    // First find the student's username/email before deleting the row
    String findUserQuery = "SELECT username FROM students WHERE student_id = ?";
    String deleteStudentQuery = "DELETE FROM students WHERE student_id = ?";
    String deleteUserQuery = "DELETE FROM users WHERE username = ?";
    
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);
        String username = null;
        
        try (PreparedStatement stmtFind = conn.prepareStatement(findUserQuery)) {
            stmtFind.setInt(1, id);
            try (ResultSet rs = stmtFind.executeQuery()) {
                if (rs.next()) { username = rs.getString("username"); }
            }
        }
        
        // Delete student profile tracking row
        try (PreparedStatement stmtDelStud = conn.prepareStatement(deleteStudentQuery)) {
            stmtDelStud.setInt(1, id);
            stmtDelStud.executeUpdate();
        }
        
        // Delete authorization credentials row
        if (username != null) {
            try (PreparedStatement stmtDelUser = conn.prepareStatement(deleteUserQuery)) {
                stmtDelUser.setString(1, username);
                stmtDelUser.executeUpdate();
            }
        }
        
        conn.commit();
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    // 4. UPDATE STUDENT
    public boolean updateStudent(Student student) {
        String query = "UPDATE students SET student_name=?, email=?, course=?, phone=? WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, student.getStudentName());
            stmt.setString(2, student.getEmail());
            stmt.setString(3, student.getCourse());
            stmt.setString(4, student.getPhone());
            stmt.setInt(5, student.getStudentId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
