#!/bin/bash

# Java SAML SSO Sample Application - Debugging Script
# This script provides multiple debugging options

echo "🐛 Java SAML SSO Application - Debugging Tools"
echo "=============================================="

# Function to show menu
show_menu() {
    echo ""
    echo "Select a debugging option:"
    echo "1) Run with enhanced logging (DEBUG level)"
    echo "2) Run with remote debugging (IDE attachment)"
    echo "3) Run with step-by-step debugging (suspend on start)"
    echo "4) Monitor logs in real-time"
    echo "5) Check application status"
    echo "6) View recent error logs"
    echo "7) Clear logs and restart"
    echo "8) Exit"
    echo ""
    read -p "Enter your choice (1-8): " choice
}

# Function to run with enhanced logging
run_with_debug_logging() {
    echo "🔍 Starting application with DEBUG logging..."
    echo "📝 Logs will be written to:"
    echo "   - Console (immediate feedback)"
    echo "   - logs/saml-sso-app.log"
    echo "   - logs/saml-sso-errors.log"
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""
    
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    mvn clean package tomcat7:run
}

# Function to run with remote debugging
run_with_remote_debug() {
    echo "🔗 Starting application with remote debugging..."
    echo "📡 Debug port: 5005"
    echo "🔧 Attach your IDE to: localhost:5005"
    echo ""
    echo "IDE Configuration:"
    echo "  - Host: localhost"
    echo "  - Port: 5005"
    echo "  - Transport: dt_socket"
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""
    
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
}

# Function to run with step-by-step debugging
run_with_step_debug() {
    echo "⏸️  Starting application with step-by-step debugging..."
    echo "🛑 Application will suspend on startup"
    echo "🔧 Attach your IDE to: localhost:5005"
    echo "▶️  Resume execution from your IDE"
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""
    
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    mvn clean package tomcat7:run -Dmaven.tomcat.jvmargs="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
}

# Function to monitor logs
monitor_logs() {
    echo "📊 Monitoring application logs..."
    echo "Press Ctrl+C to stop monitoring"
    echo ""
    
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    # Monitor both console and file logs
    tail -f logs/saml-sso-app.log logs/saml-sso-errors.log 2>/dev/null || echo "No log files found yet. Start the application first."
}

# Function to check application status
check_status() {
    echo "🔍 Checking application status..."
    
    # Check if application is running
    if curl -s http://localhost:8080/java-saml-sso/ > /dev/null 2>&1; then
        echo "✅ Application is running at: http://localhost:8080/java-saml-sso/"
        
        # Check specific endpoints
        echo ""
        echo "📋 Endpoint Status:"
        
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/ | grep -q "200"; then
            echo "  ✅ Home page: http://localhost:8080/java-saml-sso/"
        else
            echo "  ❌ Home page: Not accessible"
        fi
        
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/login.jsp | grep -q "200"; then
            echo "  ✅ Login page: http://localhost:8080/java-saml-sso/login.jsp"
        else
            echo "  ❌ Login page: Not accessible"
        fi
        
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/diagnostic.jsp | grep -q "200"; then
            echo "  ✅ Diagnostic page: http://localhost:8080/java-saml-sso/diagnostic.jsp"
        else
            echo "  ❌ Diagnostic page: Not accessible"
        fi
        
    else
        echo "❌ Application is not running"
        echo "💡 Start the application using option 1, 2, or 3"
    fi
    
    # Check for log files
    echo ""
    echo "📁 Log Files:"
    if [ -f "logs/saml-sso-app.log" ]; then
        echo "  ✅ Application logs: logs/saml-sso-app.log"
        echo "     Size: $(du -h logs/saml-sso-app.log | cut -f1)"
    else
        echo "  ❌ Application logs: Not found"
    fi
    
    if [ -f "logs/saml-sso-errors.log" ]; then
        echo "  ✅ Error logs: logs/saml-sso-errors.log"
        echo "     Size: $(du -h logs/saml-sso-errors.log | cut -f1)"
    else
        echo "  ❌ Error logs: Not found"
    fi
}

# Function to view recent error logs
view_error_logs() {
    echo "🚨 Recent Error Logs:"
    echo "===================="
    
    if [ -f "logs/saml-sso-errors.log" ]; then
        echo "Last 20 error entries:"
        tail -20 logs/saml-sso-errors.log
    else
        echo "No error log file found."
    fi
    
    echo ""
    echo "📋 Recent Application Logs (last 10 entries):"
    echo "============================================"
    
    if [ -f "logs/saml-sso-app.log" ]; then
        tail -10 logs/saml-sso-app.log
    else
        echo "No application log file found."
    fi
}

# Function to clear logs and restart
clear_logs_and_restart() {
    echo "🧹 Clearing logs and restarting..."
    
    # Stop any running application
    pkill -f "tomcat7:run" 2>/dev/null || true
    
    # Clear logs
    rm -rf logs/*
    mkdir -p logs
    
    echo "✅ Logs cleared"
    echo "🔄 Ready to restart with clean logs"
    echo ""
    echo "Choose option 1, 2, or 3 to restart the application"
}

# Main menu loop
while true; do
    show_menu
    
    case $choice in
        1)
            run_with_debug_logging
            ;;
        2)
            run_with_remote_debug
            ;;
        3)
            run_with_step_debug
            ;;
        4)
            monitor_logs
            ;;
        5)
            check_status
            ;;
        6)
            view_error_logs
            ;;
        7)
            clear_logs_and_restart
            ;;
        8)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please choose 1-8."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done 