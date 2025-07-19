# 🔐 Keycloak SAML Configuration Guide

This guide will help you get the SAML configuration details from Keycloak to configure your Java SAML SSO application.

## 📋 **Prerequisites**
- Keycloak server running and accessible
- Admin access to Keycloak
- Your Java SAML application running on `https://localhost:8899/java-saml-sso/`

## 🚀 **Step-by-Step Configuration**

### **Step 1: Access Keycloak Admin Console**
1. Open your browser and go to: `https://your-keycloak-domain/auth/admin/`
2. Login with your admin credentials

### **Step 2: Create a New Realm (if needed)**
1. In the top-left dropdown, select "Create Realm"
2. Enter a realm name (e.g., "saml-demo")
3. Click "Create"

### **Step 3: Create a New Client**
1. In the left sidebar, click "Clients"
2. Click "Create" button
3. Fill in the following details:
   - **Client ID**: `java-saml-sso`
   - **Client Protocol**: `saml`
   - **Client SAML Endpoint**: `https://localhost:8899/java-saml-sso/saml/metadata`
4. Click "Save"

### **Step 4: Configure Client Settings**
1. In the client settings, go to the "Settings" tab
2. Configure the following:
   - **Valid Redirect URIs**: `https://localhost:8899/java-saml-sso/*`
   - **Base URL**: `https://localhost:8899/java-saml-sso/`
   - **Master SAML Processing URL**: `https://localhost:8899/java-saml-sso/saml/SSO`
   - **Service Accounts Enabled**: `OFF`
   - **Authorization Enabled**: `OFF`

### **Step 5: Get Identity Provider Details**

#### **A. Get Entity ID**
1. Go to "Realm Settings" in the left sidebar
2. Click on "General" tab
3. Copy the "Realm name" - this is your `idp.entityId`

#### **B. Get SSO and Logout URLs**
1. In "Realm Settings" → "General" tab
2. Note your realm name (e.g., "saml-demo")
3. Your URLs will be:
   - **SSO URL**: `https://your-keycloak-domain/auth/realms/saml-demo/protocol/saml`
   - **Logout URL**: `https://your-keycloak-domain/auth/realms/saml-demo/protocol/saml/logout`

#### **C. Get X.509 Certificate**
1. Go to "Realm Settings" → "Keys" tab
2. Look for the "Certificate" section
3. Copy the certificate content (starts with `-----BEGIN CERTIFICATE-----`)
4. This is your `idp.x509cert`

### **Step 6: Download Service Provider Metadata**
1. Go to your client: "Clients" → "java-saml-sso"
2. Click on the "Installation" tab
3. Select "SAML Metadata" format
4. Download the XML file
5. This contains all the IdP configuration details

## 📝 **Configuration Values**

Based on your setup, here are the values you'll need:

### **Service Provider Configuration (Your Java App)**
```properties
sp.entityId=https://localhost:8899/java-saml-sso/saml/metadata
sp.assertionConsumerService.url=https://localhost:8899/java-saml-sso/saml/acs
sp.singleLogoutService.url=https://localhost:8899/java-saml-sso/saml/sls
```

### **Identity Provider Configuration (Keycloak)**
```properties
# Replace with your actual Keycloak details
idp.entityId=https://your-keycloak-domain/auth/realms/saml-demo
idp.singleSignOnService.url=https://your-keycloak-domain/auth/realms/saml-demo/protocol/saml
idp.singleLogoutService.url=https://your-keycloak-domain/auth/realms/saml-demo/protocol/saml/logout
idp.x509cert=-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
```

## 🔧 **Quick Setup Script**

Create a file called `keycloak-setup.sh` with the following content:

```bash
#!/bin/bash

echo "🔐 Keycloak SAML Configuration Helper"
echo "====================================="

echo ""
echo "📋 Please provide the following information:"
echo ""

read -p "Enter your Keycloak domain (e.g., keycloak.example.com): " KEYCLOAK_DOMAIN
read -p "Enter your realm name (e.g., saml-demo): " REALM_NAME

echo ""
echo "✅ Your configuration values:"
echo "============================"
echo ""
echo "# Service Provider Configuration (Your Java App)"
echo "sp.entityId=https://localhost:8899/java-saml-sso/saml/metadata"
echo "sp.assertionConsumerService.url=https://localhost:8899/java-saml-sso/saml/acs"
echo "sp.singleLogoutService.url=https://localhost:8899/java-saml-sso/saml/sls"
echo ""
echo "# Identity Provider Configuration (Keycloak)"
echo "idp.entityId=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}"
echo "idp.singleSignOnService.url=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}/protocol/saml"
echo "idp.singleLogoutService.url=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}/protocol/saml/logout"
echo ""
echo "🔑 Next steps:"
echo "1. Go to Keycloak Admin Console: https://${KEYCLOAK_DOMAIN}/auth/admin/"
echo "2. Create a new client with ID: java-saml-sso"
echo "3. Set client protocol to: saml"
echo "4. Download the X.509 certificate from Realm Settings → Keys"
echo "5. Update your saml.properties file with these values"
```

## 🚨 **Important Notes**

1. **HTTPS Required**: Make sure your Keycloak server is running on HTTPS
2. **Certificate**: The X.509 certificate is crucial for SAML security
3. **Realm Name**: Use a descriptive realm name for your application
4. **Client ID**: Must match your application's entity ID
5. **Redirect URIs**: Ensure all your application URLs are properly configured

## 🔍 **Troubleshooting**

### **Common Issues:**
1. **Certificate Issues**: Make sure to copy the entire certificate including BEGIN/END markers
2. **URL Mismatches**: Double-check all URLs match exactly
3. **Realm Configuration**: Ensure the realm is properly configured in Keycloak
4. **Client Settings**: Verify all client settings are correct

### **Testing:**
1. Use Keycloak's built-in SAML testing tools
2. Check browser developer tools for SAML request/response
3. Verify certificate validity
4. Test both SSO and SLO flows

## 📞 **Need Help?**

If you encounter issues:
1. Check Keycloak server logs
2. Verify network connectivity
3. Ensure all URLs are accessible
4. Review SAML configuration in both Keycloak and your application
``` 