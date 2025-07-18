<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Import required classes
    import com.sample.saml.service.SAMLService;
    import com.sample.saml.model.SAMLUserInfo;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    
    Logger logger = LoggerFactory.getLogger("acs.jsp");
    
    // Check if this is a SAML response
    String samlResponse = request.getParameter("SAMLResponse");
    
    if (samlResponse != null) {
        try {
            logger.info("Processing SAML response in ACS");
            
            // Initialize SAML service
            SAMLService samlService = new SAMLService();
            
            // Process the SAML response
            SAMLUserInfo userInfo = samlService.processResponse(request);
            
            // Store user information in session
            HttpSession session = request.getSession();
            session.setAttribute("saml.userInfo", userInfo);
            session.setAttribute("saml.sessionIndex", userInfo.getSessionIndex());
            
            // Store relay state if present
            String relayState = request.getParameter("RelayState");
            if (relayState != null && !relayState.trim().isEmpty()) {
                session.setAttribute("saml.relayState", relayState);
            }
            
            logger.info("SAML authentication successful for user: {}", userInfo.getNameId());
            
            // Redirect to success page
            String successUrl = request.getContextPath() + "/welcome.jsp";
            if (relayState != null && !relayState.trim().isEmpty()) {
                successUrl = relayState;
            }
            
            response.sendRedirect(successUrl);
            return;
            
        } catch (Exception e) {
            logger.error("Failed to process SAML response", e);
            request.setAttribute("error", "SAML authentication failed: " + e.getMessage());
        }
    } else {
        logger.warn("ACS accessed without SAMLResponse parameter");
        request.setAttribute("error", "No SAML response received");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAML Authentication - Java SAML SSO Sample App</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .logo {
            font-size: 2.5em;
            color: #667eea;
            margin-bottom: 20px;
        }
        
        .title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #c33;
        }
        
        .success {
            background: #efe;
            color: #363;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #363;
        }
        
        .info {
            background: #e8f4fd;
            color: #0066cc;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #0066cc;
        }
        
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #f8f9fa;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
        }
        
        .loading {
            margin: 20px 0;
        }
        
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .footer {
            margin-top: 30px;
            color: #999;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🔐</div>
        <h1 class="title">SAML Authentication</h1>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Authentication Error:</strong><br>
                ${error}
            </div>
            
            <div class="info">
                <strong>Troubleshooting:</strong><br>
                • Verify your IdP configuration<br>
                • Check that SP metadata is correctly configured in your IdP<br>
                • Ensure certificates are valid and properly configured<br>
                • Check application logs for detailed error information
            </div>
            
            <a href="index.jsp" class="btn">Back to Home</a>
            <a href="login.jsp" class="btn btn-secondary">Try Again</a>
        </c:if>
        
        <!-- Success Message (should not be shown due to redirect) -->
        <c:if test="${empty error}">
            <div class="success">
                <strong>Authentication Successful!</strong><br>
                Processing your login...
            </div>
            
            <div class="loading">
                <div class="spinner"></div>
                <p>Redirecting to application...</p>
            </div>
        </c:if>
        
        <div class="footer">
            <p>Assertion Consumer Service (ACS) - SAML SSO Sample App</p>
        </div>
    </div>
</body>
</html> 