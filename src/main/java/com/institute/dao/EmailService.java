package com.institute.dao;

public class EmailService {
    
    public static void sendWelcomeEmail(String recipientEmail, String studentName) {
        // Run in a background thread to match production-grade architecture patterns
        new Thread(() -> {
            try {
                System.out.println("=================================================");
                System.out.println("📨 [MOCK SMTP EMAIL SERVICE TRIGGERED]");
                System.out.println("To: " + recipientEmail);
                System.out.println("Subject: 🎯 Account Active: Institute Confirmation");
                System.out.println("-------------------------------------------------");
                System.out.println("Dear " + studentName + ",");
                System.out.println("Your profile has been generated inside our database.");
                System.out.println("Temporary Credentials: password123");
                System.out.println("=================================================");
                
                // Simulates a quick network latency delay
                Thread.sleep(1000); 
                
                System.out.println("✅ Background dispatch log finalized successfully.");
            } catch (Exception e) {
                System.out.println("⚠️ Mock email routine interrupted.");
            }
        }).start();
    }
}
