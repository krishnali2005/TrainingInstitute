package com.institute.dao;

import com.institute.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    
    public User validateUser(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setRole(rs.getString("role"));
                    return user; // Found user with role!
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Return null if login credentials fail
    }
}
