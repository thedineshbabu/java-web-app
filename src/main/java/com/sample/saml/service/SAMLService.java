package com.sample.saml.service;

import com.onelogin.saml2.Auth;
import com.onelogin.saml2.exception.SettingsException;
import com.onelogin.saml2.exception.XMLEntityException;
import com.onelogin.saml2.settings.Saml2Settings;
import com.onelogin.saml2.settings.SettingsBuilder;
import com.sample.saml.model.SAMLUserInfo;
import com.sample.saml.util.SAMLConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SAML Service Provider Implementation
 * 
 * This class provides the core SAML functionality for the application,
 * including authentication, logout, and metadata operations. It uses
 * the OneLogin Java SAML toolkit to handle SAML protocol operations.
 * 
 * @author SAML SSO Sample App
 * @version 1.0.0
 */
public class SAMLService {
    
    private static final Logger logger = LoggerFactory.getLogger(SAMLService.class);
    
    private Auth auth;
    private Saml2Settings settings;
    
    /**
     * Constructor that initializes the SAML service with configuration
     * 
     * @throws RuntimeException if SAML configuration is invalid
     */
    public SAMLService() {
        logger.info("Initializing SAML service");
        initializeSAML();
    }
    
    /**
     * Initializes the SAML toolkit with configuration from properties
     * 
     * @throws RuntimeException if initialization fails
     */
    private void initializeSAML() {
        try {
            logger.debug("Loading SAML settings from configuration");
            
            // Create settings builder and configure SAML settings
            SettingsBuilder builder = new SettingsBuilder();
            
            // Build SAML settings from configuration
            settings = builder.fromValues(getSAMLConfiguration()).build();
            
            // Create Auth instance with settings
            auth = new Auth(settings, null, null);
            
            logger.info("SAML service initialized successfully");
            logger.debug("SAML settings loaded - SP Entity ID: {}", settings.getSpEntityId());
            
        } catch (SettingsException e) {
            logger.error("Failed to initialize SAML settings", e);
            throw new RuntimeException("SAML initialization failed", e);
        }
    }
    
    /**
     * Creates SAML configuration map from properties
     * 
     * @return Map containing SAML configuration
     */
    private Map<String, Object> getSAMLConfiguration() {
        logger.debug("Building SAML configuration from properties");
        
        Map<String, Object> config = new HashMap<>();
        
        // Service Provider (SP) Configuration
        Map<String, Object> sp = new HashMap<>();
        sp.put("entityId", SAMLConfig.getProperty("sp.entityId"));
        sp.put("assertionConsumerService", new HashMap<String, Object>() {{
            put("url", SAMLConfig.getProperty("sp.assertionConsumerService.url"));
            put("binding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST");
        }});
        sp.put("singleLogoutService", new HashMap<String, Object>() {{
            put("url", SAMLConfig.getProperty("sp.singleLogoutService.url"));
            put("binding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect");
        }});
        
        // Add SP certificate and private key if configured
        String spCert = SAMLConfig.getProperty("sp.x509cert");
        String spKey = SAMLConfig.getProperty("sp.privateKey");
        if (spCert != null && !spCert.trim().isEmpty()) {
            sp.put("x509cert", spCert);
        }
        if (spKey != null && !spKey.trim().isEmpty()) {
            sp.put("privateKey", spKey);
        }
        
        config.put("sp", sp);
        
        // Identity Provider (IdP) Configuration
        Map<String, Object> idp = new HashMap<>();
        idp.put("entityId", SAMLConfig.getProperty("idp.entityId"));
        idp.put("singleSignOnService", new HashMap<String, Object>() {{
            put("url", SAMLConfig.getProperty("idp.singleSignOnService.url"));
            put("binding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect");
        }});
        idp.put("singleLogoutService", new HashMap<String, Object>() {{
            put("url", SAMLConfig.getProperty("idp.singleLogoutService.url"));
            put("binding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect");
        }});
        
        // Add IdP certificate if configured
        String idpCert = SAMLConfig.getProperty("idp.x509cert");
        if (idpCert != null && !idpCert.trim().isEmpty()) {
            idp.put("x509cert", idpCert);
        }
        
        config.put("idp", idp);
        
        // Security Settings
        Map<String, Object> security = new HashMap<>();
        security.put("wantAssertionsSigned", SAMLConfig.getBooleanProperty("saml.security.wantAssertionsSigned", true));
        security.put("authnRequestsSigned", SAMLConfig.getBooleanProperty("saml.security.authnRequestsSigned", true));
        security.put("logoutRequestSigned", SAMLConfig.getBooleanProperty("saml.security.logoutRequestSigned", true));
        security.put("logoutResponseSigned", SAMLConfig.getBooleanProperty("saml.security.logoutResponseSigned", true));
        security.put("wantNameIdEncrypted", SAMLConfig.getBooleanProperty("saml.security.wantNameIdEncrypted", false));
        security.put("wantAssertionsEncrypted", SAMLConfig.getBooleanProperty("saml.security.wantAssertionsEncrypted", false));
        security.put("wantNameIdInLogoutRequest", SAMLConfig.getBooleanProperty("saml.security.wantNameIdInLogoutRequest", true));
        
        config.put("security", security);
        
        // Contact Information (optional)
        Map<String, Object> contact = new HashMap<>();
        contact.put("technical", new HashMap<String, Object>() {{
            put("givenName", "SAML SSO Sample App");
            put("emailAddress", "admin@example.com");
        }});
        config.put("contactPerson", contact);
        
        // Organization Information (optional)
        Map<String, Object> organization = new HashMap<>();
        organization.put("en-US", new HashMap<String, Object>() {{
            put("name", "SAML SSO Sample Organization");
            put("displayname", "SAML SSO Sample");
            put("url", "https://example.com");
        }});
        config.put("organization", organization);
        
        logger.debug("SAML configuration built successfully");
        return config;
    }
    
