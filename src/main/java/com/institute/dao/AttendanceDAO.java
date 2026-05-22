package com.institute.dao;

import com.institute.model.Attendance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    // 1. MARK ATTENDANCE
    public boolean markAttendance(int studentId, String date, String status) {
        String query = "INSERT INTO attendance (student_id, date, status) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, studentId);
            stmt.setString(2, date);
            stmt.setString(3, status);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. VIEW ALL ATTENDANCE RECORDS WITH STUDENT NAMES (JOIN Query)
    public List<Attendance> getAllAttendanceRecords() {
        List<Attendance> list = new ArrayList<>();
        String query = "SELECT a.*, s.student_name FROM attendance a JOIN students s ON a.student_id = s.student_id ORDER BY a.date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAttendanceId(rs.getInt("attendance_id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setStudentName(rs.getString("student_name"));
                a.setDate(rs.getString("date"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. BUSINESS LOGIC LAYER: CALCULATE PERCENTAGE USING A LOOP
    public double calculateAttendancePercentage(int studentId) {
        String query = "SELECT status FROM attendance WHERE student_id = ?";
        int totalClasses = 0;
        int presentCount = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                // Loop through the data to compute the statistics
                while (rs.next()) {
                    totalClasses++;
                    if ("Present".equalsIgnoreCase(rs.getString("status"))) {
                        presentCount++;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (totalClasses == 0) return 0.0;
        return ((double) presentCount / totalClasses) * 100;
    }
}