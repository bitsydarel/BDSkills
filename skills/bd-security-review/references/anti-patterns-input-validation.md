# Anti-patterns: Input Validation

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure. Each pattern includes signs to look for, its impact, and a concrete fix.

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

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
