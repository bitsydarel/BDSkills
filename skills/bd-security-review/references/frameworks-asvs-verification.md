# ASVS 5.0 Verification Rubric

Maps OWASP ASVS 5.0 verification levels to the security review's 1-5 scoring scale. Use this when scoring Application Security criteria (Lens 2) and related criteria across other lenses.

## Scoring alignment

| ASVS Level | Review Score | Meaning |
|------------|-------------|---------|
| Not addressed | 1 (Missing) | No ASVS requirements met; fundamental flaws |
| Partial L1 | 2 (Weak) | Some L1 requirements met but significant gaps remain |
| L1 (Opportunistic) | 3 (Adequate) | Minimum viable security; automated tools can verify most |
| L2 (Standard) | 4 (Good) | Recommended for apps handling sensitive data; requires manual review |
| L3 (Advanced) | 5 (Excellent) | Critical apps (financial, healthcare, infrastructure); formal verification |

When scoring, identify the applicable ASVS chapters for the criterion, check requirements at each level, and assign the score matching the highest level fully satisfied.

---

## V1: Encoding and Sanitization → A3

**L1 key requirements (Score 3)**:
- Output encoding applied as the final step before the interpreter, using the interpreter's own encoding method where available
- Parameterized queries or equivalent safe APIs used for all database access — no string concatenation of user input into queries
- Context-specific encoding applied: HTML entities for HTML body, URL encoding for URLs, JS escaping for inline scripts
- Server-side input decoding happens exactly once into canonical form before any validation or processing

**L2 delta (Score 4)**:
- Injection prevention verified across all interpreter contexts: HTML, URL, JavaScript, CSS, OS command, LDAP, XPath, LaTeX, regex, CSV/formula, JNDI
- WYSIWYG/rich text editor input sanitized through an allowlist-based HTML sanitizer, not a blocklist
- SVG scriptable content and template language injection addressed
- Format string vulnerabilities prevented in all logging and string-formatting operations

**L3 delta (Score 5)**:
- Memory safety verified: buffer overflows, integer overflows, and use-after-free vulnerabilities addressed for unmanaged code
- XML parsers configured to restrict external entity resolution and DTD processing
- Deserialization restricted to allowlists or type-constrained mechanisms for untrusted input

**Common failures (Score 1-2)**:
- Blocklist-based XSS filtering (`if input.includes('<script>') reject`)
- SQL concatenation "for performance" or "just this one query"
- Client-side-only encoding with no server-side enforcement
- Single encoding strategy applied regardless of output context

---

## V2: Validation and Business Logic → A3, A6

**L1 key requirements (Score 3)**:
- Input validation rules documented for every trust boundary
- Server-side input validation enforced — client-side validation used only for usability
- Business logic enforces sequential flow without step-skipping
- Anti-automation controls prevent excessive requests that could enable data theft or DoS

**L2 delta (Score 4)**:
- Contextual consistency checks applied (e.g., shipping address matches billing country for high-risk orders)
- Business logic locking mechanisms prevent double-booking of limited resources
- Transactional controls ensure operations complete entirely or rollback to previous valid state
- Realistic human timing requirements prevent automated rapid submissions in critical workflows

**L3 delta (Score 5)**:
- Elevated-value transactions require multi-user approval
- Business logic constraints formally documented and tested against abuse scenarios
- Anti-automation includes behavioral analysis beyond simple rate limiting

**Common failures (Score 1-2)**:
- No server-side validation — frontend-only checks
- Business logic allows skipping checkout steps by directly calling later endpoints
- No rate limiting on resource-consuming operations
- Race conditions allow double-spending or double-booking

---

## V3: Web Frontend Security → A7

**L1 key requirements (Score 3)**:
- HSTS enforced with max-age of at least 1 year
- Sensitive cookies carry the `Secure` attribute
- Content rendered using safe methods (`createTextNode`, framework auto-escaping) to prevent unintended script execution
- Content-Security-Policy header set with `object-src 'none'`
- Anti-forgery tokens used for sensitive state-changing operations

