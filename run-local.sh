#!/bin/bash

# Java SAML SSO Sample Application - Local Development Script
# This script helps you run the application locally

echo "🚀 Java SAML SSO Sample Application - Local Development"
echo "======================================================"

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed or not in PATH"
    exit 1
fi

# Check if Maven is available
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed or not in PATH"
    exit 1
fi

echo "✅ Java version: $(java -version 2>&1 | head -1)"
echo "✅ Maven version: $(mvn -version 2>&1 | head -1)"

# Build the application
echo ""
echo "🔨 Building the application..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"

# Check if Tomcat is available
TOMCAT_HOME=""
if command -v catalina &> /dev/null; then
    TOMCAT_HOME=$(dirname $(dirname $(which catalina)))
    echo "✅ Tomcat found at: $TOMCAT_HOME"
elif [ -d "/opt/homebrew/opt/tomcat@9" ]; then
    TOMCAT_HOME="/opt/homebrew/opt/tomcat@9"
    echo "✅ Tomcat found at: $TOMCAT_HOME"
elif [ -d "/usr/local/opt/tomcat@9" ]; then
    TOMCAT_HOME="/usr/local/opt/tomcat@9"
    echo "✅ Tomcat found at: $TOMCAT_HOME"
else
    echo "⚠️  Tomcat not found. Please install it manually:"
    echo "   brew install tomcat@9"
    echo ""
    echo "📋 Manual Deployment Instructions:"
    echo "1. Download Apache Tomcat 9.0 from: https://tomcat.apache.org/download-90.cgi"
    echo "2. Extract it to a directory (e.g., ~/tomcat9)"
    echo "3. Copy target/java-saml-sso.war to ~/tomcat9/webapps/"
    echo "4. Start Tomcat: ~/tomcat9/bin/startup.sh"
    echo "5. Access the application at: http://localhost:8080/java-saml-sso/"
    echo ""
    echo "🔧 Alternative: Use embedded Tomcat with Maven"
    echo "   mvn tomcat7:run"
    exit 0
fi

# Deploy to Tomcat
echo ""
echo "📦 Deploying to Tomcat..."

# Copy WAR file to Tomcat webapps
cp target/java-saml-sso.war "$TOMCAT_HOME/libexec/webapps/"

if [ $? -eq 0 ]; then
    echo "✅ WAR file deployed to Tomcat"
    
    # Start Tomcat if not running
    echo ""
    echo "🚀 Starting Tomcat..."
    "$TOMCAT_HOME/libexec/bin/startup.sh"
    
    echo ""
    echo "🎉 Application deployed successfully!"
    echo "📱 Access your application at:"
    echo "   http://localhost:8080/java-saml-sso/"
    echo ""
    echo "🔧 Useful commands:"
    echo "   Stop Tomcat: $TOMCAT_HOME/libexec/bin/shutdown.sh"
    echo "   View logs: tail -f $TOMCAT_HOME/libexec/logs/catalina.out"
    echo "   Tomcat manager: http://localhost:8080/manager"
else
    echo "❌ Failed to deploy WAR file"
    exit 1
fi 