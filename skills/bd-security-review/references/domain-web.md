# Security Review — Web Applications

## Domain context

Web applications face the broadest attack surface of any domain: public-facing, accessible from any browser, subject to cross-origin attacks, and dependent on client-side execution in an untrusted environment. The browser is both the delivery mechanism and a significant threat vector (XSS, CSRF, clickjacking, cookie theft). Modern SPAs add complexity with client-side routing, state management, and API-heavy architectures.

## OWASP Web Top 10 (2025) mapping

| OWASP # | Risk | Mapped Criteria |
|---------|------|----------------|
| A01:2025 | Broken Access Control | A2: Authorization |
| A02:2025 | Cryptographic Failures | A4: Data Protection |
| A03:2025 | Injection | A3: Input Validation |
| A04:2025 | Insecure Design | T2: Threat Modeling |
| A05:2025 | Security Misconfiguration | O3: Infrastructure Hardening |
| A06:2025 | Vulnerable and Outdated Components | A5: Supply Chain |
| A07:2025 | Identification and Authentication Failures | A1: Authentication |
| A08:2025 | Software and Data Integrity Failures | A5: Supply Chain |
| A09:2025 | Security Logging and Monitoring Failures | O1: Security Logging |
| A10:2025 | Server-Side Request Forgery (SSRF) | A3: Input Validation |

## Criterion interpretation for web applications

| Criterion | Web-Specific Interpretation |
|-----------|---------------------------|
| T1 | Map all routes, WebSocket endpoints, form actions, file upload paths, OAuth callbacks, webhook receivers |
| T2 | Apply STRIDE to each page/route considering browser-specific threats (XSS as Info Disclosure, CSRF as Spoofing) |
| T3 | Browser → CDN → server is first trust boundary. Same-origin policy is a trust mechanism — CSP extends it |
| A1 | Cookie-based sessions with Secure/HttpOnly/SameSite flags. CSRF protection. OAuth 2.0/OIDC for SSO |
| A2 | Server-side authorization for every route. IDOR protection. CORS policy limiting cross-origin access |
| A3 | XSS prevention via context-aware output encoding and CSP. SQL injection via parameterized queries. Path traversal checks |
| A4 | TLS 1.2+ for all connections. HSTS header. Secure cookie flags. No sensitive data in URLs or localStorage |
| A5 | NPM/CDN dependency integrity (SRI hashes). Lock files with integrity verification. No inline third-party scripts without CSP |
| A6 | Framework-specific secure defaults (auto-escaping in templates, CSRF tokens). Error pages without stack traces |
| A7 | CSP frame-ancestors for clickjacking. Clear security indicators. No dark patterns in cookie consent |
| O1 | Log auth events, failed access attempts, CSP violations (report-uri/report-to) |
| O3 | Security headers (CSP, HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy) |

## Top 5 web-specific anti-patterns

### 1. CSP Theater

**Signs**: CSP with `unsafe-inline`, `unsafe-eval`, or wildcard `*` domains. CSP in report-only mode permanently. No CSP at all despite running an SPA.

**Impact**: XSS attacks succeed despite having a "CSP in place." False security confidence in audit reports.

**Fix**: Deploy CSP with nonce-based inline scripts, no `unsafe-eval`, explicit domain allowlists. Use report-uri to monitor violations before enforcing.

---

### 2. Cookie Misconfiguration

**Signs**: Session cookies without `Secure`, `HttpOnly`, or `SameSite` attributes. `SameSite=None` without understanding cross-site implications. Cookies accessible via JavaScript.

**Impact**: Session hijacking via XSS (no HttpOnly), cookie theft over HTTP (no Secure), CSRF attacks (no SameSite).

**Fix**: All session cookies: `Secure; HttpOnly; SameSite=Strict` (or `Lax` for OAuth flows). Non-session cookies: evaluate each attribute individually.

---

### 3. CORS Wildcard

**Signs**: `Access-Control-Allow-Origin: *` on authenticated endpoints. Origin reflected from request header without validation. Credentials allowed with wildcard origins.

**Impact**: Any website can make authenticated cross-origin requests, stealing data or performing actions on behalf of the user.

**Fix**: Explicitly allowlist trusted origins. Never reflect the request Origin without validation. Never combine `Access-Control-Allow-Credentials: true` with wildcard origins.

---

### 4. Client-Side Secret Storage

**Signs**: API keys, tokens, or secrets stored in localStorage, sessionStorage, or hardcoded in JavaScript. JWT tokens in localStorage (accessible via XSS).

**Impact**: Any XSS vulnerability exposes all client-side stored secrets. localStorage persists across sessions with no expiration.

**Fix**: Use HttpOnly cookies for session tokens. Store API keys server-side. If client-side storage is necessary, use short-lived tokens with server-side refresh.

---

### 5. Template Injection Ignorance

**Signs**: User input embedded in server-side templates without escaping. Client-side template engines processing untrusted data. Markdown renderers allowing raw HTML.

**Impact**: Server-side template injection (SSTI) leads to remote code execution. Client-side template injection enables XSS bypass of output encoding.

**Fix**: Use template engines with auto-escaping enabled by default. Never pass user input to template compilation functions. Sanitize markdown output with allowlisted HTML tags.

---

## Key controls checklist

- [ ] TLS 1.2+ with HSTS (max-age >= 1 year, includeSubDomains)
- [ ] CSP with nonce-based scripts, no unsafe-inline/unsafe-eval
- [ ] Secure cookie attributes (Secure, HttpOnly, SameSite)
- [ ] CSRF protection (SameSite cookies or synchronizer token)
- [ ] CORS restricted to explicit trusted origins
- [ ] Input validation server-side with parameterized queries
- [ ] Context-aware output encoding (HTML, URL, JS, CSS contexts)
- [ ] Subresource Integrity (SRI) for CDN-loaded scripts
- [ ] Security headers (X-Content-Type-Options, Referrer-Policy, Permissions-Policy)
- [ ] Rate limiting on auth and sensitive endpoints
- [ ] File upload validation (type, size, content, stored outside web root)
- [ ] No sensitive data in URLs, localStorage, or client-side code

## Company practices

- **Google**: Strict CSP across all properties, Trusted Types for DOM XSS prevention, BeyondCorp zero trust for internal apps
- **Netflix**: Automated security testing in CI/CD, custom CSP monitoring, lemur for certificate management
- **Spotify**: OAuth 2.0 with PKCE for all web flows, centralized auth service, automated DAST scanning
- **Microsoft**: SDL integrated in Azure DevOps, ASVS-aligned verification, Edge browser security features as defense layer

## Tools and standards

- **DAST**: OWASP ZAP, Burp Suite, Nuclei
- **Headers**: securityheaders.com, Mozilla Observatory
- **CSP**: CSP Evaluator (Google), report-uri.com
- **TLS**: SSL Labs Server Test, testssl.sh
- **Standards**: OWASP ASVS 5.0, OWASP Web Top 10 2025, Mozilla Web Security Guidelines
