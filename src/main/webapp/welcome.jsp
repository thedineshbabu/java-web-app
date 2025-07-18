<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Import required classes
    import com.sample.saml.model.SAMLUserInfo;
    import java.util.List;
    import java.util.Map;
    
    // Get user info from session
    SAMLUserInfo userInfo = (SAMLUserInfo) session.getAttribute("saml.userInfo");
    
    if (userInfo == null) {
        // Redirect to login if no user info
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Java SAML SSO Sample App</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .header {
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px 0;
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5em;
            color: #667eea;
            font-weight: bold;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background: #667eea;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .logout-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
            transition: background 0.2s;
        }
        
        .logout-btn:hover {
            background: #c82333;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            margin-bottom: 30px;
        }
        
        .welcome-title {
            font-size: 2.5em;
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .welcome-subtitle {
            color: #666;
            font-size: 1.2em;
            margin-bottom: 30px;
        }
        
        .user-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
        }
        
        .detail-row {
            display: flex;
            margin: 15px 0;
            align-items: center;
        }
        
        .detail-label {
            font-weight: 600;
            color: #333;
            width: 150px;
            min-width: 150px;
        }
        
        .detail-value {
            color: #666;
            flex: 1;
        }
        
        .attributes-section {
            margin-top: 30px;
        }
        
        .attributes-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .attribute-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
        }
        
        .attribute-name {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .attribute-values {
            color: #666;
        }
        
        .session-info {
            background: #e8f4fd;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
            border-left: 4px solid #0066cc;
        }
        
        .session-title {
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 15px;
        }
        
        .actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
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
        
        .footer {
            text-align: center;
            color: #999;
            margin-top: 40px;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">🔐 SAML SSO Sample App</div>
            <div class="user-info">
                <div class="user-avatar">
                    <%= userInfo.getNameId().substring(0, 1).toUpperCase() %>
                </div>
                <span><%= userInfo.getNameId() %></span>
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-card">
            <h1 class="welcome-title">Welcome!</h1>
            <p class="welcome-subtitle">You have successfully authenticated using SAML 2.0 Single Sign-On.</p>
            
            <div class="user-details">
                <h3>User Information</h3>
                <div class="detail-row">
                    <div class="detail-label">Name ID:</div>
                    <div class="detail-value"><%= userInfo.getNameId() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Session Index:</div>
                    <div class="detail-value"><%= userInfo.getSessionIndex() != null ? userInfo.getSessionIndex() : "Not provided" %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Attributes Count:</div>
                    <div class="detail-value"><%= userInfo.getAttributes() != null ? userInfo.getAttributes().size() : 0 %> attributes received</div>
                </div>
            </div>
            
            <% if (userInfo.getAttributes() != null && !userInfo.getAttributes().isEmpty()) { %>
            <div class="attributes-section">
                <h3 class="attributes-title">SAML Attributes</h3>
                <% for (Map.Entry<String, List<String>> entry : userInfo.getAttributes().entrySet()) { %>
                <div class="attribute-item">
                    <div class="attribute-name"><%= entry.getKey() %></div>
                    <div class="attribute-values">
                        <% for (String value : entry.getValue()) { %>
                            <div><%= value %></div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
            
            <div class="session-info">
                <div class="session-title">Session Information</div>
                <div class="detail-row">
                    <div class="detail-label">Session ID:</div>
                    <div class="detail-value"><%= session.getId() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Creation Time:</div>
                    <div class="detail-value"><%= new java.util.Date(session.getCreationTime()) %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Last Access:</div>
                    <div class="detail-value"><%= new java.util.Date(session.getLastAccessedTime()) %></div>
                </div>
            </div>
            
            <div class="actions">
                <a href="index.jsp" class="btn">Back to Home</a>
                <a href="metadata.jsp" class="btn btn-secondary">View SP Metadata</a>
                <a href="logout.jsp" class="btn btn-secondary">Logout</a>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p>Java SAML SSO Sample Application - Successfully authenticated via SAML 2.0</p>
        <p>Session established at: <%= new java.util.Date() %></p>
    </div>
</body>
</html> 