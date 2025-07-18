#!/bin/bash

# Java SAML SSO Sample App - Docker Run Script
# This script provides easy commands to run the application in Docker

set -e

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

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop first."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to create logs directory
create_logs_dir() {
    if [ ! -d "logs" ]; then
        print_status "Creating logs directory..."
        mkdir -p logs
        print_success "Logs directory created"
    fi
}

# Function to generate SSL certificates
generate_ssl_certs() {
    if [ ! -d "docker/ssl" ]; then
        print_status "Generating SSL certificates for development..."
        mkdir -p docker/ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout docker/ssl/key.pem \
            -out docker/ssl/cert.pem \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" 2>/dev/null || {
            print_warning "Could not generate SSL certificates. HTTPS will not be available."
            return 1
        }
        print_success "SSL certificates generated"
    fi
}

# Function to show help
show_help() {
    echo "Java SAML SSO Sample App - Docker Run Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Start the application (default)"
    echo "  stop        Stop the application"
    echo "  restart     Restart the application"
    echo "  build       Build the Docker image"
    echo "  logs        Show application logs"
    echo "  shell       Open shell in running container"
    echo "  dev         Start in development mode"
    echo "  https       Start with HTTPS (Nginx proxy)"
    echo "  clean       Clean up containers and images"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start              # Start the application"
    echo "  $0 dev                # Start in development mode"
    echo "  $0 https              # Start with HTTPS"
    echo "  $0 logs               # View logs"
    echo ""
    echo "Access URLs:"
    echo "  Application: http://localhost:8080/java-saml-sso/"
    echo "  Tomcat Manager: http://localhost:8080/manager/ (admin/admin123)"
}

# Function to start the application
start_app() {
    print_status "Starting Java SAML SSO application..."
    docker-compose up -d
    print_success "Application started"
    print_status "Access the application at: http://localhost:8080/java-saml-sso/"
}

# Function to stop the application
stop_app() {
    print_status "Stopping Java SAML SSO application..."
    docker-compose down
    print_success "Application stopped"
}

# Function to restart the application
restart_app() {
    print_status "Restarting Java SAML SSO application..."
    docker-compose down
    docker-compose up -d
    print_success "Application restarted"
}

# Function to build the application
build_app() {
    print_status "Building Docker image..."
    docker-compose build
    print_success "Docker image built successfully"
}

# Function to show logs
show_logs() {
    print_status "Showing application logs..."
    docker-compose logs -f
}

# Function to open shell
open_shell() {
    print_status "Opening shell in container..."
    docker exec -it java-saml-sso /bin/bash
}

# Function to start in development mode
start_dev() {
    print_status "Starting in development mode..."
    docker-compose -f docker-compose.dev.yml --profile dev up -d
    print_success "Development environment started"
    print_status "Access the application at: http://localhost:8080/java-saml-sso/"
    print_status "JMX debugging available at: localhost:9999"
}

# Function to start with HTTPS
start_https() {
    print_status "Starting with HTTPS (Nginx proxy)..."
    generate_ssl_certs
    docker-compose --profile proxy up -d
    print_success "Application started with HTTPS"
    print_status "Access the application at: https://localhost/java-saml-sso/"
}

# Function to clean up
clean_up() {
    print_status "Cleaning up containers and images..."
    docker-compose down -v --rmi all
    docker system prune -f
    print_success "Cleanup completed"
}

# Main script logic
main() {
    case "${1:-start}" in
        "start")
            check_docker
            create_logs_dir
            start_app
            ;;
        "stop")
            check_docker
            stop_app
            ;;
        "restart")
            check_docker
            restart_app
            ;;
        "build")
            check_docker
            build_app
            ;;
        "logs")
            check_docker
            show_logs
            ;;
        "shell")
            check_docker
            open_shell
            ;;
        "dev")
            check_docker
            create_logs_dir
            start_dev
            ;;
        "https")
            check_docker
            create_logs_dir
            start_https
            ;;
        "clean")
            check_docker
            clean_up
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 