# Java SAML SSO Sample Application Dockerfile
# Multi-stage build for optimized image size

# Stage 1: Build the application
FROM maven:3.8.6-openjdk-8 AS builder

# Set working directory
WORKDIR /app

# Copy Maven configuration files
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Download dependencies (cached layer)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime with Tomcat
FROM tomcat:9.0-jdk8-openjdk-slim

# Set metadata
LABEL maintainer="SAML SSO Sample App"
LABEL description="Java SAML SSO Sample Application with Tomcat"
LABEL version="1.0.0"

# Install additional packages for debugging and utilities
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create application user
RUN groupadd -r samlapp && useradd -r -g samlapp samlapp

# Set working directory
WORKDIR /usr/local/tomcat

# Copy the built WAR file from builder stage
COPY --from=builder /app/target/java-saml-sso.war webapps/

# Create logs directory
RUN mkdir -p logs && chown -R samlapp:samlapp logs

# Copy custom Tomcat configuration (optional)
COPY docker/tomcat-users.xml conf/
COPY docker/server.xml conf/

# Create application directories
RUN mkdir -p /opt/saml-app/logs && \
    chown -R samlapp:samlapp /opt/saml-app

# Switch to non-root user
USER samlapp

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/java-saml-sso/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"] 