**L2 delta (Score 4)**:
- CSP includes restrictive `script-src` (nonce-based or hash-based, no `unsafe-inline`)
- CORS origin validation implemented — wildcard not used for authenticated endpoints
- Sensitive cookies use `HttpOnly`, `SameSite`, and `__Host-` prefix
- Subresource Integrity (SRI) hashes applied to all third-party scripts and stylesheets
- JSONP disabled to prevent cross-site script inclusion

**L3 delta (Score 5)**:
- CSP reporting enabled with violation monitoring and alerting
- Encrypted Client Hello deployed for metadata protection
- All browser security headers comprehensively set and tested (Permissions-Policy, X-Content-Type-Options, Referrer-Policy)
- Third-party resource loading formally documented with security justification for each

**Common failures (Score 1-2)**:
- No CSP header; pages frameable by any origin
- Cookies missing `Secure`, `HttpOnly`, or `SameSite` attributes
- CORS allows wildcard origin for authenticated APIs
- No SRI on CDN-loaded scripts

---

## V4: API and Web Service → A3, A7

**L1 key requirements (Score 3)**:
- Every HTTP response with a body includes a correct `Content-Type` header matching actual content
- Unsupported HTTP methods return 405 and are not silently processed

**L2 delta (Score 4)**:
- HTTP request smuggling prevented through proper `Transfer-Encoding`/`Content-Length` handling
- Excessively large headers rejected to prevent denial of service
- GraphQL: query complexity limited through depth limiting, cost analysis, or allowlists
- GraphQL introspection disabled in production

**L3 delta (Score 5)**:
- WebSocket connections use WSS (TLS) exclusively
- WebSocket handshakes validate the `Origin` header
- WebSocket session tokens obtained through authenticated HTTPS, not reusing HTTP cookies
- All API contract validation automated in CI/CD

**Common failures (Score 1-2)**:
- No Content-Type validation; MIME confusion attacks possible
- GraphQL introspection exposed in production with no query limits
- WebSocket over plain WS without authentication
- No protection against HTTP request smuggling

---

## V5: File Handling → A3

**L1 key requirements (Score 3)**:
- File type validated by extension allowlist AND magic byte verification, not extension alone
- File size limits enforced to prevent denial-of-service
- Compressed file size validated before extraction (zip bomb prevention)
- Uploaded files stored outside web root or cannot be executed as server code

**L2 delta (Score 4)**:
- File paths use internally-generated names; user input never used in file paths
- Per-user storage quotas enforced
- Oversized images rejected to prevent pixel flood attacks
- Symlinks in archives blocked unless explicitly required

**L3 delta (Score 5)**:
- Untrusted files scanned with antivirus tools before processing
- File processing sandboxed in isolated environments
- Complete file handling documentation with risk assessment per file type

**Common failures (Score 1-2)**:
- Extension-only validation (`.jpg` renamed to `.php` bypasses)
- No file size limits; upload of multi-GB files possible
- Uploaded files executable via direct URL access
- User-controlled file paths enabling path traversal

---

## V6: Authentication → A1

**L1 key requirements (Score 3)**:
- Passwords minimum 8 characters, any composition allowed, no arbitrary complexity rules
- Passwords checked against breach databases and context-specific word lists
- Controls against credential stuffing and brute-force attacks with rate limiting
- Temporary credentials have defined expiration

**L2 delta (Score 4)**:
- MFA enforced for all users
- Authentication factor lifecycle managed: secure enrollment, revocation, expiration
- Password reset requires time-limited, single-use tokens with identity verification
- Email not used as an authentication mechanism (only for notifications)
- Authentication strength claims from identity providers validated

