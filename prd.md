---

## 📄 Product Requirements Document (PRD)

### Project Title:

**Java SAML SSO Sample App using OneLogin Java Toolkit**

---

### 1. **Purpose**

To develop a Java web application that demonstrates how to implement **SAML 2.0-based Single Sign-On (SSO)** using the **OneLogin Java Toolkit**. This sample application will act as a **SAML Service Provider (SP)** and authenticate users via a SAML-compliant Identity Provider (IdP) like **OneLogin** or **Keycloak**.

---

### 2. **Scope**

* Build a deployable Java web application (WAR)
* Integrate SAML 2.0 SSO using the OneLogin toolkit
* Allow SAML-based login and logout flows
* Validate SAML assertions and establish user sessions
* Compatible with servlet containers like Apache Tomcat

---

### 3. **Assumptions**

* Java 8 or later is used
* Apache Tomcat 9.x is used for local deployment
* Developer has access to a SAML IdP (OneLogin, Keycloak, Okta, etc.)
* HTTPS configuration is out of scope for this version (can be added later)

---

### 4. **Out of Scope**

* OAuth2 or OIDC login mechanisms
* Integration with Spring Security
* Multi-tenancy
* Production-grade user management or session storage

---

### 5. **Requirements**

#### 5.1 Functional Requirements

| ID  | Requirement Description                                                                                       |
| --- | ------------------------------------------------------------------------------------------------------------- |
| FR1 | The application shall expose a home page accessible without login                                             |
| FR2 | The application shall have a "Login via SAML" button                                                          |
| FR3 | The application shall redirect the user to the IdP for authentication                                         |
| FR4 | The application shall consume and validate the SAML Response at the Assertion Consumer Service (ACS) endpoint |
| FR5 | The application shall create a session after successful login and display a welcome page                      |
| FR6 | The application shall expose SP metadata at `/metadata.jsp`                                                   |
| FR7 | The application shall support Single Logout (SLO) via `/sls.jsp`                                              |
| FR8 | The application shall read its SAML configuration from a properties file (`saml.properties`)                  |

#### 5.2 Non-Functional Requirements

| ID   | Requirement Description                                                                   |
| ---- | ----------------------------------------------------------------------------------------- |
| NFR1 | The application shall use Maven for dependency management                                 |
| NFR2 | The application shall be deployable as a WAR on Apache Tomcat                             |
| NFR3 | The application shall include instructions for configuring the IdP (OneLogin or Keycloak) |
| NFR4 | The application shall log SAML assertions and validation results for debugging            |

---

### 6. **Architecture & Design**

#### High-Level Flow:

1. User visits homepage
2. Clicks “Login with SAML” → SP generates AuthnRequest
3. User is redirected to IdP
4. User authenticates at IdP
5. IdP returns SAMLResponse to ACS endpoint
6. Toolkit verifies SAML Response, extracts user identity
7. App creates a user session and redirects to welcome page
8. User may initiate logout which hits `/sls.jsp`

#### Key Components:

| Component         | Description                                |
| ----------------- | ------------------------------------------ |
| `index.jsp`       | Home page                                  |
| `login.jsp`       | Starts SAML SSO                            |
| `acs.jsp`         | Handles SAML response                      |
| `metadata.jsp`    | Provides SP metadata                       |
| `sls.jsp`         | Handles Single Logout                      |
| `saml.properties` | Configuration file for SP and IdP metadata |

---

### 7. **Deliverables**

* Java web app source code (Maven project)
* `README.md` with setup & configuration steps
* Sample `saml.properties`
* WAR file for deployment
* Screenshots or screencast of working login/logout

---

### 8. **Timeline**

| Task                        | Estimated Duration |
| --------------------------- | ------------------ |
| Environment Setup           | 1 day              |
| Project Scaffold            | 1 day              |
| SAML Toolkit Integration    | 2 days             |
| UI JSP Pages Development    | 1 day              |
| IdP Configuration & Testing | 1 day              |
| Packaging & Documentation   | 1 day              |
| **Total**                   | **7 days**         |

---

### 9. **Risks and Mitigations**

| Risk                                | Mitigation                                 |
| ----------------------------------- | ------------------------------------------ |
| Misconfiguration of SAML properties | Provide sample config with comments        |
| Time sync issues between IdP and SP | Sync system clocks or adjust SAML settings |
| Deployment failures on Tomcat       | Validate with test deployment scripts      |

---

### 10. **Success Criteria**

* Application is able to initiate SAML login
* IdP authentication is successful
* User session is created post-authentication
* SP metadata is correctly served and consumed by IdP
* Logout successfully terminates the session and redirects to IdP logout

---