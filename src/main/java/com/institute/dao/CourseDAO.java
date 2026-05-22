package com.institute.dao;

import com.institute.model.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    // 1. ADD COURSE
    public boolean addCourse(Course course) {
        String query = "INSERT INTO courses (course_name, duration, fees, faculty_assigned) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, course.getCourseName());
            stmt.setString(2, course.getDuration());
            stmt.setDouble(3, course.getFees());
            stmt.setString(4, course.getFacultyAssigned());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. VIEW ALL COURSES
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String query = "SELECT * FROM courses";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setCourseName(rs.getString("course_name"));
                c.setDuration(rs.getString("duration"));
                c.setFees(rs.getDouble("fees"));
                c.setFacultyAssigned(rs.getString("faculty_assigned"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. ASSIGN OR UPDATE FACULTY TO COURSE
    public boolean assignFaculty(int courseId, String facultyName) {
        String query = "UPDATE courses SET faculty_assigned = ? WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, facultyName);
            stmt.setInt(2, courseId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