**L3 delta (Score 5)**:
- Hardware-based authentication required (FIDO2/WebAuthn), performed in attested/trusted execution environment
- Recovery processes match enrollment-level identity verification
- Identity provider assertions validated via digital signatures with spoofing prevention
- Authentication events fully auditable with tamper-evident logging

**Common failures (Score 1-2)**:
- Plaintext or MD5-hashed passwords
- No brute-force protection — unlimited login attempts
- Password reset sends new password via email instead of a reset link
- "Remember me" uses permanent plaintext cookie with user ID

---

## V7: Session Management → A1

**L1 key requirements (Score 3)**:
- Sessions use dynamically generated tokens, not static API keys
- Session validation performed on the trusted backend, not client-side
- Reference tokens have at least 128 bits of entropy from a CSPRNG
- Session inactivity timeout and absolute maximum lifetime defined and enforced

**L2 delta (Score 4)**:
- Sessions invalidated on logout, account deletion, and authentication factor changes
- Users can view and terminate all active sessions (after re-authentication)
- Session tokens rotated on privilege escalation
- Federated re-authentication enforced when session security level changes

**L3 delta (Score 5)**:
- Administrator-initiated session revocation supported
- Session binding to device or client fingerprint for anomaly detection

**Common failures (Score 1-2)**:
- Static API keys used as session identifiers
- Sessions never expire; infinite lifetime
- No session invalidation on password change
- Session tokens in URL query parameters

---

## V8: Authorization → A2

**L1 key requirements (Score 3)**:
- Authorization rules documented for functional, data-specific, and field-level access
- Server-side enforcement at a trusted service layer — no client-side-only authorization
- Explicit permissions at function and data levels
- Principle of least privilege applied

**L2 delta (Score 4)**:
- Object-level authorization prevents IDOR/BOLA on every endpoint
- Field-level authorization prevents BOPLA (mass assignment via API)
- Multi-tenant isolation enforced — tenants cannot access each other's data

**L3 delta (Score 5)**:
- Dynamic/contextual authorization evaluates attributes (location, time, device) at session initiation and during activity
- Administrative interfaces require additional security controls beyond standard authorization
- Authorization decisions logged and auditable
- Automated authorization testing in CI/CD verifies no bypass paths

**Common failures (Score 1-2)**:
- All users share one role; admin hidden behind UI routing but accessible via direct API
- Changing object ID in request returns another user's data (IDOR)
- No difference between "can view" and "can edit"
- Shared admin accounts with no individual accountability

---

## V9: Self-contained Tokens → A1, A2

**L1 key requirements (Score 3)**:
- Self-contained tokens validated using digital signature or MAC — tampering prevented
- Algorithm `None` explicitly rejected; algorithm allowlist enforced
- Key sources restricted to pre-configured trusted sources for the token issuer
- Temporal validity checked via `nbf` and `exp` claims
- Token type verified (access tokens for authorization, ID tokens for authentication)

**L2 delta (Score 4)**:
- Audience claim (`aud`) validated against service-specific allowlists
- When issuers reuse private keys across audiences, audience restriction enforced to prevent cross-service misuse
- Token issuer (`iss`) validated against known trusted issuers
- Token content does not leak sensitive data

**Common failures (Score 1-2)**:
- JWT signature not verified; accepts unsigned tokens
- No `exp` claim; tokens never expire
- `aud` claim ignored; token accepted by any service
- Algorithm confusion attacks possible (RS256 → HS256)

---

## V10: OAuth and OIDC → A1, A2

**L1 key requirements (Score 3)**:
- Authorization codes are single-use and short-lived (max 10 minutes)
- PKCE implemented for all OAuth clients
- Tokens sent only to components that strictly need them

**L2 delta (Score 4)**:
- Access and refresh tokens accessible only to backend in browser-based apps
- Client defends against authorization server mix-up attacks
- Refresh token rotation with invalidation on reuse
- Resource servers validate audience claims and enforce authorization based on delegated claims (scope, sub)
- User consent explicitly collected with clear information about permissions, client identity, and lifetime

