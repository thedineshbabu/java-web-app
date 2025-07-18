<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Get error information
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
    String exceptionType = (String) request.getAttribute("javax.servlet.error.exception_type");
    Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
    
    // Set default values if not provided
    if (statusCode == null) {
        statusCode = 500;
    }
    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        switch (statusCode) {
            case 404:
                errorMessage = "The requested page was not found.";
                break;
            case 403:
                errorMessage = "Access to this resource is forbidden.";
                break;
            case 500:
                errorMessage = "An internal server error occurred.";
                break;
            default:
                errorMessage = "An unexpected error occurred.";
                break;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error ${statusCode} - Java SAML SSO Sample App</title>
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
            max-width: 600px;
            width: 90%;
        }
        
        .error-code {
            font-size: 6em;
            color: #dc3545;
            margin-bottom: 20px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .error-title {
            font-size: 2em;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .error-message {
            color: #666;
            font-size: 1.2em;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
            text-align: left;
        }
        
        .error-details h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        
        .detail-row {
            margin: 10px 0;
            display: flex;
            align-items: flex-start;
        }
        
        .detail-label {
            font-weight: 600;
            color: #667eea;
            width: 120px;
            min-width: 120px;
            margin-right: 15px;
        }
        
        .detail-value {
            color: #666;
            flex: 1;
            word-break: break-all;
        }
        
        .actions {
            margin: 30px 0;
            display: flex;
            gap: 15px;
            justify-content: center;
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
        
        .help-section {
            background: #e8f4fd;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
            border-left: 4px solid #0066cc;
        }
        
        .help-title {
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 15px;
        }
        
        .help-content {
            color: #333;
            line-height: 1.6;
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
        <div class="error-code">${statusCode}</div>
        <h1 class="error-title">
            <% switch (statusCode) {
                case 404: %>Page Not Found<% break;
                case 403: %>Access Forbidden<% break;
                case 500: %>Internal Server Error<% break;
                default: %>Error Occurred<% break;
            } %>
        </h1>
        <p class="error-message">${errorMessage}</p>
        
        <div class="error-details">
            <h3>Error Details</h3>
            <div class="detail-row">
                <div class="detail-label">Status Code:</div>
                <div class="detail-value">${statusCode}</div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Request URI:</div>
                <div class="detail-value">${requestUri != null ? requestUri : 'Not available'}</div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Exception Type:</div>
                <div class="detail-value">${exceptionType != null ? exceptionType : 'Not available'}</div>
            </div>
            <% if (exception != null) { %>
            <div class="detail-row">
                <div class="detail-label">Exception:</div>
                <div class="detail-value">${exception.message}</div>
            </div>
            <% } %>
        </div>
        
        <div class="help-section">
            <div class="help-title">What can you do?</div>
            <div class="help-content">
                <% switch (statusCode) {
                    case 404: %>
                        • Check if the URL is correct<br>
                        • Navigate back to the home page<br>
                        • Contact support if you believe this is an error
                    <% break;
                    case 403: %>
                        • Make sure you are logged in<br>
                        • Check if you have the required permissions<br>
                        • Try logging in again
                    <% break;
                    case 500: %>
                        • Try refreshing the page<br>
                        • Check if the service is running properly<br>
                        • Contact support if the problem persists
                    <% break;
                    default: %>
                        • Try refreshing the page<br>
                        • Navigate back to the home page<br>
                        • Contact support if the problem persists
                    <% break;
                } %>
            </div>
        </div>
        
        <div class="actions">
            <a href="index.jsp" class="btn">Go to Home Page</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
            <a href="javascript:location.reload()" class="btn btn-secondary">Refresh Page</a>
        </div>
        
        <div class="footer">
            <p>Java SAML SSO Sample Application - Error Page</p>
            <p>If you continue to experience issues, please contact your system administrator.</p>
        </div>
    </div>
</body>
</html> 