package com.sample.saml.model;

import java.util.List;
import java.util.Map;

/**
 * SAML User Information Model
 * 
 * This class holds user information extracted from SAML assertions
 * after successful authentication. It includes the NameID, attributes,
 * and session information.
 * 
 * @author SAML SSO Sample App
 * @version 1.0.0
 */
public class SAMLUserInfo {
    
    private String nameId;
    private Map<String, List<String>> attributes;
    private String sessionIndex;
    private String notOnOrAfter;
    private String notBefore;
    
    /**
     * Default constructor
     */
    public SAMLUserInfo() {
        // Default constructor
    }
    
    /**
     * Constructor with basic user information
     * 
     * @param nameId the SAML NameID
     * @param attributes user attributes from SAML assertion
     * @param sessionIndex the session index
     */
    public SAMLUserInfo(String nameId, Map<String, List<String>> attributes, String sessionIndex) {
        this.nameId = nameId;
        this.attributes = attributes;
        this.sessionIndex = sessionIndex;
    }
    
    /**
     * Gets the SAML NameID (user identifier)
     * 
     * @return the NameID
     */
    public String getNameId() {
        return nameId;
    }
    
    /**
     * Sets the SAML NameID
     * 
     * @param nameId the NameID to set
     */
    public void setNameId(String nameId) {
        this.nameId = nameId;
    }
    
    /**
     * Gets the user attributes from SAML assertion
     * 
     * @return map of attribute names to attribute values
     */
    public Map<String, List<String>> getAttributes() {
        return attributes;
    }
    
    /**
     * Sets the user attributes
     * 
     * @param attributes the attributes to set
     */
    public void setAttributes(Map<String, List<String>> attributes) {
        this.attributes = attributes;
    }
    
    /**
     * Gets the SAML session index
     * 
     * @return the session index
     */
    public String getSessionIndex() {
        return sessionIndex;
    }
    
    /**
     * Sets the SAML session index
     * 
     * @param sessionIndex the session index to set
     */
    public void setSessionIndex(String sessionIndex) {
        this.sessionIndex = sessionIndex;
    }
    
    /**
     * Gets the assertion validity end time
     * 
     * @return the notOnOrAfter timestamp
     */
    public String getNotOnOrAfter() {
        return notOnOrAfter;
    }
    
    /**
     * Sets the assertion validity end time
     * 
     * @param notOnOrAfter the notOnOrAfter timestamp to set
     */
    public void setNotOnOrAfter(String notOnOrAfter) {
        this.notOnOrAfter = notOnOrAfter;
    }
    
    /**
     * Gets the assertion validity start time
     * 
     * @return the notBefore timestamp
     */
    public String getNotBefore() {
        return notBefore;
    }
    
    /**
     * Sets the assertion validity start time
     * 
     * @param notBefore the notBefore timestamp to set
     */
    public void setNotBefore(String notBefore) {
        this.notBefore = notBefore;
    }
    
    /**
     * Gets a specific attribute value (first value if multiple)
     * 
     * @param attributeName the name of the attribute
     * @return the first value of the attribute, or null if not found
     */
    public String getAttributeValue(String attributeName) {
        if (attributes != null && attributes.containsKey(attributeName)) {
            List<String> values = attributes.get(attributeName);
            if (values != null && !values.isEmpty()) {
                return values.get(0);
            }
        }
        return null;
    }
    
    /**
     * Gets all values for a specific attribute
     * 
     * @param attributeName the name of the attribute
     * @return list of attribute values, or null if not found
     */
    public List<String> getAttributeValues(String attributeName) {
        if (attributes != null && attributes.containsKey(attributeName)) {
            return attributes.get(attributeName);
        }
        return null;
    }
    
    /**
     * Checks if the user has a specific attribute
     * 
     * @param attributeName the name of the attribute
     * @return true if the attribute exists and has values
     */
    public boolean hasAttribute(String attributeName) {
        if (attributes != null && attributes.containsKey(attributeName)) {
            List<String> values = attributes.get(attributeName);
            return values != null && !values.isEmpty();
        }
        return false;
    }
    
    @Override
    public String toString() {
        return "SAMLUserInfo{" +
                "nameId='" + nameId + '\'' +
                ", sessionIndex='" + sessionIndex + '\'' +
                ", attributesCount=" + (attributes != null ? attributes.size() : 0) +
                '}';
    }
} 