**L3 delta (Score 5)**:
- Authorization codes valid for maximum 1 minute
- Sender-constrained tokens via DPoP or mutual TLS for public clients
- Full consent lifecycle management: grant, revoke, audit
- Authorization server hardened against all known OAuth attack vectors

**Common failures (Score 1-2)**:
- No PKCE; authorization code interception possible
- Tokens exposed to frontend JavaScript in browser apps
- Refresh tokens never expire and are not rotated
- No consent mechanism; permissions granted silently

---

## V11: Cryptography → A4

**L1 key requirements (Score 3)**:
- Only industry-validated cryptographic implementations used (no custom crypto)
- Minimum 128-bit cryptographic strength across all primitives
- Cryptographically secure random number generators used with minimum 128-bit entropy

**L2 delta (Score 4)**:
- Documented key management policy following NIST SP 800-57
- Current cryptographic inventory tracking all algorithms, keys, and certificates
- Authenticated encryption enforced (AES-GCM preferred); ECB mode prohibited
- MD5 prohibited for any cryptographic purpose; approved hash functions only
- Constant-time operations for cryptographic comparisons (timing attack prevention)
- Nonces and initialization vectors never reused

**L3 delta (Score 5)**:
- Crypto agility: algorithms swappable without major refactoring; migration path to post-quantum cryptography
- Encrypt-then-MAC when combining encryption with authentication
- Sensitive data protected during processing through full memory encryption
- Cryptographic operations isolated in dedicated security modules (HSM)

**Common failures (Score 1-2)**:
- MD5 or SHA1 used for security purposes
- ECB mode encryption
- Hardcoded encryption keys in source code
- Custom cryptographic implementations instead of vetted libraries

---

## V12: Secure Communication → A4

**L1 key requirements (Score 3)**:
- TLS used for all client-to-server HTTP connectivity; no fallback to unencrypted
- Publicly trusted certificates used for external-facing services
- Only recommended TLS protocol versions enabled (TLS 1.2+ minimum)

**L2 delta (Score 4)**:
- Only recommended cipher suites with forward secrecy
- Certificate revocation checking enabled (OCSP Stapling)
- Internal service-to-service communication encrypted with certificate validation
- Strong mutual authentication between services

**L3 delta (Score 5)**:
- Encrypted Client Hello for metadata protection
- mTLS between all internal services
- Certificate lifecycle fully automated with monitoring
- TLS configuration achieves top security ratings (e.g., SSL Labs A+)

**Common failures (Score 1-2)**:
- Plaintext HTTP for any endpoint
- TLS configured but internal service traffic unencrypted
- Self-signed certificates in production without proper trust chain
- Deprecated protocols (SSLv3, TLS 1.0/1.1) still enabled

---

## V13: Configuration → O3

**L1 key requirements (Score 3)**:
- All application communication needs documented including external dependencies

**L2 delta (Score 4)**:
- Backend components use individual service accounts, short-term tokens, or certificate-based auth (not shared static credentials)
- Secrets stored in a key vault/secrets manager; not in code or config files
- Least-privilege enforced for all services; allowlists control external connections
- Production environments: debug mode disabled, directory listing off, HTTP TRACE disabled, version headers removed
- Source control metadata (.git, .svn) inaccessible externally

**L3 delta (Score 5)**:
- Cryptographic operations isolated in dedicated security modules
- Secrets configured for automatic rotation
- All configuration documented and verified against hardening baselines (CIS benchmarks)
- Infrastructure as code with security controls codified and auditable

**Common failures (Score 1-2)**:
- Debug mode enabled in production
- Secrets hardcoded in source code or environment variables without vault
- Shared admin credentials across services
- .git directory exposed on web server

---

## V14: Data Protection → A4, G2

**L1 key requirements (Score 3)**:
- Sensitive data classified into protection tiers
- Sensitive data never included in URLs or query strings

