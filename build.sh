#!/bin/bash

# Java SAML SSO Sample App - Build Script
# This script automates the build and deployment process

set -e  # Exit on any error

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Java version
check_java() {
    if ! command_exists java; then
        print_error "Java is not installed or not in PATH"
        exit 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 8 ]; then
        print_error "Java 8 or later is required. Found version: $JAVA_VERSION"
        exit 1
    fi
    
    print_success "Java version check passed: $(java -version 2>&1 | head -n 1)"
}

# Function to check Maven
check_maven() {
    if ! command_exists mvn; then
        print_error "Maven is not installed or not in PATH"
        exit 1
    fi
    
    print_success "Maven found: $(mvn -version | head -n 1)"
}

# Function to clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    mvn clean
    print_success "Clean completed"
}

# Function to build the application
build_app() {
    print_status "Building application..."
    mvn package -DskipTests
    print_success "Build completed successfully"
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    mvn test
    print_success "Tests completed"
}

# Function to check WAR file
check_war() {
    WAR_FILE="target/java-saml-sso.war"
    if [ ! -f "$WAR_FILE" ]; then
        print_error "WAR file not found: $WAR_FILE"
        exit 1
    fi
    
    WAR_SIZE=$(du -h "$WAR_FILE" | cut -f1)
    print_success "WAR file created: $WAR_FILE ($WAR_SIZE)"
}

# Function to deploy to Tomcat
deploy_tomcat() {
    if [ -z "$TOMCAT_HOME" ]; then
        print_warning "TOMCAT_HOME environment variable not set"
        print_status "Please set TOMCAT_HOME to your Tomcat installation directory"
        print_status "Example: export TOMCAT_HOME=/opt/tomcat"
        return 1
    fi
    
    if [ ! -d "$TOMCAT_HOME/webapps" ]; then
        print_error "Tomcat webapps directory not found: $TOMCAT_HOME/webapps"
        return 1
    fi
    
    print_status "Deploying to Tomcat..."
    cp target/java-saml-sso.war "$TOMCAT_HOME/webapps/"
    print_success "Deployment completed"
    print_status "Application will be available at: http://localhost:8080/java-saml-sso/"
}

# Function to start Tomcat
start_tomcat() {
    if [ -z "$TOMCAT_HOME" ]; then
        print_warning "TOMCAT_HOME not set, cannot start Tomcat"
        return 1
    fi
    
    if [ ! -f "$TOMCAT_HOME/bin/startup.sh" ]; then
        print_error "Tomcat startup script not found: $TOMCAT_HOME/bin/startup.sh"
        return 1
    fi
    
    print_status "Starting Tomcat..."
    "$TOMCAT_HOME/bin/startup.sh"
    print_success "Tomcat started"
}

# Function to stop Tomcat
stop_tomcat() {
    if [ -z "$TOMCAT_HOME" ]; then
        print_warning "TOMCAT_HOME not set, cannot stop Tomcat"
        return 1
    fi
    
    if [ ! -f "$TOMCAT_HOME/bin/shutdown.sh" ]; then
        print_error "Tomcat shutdown script not found: $TOMCAT_HOME/bin/shutdown.sh"
        return 1
    fi
    
    print_status "Stopping Tomcat..."
    "$TOMCAT_HOME/bin/shutdown.sh"
    print_success "Tomcat stopped"
}

# Function to show help
show_help() {
    echo "Java SAML SSO Sample App - Build Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  build       Build the application (default)"
    echo "  clean       Clean previous builds"
    echo "  test        Run tests"
    echo "  deploy      Deploy to Tomcat (requires TOMCAT_HOME)"
    echo "  start       Start Tomcat (requires TOMCAT_HOME)"
    echo "  stop        Stop Tomcat (requires TOMCAT_HOME)"
    echo "  full        Clean, build, test, and deploy"
    echo "  help        Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  TOMCAT_HOME Path to Tomcat installation directory"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build application"
    echo "  $0 full               # Full build and deploy"
    echo "  export TOMCAT_HOME=/opt/tomcat"
    echo "  $0 deploy             # Deploy to Tomcat"
}

# Main script logic
main() {
    case "${1:-build}" in
        "build")
            check_java
            check_maven
            build_app
            check_war
            ;;
        "clean")
            check_maven
            clean_build
            ;;
        "test")
            check_java
            check_maven
            run_tests
            ;;
        "deploy")
            check_java
            check_maven
            build_app
            check_war
            deploy_tomcat
            ;;
        "start")
            start_tomcat
            ;;
        "stop")
            stop_tomcat
            ;;
        "full")
            check_java
            check_maven
            clean_build
            build_app
            run_tests
            check_war
            deploy_tomcat
            print_success "Full build and deployment completed!"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 