#!/bin/bash

# Java Web Server Comparison Script
# This script helps you compare different server options for your SAML application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}========================================${NC}"
}

print_section() {
    echo -e "${CYAN}$1${NC}"
}

print_item() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop first."
        exit 1
    fi
    print_item "Docker is running"
}

# Function to build and test Jetty
test_jetty() {
    print_section "Testing Jetty Server..."
    
    print_item "Building Jetty image..."
    docker-compose -f docker-compose.jetty.yml build --no-cache >/dev/null 2>&1
    
    print_item "Starting Jetty container..."
    docker-compose -f docker-compose.jetty.yml up -d >/dev/null 2>&1
    
    # Wait for startup
    sleep 30
    
    # Test response time
    start_time=$(date +%s%N)
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/ || echo "000")
    end_time=$(date +%s%N)
    
    response_time=$(( (end_time - start_time) / 1000000 ))
    
    if [ "$response" = "200" ]; then
        print_item "Jetty: HTTP 200 OK (${response_time}ms)"
    else
        print_warning "Jetty: HTTP $response (${response_time}ms)"
    fi
    
    # Get memory usage
    memory_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" java-saml-sso-jetty | tail -n 1 | awk '{print $1}')
    print_item "Jetty Memory Usage: $memory_usage"
    
    # Stop container
    docker-compose -f docker-compose.jetty.yml down >/dev/null 2>&1
}

# Function to test Spring Boot
test_spring_boot() {
    print_section "Testing Spring Boot Server..."
    
    print_item "Building Spring Boot image..."
    docker-compose -f docker-compose.spring-boot.yml build --no-cache >/dev/null 2>&1
    
    print_item "Starting Spring Boot container..."
    docker-compose -f docker-compose.spring-boot.yml up -d >/dev/null 2>&1
    
    # Wait for startup
    sleep 45
    
    # Test response time
    start_time=$(date +%s%N)
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/ || echo "000")
    end_time=$(date +%s%N)
    
    response_time=$(( (end_time - start_time) / 1000000 ))
    
    if [ "$response" = "200" ]; then
        print_item "Spring Boot: HTTP 200 OK (${response_time}ms)"
    else
        print_warning "Spring Boot: HTTP $response (${response_time}ms)"
    fi
    
    # Get memory usage
    memory_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" java-saml-sso-spring | tail -n 1 | awk '{print $1}')
    print_item "Spring Boot Memory Usage: $memory_usage"
    
    # Stop container
    docker-compose -f docker-compose.spring-boot.yml down >/dev/null 2>&1
}

# Function to test current Tomcat
test_tomcat() {
    print_section "Testing Current Tomcat Server..."
    
    if docker ps | grep -q java-saml-sso; then
        print_item "Tomcat container is already running"
    else
        print_item "Starting Tomcat container..."
        docker-compose up -d >/dev/null 2>&1
        sleep 15
    fi
    
    # Test response time
    start_time=$(date +%s%N)
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/java-saml-sso/ || echo "000")
    end_time=$(date +%s%N)
    
    response_time=$(( (end_time - start_time) / 1000000 ))
    
    if [ "$response" = "200" ]; then
        print_item "Tomcat: HTTP 200 OK (${response_time}ms)"
    else
        print_warning "Tomcat: HTTP $response (${response_time}ms)"
    fi
    
    # Get memory usage
    memory_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" java-saml-sso | tail -n 1 | awk '{print $1}')
    print_item "Tomcat Memory Usage: $memory_usage"
}

# Function to show comparison table
show_comparison() {
    print_header "Server Comparison Summary"
    
    echo -e "${CYAN}Feature Comparison:${NC}"
    echo ""
    echo -e "${YELLOW}Server Type    | Startup Time | Memory Usage | Performance | Ease of Use | Community${NC}"
    echo "-------------|-------------|-------------|-------------|-------------|----------"
    echo -e "Tomcat       | ${GREEN}Slow${NC}        | ${YELLOW}High${NC}        | ${GREEN}Good${NC}      | ${GREEN}Easy${NC}      | ${GREEN}Large${NC}"
    echo -e "Jetty        | ${GREEN}Fast${NC}        | ${GREEN}Low${NC}         | ${GREEN}Excellent${NC} | ${YELLOW}Medium${NC}   | ${YELLOW}Medium${NC}"
    echo -e "Spring Boot  | ${YELLOW}Medium${NC}     | ${YELLOW}Medium${NC}     | ${GREEN}Good${NC}      | ${GREEN}Easy${NC}      | ${GREEN}Large${NC}"
    echo -e "Undertow     | ${GREEN}Fast${NC}        | ${GREEN}Low${NC}         | ${GREEN}Excellent${NC} | ${RED}Hard${NC}       | ${YELLOW}Small${NC}"
    echo -e "WildFly      | ${RED}Very Slow${NC}   | ${RED}Very High${NC}  | ${GREEN}Good${NC}      | ${RED}Hard${NC}       | ${YELLOW}Medium${NC}"
    
    echo ""
    print_section "Recommendations:"
    echo ""
    print_item "For Development: Spring Boot (easiest setup)"
    print_item "For Production: Jetty (best performance)"
    print_item "For Enterprise: Tomcat (most familiar)"
    print_item "For Microservices: Undertow (best async support)"
}

# Function to show usage
show_usage() {
    echo "Java Web Server Comparison Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  test-all     Test all server options (default)"
    echo "  test-jetty   Test only Jetty"
    echo "  test-spring  Test only Spring Boot"
    echo "  test-tomcat  Test only current Tomcat"
    echo "  compare      Show comparison table only"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 test-all              # Test all servers"
    echo "  $0 test-jetty            # Test only Jetty"
    echo "  $0 compare               # Show comparison"
}

# Main script logic
main() {
    case "${1:-test-all}" in
        "test-all")
            check_docker
            test_tomcat
            test_jetty
            test_spring_boot
            show_comparison
            ;;
        "test-jetty")
            check_docker
            test_jetty
            ;;
        "test-spring")
            check_docker
            test_spring_boot
            ;;
        "test-tomcat")
            check_docker
            test_tomcat
            ;;
        "compare")
            show_comparison
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@" 