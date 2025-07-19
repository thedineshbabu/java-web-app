# 🐛 Complete Debugging Guide

This guide provides comprehensive debugging options for your Java SAML SSO application.

## 🚀 Quick Start Debugging

### **Option 1: Interactive Debug Script (Recommended)**

```bash
# Run the interactive debugging script
./debug.sh
```

This script provides a menu with multiple debugging options:
- Enhanced logging
- Remote debugging for IDE
- Step-by-step debugging
- Real-time log monitoring
- Application status checking

### **Option 2: Enhanced Logging Only**

```bash
# Run with DEBUG level logging
mvn clean package tomcat7:run
```

This will show detailed logs in the console and save them to:
- `logs/saml-sso-app.log`
- `logs/saml-sso-errors.log`

## 🔧 IDE Debugging Setup

### **VS Code Setup**

1. **Install Extensions:**
   - Java Extension Pack
   - Debugger for Java

2. **Create `.vscode/launch.json`:**
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "java",
            "name": "Debug SAML App",
            "request": "attach",
            "hostName": "localhost",
            "port": 5005,
            "timeout": 30000
        }
    ]
}
```

3. **Start with remote debugging:**
```bash
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
```

4. **Set breakpoints and start debugging**

### **IntelliJ IDEA Setup**

1. **Go to Run → Edit Configurations**
2. **Click + → Remote JVM Debug**
3. **Configure:**
   - Name: `SAML App Debug`
   - Host: `localhost`
   - Port: `5005`
   - Use module classpath: `java-saml-sso`
4. **Start the application with remote debugging**
5. **Set breakpoints and start debugging**

## 🎯 Strategic Debug Points

### **Key Areas to Set Breakpoints**

1. **SAMLService Constructor** (`SAMLService.java:40`)
   - Debug SAML initialization
   - Check configuration loading

2. **initializeSAML() Method** (`SAMLService.java:55`)
   - Debug settings creation
   - Check for configuration errors

3. **getSAMLConfiguration() Method** (`SAMLService.java:75`)
   - Debug configuration building
   - Check property values

4. **login() Method** (`SAMLService.java:160`)
   - Debug authentication initiation
   - Check request/response flow

5. **processResponse() Method** (`SAMLService.java:200`)
   - Debug SAML response processing
   - Check user authentication

### **JSP Debug Points**

1. **login.jsp** - Check SAML service instantiation
2. **acs.jsp** - Check SAML response processing
3. **diagnostic.jsp** - Check configuration status

## 📊 Log Analysis

### **Understanding Log Levels**

- **TRACE**: Most detailed logging
- **DEBUG**: Detailed debugging information
- **INFO**: General application flow
- **WARN**: Warning messages
- **ERROR**: Error messages

### **Key Log Patterns to Watch**

```bash
# SAML Initialization
grep "🐛 DEBUG: Initializing SAML service" logs/saml-sso-app.log

# Configuration Loading
grep "🐛 DEBUG: Loading SAML settings" logs/saml-sso-app.log

# Authentication Flow
grep "🐛 DEBUG: Initiating SAML login" logs/saml-sso-app.log

# Errors
grep "❌" logs/saml-sso-errors.log
```

### **Real-time Log Monitoring**

```bash
# Monitor all logs
tail -f logs/saml-sso-app.log logs/saml-sso-errors.log

# Monitor only errors
tail -f logs/saml-sso-errors.log

# Monitor specific patterns
tail -f logs/saml-sso-app.log | grep "🐛 DEBUG"
```

## 🔍 Common Debugging Scenarios

### **Scenario 1: Application Won't Start**

**Symptoms:**
- Application fails to start
- No response on port 8080

**Debug Steps:**
1. Check Java version: `java -version`
2. Check Maven build: `mvn clean package -DskipTests`
3. Check port availability: `lsof -i :8080`
4. Review startup logs

**Common Issues:**
- Java version mismatch
- Port already in use
- Missing dependencies

### **Scenario 2: SAML Configuration Errors**

**Symptoms:**
- SAML service initialization fails
- Configuration errors in logs

**Debug Steps:**
1. Check `saml.properties` file
2. Verify property values
3. Check file permissions
4. Review SAML configuration logs

**Common Issues:**
- Missing required properties
- Invalid URLs
- Certificate format issues

### **Scenario 3: Authentication Flow Issues**

**Symptoms:**
- Login button doesn't work
- Redirect to IdP fails
- SAML response processing errors

**Debug Steps:**
1. Set breakpoints in `login()` method
2. Check SAML settings
3. Verify IdP configuration
4. Monitor network requests

**Common Issues:**
- Invalid IdP URL
- Certificate validation failures
- Network connectivity issues

### **Scenario 4: Session Management Issues**

**Symptoms:**
- Session not maintained
- User logged out unexpectedly
- Session attributes missing

**Debug Steps:**
1. Check session configuration in `web.xml`
2. Monitor session creation/destruction
3. Check session attributes
4. Review session filter logs

## 🛠️ Debugging Tools

### **Built-in Debug Scripts**

```bash
# Interactive debugging menu
./debug.sh

# Check application status
./debug.sh  # Choose option 5

# Monitor logs
./debug.sh  # Choose option 4

# View error logs
./debug.sh  # Choose option 6
```

### **Maven Debug Options**

```bash
# Run with debug logging
mvn clean package tomcat7:run

# Run with remote debugging
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

# Run with step debugging (suspend on start)
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
```

### **Browser Developer Tools**

1. **Network Tab:**
   - Monitor HTTP requests/responses
   - Check SAML redirects
   - Verify response status codes

2. **Console Tab:**
   - Check for JavaScript errors
   - Monitor AJAX requests
   - Debug client-side issues

3. **Application Tab:**
   - Check session storage
   - Monitor cookies
   - Verify local storage

## 📋 Debug Checklist

### **Before Starting Debugging**

- [ ] Application builds successfully
- [ ] No compilation errors
- [ ] Dependencies are resolved
- [ ] Configuration files are present
- [ ] Log directories exist

### **During Debugging**

- [ ] Set appropriate breakpoints
- [ ] Monitor console output
- [ ] Check log files
- [ ] Verify network requests
- [ ] Test different scenarios

### **After Debugging**

- [ ] Remove debug breakpoints
- [ ] Clean up debug logs
- [ ] Document findings
- [ ] Update configuration if needed
- [ ] Test the fix

## 🚨 Emergency Debugging

### **Quick Diagnostic Commands**

```bash
# Check if application is running
curl -I http://localhost:8080/java-saml-sso/

# Check recent errors
tail -20 logs/saml-sso-errors.log

# Check application status
./debug.sh  # Option 5

# Restart with clean logs
./debug.sh  # Option 7
```

### **Reset Everything**

```bash
# Stop all processes
pkill -f "tomcat7:run"

# Clean everything
mvn clean
rm -rf logs/*
rm -rf target/*

# Rebuild and restart
mvn clean package tomcat7:run
```

## 📞 Getting Help

If you're still having issues:

1. **Check the logs:** `logs/saml-sso-errors.log`
2. **Review this guide:** Look for similar scenarios
3. **Use the debug script:** `./debug.sh`
4. **Check configuration:** Verify `saml.properties`
5. **Test connectivity:** Ensure network access

## 🎯 Best Practices

1. **Start with logging:** Use enhanced logging first
2. **Set strategic breakpoints:** Focus on key methods
3. **Monitor logs:** Watch for patterns and errors
4. **Test incrementally:** Fix one issue at a time
5. **Document changes:** Keep track of what you find
6. **Use version control:** Commit working states

Happy debugging! 🐛✨ 