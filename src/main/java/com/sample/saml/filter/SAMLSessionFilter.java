package com.sample.saml.filter;

import com.sample.saml.model.SAMLUserInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * SAML Session Filter
 * 
 * This filter manages SAML authentication sessions and provides
 * session validation for protected resources. It checks for valid
 * SAML sessions and redirects unauthenticated users to the login page.
 * 
 * @author SAML SSO Sample App
 * @version 1.0.0
 */
public class SAMLSessionFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(SAMLSessionFilter.class);
    
    // URLs that don't require authentication
    private static final String[] PUBLIC_URLS = {
        "/index.jsp",
        "/login.jsp",
        "/acs.jsp",
        "/metadata.jsp",
        "/sls.jsp",
        "/error.jsp",
        "/css/",
        "/js/",
        "/images/",
        "/favicon.ico"
    };
    
    /**
     * Initializes the filter
     * 
     * @param filterConfig the filter configuration
     */
    @Override
    public void init(FilterConfig filterConfig) {
        logger.info("SAML Session Filter initialized");
    }
    
    /**
     * Filters requests to check for valid SAML sessions
     * 
     * @param request the servlet request
     * @param response the servlet response
     * @param chain the filter chain
     * @throws IOException if an I/O error occurs
     * @throws ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestURI.substring(contextPath.length());
        
        logger.debug("Processing request: {}", relativePath);
        
        // Check if this is a public URL that doesn't require authentication
        if (isPublicUrl(relativePath)) {
            logger.debug("Public URL accessed: {}", relativePath);
            chain.doFilter(request, response);
            return;
        }
        
        // Check for valid SAML session
        HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            SAMLUserInfo userInfo = (SAMLUserInfo) session.getAttribute("saml.userInfo");
            if (userInfo != null) {
                logger.debug("Valid SAML session found for user: {}", userInfo.getNameId());
                
                // Add user info to request attributes for JSP access
                request.setAttribute("samlUser", userInfo);
                
                chain.doFilter(request, response);
                return;
            } else {
                logger.debug("Session exists but no SAML user info found");
            }
        } else {
            logger.debug("No session found");
        }
        
        // No valid session, redirect to login
        logger.info("Unauthenticated access attempt to: {}", relativePath);
        String loginUrl = contextPath + "/login.jsp";
        httpResponse.sendRedirect(loginUrl);
    }
    
    /**
     * Checks if the given URL is a public URL that doesn't require authentication
     * 
     * @param url the URL to check
     * @return true if the URL is public, false otherwise
     */
    private boolean isPublicUrl(String url) {
        for (String publicUrl : PUBLIC_URLS) {
            if (url.equals(publicUrl) || url.startsWith(publicUrl)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Destroys the filter
     */
    @Override
    public void destroy() {
        logger.info("SAML Session Filter destroyed");
    }
} 