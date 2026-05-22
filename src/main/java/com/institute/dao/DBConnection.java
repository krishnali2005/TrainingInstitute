package com.institute.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String username;
    private static String password;

    // Static block runs once when the class loads to fetch credentials safely
    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("config.properties")) {
            Properties prop = new Properties();
            
            if (input == null) {
                throw new RuntimeException("Sorry, unable to find config.properties");
            }

            // Load the properties file
            prop.load(input);
            url = prop.getProperty("db.url");
            username = prop.getProperty("db.username");
            password = prop.getProperty("db.password");

            // Explicitly load MySQL Driver for Tomcat
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing database configuration variables", e);
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