**L2 delta (Score 4)**:
- Sensitive data does not accumulate in caches; anti-caching headers set (`Cache-Control: no-store`)
- Sensitive data not transmitted to untrusted third parties
- Minimal data returned to users (data minimization)
- Authenticated data cleared from browser storage after session termination
- Sensitive information excluded from local storage except session tokens
- Automatic deletion schedules for outdated sensitive data

**L3 delta (Score 5)**:
- Metadata stripped from user-submitted files unless explicitly consented
- Full data lifecycle management: creation, storage, transmission, archival, deletion
- Data protection controls verified through automated testing
- Privacy impact assessments for all data handling changes

**Common failures (Score 1-2)**:
- No data classification; all data treated equally
- Session tokens or PII in URL query strings
- Sensitive data cached indefinitely in browser
- No data retention or deletion policy

---

## V15: Secure Coding and Architecture → A5, A6, T1-T4

**L1 key requirements (Score 3)**:
- Third-party components inventoried (SBOM)
- Vulnerability remediation timeframes documented

**L2 delta (Score 4)**:
- Components current within documented update windows; dependency confusion prevented through verified trusted repositories
- Mass assignment, prototype pollution, and HTTP parameter pollution attacks prevented
- Only necessary data fields returned in API responses (no over-fetching)
- Resource exhaustion prevented through async processing, queuing, and concurrency limits
- Dangerous functionality documented and access-controlled

**L3 delta (Score 5)**:
- Thread-safe mechanisms and atomic operations prevent race conditions and TOCTOU vulnerabilities
- Deadlock and thread starvation prevention verified
- Formal security architecture review documented
- All third-party integrations security-assessed with documented risk acceptance

**Common failures (Score 1-2)**:
- No dependency tracking; unknown transitive dependencies
- Mass assignment allows setting admin role via API
- API returns full database records including internal fields
- Unbounded resource consumption (no timeouts, no queue limits)

---

## V16: Security Logging and Error Handling → A6, O1

**L2 key requirements (Score 4)** (no L1 requirements in this chapter):
- Logging inventory documents what is logged at each layer
- Each log entry contains required metadata: when, where, who, what
- Logging enforced based on data protection level; credentials and payment details excluded
- Session tokens masked in logs
- Authentication attempts (success and failure), authorization failures, and security control bypass attempts logged
- Logs protected from tampering and unauthorized access
- Logs transmitted securely to isolated systems separate from the application
- Generic error messages returned to users; no stack traces, query fragments, or secrets exposed

**L3 delta (Score 5)**:
- Error handling verified to never expose internal details under any failure mode, including edge cases
- Log analysis and correlation automated with alerting
- Tamper-evident logging with cryptographic verification

**Common failures (Score 1-2)**:
- Stack traces displayed to users on 500 errors
- No security event logging; authentication failures not recorded
- Sensitive data (passwords, tokens) written to logs
- Logs stored on the same server as the application with no access controls

---

## V17: WebRTC → domain-specific

Applies only when the application uses WebRTC. Score as N/A if WebRTC is not in scope.

**L2 key requirements (Score 4)** (no L1 requirements in this chapter):
- TURN server access restricted to non-reserved IP addresses
- TURN server prevents resource exhaustion from excessive port allocation
- DTLS encryption with approved cipher suites for all media streams
- SRTP authentication validated to block RTP injection
- DTLS certificates validated against SDP fingerprints
- Signaling server resilient to flood attacks with rate limiting
- Malformed signaling messages handled gracefully without denial of service
- Media stream availability maintained during malformed packet receipt

**L3 delta (Score 5)**:
- Advanced flood protection for both media and signaling channels
- WebRTC peer connection security formally documented and tested
- TURN server hardened against relay abuse
- End-to-end encryption for media streams where supported

**Common failures (Score 1-2)**:
- Plain RTP without SRTP encryption
- TURN server open to unauthenticated relay
- No rate limiting on signaling connections
- DTLS certificate validation skipped
