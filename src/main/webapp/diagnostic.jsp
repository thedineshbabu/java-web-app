<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sample.saml.util.SAMLConfig" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Get application context information
    boolean samlConfigInitialized = application.getAttribute("saml.config.initialized") != null;
    String configStatus = samlConfigInitialized ? "Initialized" : "Not Initialized";
    
    // Try to load SAML configuration
    String configError = null;
    try {
        if (!samlConfigInitialized) {
            SAMLConfig.initialize();
        }
    } catch (Exception e) {
        configError = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAML Diagnostic - Java SAML SSO Sample App</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #667eea;
        }
        
        .status-section {
            margin: 20px 0;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            background: #f8f9fa;
        }
        
        .status-ok {
            border-left-color: #28a745;
            background: #d4edda;
        }
        
        .status-error {
            border-left-color: #dc3545;
            background: #f8d7da;
        }
        
        .status-warning {
            border-left-color: #ffc107;
            background: #fff3cd;
        }
        
        .config-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        .config-table th,
        .config-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .config-table th {
            background: #667eea;
            color: white;
        }
        
        .config-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .btn {
            background: #667eea;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
        }
        
        .btn:hover {
            background: #5a6fd8;
        }
        
        .error-details {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            padding: 15px;
            margin: 10px 0;
            color: #721c24;
        }
        
        .success-details {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            padding: 15px;
            margin: 10px 0;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔍 SAML Diagnostic Tool</h1>
            <p>Java SAML SSO Sample Application - Configuration Diagnostics</p>
        </div>
        
        <!-- Application Status -->
        <div class="status-section <%= samlConfigInitialized ? "status-ok" : "status-error" %>">
            <h2>Application Status</h2>
            <p><strong>SAML Configuration:</strong> <%= configStatus %></p>
            <% if (configError != null) { %>
                <div class="error-details">
                    <strong>Configuration Error:</strong> <%= configError %>
                </div>
            <% } else if (samlConfigInitialized) { %>
                <div class="success-details">
                    <strong>✓ Configuration loaded successfully</strong>
                </div>
            <% } %>
        </div>
        
        <!-- Configuration Details -->
        <% if (samlConfigInitialized && configError == null) { %>
            <div class="status-section status-ok">
                <h2>SAML Configuration Details</h2>
                <table class="config-table">
                    <thead>
                        <tr>
                            <th>Configuration Item</th>
                            <th>Value</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>SP Entity ID</td>
                            <td><%= SAMLConfig.getProperty("sp.entityId") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>SP ACS URL</td>
                            <td><%= SAMLConfig.getProperty("sp.assertionConsumerService.url") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>SP SLO URL</td>
                            <td><%= SAMLConfig.getProperty("sp.singleLogoutService.url") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>IdP Entity ID</td>
                            <td><%= SAMLConfig.getProperty("idp.entityId") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>IdP SSO URL</td>
                            <td><%= SAMLConfig.getProperty("idp.singleSignOnService.url") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>IdP SLO URL</td>
                            <td><%= SAMLConfig.getProperty("idp.singleLogoutService.url") %></td>
                            <td>✓</td>
                        </tr>
                        <tr>
                            <td>IdP Certificate</td>
                            <td><%= SAMLConfig.getProperty("idp.x509cert") != null && !SAMLConfig.getProperty("idp.x509cert").trim().isEmpty() ? "Configured" : "Missing" %></td>
                            <td><%= SAMLConfig.getProperty("idp.x509cert") != null && !SAMLConfig.getProperty("idp.x509cert").trim().isEmpty() ? "✓" : "⚠" %></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        <% } %>
        
        <!-- System Information -->
        <div class="status-section">
            <h2>System Information</h2>
            <table class="config-table">
                <tr>
                    <td>Java Version</td>
                    <td><%= System.getProperty("java.version") %></td>
                </tr>
                <tr>
                    <td>Application Server</td>
                    <td><%= application.getServerInfo() %></td>
                </tr>
                <tr>
                    <td>Servlet Version</td>
                    <td><%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></td>
                </tr>
                <tr>
                    <td>Context Path</td>
                    <td><%= request.getContextPath() %></td>
                </tr>
                <tr>
                    <td>Server Name</td>
                    <td><%= request.getServerName() %>:<%= request.getServerPort() %></td>
                </tr>
            </table>
        </div>
        
        <!-- Actions -->
        <div class="status-section">
            <h2>Actions</h2>
            <a href="index.jsp" class="btn">Go to Home Page</a>
            <a href="login.jsp" class="btn">Test SAML Login</a>
            <a href="metadata.jsp" class="btn">View SP Metadata</a>
            <a href="javascript:location.reload()" class="btn">Refresh Diagnostics</a>
        </div>
        
        <!-- Troubleshooting Tips -->
        <div class="status-section status-warning">
            <h2>Troubleshooting Tips</h2>
            <ul>
                <li><strong>Configuration Issues:</strong> Check that saml.properties is properly configured</li>
                <li><strong>Certificate Issues:</strong> Ensure IdP certificate is valid and properly formatted</li>
                <li><strong>URL Issues:</strong> Verify all URLs are accessible and correctly formatted</li>
                <li><strong>Network Issues:</strong> Check connectivity to the IdP server</li>
                <li><strong>Logs:</strong> Check application logs for detailed error information</li>
            </ul>
        </div>
    </div>
</body>
</html> 