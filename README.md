# Java SAML SSO Sample Application

A complete Java web application demonstrating SAML 2.0 Single Sign-On (SSO) integration using the OneLogin Java Toolkit. This application acts as a Service Provider (SP) and can authenticate users via any SAML-compliant Identity Provider (IdP).

## 🚀 Features

- **SAML 2.0 Authentication**: Complete SSO implementation using OneLogin Java Toolkit
- **Single Sign-On (SSO)**: Seamless authentication flow with IdP
- **Single Logout (SLO)**: Proper session termination across all applications
- **Metadata Exchange**: Automatic SP metadata generation for IdP configuration
- **Session Management**: Secure session handling with timeout configuration
- **Comprehensive Logging**: Winston-style logging with multiple levels
- **Modern UI**: Beautiful, responsive web interface
- **Error Handling**: User-friendly error pages and troubleshooting

## 📋 Prerequisites

- **Java 8 or later**
- **Apache Maven 3.6+**
- **Apache Tomcat 9.x**
- **SAML Identity Provider** (OneLogin, Keycloak, Okta, etc.)

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd java-web-app
```

### 2. Build the Application

```bash
mvn clean package
```

This will create a WAR file in the `target/` directory: `java-saml-sso.war`

### 3. Deploy to Tomcat

1. Copy the WAR file to Tomcat's `webapps/` directory:
   ```bash
   cp target/java-saml-sso.war $TOMCAT_HOME/webapps/
   ```

2. Start Tomcat:
   ```bash
   $TOMCAT_HOME/bin/startup.sh
   ```

3. The application will be available at: `http://localhost:8080/java-saml-sso/`

## ⚙️ Configuration

### 1. SAML Configuration

Edit `src/main/resources/saml.properties` with your IdP settings:

```properties
# Service Provider Configuration
sp.entityId=https://your-domain.com/java-saml-sso/saml/metadata
sp.assertionConsumerService.url=https://your-domain.com/java-saml-sso/saml/acs
sp.singleLogoutService.url=https://your-domain.com/java-saml-sso/saml/sls

# Identity Provider Configuration
idp.entityId=https://your-idp-domain/auth/realms/your-realm
idp.singleSignOnService.url=https://your-idp-domain/auth/realms/your-realm/protocol/saml
idp.singleLogoutService.url=https://your-idp-domain/auth/realms/your-realm/protocol/saml/logout
idp.x509cert=YOUR_IDP_CERTIFICATE_HERE
```

### 2. Certificate Generation (Optional)

For production use, generate SP certificates:

```bash
# Generate private key
openssl genrsa -out sp.key 2048

# Generate certificate
openssl req -new -x509 -key sp.key -out sp.crt -days 365

# Convert to Base64 for saml.properties
openssl x509 -in sp.crt -outform DER | base64 > sp.crt.b64
openssl rsa -in sp.key -outform DER | base64 > sp.key.b64
```

Add the Base64 content to `saml.properties`:
```properties
sp.x509cert=YOUR_SP_CERTIFICATE_BASE64
sp.privateKey=YOUR_SP_PRIVATE_KEY_BASE64
```

## 🔧 IdP Configuration

### OneLogin Setup

1. **Create SAML Application**:
   - Log into OneLogin Admin
   - Go to Applications → Add App
   - Search for "SAML Test Connector (SP)"
   - Configure the application

2. **Configure SP Settings**:
   - **Audience**: `https://your-domain.com/java-saml-sso/saml/metadata`
   - **Recipient**: `https://your-domain.com/java-saml-sso/saml/acs`
   - **ACS (Consumer) URL Validator**: `https://your-domain.com/java-saml-sso/saml/acs`
   - **ACS (Consumer) URL**: `https://your-domain.com/java-saml-sso/saml/acs`
   - **Single Logout URL**: `https://your-domain.com/java-saml-sso/saml/sls`

3. **Import SP Metadata**:
   - Download SP metadata from: `https://your-domain.com/java-saml-sso/metadata.jsp?format=xml`
   - Import into OneLogin application settings

### Keycloak Setup

1. **Create Realm** (if needed):
   - Log into Keycloak Admin Console
   - Create a new realm or use existing

2. **Create Client**:
   - Go to Clients → Create
   - Client ID: `java-saml-sso`
   - Client Protocol: `saml`

