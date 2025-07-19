#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🔍 SAML Configuration Validator${NC}"
echo -e "${PURPLE}==============================${NC}"

SAML_PROPERTIES_FILE="src/main/resources/saml.properties"

# Check if file exists
if [ ! -f "$SAML_PROPERTIES_FILE" ]; then
    echo -e "${RED}❌ Error: $SAML_PROPERTIES_FILE not found!${NC}"
    exit 1
fi

echo -e "${CYAN}📋 Validating SAML configuration...${NC}"
echo ""

# Function to extract and validate property
validate_property() {
    local property_name=$1
    local expected_pattern=$2
    local description=$3
    
    local value=$(grep "^$property_name=" "$SAML_PROPERTIES_FILE" | cut -d'=' -f2-)
    
    if [ -z "$value" ]; then
        echo -e "${RED}❌ $property_name: NOT SET${NC}"
        echo -e "${YELLOW}   Description: $description${NC}"
        return 1
    elif [[ $value =~ $expected_pattern ]]; then
        echo -e "${GREEN}✅ $property_name: $value${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  $property_name: $value${NC}"
        echo -e "${YELLOW}   Expected pattern: $expected_pattern${NC}"
        return 1
    fi
}

# Validate Service Provider Configuration
echo -e "${BLUE}🔧 Service Provider Configuration:${NC}"
validate_property "sp.entityId" "https://localhost:8899/java-saml-sso/saml/metadata" "SP Entity ID"
validate_property "sp.assertionConsumerService.url" "https://localhost:8899/java-saml-sso/saml/acs" "ACS URL"
validate_property "sp.singleLogoutService.url" "https://localhost:8899/java-saml-sso/saml/sls" "SLO URL"

echo ""

# Validate Identity Provider Configuration
echo -e "${BLUE}🔐 Identity Provider Configuration:${NC}"
validate_property "idp.entityId" "https://.*/auth/realms/.*" "IdP Entity ID"
validate_property "idp.singleSignOnService.url" "https://.*/auth/realms/.*/protocol/saml" "SSO URL"
validate_property "idp.singleLogoutService.url" "https://.*/auth/realms/.*/protocol/saml/logout" "SLO URL"

# Check for X.509 certificate
cert_value=$(grep "^idp.x509cert=" "$SAML_PROPERTIES_FILE" | cut -d'=' -f2-)
if [ -n "$cert_value" ]; then
    echo -e "${GREEN}✅ idp.x509cert: SET${NC}"
else
    echo -e "${RED}❌ idp.x509cert: NOT SET${NC}"
    echo -e "${YELLOW}   Description: IdP X.509 certificate is required for SAML security${NC}"
fi

echo ""

# Validate SAML Protocol Settings
echo -e "${BLUE}⚙️  SAML Protocol Settings:${NC}"
validate_property "saml.protocol.binding" "(HTTP-POST|HTTP-Redirect)" "Protocol Binding"
validate_property "saml.nameIdFormat" "urn:oasis:names:tc:SAML:.*" "NameID Format"
validate_property "saml.requestedAuthnContext" "urn:oasis:names:tc:SAML:.*" "Authn Context"

echo ""

# Validate Security Settings
echo -e "${BLUE}🔒 Security Settings:${NC}"
validate_property "saml.security.wantAssertionsSigned" "(true|false)" "Want Assertions Signed"
validate_property "saml.security.authnRequestsSigned" "(true|false)" "Authn Requests Signed"
validate_property "saml.security.logoutRequestSigned" "(true|false)" "Logout Request Signed"

echo ""

# Check for common issues
echo -e "${BLUE}🔍 Common Issues Check:${NC}"

# Check if port 8080 is still being used
if grep -q "localhost:8080" "$SAML_PROPERTIES_FILE"; then
    echo -e "${RED}❌ Found references to port 8080 - should be 8899${NC}"
else
    echo -e "${GREEN}✅ Port configuration is correct (8899)${NC}"
fi

# Check if Keycloak URLs have /auth/ prefix
if grep -q "idp\.entityId=https://.*/realms/" "$SAML_PROPERTIES_FILE"; then
    echo -e "${YELLOW}⚠️  IdP URLs might be missing /auth/ prefix${NC}"
else
    echo -e "${GREEN}✅ IdP URLs have correct format${NC}"
fi

# Check if certificate is properly formatted
if grep -q "^idp.x509cert=" "$SAML_PROPERTIES_FILE"; then
    cert_line=$(grep "^idp.x509cert=" "$SAML_PROPERTIES_FILE")
    if [[ $cert_line =~ ^idp\.x509cert=$ ]]; then
        echo -e "${RED}❌ X.509 certificate is empty${NC}"
    else
        echo -e "${GREEN}✅ X.509 certificate is set${NC}"
    fi
fi

echo ""
echo -e "${CYAN}📖 Configuration Summary:${NC}"
echo "=================================="

# Count total properties
total_props=$(grep -c "^[a-z]" "$SAML_PROPERTIES_FILE")
echo "Total SAML properties: $total_props"

# Count required properties
required_props=("sp.entityId" "sp.assertionConsumerService.url" "sp.singleLogoutService.url" 
               "idp.entityId" "idp.singleSignOnService.url" "idp.singleLogoutService.url" 
               "idp.x509cert")

missing_count=0
for prop in "${required_props[@]}"; do
    if ! grep -q "^$prop=" "$SAML_PROPERTIES_FILE"; then
        ((missing_count++))
    fi
done

if [ $missing_count -eq 0 ]; then
    echo -e "${GREEN}✅ All required properties are configured${NC}"
else
    echo -e "${RED}❌ Missing $missing_count required properties${NC}"
fi

echo ""
echo -e "${PURPLE}🚀 Ready to deploy with SAML configuration!${NC}" 