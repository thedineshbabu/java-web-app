<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Import required classes
    import com.sample.saml.service.SAMLService;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    
    Logger logger = LoggerFactory.getLogger("metadata.jsp");
    
    // Check if user wants to view metadata as HTML or download as XML
    String format = request.getParameter("format");
    
    if ("xml".equals(format)) {
        // Serve metadata as XML for download
        try {
            logger.info("Serving SP metadata as XML");
            
            SAMLService samlService = new SAMLService();
            String metadata = samlService.getMetadata();
            
            response.setContentType("application/xml");
            response.setHeader("Content-Disposition", "attachment; filename=\"sp-metadata.xml\"");
            response.setCharacterEncoding("UTF-8");
            
            out.print(metadata);
            return;
            
        } catch (Exception e) {
            logger.error("Failed to generate SP metadata", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate metadata");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SP Metadata - Java SAML SSO Sample App</title>
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
        
        .back-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
            transition: background 0.2s;
        }
        
        .back-btn:hover {
            background: #5a6fd8;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .metadata-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            margin-bottom: 30px;
        }
        
        .title {
            font-size: 2.5em;
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .subtitle {
            color: #666;
            font-size: 1.2em;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #e8f4fd;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
            border-left: 4px solid #0066cc;
        }
        
        .info-title {
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        
        .info-content {
            color: #333;
            line-height: 1.6;
        }
        
        .actions {
            margin: 30px 0;
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
        
        .metadata-preview {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
            max-height: 400px;
            overflow-y: auto;
        }
        
        .metadata-preview pre {
            margin: 0;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            color: #333;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .endpoints {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
        }
        
        .endpoint-item {
            margin: 15px 0;
            padding: 15px;
            background: white;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .endpoint-name {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .endpoint-url {
            color: #666;
            font-family: 'Courier New', monospace;
            word-break: break-all;
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
            <a href="javascript:history.back()" class="back-btn">← Back</a>
        </div>
    </div>
    
    <div class="container">
        <div class="metadata-card">
            <h1 class="title">Service Provider Metadata</h1>
            <p class="subtitle">This page provides the SAML metadata for configuring this application as a Service Provider in your Identity Provider.</p>
            
            <div class="info-section">
                <div class="info-title">What is SP Metadata?</div>
                <div class="info-content">
                    Service Provider (SP) metadata contains all the necessary information for an Identity Provider (IdP) 
                    to establish a trust relationship with this application. This includes endpoints, certificates, 
                    and configuration details required for SAML authentication.
                </div>
            </div>
            
            <div class="endpoints">
                <h3>Key Endpoints</h3>
                <div class="endpoint-item">
                    <div class="endpoint-name">Entity ID</div>
                    <div class="endpoint-url">https://localhost:8080/java-saml-sso/saml/metadata</div>
                </div>
                <div class="endpoint-item">
                    <div class="endpoint-name">Assertion Consumer Service (ACS)</div>
                    <div class="endpoint-url">https://localhost:8080/java-saml-sso/saml/acs</div>
                </div>
                <div class="endpoint-item">
                    <div class="endpoint-name">Single Logout Service (SLO)</div>
                    <div class="endpoint-url">https://localhost:8080/java-saml-sso/saml/sls</div>
                </div>
            </div>
            
            <div class="actions">
                <a href="metadata.jsp?format=xml" class="btn">Download Metadata XML</a>
                <a href="javascript:history.back()" class="btn btn-secondary">Back</a>
            </div>
            
            <div class="metadata-preview">
                <h4>Metadata Preview (First 500 characters):</h4>
                <pre><%
                    try {
                        SAMLService samlService = new SAMLService();
                        String metadata = samlService.getMetadata();
                        String preview = metadata.length() > 500 ? metadata.substring(0, 500) + "..." : metadata;
                        out.print(org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(preview));
                    } catch (Exception e) {
                        out.print("Error generating metadata preview: " + e.getMessage());
                    }
                %></pre>
            </div>
            
            <div class="info-section">
                <div class="info-title">Configuration Instructions</div>
                <div class="info-content">
                    <ol>
                        <li><strong>Download the metadata:</strong> Click the "Download Metadata XML" button above</li>
                        <li><strong>Configure your IdP:</strong> Import the downloaded XML file into your Identity Provider</li>
                        <li><strong>Configure this app:</strong> Update the <code>saml.properties</code> file with your IdP settings</li>
                        <li><strong>Test the connection:</strong> Try logging in to verify the SAML integration works</li>
                    </ol>
                    <p><strong>Note:</strong> Make sure to update the Entity ID and endpoint URLs in the metadata 
                    to match your actual deployment URL (replace localhost:8080 with your domain).</p>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p>Service Provider Metadata - Java SAML SSO Sample Application</p>
        <p>Generated at: <%= new java.util.Date() %></p>
    </div>
</body>
</html> 