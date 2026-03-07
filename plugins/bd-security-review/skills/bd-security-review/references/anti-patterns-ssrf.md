# Anti-patterns: Input Validation & SSRF

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of Server-Side Request Forgery (SSRF), where an attacker abuses server-side functionality to make requests to unintended destinations. SSRF weaponizes the server's trusted network position, enabling access to internal services, cloud metadata endpoints, and private infrastructure.

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

## Allowlist Bypass — Critical

**Signs**: URL validation using regex matching on the raw URL string. Hostname comparison against a blocklist of known-bad values. IP range checks that only handle dotted-decimal notation. URL parsing that does not account for encoding variants. Validation performed on the original URL but not on the resolved IP address.

**Impact**: Attacker bypasses URL validation using IP encoding variants: decimal notation (2130706433 for 127.0.0.1), octal notation (017700000001), hexadecimal (0x7f000001), IPv6-mapped addresses ([::ffff:127.0.0.1]), mixed notation (127.1 as shorthand), and URL encoding of hostname components. DNS rebinding attacks resolve an attacker-controlled domain to an internal IP after the validation check. Open redirect chains on allowed domains redirect to internal targets.

**Fix**: Parse the URL, resolve DNS, and validate the resolved IP address — not the hostname — against a denylist of private and reserved ranges: 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16, ::1, fc00::/7, fe80::/10. Validate AFTER DNS resolution, not before. Re-validate on every redirect hop.

**Detection**:
- *Code patterns*: Regex-based URL validation; hostname string comparison against blocklists; URL passed to HTTP client without post-DNS-resolution IP validation; no redirect validation logic
- *Review questions*: Is URL validation performed before or after DNS resolution? Does the validation handle IPv6, decimal IP, octal IP, and URL-encoded variants? Are redirects re-validated?
- *Test methods*: Send requests with IP encoding variants (decimal, hex, octal, IPv6-mapped) targeting 127.0.0.1. Test DNS rebinding with a domain that alternates between external and internal IPs. Test redirect chains through an external server that redirects to an internal target

---

## Cloud Metadata Exposure — Critical

**Signs**: No network-level or application-level protection against requests to cloud metadata endpoints. Application runs on AWS, GCP, or Azure without IMDSv2 enforcement. URL validation does not block the link-local IP range 169.254.0.0/16. No firewall rules preventing application-tier access to metadata services.

**Impact**: Attacker reaches cloud metadata endpoints to steal IAM credentials, API keys, and infrastructure secrets. AWS IMDSv1 at the link-local address returns temporary credentials with a simple GET request. Azure IMDS requires a Metadata header but is still exploitable. GCP metadata via the internal hostname returns service account tokens. Stolen credentials enable full infrastructure compromise: S3 bucket access, RDS database access, EC2 instance control, privilege escalation through IAM roles.

**Fix**: Block requests to the link-local range (169.254.0.0/16) in URL validation. Enforce IMDSv2 on all AWS instances (requires PUT request with token header, which SSRF cannot easily perform). Configure network-level metadata endpoint protection: AWS instance metadata service hop limit of 1, GCP Workload Identity, Azure managed identity with network restrictions. Use VPC firewall rules to restrict outbound traffic from application instances.

**Detection**:
- *Code patterns*: No IP range validation for link-local addresses in URL processing; AWS infrastructure configured without IMDSv2 enforcement; no outbound firewall rules for application tier
- *Review questions*: Can the application make requests to the link-local metadata address? Is IMDSv2 enforced on all cloud instances? Are there network-level controls preventing metadata access from the application tier?
- *Test methods*: Attempt SSRF to metadata endpoints and variants. Check AWS instance metadata configuration for IMDSv2 enforcement. Verify firewall rules block application-to-metadata-endpoint traffic

---

## Blind SSRF Ignored — Major

**Signs**: SSRF protections only applied to endpoints that return response content to the user. Webhook URLs, callback URLs, import URLs, and PDF/image generation endpoints not covered by URL validation. No outbound connection monitoring. Assumption that "if the response is not returned, SSRF is not exploitable."

