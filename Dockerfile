# Java SAML SSO Sample Application Dockerfile
# Single-stage build for simplicity

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

# Copy the WAR file directly
COPY target/java-saml-sso.war webapps/

# Extract the WAR file
RUN cd webapps && \
    jar -xf java-saml-sso.war && \
    rm java-saml-sso.war

# Verify classes are present
RUN echo "=== VERIFYING CLASSES ===" && \
    ls -la webapps/WEB-INF/classes/ && \
    find webapps/WEB-INF/classes/ -name "*.class" | head -5

# Create necessary directories and set permissions
RUN mkdir -p logs && \
    mkdir -p /opt/saml-app/logs && \
    mkdir -p conf/Catalina/localhost && \
    chown -R samlapp:samlapp logs && \
    chown -R samlapp:samlapp /opt/saml-app && \
    chown -R samlapp:samlapp conf/Catalina && \
    chown -R samlapp:samlapp webapps

# Copy custom Tomcat configuration (optional)
COPY docker/tomcat-users.xml conf/
COPY docker/server.xml conf/

# Switch to non-root user
USER samlapp

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/java-saml-sso/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"] 