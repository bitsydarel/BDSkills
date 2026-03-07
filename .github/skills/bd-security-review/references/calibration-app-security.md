# Calibration: Application Security (Lens 2)

What good application security looks like — reference examples for scoring A1-A7.

## A1: Weak authentication design (Score 1-2)

- Passwords stored as MD5 hashes (or SHA-256 without salt).
- Session tokens in URL query parameters.
- No brute-force protection — unlimited login attempts.
- "Remember me" sets a permanent cookie with user ID in plaintext.
- Password reset sends new password via email instead of a time-limited reset link.

## A1: Adequate authentication design (Score 3)

- Passwords hashed with bcrypt. Sessions have 24h expiration. No MFA available.
- Brute-force protection limited to account lockout after 10 attempts, no CAPTCHA or progressive delay.
- Password reset uses time-limited token but link does not expire on use — can be reused within the window.
- Session cookies set with Secure and HttpOnly flags but SameSite not configured.
- "Remember me" extends session to 30 days without re-authentication for sensitive actions.

## A1: Strong authentication design (Score 4-5)

- Passwords hashed with Argon2id (memory: 64MB, iterations: 3, parallelism: 4).
- Session tokens: 256-bit random, stored server-side, transmitted via `Secure; HttpOnly; SameSite=Strict` cookies.
- Rate limiting: 10 attempts per 15 minutes per username, progressive delays, CAPTCHA after 5 failures.
- MFA required for: login, password change, payment actions. TOTP + WebAuthn supported.
- Password reset: time-limited token (15 min), single-use, invalidated on use or password change.
- Sessions invalidated on password change. Session listing available to users. Remote revocation supported.

## A2: Weak authorization (Score 1-2)

- All users share one role ("user"). Admin functionality hidden behind UI routing but accessible via direct API calls.
- Authorization checked only at the frontend — changing the user ID in a GET request returns another user's data (IDOR).
- No difference between "can view" and "can edit" — anyone who can read a resource can modify or delete it.
- Shared admin accounts used by the team, with no individual accountability.
- API endpoint returns full user list regardless of who is calling it.

## A2: Adequate authorization (Score 3)

- RBAC implemented for major roles (admin, user, viewer). Object-level authorization present on most endpoints but missing on a few secondary ones.
- Default-deny at API gateway but some legacy endpoints grandfathered in without authorization checks.
- IDOR not tested automatically — caught occasionally during manual QA.
- Self-assignment of roles blocked, but role changes lack an approval workflow — any admin can grant admin to others.

## A2: Strong authorization (Score 4-5)

- Formal permission model (RBAC with scoped roles, or ABAC with attribute-based policies) documented and implemented.
- Object-level authorization on every endpoint: `GET /api/users/{id}` verifies the authenticated user owns or has explicit access to that resource.
- Default-deny at the API gateway — unauthenticated requests to any protected endpoint get 401. Unauthorized requests get 403 with no body.
- IDOR tested automatically in CI: tests modify the object ID in requests and verify denial.
- Privilege escalation prevention: role changes require admin approval and are audited. Self-assignment of roles blocked.
- Function-level authorization: admin endpoints (`POST /api/admin/*`) require admin role verified server-side, not just hidden in the UI.

## A3: Weak input validation (Score 1-2)

- `if (input.includes('<script>')) reject()` — blocklist approach to XSS.
- SQL queries built with string concatenation "for performance."
- File upload checks extension only (`.jpg` renamed to `.php` bypasses).
- User input reflected in error messages without encoding.

## A3: Adequate input validation (Score 3)

- Parameterized queries used consistently. No raw SQL.
- Server-side validation present but not using a centralized framework — each endpoint validates independently, leading to inconsistencies.
- Output encoding for HTML context but not for URL or JavaScript contexts.
- File uploads checked by extension allowlist, not content type or magic bytes. Stored outside web root.
- CSP exists but includes unsafe-inline, reducing its effectiveness.

## A3: Strong input validation (Score 4-5)

- Server-side validation framework (Joi, Zod, Pydantic) with schemas per endpoint.
- All database access via parameterized queries or ORM — no raw SQL anywhere.
- File uploads validated by: extension allowlist, MIME type check, magic byte verification, antivirus scan, stored outside web root with random filename.
- Context-specific output encoding: HTML entities for HTML context, URL encoding for URL context, JS string escaping for inline scripts.
- Content Security Policy with no `unsafe-inline` or `unsafe-eval`.

## A3: SSRF-specific calibration

### Weak SSRF protection (Score 1-2)

- User-supplied URL passed directly to HTTP client with no validation.
- HTTP client follows redirects by default with no limit or re-validation.
- No URL scheme restriction — non-HTTP protocols accepted.
- Cloud metadata endpoint (169.254.169.254) reachable from application.
- URL validation uses regex matching on the raw URL string before DNS resolution.

