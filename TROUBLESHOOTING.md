# 🔧 SAML SSO Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the Java SAML SSO Sample Application.

## 🚨 **Common Error: Internal Server Error (500)**

### **Root Cause Analysis**

The most common cause of 500 errors is **JSP compilation failures**. This typically happens when:

1. **Incorrect JSP Import Syntax**: Using Java `import` statements inside JSP scriptlets
2. **Missing Dependencies**: Required classes not found in classpath
3. **Configuration Issues**: SAML properties not properly configured
4. **Class Loading Issues**: JAR files not properly deployed

### **Quick Fix Steps**

#### **Step 1: Check Application Logs**
```bash
# View application logs
tail -f logs/saml-sso-app.log

# View error logs
tail -f logs/saml-sso-errors.log

# View Tomcat logs
tail -f logs/catalina.*.log
```

#### **Step 2: Use Diagnostic Page**
Visit: `http://localhost:8080/java-saml-sso/diagnostic.jsp`

This page will show:
- SAML configuration status
- Missing configuration items
- System information
- Detailed error messages

#### **Step 3: Verify JSP Syntax**
Ensure all JSP files use correct import syntax:

```jsp
<!-- CORRECT: Use page directive for imports -->
<%@ page import="com.sample.saml.service.SAMLService" %>
<%@ page import="org.slf4j.Logger" %>

<!-- INCORRECT: Don't use import inside scriptlets -->
<%
    import com.sample.saml.service.SAMLService; // ❌ Wrong!
%>
```

## 🔍 **Detailed Troubleshooting**

### **1. JSP Compilation Errors**

**Symptoms:**
- 500 Internal Server Error
- "Unable to compile class for JSP" in logs
- "cannot be resolved to a type" errors

**Solutions:**
1. **Fix Import Syntax**: Use `<%@ page import="..." %>` directives
2. **Check Dependencies**: Ensure all required JARs are in `WEB-INF/lib`
3. **Rebuild Application**: Run `mvn clean package`
4. **Clear Tomcat Cache**: Delete `work` directory and restart

### **2. SAML Configuration Issues**

**Symptoms:**
- "SAML configuration file not found" errors
- "Missing required SAML configuration" errors
- Authentication failures

**Solutions:**
1. **Verify saml.properties**: Ensure file exists in `src/main/resources/`
2. **Check Required Properties**:
   ```properties
   sp.entityId=https://localhost:8080/java-saml-sso/saml/metadata
   sp.assertionConsumerService.url=https://localhost:8080/java-saml-sso/saml/acs
   sp.singleLogoutService.url=https://localhost:8080/java-saml-sso/saml/sls
   idp.entityId=https://your-idp-domain/realms/your-realm
   idp.singleSignOnService.url=https://your-idp-domain/realms/your-realm/protocol/saml
   idp.singleLogoutService.url=https://your-idp-domain/realms/your-realm/protocol/saml/logout
   idp.x509cert=-----BEGIN CERTIFICATE-----...
   ```
3. **Validate Certificate**: Ensure IdP certificate is properly formatted
4. **Check URLs**: Verify all URLs are accessible and correctly formatted

### **3. Class Loading Issues**

**Symptoms:**
- `ClassNotFoundException` errors
- "cannot be resolved to a type" errors
- Missing dependency errors

**Solutions:**
1. **Check Maven Dependencies**: Ensure all dependencies are included in WAR
2. **Verify JAR Files**: Check `target/java-saml-sso/WEB-INF/lib/`
3. **Rebuild with Dependencies**: Run `mvn clean package -DskipTests`
4. **Check Classpath**: Ensure no conflicting JAR versions

### **4. Session Management Issues**

**Symptoms:**
- Users redirected to login repeatedly
- Session not maintained
- Logout not working

**Solutions:**
1. **Enable SAML Filter**: Ensure filter is enabled in `web.xml`
2. **Check Session Configuration**: Verify session timeout settings
3. **Validate Cookie Settings**: Check secure and httpOnly settings
4. **Test Session Storage**: Verify session attributes are set correctly

## 🛠️ **Debugging Tools**

### **1. Diagnostic Page**
Access: `http://localhost:8080/java-saml-sso/diagnostic.jsp`

**Features:**
- Real-time configuration validation
- System information display
- Error details and suggestions
- Quick access to other pages

