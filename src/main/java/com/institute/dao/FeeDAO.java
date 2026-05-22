package com.institute.dao;

import com.institute.model.Fee;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeeDAO {

    // 1. RECORD FEE PAYMENT
    public boolean recordPayment(int studentId, double amount, String date) {
        String query = "INSERT INTO fees (student_id, amount_paid, payment_date) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, studentId);
            stmt.setDouble(2, amount);
            stmt.setString(3, date);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. VIEW ALL PAYMENTS (With Student Names)
    public List<Fee> getAllPayments() {
        List<Fee> list = new ArrayList<>();
        String query = "SELECT f.*, s.student_name FROM fees f JOIN students s ON f.student_id = s.student_id ORDER BY f.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Fee f = new Fee();
                f.setPaymentId(rs.getInt("payment_id"));
                f.setStudentId(rs.getInt("student_id"));
                f.setStudentName(rs.getString("student_name"));
                f.setAmountPaid(rs.getDouble("amount_paid"));
                f.setPaymentDate(rs.getString("payment_date"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