### Adequate SSRF protection (Score 3)

- URL scheme restricted to http/https at the application layer.
- Hostname checked against a blocklist of known internal hostnames and private IP ranges.
- But: validation occurs before DNS resolution — vulnerable to DNS rebinding where an attacker-controlled domain resolves to an internal IP after the check.
- HTTP client follows redirects without re-validating the destination URL against the same policy.
- Cloud metadata protection relies on application-level URL blocking, not network-level controls.

### Strong SSRF protection (Score 4-5)

- URL parsed, DNS resolved, and the resolved IP validated against a denylist of private ranges (127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16, ::1, fc00::/7).
- Validation occurs after DNS resolution and is repeated on every redirect hop.
- Only http and https schemes allowed — all others rejected at parse time.
- IMDSv2 enforced on cloud instances (requires PUT request with token header, blocking simple GET-based SSRF).
- Network-level metadata endpoint protection (firewall rules, VPC configuration).
- Outbound connection monitoring and alerting for unexpected internal destinations.

## A4: Weak data protection (Score 1-2)

- API keys hardcoded in source code, committed to git. "We will rotate them later."
- TLS configured on the load balancer, but internal service-to-service traffic is plaintext HTTP.
- Passwords hashed with MD5, or SHA-256 without salt. Encryption key stored in the same config file as the encrypted data.
- Database connection string with plaintext password in `docker-compose.yml` committed to the repository.
- Sensitive fields (SSN, credit card) stored unencrypted in the database because "it is behind a firewall."

## A4: Adequate data protection (Score 3)

- TLS 1.2 on all external endpoints. Internal traffic uses TLS but not mTLS.
- Secrets in environment variables (not vault) but not in source code. Pre-commit hook for secret detection not configured.
- Encryption at rest for database (full-disk encryption via cloud provider). No field-level encryption for PII.
- Key rotation manual, last done 8 months ago. No automated rotation or expiry alerts.
- Data classification exists informally ("we know what is sensitive") but not documented as policy.

## A4: Strong data protection (Score 4-5)