**Impact**: Blind SSRF (where the response is not returned to the attacker) is still dangerous. It enables: port scanning of internal networks (open/closed ports produce different response times), reaching internal services that perform actions on request (admin endpoints, cache invalidation, deployment triggers), exfiltrating data via DNS lookups (encoding data in subdomain queries to attacker-controlled DNS), and timing side channels that reveal internal network topology.

**Fix**: Apply the same URL validation policy to ALL outbound requests regardless of whether the response is returned. This includes: webhook delivery, URL imports, PDF generation from URLs, image fetching, link preview generation, RSS feed fetching, and any other feature that makes server-side HTTP requests. Monitor outbound connections from application servers for unexpected internal destinations.

**Detection**:
- *Code patterns*: URL validation applied inconsistently — present on some endpoints but missing on webhook, callback, or import features; outbound HTTP requests without centralized URL validation middleware
- *Review questions*: Are ALL features that make outbound HTTP requests subject to the same URL validation? Is outbound traffic from application servers monitored? Are there features that accept URLs but do not return the response?
- *Test methods*: Identify all features that accept URLs as input. Test each with internal IP targets and cloud metadata endpoints. Use a collaborator tool to detect blind SSRF via DNS/HTTP callbacks

---

## Protocol Smuggling — Major

**Signs**: URL scheme not restricted before making requests. HTTP client library supports multiple protocols (file, ftp, gopher, dict, ldap, tftp). No protocol allowlist at the URL validation layer. User-supplied URLs passed to libraries that support non-HTTP protocols.

**Impact**: Non-HTTP protocols enable attacks beyond standard SSRF. The file protocol reads local files. The gopher protocol sends arbitrary TCP payloads to internal services (Redis, Memcached, SMTP — enabling command injection on internal services). The dict protocol probes service banners. The ftp protocol reads files from internal FTP servers. These attacks bypass HTTP-focused SSRF protections.

**Fix**: Allowlist only http and https schemes at the URL parsing stage, before any request is made. Reject all other schemes unconditionally. Do not rely on the HTTP client library to restrict protocols — validate at the application layer.

**Detection**:
- *Code patterns*: URL passed to HTTP client without scheme validation; HTTP client configured to support multiple protocols; no URL scheme allowlist in validation logic
- *Review questions*: Does the URL validation restrict the scheme to http/https? Does the HTTP client library support non-HTTP protocols by default?
- *Test methods*: Submit URLs with non-HTTP schemes. Verify they are rejected before any request is made. Test with mixed-case scheme variants

---

## Redirect Chain Abuse — Major

**Signs**: HTTP client follows redirects with default settings (most libraries follow redirects automatically). No redirect limit configured. Redirect destinations not re-validated against the URL policy. Initial URL passes validation but the redirect target is not checked.

**Impact**: Attacker hosts a URL on an allowed external domain that returns a 302 redirect to an internal target. The initial URL passes validation, but the HTTP client follows the redirect to the internal target without re-checking. Multi-hop redirects through multiple external servers can chain past even some redirect-aware protections.

**Fix**: Disable automatic redirect following in the HTTP client. Manually handle each redirect: extract the Location header, validate the redirect URL against the same SSRF protection policy, then make a new request if valid. Set a maximum redirect count (3-5 hops). For headless browser scenarios, intercept navigation events and validate each URL.

**Detection**:
- *Code patterns*: HTTP client used with default redirect settings; no redirect validation callback configured; no maximum redirect limit set
- *Review questions*: Does the HTTP client follow redirects automatically? Are redirect destinations validated against the same URL policy? Is there a maximum redirect count?
- *Test methods*: Set up an external server that returns a 302 redirect to an internal IP. Test whether the SSRF protection catches the redirect. Test multi-hop redirects. Test with different redirect status codes (301, 302, 303, 307, 308)

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Allowlist Bypass | Critical | A3: Input Validation | Both |
| Cloud Metadata Exposure | Critical | A3: Input Validation, O3: Infrastructure | Both |
| Blind SSRF Ignored | Major | A3: Input Validation | Both |
| Protocol Smuggling | Major | A3: Input Validation | Both |
| Redirect Chain Abuse | Major | A3: Input Validation | Both |
