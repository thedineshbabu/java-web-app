# 🚀 Local Development Guide

This guide will help you run the Java SAML SSO Sample Application locally on your machine without Docker.

## 📋 Prerequisites

- **Java 22** (or later) - ✅ You have this installed
- **Maven 3.6+** - ✅ You have this installed
- **Apache Tomcat 9.0** (optional, for standalone deployment)

## 🎯 Quick Start (Recommended)

### Option 1: Using Maven Embedded Tomcat (Easiest)

1. **Build and run the application:**
   ```bash
   mvn clean package tomcat7:run
   ```

2. **Access the application:**
   - Home page: http://localhost:8080/java-saml-sso/
   - Login page: http://localhost:8080/java-saml-sso/login.jsp
   - Diagnostic page: http://localhost:8080/java-saml-sso/diagnostic.jsp

3. **Stop the application:**
   - Press `Ctrl+C` in the terminal

### Option 2: Using the Automated Script

1. **Run the setup script:**
   ```bash
   ./run-local.sh
   ```

2. **Follow the instructions provided by the script**

### Option 3: Manual Tomcat Deployment

1. **Install Tomcat 9:**
   ```bash
   brew install tomcat@9
   ```

2. **Build the application:**
   ```bash
   mvn clean package -DskipTests
   ```

3. **Deploy to Tomcat:**
   ```bash
   # Copy WAR file to Tomcat webapps
   cp target/java-saml-sso.war /opt/homebrew/opt/tomcat@9/libexec/webapps/
   
   # Start Tomcat
   /opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
   ```

4. **Access the application:**
   - http://localhost:8080/java-saml-sso/

5. **Stop Tomcat:**
   ```bash
   /opt/homebrew/opt/tomcat@9/libexec/bin/shutdown.sh
   ```

## 🔧 Development Workflow

### Building the Application
```bash
# Clean and build
mvn clean package -DskipTests

# Build with tests
mvn clean package
```

### Running Tests
```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=SAMLServiceTest
```

### Hot Reload (Development)
```bash
# Run with hot reload (Maven Tomcat plugin)
mvn tomcat7:run

# The application will automatically reload when you make changes
```

## 📁 Project Structure

```
java-web-app/
├── src/
│   ├── main/
│   │   ├── java/                    # Java source code
│   │   │   └── com/sample/saml/
│   │   │       ├── filter/          # SAML Session Filter
│   │   │       ├── listener/        # SAML Context Listener
│   │   │       ├── model/           # SAML User Info model
│   │   │       ├── service/         # SAML Service
│   │   │       └── util/            # SAML Configuration
│   │   ├── resources/               # Configuration files
│   │   │   ├── logback.xml         # Logging configuration
│   │   │   └── saml.properties     # SAML configuration
│   │   └── webapp/                  # Web application files
│   │       ├── WEB-INF/
│   │       │   └── web.xml         # Web application configuration
│   │       ├── index.jsp           # Home page
│   │       ├── login.jsp           # Login page
│   │       └── diagnostic.jsp      # Diagnostic page
│   └── test/                        # Test files
├── target/                          # Build output
├── pom.xml                         # Maven configuration
├── run-local.sh                    # Local development script
└── LOCAL_DEVELOPMENT.md            # This file
```

## 🔍 Troubleshooting

### Common Issues

1. **Port 8080 already in use:**
   ```bash
   # Find process using port 8080
   lsof -i :8080
   
   # Kill the process
   kill -9 <PID>
   ```

2. **Java version issues:**
   ```bash
   # Check Java version
   java -version
   
   # Set JAVA_HOME if needed
   export JAVA_HOME=$(/usr/libexec/java_home -v 22)
   ```

3. **Maven build fails:**
   ```bash
   # Clean Maven cache
   mvn clean
   rm -rf ~/.m2/repository/com/sample/
   
   # Rebuild
   mvn clean package -DskipTests
   ```

4. **Application not accessible:**
   - Check Tomcat logs: `tail -f /opt/homebrew/opt/tomcat@9/libexec/logs/catalina.out`
   - Verify WAR file is deployed: Check `webapps/` directory
   - Check application context path in URL

### Logs and Debugging

- **Maven Tomcat logs:** Displayed in the terminal where you ran `mvn tomcat7:run`
- **Standalone Tomcat logs:** `/opt/homebrew/opt/tomcat@9/libexec/logs/`
- **Application logs:** Configured in `src/main/resources/logback.xml`

## 🎯 Next Steps

1. **Configure SAML Identity Provider:**
   - Update `src/main/resources/saml.properties`
   - Configure your IdP settings

2. **Enable SAML Components:**
   - Uncomment SAML listener and filter in `web.xml`
   - Test full SAML authentication flow

3. **Customize the Application:**
   - Modify JSP pages for your branding
   - Add additional SAML features
   - Implement custom user management

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review the application logs
3. Verify your Java and Maven versions
4. Ensure all dependencies are properly installed

Happy coding! 🎉 