### **2. Enhanced Logging**
The application uses Winston logging with multiple levels:

```bash
# View all application logs
tail -f logs/saml-sso-app.log

# View only errors
tail -f logs/saml-sso-errors.log

# View SAML-specific logs
grep "com.sample.saml" logs/saml-sso-app.log

# View OneLogin toolkit logs
grep "com.onelogin.saml2" logs/saml-sso-app.log
```

### **3. Browser Developer Tools**
1. **Network Tab**: Monitor SAML requests/responses
2. **Console**: Check for JavaScript errors
3. **Application Tab**: Verify cookies and session storage

## 🔧 **Common Fixes**

### **Fix 1: JSP Import Issues**
```jsp
<!-- Before (Broken) -->
<%
    import com.sample.saml.service.SAMLService;
    import org.slf4j.Logger;
%>

<!-- After (Fixed) -->
<%@ page import="com.sample.saml.service.SAMLService" %>
<%@ page import="org.slf4j.Logger" %>
<%
    // Your code here
%>
```

### **Fix 2: Missing SAML Configuration**
```properties
# Add to saml.properties
sp.entityId=https://localhost:8080/java-saml-sso/saml/metadata
sp.assertionConsumerService.url=https://localhost:8080/java-saml-sso/saml/acs
sp.singleLogoutService.url=https://localhost:8080/java-saml-sso/saml/sls
idp.entityId=https://your-idp-domain/realms/your-realm
idp.singleSignOnService.url=https://your-idp-domain/realms/your-realm/protocol/saml
idp.singleLogoutService.url=https://your-idp-domain/realms/your-realm/protocol/saml/logout
idp.x509cert=-----BEGIN CERTIFICATE-----...
```

### **Fix 3: Enable SAML Components**
```xml
<!-- In web.xml -->
<listener>
    <listener-class>com.sample.saml.listener.SAMLContextListener</listener-class>
</listener>

<filter>
    <filter-name>SAMLSessionFilter</filter-name>
    <filter-class>com.sample.saml.filter.SAMLSessionFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>SAMLSessionFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 🚀 **Quick Recovery Steps**

### **Step 1: Stop Application**
```bash
docker-compose down
```

### **Step 2: Clean and Rebuild**
```bash
mvn clean package -DskipTests
```

### **Step 3: Restart Application**
```bash
docker-compose up -d
```

### **Step 4: Check Status**
```bash
# Check if application is running
curl -s http://localhost:8080/java-saml-sso/diagnostic.jsp

# Check logs
tail -f logs/saml-sso-app.log
```

## 📞 **Getting Help**

### **1. Check Logs First**
Always check the application logs before seeking help:
- `logs/saml-sso-app.log` - Application logs
- `logs/saml-sso-errors.log` - Error logs
- `logs/catalina.*.log` - Tomcat logs

### **2. Use Diagnostic Page**
Visit the diagnostic page for automated troubleshooting:
`http://localhost:8080/java-saml-sso/diagnostic.jsp`

### **3. Common Error Messages**

| Error Message | Likely Cause | Solution |
|---------------|--------------|----------|
| "Unable to compile class for JSP" | JSP syntax error | Fix import statements |
| "SAML configuration file not found" | Missing saml.properties | Create/verify config file |
| "Missing required SAML configuration" | Incomplete config | Add missing properties |
| "ClassNotFoundException" | Missing dependency | Check Maven dependencies |
| "cannot be resolved to a type" | Import/classpath issue | Fix imports or rebuild |

### **4. Still Having Issues?**

If you're still experiencing problems:

1. **Collect Information**:
   - Error messages from logs
   - Screenshot of diagnostic page
   - SAML configuration (without sensitive data)

2. **Check Prerequisites**:
   - Java 8+ installed
   - Maven 3.6+ installed
   - Docker running
   - Port 8080 available

3. **Verify Configuration**:
   - All required SAML properties set
   - IdP certificate valid
   - URLs accessible and correct

## 🎯 **Prevention Tips**

1. **Always use correct JSP syntax** for imports
2. **Test configuration** before deployment
3. **Monitor logs** regularly
4. **Use diagnostic page** for quick checks
5. **Keep dependencies updated**
6. **Backup configuration** before changes

---

**Remember**: Most issues can be resolved by checking the logs and using the diagnostic page. The application includes comprehensive logging to help identify and fix problems quickly. 