- Data classification policy: PII, PCI, PHI, internal, public — each with defined handling rules.
- AES-256-GCM for encryption at rest, keys managed in KMS/Vault with automated rotation every 90 days.
- TLS 1.3 on all external endpoints. mTLS between internal services. SSL Labs grade A+.
- No secrets in source code — pre-commit hooks (GitLeaks, detect-secrets) block secret commits. All secrets in vault.
- Database column-level encryption for PII fields. Tokenization for payment card data.
- Certificate lifecycle fully automated (cert-manager, Let's Encrypt). Expiry alerts 30 days before.

## A5: Weak supply chain (Score 1-2)

- `package-lock.json` not committed. Dependencies installed with `npm install` (mutable resolution).
- No SCA tool in CI — `npm audit` run manually once during initial setup, never again.
- Transitive dependencies not audited. Log4j-style deep transitive vulnerability would go undetected.
- Forked a library 2 years ago to fix a bug. Fork has never synced with upstream. 14 CVEs accumulated.
- Third-party CDN scripts loaded without SRI hashes. Polyfill.io-style CDN compromise would succeed.

## A5: Adequate supply chain (Score 3)

- npm audit runs in CI but critical CVEs don't block merge — alerts only, addressed when convenient.
- Lock file committed but hash verification not enforced. npm install used instead of npm ci.
- No SBOM generated. Dependencies reviewed informally when adding new ones — no formal review checklist.
- Dependabot enabled but PRs pile up without timely triage. Some are months old.
- Third-party CDN scripts used without SRI hashes on non-critical pages.

## A5: Strong supply chain (Score 4-5)

- SBOM generated on every build (CycloneDX format). Published alongside release artifacts.
- SCA tool (Snyk/Dependabot) runs on every PR. Critical CVEs block merge. High CVEs generate tracking issues.
- Dependencies pinned with lock file integrity hashes. `npm ci` enforced — `npm install` blocked in CI.
- Dependency review process: new dependencies require security review (license, maintainer activity, vulnerability history).
- SLSA Level 2+: build provenance attestation. Container images signed with cosign. Artifact digests verified before deployment.
- Quarterly dependency audit: unused dependencies removed, forked dependencies synced or replaced.

## A6: Weak secure coding (Score 1-2)

- Stack traces displayed to users on 500 errors. Framework debug page enabled in production.
- No SAST tool in CI. Code review does not include security considerations.
- No resource limits on API endpoints — a single request can allocate unbounded memory or run indefinitely.
- Error messages differ between "user not found" and "wrong password," enabling username enumeration.
- Language-specific pitfalls ignored: Python `shell=True`, Java `BinaryFormatter`, Go ignored errors.

## A6: Adequate secure coding (Score 3)

- Semgrep runs on PRs but 12 unaddressed medium-severity findings suppressed with inline comments.
- Most error responses generic but some legacy endpoints return stack traces in staging that occasionally leak to production.
- Resource limits on public endpoints (rate limiting, request size) but not on internal APIs or background jobs.
- Secure coding guidelines exist in a wiki but not enforced via linting rules — compliance depends on reviewer awareness.
- Error messages identical for "user not found" vs "wrong password" on main login, but differ on a legacy mobile endpoint.

## A6: Strong secure coding (Score 4-5)

- SAST (Semgrep, CodeQL) runs on every PR with zero unaddressed high-severity findings.
- Generic error responses in production: "An error occurred" with a correlation ID for internal lookup.
- All resources bounded: connection pools sized, memory limits set, request timeouts configured, query complexity limited.
- Language-specific secure coding guidelines documented and enforced via linting rules.
- Error messages intentionally identical for auth failures: same response body, same HTTP status, same response time (prevents timing-based enumeration).
- DAST/fuzzing runs on release candidates. Findings triaged within one sprint.

## A7: Weak UI/UX security (Score 1-2)

- No CSP header. Page frameable by any origin (clickjacking possible).
- "Delete account" button with no confirmation dialog — single click is permanent.
- Cookie consent banner: "Accept All" is a large button, "Manage Preferences" is tiny gray text that opens a 5-step flow. Tracking starts before consent.
- Login page is a generic form with no domain indicator — trivially imitated by a phishing site.
- Security notifications sent as marketing-style emails indistinguishable from spam.

## A7: Adequate UI/UX security (Score 3)

- X-Frame-Options: SAMEORIGIN set. CSP exists but includes unsafe-inline.
- Confirmation dialog on account deletion but not on email change or MFA removal.
- Cookie consent has accept/reject but accept is visually emphasized (larger, colored). Withdrawal stops first-party tracking but third-party analytics scripts continue briefly.
- Security notifications sent for password changes but not for new device logins. Notifications are plain text and distinguishable from marketing.
- Permission requests bundled on first launch rather than requested in context.

## A7: Strong UI/UX security (Score 4-5)

- CSP with `frame-ancestors 'none'` (or explicit allowlist). X-Frame-Options set as fallback.
- All destructive actions (delete, revoke, transfer) require explicit confirmation with clear consequence description.
- Cookie consent: equal-prominence accept/reject buttons. Granular opt-in per category. Tracking verifiably stops when consent is withdrawn.
- Login flow uses WebAuthn/passkeys as primary option. Domain and certificate clearly displayed. Phishing-resistant by design.
- Security notifications (new device login, password change, MFA added) are distinct from marketing. Include "If this was not you" recovery link.
- Permission requests show clear rationale ("Camera access is needed to scan the QR code") and are requested in context, not on first launch.

## Comparison table

| Criterion | Weak (Score 1-2) | Adequate (Score 3) | Strong (Score 4-5) |
|-----------|------------------|-------------------|-------------------|
| A1: Authentication | MD5 passwords, no MFA, permanent sessions | Bcrypt, session expiration, account lockout, no MFA | Argon2id, MFA enforced, session rotation, passkeys |
| A2: Authorization | UI-only checks, IDOR, no object-level authz | RBAC for major roles, most endpoints checked, legacy gaps | Default-deny, object-level checks per endpoint, automated IDOR testing |
| A3: Input Validation | Blocklist XSS filter, raw SQL, extension-only upload check | Parameterized queries, per-endpoint validation, HTML encoding only | Schema validation framework, parameterized queries, magic byte + AV scanning |
| A4: Data Protection | Hardcoded keys, plaintext internal traffic, MD5 | TLS 1.2, secrets in env vars not code, full-disk encryption, manual key rotation | KMS-managed keys, mTLS everywhere, automated rotation, data classification |
| A5: Supply Chain | No SCA, unpinned deps, no SBOM | npm audit in CI (alerts only), lock file committed, no SBOM | SCA in CI with SLA, SBOM, SLSA provenance, signed artifacts |
| A6: Secure Coding | Stack traces in prod, no SAST, unbounded resources | SAST on PRs with suppressed findings, public rate limits, wiki guidelines | SAST in CI, generic errors, all resources bounded, DAST on release |
| A7: UI/UX Security | No CSP, dark pattern consent, no confirmation dialogs | X-Frame-Options set, CSP with unsafe-inline, partial confirmation dialogs | CSP enforced, equal-prominence consent, passkeys, contextual permission requests |