    /**
     * Initiates SAML authentication by redirecting to the IdP
     * 
     * @param request HTTP request
     * @param response HTTP response
     * @param relayState optional relay state to preserve across authentication
     * @throws IOException if redirect fails
     */
    public void login(HttpServletRequest request, HttpServletResponse response, String relayState) throws IOException {
        logger.info("Initiating SAML login");
        
        try {
            // Store relay state in session if provided
            if (relayState != null && !relayState.trim().isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("saml.relayState", relayState);
                logger.debug("Stored relay state: {}", relayState);
            }
            
            // Initiate SAML authentication
            auth.login(relayState);
            logger.info("SAML login initiated successfully");
            
        } catch (Exception e) {
            logger.error("Failed to initiate SAML login", e);
            throw new RuntimeException("SAML login initiation failed", e);
        }
    }
    
    /**
     * Processes SAML response from IdP and validates authentication
     * 
     * @param request HTTP request containing SAML response
     * @return SAMLUserInfo containing user information if authentication successful
     * @throws RuntimeException if authentication fails
     */
    public SAMLUserInfo processResponse(HttpServletRequest request) {
        logger.info("Processing SAML response from IdP");
        
        try {
            // Get SAML response from request parameters
            String samlResponse = request.getParameter("SAMLResponse");
            if (samlResponse == null) {
                throw new RuntimeException("SAMLResponse parameter not found in request");
            }
            
            // Process the SAML response
            auth.processResponse(samlResponse);
            
            // Check for errors
            if (auth.getErrors().size() > 0) {
                String errorMsg = "SAML authentication errors: " + auth.getErrors();
                logger.error(errorMsg);
                throw new RuntimeException(errorMsg);
            }
            
            // Get user information from SAML assertion
            String nameId = auth.getNameId();
            Map<String, List<String>> attributes = auth.getAttributes();
            
            logger.info("SAML authentication successful for user: {}", nameId);
            logger.debug("SAML attributes received: {}", attributes);
            
            // Create user info object
            SAMLUserInfo userInfo = new SAMLUserInfo();
            userInfo.setNameId(nameId);
            userInfo.setAttributes(attributes);
            userInfo.setSessionIndex(auth.getSessionIndex());
            
            return userInfo;
            
        } catch (Exception e) {
            logger.error("Failed to process SAML response", e);
            throw new RuntimeException("SAML response processing failed", e);
        }
    }
    
    /**
     * Initiates SAML logout by redirecting to IdP
     * 
     * @param request HTTP request
     * @param response HTTP response
     * @param relayState optional relay state
     * @throws IOException if redirect fails
     */
    public void logout(HttpServletRequest request, HttpServletResponse response, String relayState) throws IOException {
        logger.info("Initiating SAML logout");
        
        try {
            // Get session index from session if available
            HttpSession session = request.getSession(false);
            String sessionIndex = null;
            if (session != null) {
                sessionIndex = (String) session.getAttribute("saml.sessionIndex");
            }
            
            // Initiate SAML logout - using null for LogoutRequestParams
            auth.logout(relayState, null);
            logger.info("SAML logout initiated successfully");
            
        } catch (Exception e) {
            logger.error("Failed to initiate SAML logout", e);
            throw new RuntimeException("SAML logout initiation failed", e);
        }
    }
    
    /**
     * Processes SAML logout response from IdP
     * 
     * @param request HTTP request containing logout response
     * @return true if logout was successful
     * @throws RuntimeException if logout processing fails
     */
    public boolean processLogoutResponse(HttpServletRequest request) {
        logger.info("Processing SAML logout response from IdP");
        
        try {
            // Get SAML response from request parameters
            String samlResponse = request.getParameter("SAMLResponse");
            if (samlResponse == null) {
                throw new RuntimeException("SAMLResponse parameter not found in request");
            }
            
            // Process the logout response - using null for LogoutResponseParams
            auth.processSLO();
            
            // Check for errors
            if (auth.getErrors().size() > 0) {
                String errorMsg = "SAML logout errors: " + auth.getErrors();
                logger.error(errorMsg);
                throw new RuntimeException(errorMsg);
            }
            
            logger.info("SAML logout processed successfully");
            return true;
            
        } catch (Exception e) {
            logger.error("Failed to process SAML logout response", e);
            throw new RuntimeException("SAML logout response processing failed", e);
        }
    }
    
    /**
     * Generates SP metadata XML
     * 
     * @return SP metadata as XML string
     * @throws RuntimeException if metadata generation fails
     */
    public String getMetadata() {
        logger.info("Generating SP metadata");
        
        try {
            String metadata = auth.getSettings().getSPMetadata();
            logger.info("SP metadata generated successfully");
            return metadata;
            
        } catch (Exception e) {
            logger.error("Failed to generate SP metadata", e);
            throw new RuntimeException("SP metadata generation failed", e);
        }
    }
    
    /**
     * Gets the SAML settings object
     * 
     * @return Saml2Settings object
     */
    public Saml2Settings getSettings() {
        return settings;
    }
    
    /**
     * Gets the Auth object for advanced operations
     * 
     * @return Auth object
     */
    public Auth getAuth() {
        return auth;
    }
} 