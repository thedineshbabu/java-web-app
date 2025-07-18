package com.sample.saml.listener;

import com.sample.saml.util.SAMLConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * SAML Context Listener
 * 
 * This listener initializes the SAML configuration when the web application
 * starts up. It ensures that all SAML settings are loaded and validated
 * before the application begins serving requests.
 * 
 * @author SAML SSO Sample App
 * @version 1.0.0
 */
public class SAMLContextListener implements ServletContextListener {
    
    private static final Logger logger = LoggerFactory.getLogger(SAMLContextListener.class);
    
    /**
     * Called when the web application is being initialized
     * Initializes SAML configuration and validates settings
     * 
     * @param sce the servlet context event
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Initializing SAML SSO Sample Application");
        
        try {
            // Initialize SAML configuration
            SAMLConfig.initialize();
            
            // Store SAML configuration in servlet context for access by other components
            sce.getServletContext().setAttribute("saml.config.initialized", true);
            
            logger.info("SAML SSO Sample Application initialized successfully");
            
        } catch (Exception e) {
            logger.error("Failed to initialize SAML SSO Sample Application", e);
            throw new RuntimeException("Application initialization failed", e);
        }
    }
    
    /**
     * Called when the web application is being destroyed
     * Performs cleanup operations
     * 
     * @param sce the servlet context event
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Shutting down SAML SSO Sample Application");
        
        try {
            // Remove SAML configuration from servlet context
            sce.getServletContext().removeAttribute("saml.config.initialized");
            
            logger.info("SAML SSO Sample Application shutdown completed");
            
        } catch (Exception e) {
            logger.error("Error during application shutdown", e);
        }
    }
} 