3. **Configure Client Settings**:
   - **Valid Redirect URIs**: `https://your-domain.com/java-saml-sso/*`
   - **Base URL**: `https://your-domain.com/java-saml-sso/`
   - **Master SAML Processing URL**: `https://your-domain.com/java-saml-sso/saml/acs`

4. **Import SP Metadata**:
   - Download SP metadata from: `https://your-domain.com/java-saml-sso/metadata.jsp?format=xml`
   - Import into Keycloak client settings

## 🚀 Usage

### 1. Access the Application

Navigate to: `http://localhost:8080/java-saml-sso/`

### 2. SAML Login Flow

1. Click "Login with SAML" on the home page
2. You'll be redirected to your IdP
3. Authenticate with your IdP credentials
4. You'll be redirected back to the application
5. View your user information and SAML attributes

### 3. Available Pages

- **Home Page** (`/`): Application overview and login button
- **Login** (`/login.jsp`): SAML authentication initiation
- **Welcome** (`/welcome.jsp`): Post-authentication user dashboard
- **Metadata** (`/metadata.jsp`): SP metadata for IdP configuration
- **Logout** (`/logout.jsp`): Session termination

### 4. SAML Endpoints

- **ACS**: `/saml/acs` - Assertion Consumer Service
- **SLO**: `/saml/sls` - Single Logout Service
- **Metadata**: `/saml/metadata` - SP metadata

## 📊 Logging

The application uses comprehensive logging with the following levels:

- **DEBUG**: Detailed SAML operations and configuration
- **INFO**: General application flow and user actions
- **WARN**: Configuration issues and non-critical errors
- **ERROR**: Authentication failures and system errors

Log files are stored in: `logs/saml-sso-app.log`

## 🔍 Troubleshooting

### Common Issues

1. **"SAML configuration not initialized"**
   - Check that `saml.properties` exists and is properly formatted
   - Verify all required properties are set

2. **"SAML authentication errors"**
   - Verify IdP configuration matches SP settings
   - Check certificate validity and format
   - Ensure URLs are accessible and correct

3. **"No SAML response received"**
   - Verify ACS URL is correctly configured in IdP
   - Check network connectivity between SP and IdP
   - Review IdP logs for authentication issues

4. **"Session not found"**
   - Check session timeout configuration
   - Verify session management is working properly
   - Review application logs for session errors

### Debug Mode

Enable debug logging by setting in `saml.properties`:
```properties
app.debug=true
```

### Certificate Issues

- Ensure certificates are in correct format (Base64 encoded)
- Verify certificate validity and expiration dates
- Check that private key matches the certificate

## 🏗️ Architecture

### Components

- **SAMLService**: Core SAML operations and toolkit integration
- **SAMLConfig**: Configuration management and validation
- **SAMLUserInfo**: User data model for SAML assertions
- **SAMLSessionFilter**: Session management and authentication checks
- **SAMLContextListener**: Application initialization

### Flow Diagram

```
User → SP (Login) → IdP (Auth) → SP (ACS) → Welcome Page
  ↓
User → SP (Logout) → IdP (SLO) → SP (SLS) → Home Page
```

## 🔒 Security Considerations

- **HTTPS**: Use HTTPS in production for all SAML communications
- **Certificates**: Use proper X.509 certificates for signing and encryption
- **Session Management**: Configure appropriate session timeouts
- **Input Validation**: All SAML inputs are validated by the toolkit
- **Logging**: Sensitive data is masked in logs

## 📝 API Reference

### SAMLService Methods

- `login(request, response, relayState)`: Initiate SAML authentication
- `processResponse(request)`: Process SAML response from IdP
- `logout(request, response, relayState)`: Initiate SAML logout
- `processLogoutResponse(request)`: Process logout response from IdP
- `getMetadata()`: Generate SP metadata XML

### Configuration Properties

See `src/main/resources/saml.properties` for all available configuration options.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:

1. Check the troubleshooting section above
2. Review application logs for detailed error information
3. Verify SAML configuration with your IdP
4. Create an issue in the repository

## 🔄 Version History

- **v1.0.0**: Initial release with complete SAML SSO implementation

---

**Built with ❤️ using Java, OneLogin SAML Toolkit, and Apache Tomcat** 