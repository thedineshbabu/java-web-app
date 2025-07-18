<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java SAML SSO Sample App</title>
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
            font-weight: bold;
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
        
        .features {
            margin-top: 30px;
            text-align: left;
        }
        
        .feature {
            display: flex;
            align-items: center;
            margin: 15px 0;
            color: #555;
        }
        
        .feature-icon {
            color: #667eea;
            margin-right: 10px;
            font-size: 1.2em;
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
        <h1 class="title">Java SAML SSO Sample App</h1>
        <p class="subtitle">
            A demonstration of SAML 2.0 Single Sign-On integration using the OneLogin Java Toolkit.
            This application acts as a Service Provider (SP) and can authenticate users via any SAML-compliant Identity Provider.
        </p>
        
        <a href="login.jsp" class="login-btn">Login with SAML</a>
        
        <div class="features">
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>SAML 2.0 Authentication</span>
            </div>
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>Single Sign-On (SSO)</span>
            </div>
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>Single Logout (SLO)</span>
            </div>
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>Metadata Exchange</span>
            </div>
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>Session Management</span>
            </div>
        </div>
        
        <div class="footer">
            <p>Built with Java, OneLogin SAML Toolkit, and Apache Tomcat</p>
            <p>Version 1.0.0</p>
        </div>
    </div>
</body>
</html> 