# Docker Setup for Java SAML SSO Sample App

This directory contains Docker configuration files for running the Java SAML SSO Sample Application in Docker Desktop.

## 🐳 Quick Start

### Prerequisites

- Docker Desktop installed and running
- Git (to clone the repository)

### 1. Clone and Navigate

```bash
git clone https://github.com/thedineshbabu/java-web-app.git
cd java-web-app
```

### 2. Build and Run

```bash
# Build and start the application
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build
```

### 3. Access the Application

- **Application**: http://localhost:8080/java-saml-sso/
- **Tomcat Manager**: http://localhost:8080/manager/ (admin/admin123)

## 📁 Docker Files Structure

```
docker/
├── README.md              # This file
├── tomcat-users.xml       # Tomcat admin users
├── server.xml             # Custom Tomcat configuration
├── nginx.conf             # Nginx reverse proxy config
└── saml.properties        # Docker-specific SAML config
```

## 🔧 Configuration Options

### Basic Setup (HTTP only)

```bash
docker-compose up --build
```

### With Nginx Reverse Proxy (HTTPS)

```bash
# Generate SSL certificates (self-signed for development)
mkdir -p docker/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout docker/ssl/key.pem \
  -out docker/ssl/cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Start with proxy
docker-compose --profile proxy up --build
```

### Custom Configuration

1. **Update SAML Settings**: Edit `docker/saml.properties`
2. **Modify Tomcat Config**: Edit `docker/server.xml`
3. **Change Nginx Config**: Edit `docker/nginx.conf`

## 🚀 Docker Commands

### Build and Run

```bash
# Build the image
docker build -t java-saml-sso .

# Run the container
docker run -p 8080:8080 java-saml-sso

# Run with custom configuration
docker run -p 8080:8080 \
  -v $(pwd)/docker/saml.properties:/usr/local/tomcat/webapps/java-saml-sso/WEB-INF/classes/saml.properties \
  java-saml-sso
```

### Docker Compose Commands

```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and start
docker-compose up --build

# Clean up everything
docker-compose down -v --rmi all
```

### Development Mode

```bash
# Start with volume mounts for live code changes
docker-compose -f docker-compose.dev.yml up --build
```

## 🔍 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using port 8080
   lsof -i :8080
   
   # Change port in docker-compose.yml
   ports:
     - "8081:8080"  # Use port 8081 instead
   ```

2. **Permission Issues**
   ```bash
   # Fix log directory permissions
   sudo chown -R $USER:$USER logs/
   ```

3. **Container Won't Start**
   ```bash
   # Check container logs
   docker-compose logs saml-sso-app
   
   # Check container status
   docker-compose ps
   ```

4. **SAML Configuration Issues**
   ```bash
   # Verify SAML properties are loaded
   docker exec -it java-saml-sso cat /usr/local/tomcat/webapps/java-saml-sso/WEB-INF/classes/saml.properties
   ```

### Health Checks

```bash
# Check application health
curl http://localhost:8080/java-saml-sso/

# Check container health
docker-compose ps

# View health check logs
docker inspect java-saml-sso | grep -A 10 Health
```

## 🔒 Security Considerations

### Development Environment

- Default Tomcat admin credentials: `admin/admin123`
- Self-signed SSL certificates for HTTPS
- Debug mode enabled for troubleshooting

### Production Deployment

1. **Change Default Passwords**
   ```bash
   # Edit docker/tomcat-users.xml
   # Change admin password
   ```

2. **Use Proper SSL Certificates**
   ```bash
   # Replace self-signed certificates with real ones
   # Update docker/nginx.conf with proper cert paths
   ```

3. **Disable Debug Mode**
   ```bash
   # Set app.debug=false in saml.properties
   ```

4. **Configure Firewall**
   ```bash
   # Only expose necessary ports
   # Use Docker networks for internal communication
   ```

## 📊 Monitoring

### Logs

```bash
# Application logs
docker-compose logs -f saml-sso-app

# Tomcat logs
docker exec -it java-saml-sso tail -f /usr/local/tomcat/logs/catalina.out

# Access logs
docker exec -it java-saml-sso tail -f /usr/local/tomcat/logs/localhost_access_log.*.txt
```

### Metrics

```bash
# Container resource usage
docker stats java-saml-sso

# Application metrics (if JMX enabled)
# Connect to localhost:9999 with JConsole
```

## 🧪 Testing

### Manual Testing

1. **Home Page**: http://localhost:8080/java-saml-sso/
2. **Metadata**: http://localhost:8080/java-saml-sso/metadata.jsp
3. **Login**: http://localhost:8080/java-saml-sso/login.jsp

### Automated Testing

```bash
# Run tests in container
docker exec -it java-saml-sso mvn test

# Integration tests
docker-compose -f docker-compose.test.yml up --build
```

## 🔄 Updates and Maintenance

### Update Application

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up --build
```

### Update Dependencies

```bash
# Update Maven dependencies
docker exec -it java-saml-sso mvn dependency:resolve

# Rebuild with updated dependencies
docker-compose up --build
```

### Backup and Restore

```bash
# Backup configuration
docker cp java-saml-sso:/usr/local/tomcat/webapps/java-saml-sso/WEB-INF/classes/saml.properties ./backup/

# Restore configuration
docker cp ./backup/saml.properties java-saml-sso:/usr/local/tomcat/webapps/java-saml-sso/WEB-INF/classes/
```

## 📞 Support

For issues and questions:

1. Check the troubleshooting section above
2. Review container logs: `docker-compose logs`
3. Check the main README.md for SAML configuration help
4. Create an issue in the GitHub repository

---

**Happy Dockerizing! 🐳** 