#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🔐 Keycloak SAML Configuration Helper${NC}"
echo -e "${PURPLE}=====================================${NC}"

echo ""
echo -e "${CYAN}📋 Please provide the following information:${NC}"
echo ""

read -p "Enter your Keycloak domain (e.g., keycloak.example.com): " KEYCLOAK_DOMAIN
read -p "Enter your realm name (e.g., saml-demo): " REALM_NAME

echo ""
echo -e "${GREEN}✅ Your configuration values:${NC}"
echo -e "${GREEN}============================${NC}"
echo ""
echo -e "${YELLOW}# Service Provider Configuration (Your Java App)${NC}"
echo "sp.entityId=https://localhost:8899/java-saml-sso/saml/metadata"
echo "sp.assertionConsumerService.url=https://localhost:8899/java-saml-sso/saml/acs"
echo "sp.singleLogoutService.url=https://localhost:8899/java-saml-sso/saml/sls"
echo ""
echo -e "${YELLOW}# Identity Provider Configuration (Keycloak)${NC}"
echo "idp.entityId=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}"
echo "idp.singleSignOnService.url=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}/protocol/saml"
echo "idp.singleLogoutService.url=https://${KEYCLOAK_DOMAIN}/auth/realms/${REALM_NAME}/protocol/saml/logout"
echo ""
echo -e "${BLUE}🔑 Next steps:${NC}"
echo "1. Go to Keycloak Admin Console: https://${KEYCLOAK_DOMAIN}/auth/admin/"
echo "2. Create a new client with ID: java-saml-sso"
echo "3. Set client protocol to: saml"
echo "4. Download the X.509 certificate from Realm Settings → Keys"
echo "5. Update your saml.properties file with these values"
echo ""
echo -e "${RED}⚠️  Important:${NC}"
echo "- Make sure your Keycloak server is running on HTTPS"
echo "- Copy the entire X.509 certificate including BEGIN/END markers"
echo "- Ensure all URLs are accessible from your application"
echo ""
echo -e "${GREEN}📖 For detailed instructions, see: KEYCLOAK_SAML_SETUP.md${NC}" 