<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Import required classes
    import com.sample.saml.service.SAMLService;
    import com.sample.saml.model.SAMLUserInfo;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    
    Logger logger = LoggerFactory.getLogger("logout.jsp");
    
    // Check if this is a logout request
    String action = request.getParameter("action");
    
    if ("logout".equals(action)) {
        try {
            logger.info("Initiating SAML logout from logout.jsp");
            
            // Get user info from session before clearing it
            SAMLUserInfo userInfo = (SAMLUserInfo) session.getAttribute("saml.userInfo");
            String userName = userInfo != null ? userInfo.getNameId() : "Unknown";
            
            // Initialize SAML service
            SAMLService samlService = new SAMLService();
            
            // Get relay state if provided
            String relayState = request.getParameter("relayState");
            
            // Clear session
            session.invalidate();
            
            // Initiate SAML logout
            samlService.logout(request, response, relayState);
            
            logger.info("SAML logout initiated for user: {}", userName);
            
            // Note: The logout method will redirect to IdP, so this code won't execute
            return;
            
        } catch (Exception e) {
            logger.error("Failed to initiate SAML logout", e);
            request.setAttribute("error", "Failed to initiate SAML logout: " + e.getMessage());
        }
    }
    
    // Check if this is a logout response from IdP
    String samlResponse = request.getParameter("SAMLResponse");
    if (samlResponse != null) {
        try {
            logger.info("Processing SAML logout response");
            
            SAMLService samlService = new SAMLService();
            boolean success = samlService.processLogoutResponse(request);
            
            if (success) {
                logger.info("SAML logout completed successfully");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            } else {
                request.setAttribute("error", "SAML logout response processing failed");
            }
            
        } catch (Exception e) {
            logger.error("Failed to process SAML logout response", e);
            request.setAttribute("error", "SAML logout response processing failed: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - Java SAML SSO Sample App</title>
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
        
        .logout-form {
            margin: 30px 0;
        }
        
        .logout-btn {
            background: #dc3545;
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
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(220, 53, 69, 0.3);
        }
        
        .cancel-btn {
            background: #f8f9fa;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
        }
        
        .cancel-btn:hover {
            background: #667eea;
            color: white;
        }
        
        .error {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #c33;
        }
        
        .info {
            background: #e8f4fd;
            color: #0066cc;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #0066cc;
        }
        
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #ffc107;
        }
        
        .loading {
            display: none;
            margin: 20px 0;
        }
        
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #dc3545;
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
        <h1 class="title">Logout</h1>
        <p class="subtitle">
            Are you sure you want to log out? This will terminate your session and log you out from all connected applications.
        </p>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Logout Error:</strong><br>
                ${error}
            </div>
        </c:if>
        
        <!-- Warning Message -->
        <div class="warning">
            <strong>Important:</strong> This will log you out from both this application and your Identity Provider (IdP).
        </div>
        
        <!-- Info Message -->
        <div class="info">
            <strong>Note:</strong> After logout, you will be redirected to your IdP's logout page, 
            and then back to the home page of this application.
        </div>
        
        <!-- Logout Form -->
        <div class="logout-form">
            <form action="logout.jsp" method="get" onsubmit="showLoading()">
                <input type="hidden" name="action" value="logout">
                <input type="hidden" name="relayState" value="${param.relayState}">
                <button type="submit" class="logout-btn" id="logoutBtn">
                    Logout from All Applications
                </button>
            </form>
        </div>
        
        <!-- Loading Spinner -->
        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Logging out...</p>
        </div>
        
        <!-- Cancel Button -->
        <a href="javascript:history.back()" class="cancel-btn">Cancel</a>
        
        <div class="footer">
            <p>You will be logged out from all connected SAML applications</p>
        </div>
    </div>
    
    <script>
        function showLoading() {
            document.getElementById('logoutBtn').style.display = 'none';
            document.getElementById('loading').style.display = 'block';
        }
        
        // Auto-submit form if action=logout is in URL
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('action') === 'logout') {
                document.querySelector('form').submit();
            }
        };
    </script>
</body>
</html> 