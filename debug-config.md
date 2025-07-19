# 🐛 Debugging Configuration Guide

## IntelliJ IDEA

### Setup Remote Debugging
1. **Open the project in IntelliJ IDEA**
2. **Go to Run → Edit Configurations**
3. **Click + → Remote JVM Debug**
4. **Configure:**
   - Name: `SAML App Debug`
   - Host: `localhost`
   - Port: `5005`
   - Use module classpath: `java-saml-sso`
5. **Click OK**

### Start Application with Debug
```bash
# Run with debug enabled
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
```

### Debug Steps
1. Set breakpoints in your Java code
2. Start the debug configuration in IntelliJ
3. Access the application in browser
4. Debugger will stop at breakpoints

## VS Code

### Setup Java Debugging
1. **Install Java Extension Pack**
2. **Open the project**
3. **Create `.vscode/launch.json`:**

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

### Start Application with Debug
```bash
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
```

## Eclipse

### Setup Remote Debugging
1. **Run → Debug Configurations**
2. **Remote Java Application → New**
3. **Configure:**
   - Name: `SAML App Debug`
   - Host: `localhost`
   - Port: `5005`
4. **Click Debug**

### Start Application with Debug
```bash
mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
``` 