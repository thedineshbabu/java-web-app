<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Import required classes
    import com.sample.saml.service.SAMLService;
    import com.sample.saml.util.SAMLConfig;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    
    Logger logger = LoggerFactory.getLogger("login.jsp");
    
    // Check if this is a login initiation request
    String action = request.getParameter("action");
    
    if ("login".equals(action)) {
        try {
            logger.info("Initiating SAML login from login.jsp");
            
            // Initialize SAML service
            SAMLService samlService = new SAMLService();
            
            // Get relay state if provided
            String relayState = request.getParameter("relayState");
            
            // Initiate SAML login
            samlService.login(request, response, relayState);
            
            // Note: The login method will redirect to IdP, so this code won't execute
            return;
            
        } catch (Exception e) {
            logger.error("Failed to initiate SAML login", e);
            request.setAttribute("error", "Failed to initiate SAML login: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Java SAML SSO Sample App</title>
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
        
        .login-form {
            margin: 30px 0;
        }
        
        .login-btn {
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
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .back-btn {
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
        
        .back-btn:hover {
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
        
        .loading {
            display: none;
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
        <h1 class="title">SAML Login</h1>
        <p class="subtitle">
            Click the button below to authenticate using your Identity Provider (IdP).
            You will be redirected to your IdP for authentication.
        </p>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>
        
        <!-- Info Message -->
        <div class="info">
            <strong>Note:</strong> This application is configured to use SAML 2.0 for authentication.
            Make sure your IdP is properly configured with the SP metadata.
        </div>
        
        <!-- Login Form -->
        <div class="login-form">
            <form action="login.jsp" method="get" onsubmit="showLoading()">
                <input type="hidden" name="action" value="login">
                <input type="hidden" name="relayState" value="${param.relayState}">
                <button type="submit" class="login-btn" id="loginBtn">
                    Login with SAML
                </button>
            </form>
        </div>
        
        <!-- Loading Spinner -->
        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>Redirecting to Identity Provider...</p>
        </div>
        
        <!-- Back Button -->
        <a href="index.jsp" class="back-btn">Back to Home</a>
        
        <div class="footer">
            <p>You will be redirected to your configured Identity Provider</p>
        </div>
    </div>
    
    <script>
        function showLoading() {
            document.getElementById('loginBtn').style.display = 'none';
            document.getElementById('loading').style.display = 'block';
        }
        
        // Auto-submit form if action=login is in URL
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('action') === 'login') {
                document.querySelector('form').submit();
            }
        };
    </script>
</body>
</html> 