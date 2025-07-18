<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Import required classes
    import com.sample.saml.service.SAMLService;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    
    Logger logger = LoggerFactory.getLogger("sls.jsp");
    
    // Check for SAML logout request or response
    String samlRequest = request.getParameter("SAMLRequest");
    String samlResponse = request.getParameter("SAMLResponse");
    
    if (samlRequest != null) {
        // Process logout request from IdP
        try {
            logger.info("Processing SAML logout request from IdP");
            
            SAMLService samlService = new SAMLService();
            
            // Process the logout request
            // Note: The OneLogin toolkit handles this automatically
            // We just need to invalidate the session
            
            // Get session and invalidate it
            HttpSession session = request.getSession(false);
            if (session != null) {
                logger.info("Invalidating session for logout request");
                session.invalidate();
            }
            
            // Redirect back to IdP with logout response
            String relayState = request.getParameter("RelayState");
            String logoutResponseUrl = samlService.getSettings().getIdpSingleLogoutServiceUrl();
            
            logger.info("Redirecting logout response to IdP: {}", logoutResponseUrl);
            response.sendRedirect(logoutResponseUrl);
            return;
            
        } catch (Exception e) {
            logger.error("Failed to process SAML logout request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Logout request processing failed");
            return;
        }
    } else if (samlResponse != null) {
        // Process logout response from IdP
        try {
            logger.info("Processing SAML logout response from IdP");
            
            SAMLService samlService = new SAMLService();
            boolean success = samlService.processLogoutResponse(request);
            
            if (success) {
                logger.info("SAML logout completed successfully");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            } else {
                logger.error("SAML logout response processing failed");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Logout response processing failed");
                return;
            }
            
        } catch (Exception e) {
            logger.error("Failed to process SAML logout response", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Logout response processing failed");
            return;
        }
    } else {
        // No SAML parameters - show error
        logger.warn("SLS accessed without SAML parameters");
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid SLS request - no SAML parameters");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Single Logout Service - Java SAML SSO Sample App</title>
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
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 1em;
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
        <h1 class="title">Single Logout Service</h1>
        <p class="subtitle">
            This page handles Single Logout (SLO) requests from your Identity Provider.
            If you see this page, it means the logout process is being handled automatically.
        </p>
        
        <div class="info">
            <strong>Processing logout...</strong><br>
            Please wait while we complete the logout process.
        </div>
        
        <a href="index.jsp" class="btn">Go to Home Page</a>
        
        <div class="footer">
            <p>Single Logout Service (SLS) - SAML SSO Sample App</p>
        </div>
    </div>
</body>
</html> 