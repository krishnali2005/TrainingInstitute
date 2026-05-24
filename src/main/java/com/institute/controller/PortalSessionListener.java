package com.institute.controller;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class PortalSessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Enforce a strict 15-minute timeout window (15 minutes * 60 seconds)
        se.getSession().setMaxInactiveInterval(15 * 60); 
        System.out.println("🔒 Secure Session Started: Auto-logout active for 15 minutes.");
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        System.out.println("🔓 Secure Session Expired or user logged out successfully.");
    }
}