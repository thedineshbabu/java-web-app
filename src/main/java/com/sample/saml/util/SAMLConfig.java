package com.sample.saml.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * SAML Configuration Manager
 * 
 * This class handles loading and managing SAML configuration properties
 * from the saml.properties file. It provides centralized access to all
 * SAML-related configuration settings used throughout the application.
 * 
 * @author SAML SSO Sample App
 * @version 1.0.0
 */
public class SAMLConfig {
    
    private static final Logger logger = LoggerFactory.getLogger(SAMLConfig.class);
    private static final String CONFIG_FILE = "saml.properties";
    
    private static Properties properties;
    private static boolean initialized = false;
    
    /**
     * Private constructor to prevent instantiation
     * This class uses static methods for configuration access
     */
    private SAMLConfig() {
        // Utility class - no instantiation needed
    }
    
    /**
     * Initializes the SAML configuration by loading properties from the config file
     * This method should be called during application startup
     * 
     * @throws RuntimeException if configuration cannot be loaded
     */
    public static synchronized void initialize() {
        if (initialized) {
            logger.debug("SAML configuration already initialized");
            return;
        }
        
        logger.info("Initializing SAML configuration from {}", CONFIG_FILE);
        
        try (InputStream inputStream = SAMLConfig.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (inputStream == null) {
                throw new RuntimeException("SAML configuration file not found: " + CONFIG_FILE);
            }
            
            properties = new Properties();
            properties.load(inputStream);
            
            // Validate required properties
            validateConfiguration();
            
            initialized = true;
            logger.info("SAML configuration initialized successfully");
            logConfigurationSummary();
            
        } catch (IOException e) {
            logger.error("Failed to load SAML configuration from {}", CONFIG_FILE, e);
            throw new RuntimeException("Failed to load SAML configuration", e);
        }
    }
    
    /**
     * Validates that all required SAML configuration properties are present
     * 
     * @throws RuntimeException if required properties are missing
     */
    private static void validateConfiguration() {
        logger.debug("Validating SAML configuration properties");
        
        String[] requiredProperties = {
            "sp.entityId",
            "sp.assertionConsumerService.url",
            "sp.singleLogoutService.url",
            "idp.entityId",
            "idp.singleSignOnService.url",
            "idp.singleLogoutService.url"
        };
        
        for (String property : requiredProperties) {
            String value = properties.getProperty(property);
            if (value == null || value.trim().isEmpty()) {
                logger.error("Required SAML configuration property is missing: {}", property);
                throw new RuntimeException("Missing required SAML configuration: " + property);
            }
            logger.debug("Validated property: {} = {}", property, maskSensitiveValue(value));
        }
    }
    
    /**
     * Logs a summary of the loaded configuration (excluding sensitive data)
     */
    private static void logConfigurationSummary() {
        logger.info("SAML Configuration Summary:");
        logger.info("  SP Entity ID: {}", getProperty("sp.entityId"));
        logger.info("  SP ACS URL: {}", getProperty("sp.assertionConsumerService.url"));
        logger.info("  SP SLO URL: {}", getProperty("sp.singleLogoutService.url"));
        logger.info("  IdP Entity ID: {}", getProperty("idp.entityId"));
        logger.info("  IdP SSO URL: {}", getProperty("idp.singleSignOnService.url"));
        logger.info("  Protocol Binding: {}", getProperty("saml.protocol.binding"));
        logger.info("  NameID Format: {}", getProperty("saml.nameIdFormat"));
        logger.info("  Debug Mode: {}", getProperty("app.debug"));
    }
    
    /**
     * Retrieves a configuration property value
     * 
     * @param key the property key
     * @return the property value, or null if not found
     */
    public static String getProperty(String key) {
        if (!initialized) {
            logger.warn("SAML configuration not initialized, attempting to initialize now");
            initialize();
        }
        
        String value = properties.getProperty(key);
        logger.debug("Retrieved property: {} = {}", key, maskSensitiveValue(value));
        return value;
    }
    
    /**
     * Retrieves a configuration property value with a default fallback
     * 
     * @param key the property key
     * @param defaultValue the default value if property is not found
     * @return the property value or the default value
     */
    public static String getProperty(String key, String defaultValue) {
        String value = getProperty(key);
        return value != null ? value : defaultValue;
    }
    
    /**
     * Retrieves a boolean configuration property
     * 
     * @param key the property key
     * @param defaultValue the default value if property is not found
     * @return the boolean value
     */
    public static boolean getBooleanProperty(String key, boolean defaultValue) {
        String value = getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }
    
    /**
     * Retrieves an integer configuration property
     * 
     * @param key the property key
     * @param defaultValue the default value if property is not found or invalid
     * @return the integer value
     */
    public static int getIntProperty(String key, int defaultValue) {
        String value = getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            logger.warn("Invalid integer value for property {}: {}, using default: {}", key, value, defaultValue);
            return defaultValue;
        }
    }
    
    /**
     * Masks sensitive values in logs (certificates, private keys, etc.)
     * 
     * @param value the value to mask
     * @return masked value for logging
     */
    private static String maskSensitiveValue(String value) {
        if (value == null) {
            return null;
        }
        
        // Mask certificate and private key values
        if (value.contains("-----BEGIN") || value.length() > 100) {
            return "[MASKED]";
        }
        
        return value;
    }
    
    /**
     * Checks if the configuration has been initialized
     * 
     * @return true if initialized, false otherwise
     */
    public static boolean isInitialized() {
        return initialized;
    }
    
    /**
     * Reloads the configuration from the properties file
     * Useful for runtime configuration updates
     */
    public static synchronized void reload() {
        logger.info("Reloading SAML configuration");
        initialized = false;
        initialize();
    }
} 