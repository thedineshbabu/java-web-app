#!/bin/bash

# Java SAML SSO Sample Application - Build and Run Script
# This script builds the application and runs it using Docker

set -e

echo "🔐 Java SAML SSO Sample Application"
echo "==================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Maven is available
if ! command -v mvn &> /dev/null; then
    print_warning "Maven not found. Attempting to build with Docker..."
    BUILD_WITH_DOCKER=true
else
    BUILD_WITH_DOCKER=false
fi

print_status "Starting build process..."

# Build the application
if [ "$BUILD_WITH_DOCKER" = true ]; then
    print_status "Building with Docker Maven..."
    docker run --rm -v "$(pwd)":/app -w /app maven:3.8-openjdk-8 mvn clean package -DskipTests
else
    print_status "Building with local Maven..."
    mvn clean package -DskipTests
fi

if [ $? -eq 0 ]; then
    print_success "Build completed successfully!"
else
    print_error "Build failed!"
    exit 1
fi

# Check if WAR file was created
if [ ! -f "target/java-saml-sso.war" ]; then
    print_error "WAR file not found in target directory!"
    exit 1
fi

print_status "Starting application with Docker..."

# Stop any existing containers
docker-compose down 2>/dev/null || true

# Start the application
docker-compose up -d

# Wait for application to start
print_status "Waiting for application to start..."
sleep 10

# Check if application is running
if curl -s http://localhost:8080/java-saml-sso/ > /dev/null 2>&1; then
    print_success "Application is running!"
    echo ""
    echo "🌐 Application URLs:"
    echo "  Home Page:     http://localhost:8080/java-saml-sso/"
    echo "  Diagnostic:    http://localhost:8080/java-saml-sso/diagnostic.jsp"
    echo "  Login:         http://localhost:8080/java-saml-sso/login.jsp"
    echo "  Metadata:      http://localhost:8080/java-saml-sso/metadata.jsp"
    echo ""
    echo "📋 Next Steps:"
    echo "  1. Visit the diagnostic page to check SAML configuration"
    echo "  2. Configure your IdP with the SP metadata"
    echo "  3. Test SAML login functionality"
    echo ""
    echo "📝 Logs:"
    echo "  Application logs: logs/saml-sso-app.log"
    echo "  Error logs:       logs/saml-sso-errors.log"
    echo "  Tomcat logs:      logs/catalina.*.log"
    echo ""
    echo "🛑 To stop the application: docker-compose down"
else
    print_error "Application failed to start!"
    echo ""
    echo "📋 Troubleshooting:"
    echo "  1. Check Docker logs: docker-compose logs"
    echo "  2. Check application logs: logs/saml-sso-app.log"
    echo "  3. Verify port 8080 is not in use"
    echo "  4. Check SAML configuration in saml.properties"
fi 