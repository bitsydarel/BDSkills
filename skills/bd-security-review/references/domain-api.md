# Security Review — APIs

## Domain context

APIs are the backbone of modern applications — every mobile app, SPA, microservice, and third-party integration communicates through them. Unlike web UIs, APIs expose raw functionality without browser-mediated protections (CSP, same-origin policy, cookie handling). API security failures are the #1 source of data breaches because APIs provide direct programmatic access to data and operations. REST, GraphQL, gRPC, and WebSocket each have distinct security considerations.

## OWASP API Security Top 10 (2023) mapping

| OWASP # | Risk | Mapped Criteria |
|---------|------|----------------|
| API1:2023 | Broken Object Level Authorization | A2: Authorization |
| API2:2023 | Broken Authentication | A1: Authentication |
| API3:2023 | Broken Object Property Level Authorization | A2: Authorization |
| API4:2023 | Unrestricted Resource Consumption | A6: Secure Coding |
| API5:2023 | Broken Function Level Authorization | A2: Authorization |
| API6:2023 | Unrestricted Access to Sensitive Business Flows | A7: UI/UX Security (anti-automation) |
| API7:2023 | Server Side Request Forgery | A3: Input Validation |
| API8:2023 | Security Misconfiguration | O3: Infrastructure Hardening |
| API9:2023 | Improper Inventory Management | T1: Attack Surface |
| API10:2023 | Unsafe Consumption of APIs | A5: Supply Chain |

## Criterion interpretation for APIs

| Criterion | API-Specific Interpretation |
|-----------|---------------------------|
| T1 | Enumerate all endpoints including undocumented/deprecated ones. OpenAPI/Swagger spec as source of truth. Version inventory |
| T2 | Apply STRIDE per endpoint: who can call it, what data flows through, what happens if input is malformed |
| T3 | API gateway as trust boundary. Internal vs external API segmentation. Third-party API consumption as trust crossing |
| A1 | OAuth 2.0 / API keys / JWT. Token validation on every request. No auth info in URLs. Short-lived tokens with refresh |
| A2 | Object-level authorization (IDOR prevention) on EVERY data-accessing endpoint. Function-level authorization for admin operations |
| A3 | Schema validation per endpoint. Rate limiting. Request size limits. SSRF prevention for URL-accepting parameters |
| A4 | TLS everywhere. No sensitive data in query params (logged by proxies). Response filtering (no over-fetching) |
| A5 | Third-party API consumption: validate responses, handle failures gracefully, pin TLS certificates where possible |
| A6 | Resource consumption limits: pagination, query depth (GraphQL), request size, timeout. Error responses without internals |
| A7 | Business logic abuse protection: rate limiting per user/IP, CAPTCHA for sensitive flows, anti-automation for enumeration |
| O1 | Log all API calls with correlation IDs. Alert on unusual patterns (bulk data access, enumeration, error spikes) |
| O3 | API gateway configuration: rate limits, auth enforcement, request validation. No debug endpoints in production |

## Top 5 API-specific anti-patterns

### 1. BOLA Blindness (Broken Object Level Authorization)

**Signs**: Endpoints using user-supplied IDs (`/api/users/{id}/orders`) without verifying the authenticated user owns that resource. "The frontend only shows the user's own data" as the authorization strategy.

**Impact**: Any authenticated user can access any other user's data by changing the ID. This is the #1 API vulnerability (API1:2023) and the most common source of data breaches.

**Fix**: Enforce authorization checks at the data access layer, not the API routing layer. Every query must filter by authenticated user context. Automated BOLA testing in CI/CD.

---

### 2. Mass Assignment

**Signs**: API accepts entire JSON objects and maps them directly to database models. No field-level allowlist for writable properties. User can set `isAdmin: true` or `price: 0` by including the field in the request body.

**Impact**: Privilege escalation, data manipulation, business logic bypass. An attacker can modify any field the ORM model exposes.

**Fix**: Define explicit DTOs/schemas for each endpoint's accepted input. Never bind request bodies directly to database models. Use allowlists for writable fields per endpoint per role.

---

### 3. GraphQL Depth Bomb

**Signs**: GraphQL API with no query depth or complexity limits. Introspection enabled in production. No per-query cost analysis or timeout.

**Impact**: Deeply nested queries exhaust server resources (DoS). Introspection reveals full schema to attackers. Batch queries bypass rate limiting.

**Fix**: Implement query depth limits (max 10-15 levels), complexity analysis (cost per field), and per-query timeout. Disable introspection in production. Apply rate limiting per query complexity, not just per request.

---

### 4. Zombie API Endpoints

**Signs**: Deprecated API versions still accessible. Internal/debug endpoints reachable from external networks. Endpoints not in OpenAPI spec but responding to requests. API inventory not maintained.

**Impact**: Old versions lack security patches. Internal endpoints lack authentication. Shadow APIs expand attack surface without monitoring.

**Fix**: Maintain a complete API inventory. Route all traffic through an API gateway with a positive security model (only registered endpoints allowed). Automatically retire deprecated versions with sunset headers and timelines.

---

### 5. Token Leakage

**Signs**: API tokens in URL query parameters (logged by proxies, CDNs, analytics). Tokens with excessive scope (admin token used for read-only operations). Long-lived tokens without rotation. Tokens logged in error messages.

**Impact**: Token theft via log access, proxy inspection, or browser history. Excessive token scope means one stolen token grants full access.

**Fix**: Tokens in Authorization header only. Short-lived tokens (15 min) with refresh token rotation. Minimum-scope tokens per operation. Never log tokens — mask in all log outputs.

---

## Key controls checklist

- [ ] Object-level authorization on every data-accessing endpoint
- [ ] Function-level authorization for admin/privileged operations
- [ ] Schema validation for all request inputs (body, query params, headers)
- [ ] Rate limiting per user, per IP, and per endpoint
- [ ] Request size limits and pagination enforcement
- [ ] Authentication token validation on every request
- [ ] No sensitive data in URL query parameters
- [ ] Response filtering (return only requested/needed fields)
- [ ] API versioning with deprecation and sunset policy
- [ ] Complete API inventory matching OpenAPI/Swagger spec
- [ ] GraphQL: depth limits, complexity analysis, introspection disabled in prod
- [ ] Correlation IDs in all requests for traceability

## Company practices

- **Google**: Centralized API gateway with per-method authorization, automated BOLA detection, gRPC with built-in auth
- **Netflix**: Zuul API gateway with custom security filters, API canary testing, automated rate limit tuning
- **Spotify**: OAuth 2.0 scoped tokens per API, centralized token validation service, API contract testing
- **Apple**: Certificate-pinned API communication, device attestation for API access, minimal response payloads

## Tools and standards

- **Testing**: OWASP ZAP API scan, Burp Suite, Postman security tests, dredd (contract testing)
- **Gateway**: Kong, AWS API Gateway, Envoy, Traefik
- **Spec**: OpenAPI 3.1, AsyncAPI (WebSocket/event-driven), gRPC proto definitions
- **Standards**: OWASP API Security Top 10 2023, OWASP ASVS 5.0 V4
