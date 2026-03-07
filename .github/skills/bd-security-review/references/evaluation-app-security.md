# Lens 2: Application Security (/35)

Scoring criteria for the 7 Application Security dimensions. For scoring scale and verdict thresholds, see [evaluation-scoring.md](evaluation-scoring.md). For ASVS 5.0 per-chapter verification requirements mapped to scores, see [frameworks-asvs-verification.md](frameworks-asvs-verification.md).

---

## A1: Authentication & Session Management

**Proposal questions**: Is the authentication mechanism appropriate for the risk level (passwords, MFA, passkeys, SSO)? Are session tokens generated securely with proper expiration? Is credential storage using approved algorithms (bcrypt, scrypt, Argon2)?

**Implementation-Compliance questions**: Are authentication flows implemented as designed? Do session tokens meet entropy requirements? Is MFA enforced where specified?

**Implementation-Results questions**: Are there authentication bypass attempts in logs? Are session fixation or hijacking attacks detected? What is the credential stuffing success rate?

**Scoring**:
- **5 (Excellent)**: MFA enforced for sensitive operations, passkey support, secure session management with rotation. Credential stuffing protection active. ASVS L2+ authentication requirements met. Brute-force protections tested.
- **4 (Good)**: MFA available and encouraged. Sessions expire and rotate. Credentials stored with approved algorithms. Minor gaps such as MFA not mandatory for all roles or session rotation on privilege change not implemented.
- **3 (Adequate)**: Standard password-based auth with sessions. Password hashing uses approved algorithms but MFA not available. Session expiration set but no rotation. Brute-force protection basic (lockout only).
- **2 (Weak)**: Authentication present but with significant gaps. Weak password policy, no MFA option, long session lifetimes, or session tokens predictable. Credential storage uses outdated algorithms.
- **1 (Missing)**: Plaintext passwords, no session expiration, or easily bypassable authentication.

**Quality check**: Verify credential storage algorithm (must be bcrypt/scrypt/Argon2). Confirm sessions expire AND rotate on privilege escalation. Check MFA availability for sensitive operations.

---

## A2: Authorization & Access Control

**Proposal questions**: Is the permission model defined (RBAC, ABAC, ReBAC)? Is default-deny enforced? Are object-level and function-level authorization checks specified for every endpoint?

**Implementation-Compliance questions**: Are authorization checks implemented server-side for every protected resource? Is horizontal privilege escalation prevented (IDOR)?

**Implementation-Results questions**: Are authorization failures logged and monitored? Has authorization testing (both automated and manual) confirmed no bypass paths?

**Scoring**:
- **5 (Excellent)**: Formal permission model with object-level checks on every endpoint. Default-deny enforced. Automated authorization testing. No IDOR vulnerabilities. Permission changes audited.
- **4 (Good)**: Permission model defined and implemented. Object-level checks present for most endpoints. Default-deny at API gateway level. Minor gaps in less-critical endpoints or missing automated authz tests.
- **3 (Adequate)**: Role-based checks present but missing object-level authorization on some endpoints. Default-deny not consistently enforced. IDOR protections partial.
- **2 (Weak)**: Basic role checks exist but authorization is inconsistent. Some endpoints unprotected. Client-side enforcement relied upon for non-critical paths. No IDOR testing.
- **1 (Missing)**: No authorization model or client-side-only enforcement.

**Quality check**: Test at least one endpoint for IDOR (change object ID in request, verify denial). Confirm default-deny: does an unauthenticated request to a protected endpoint get rejected?

---

## A3: Input Validation & Injection Prevention

**Proposal questions**: Is input validated at every trust boundary? Are parameterized queries used for all database access? Is output encoding applied context-specifically (HTML, URL, JS, CSS)? Are file uploads validated for type, size, and content? For features accepting URLs: is URL validation planned against private/internal IP ranges, including post-DNS-resolution validation? Are all URL-accepting parameters covered (webhooks, callbacks, imports, image fetchers)?

**Implementation-Compliance questions**: Are all user inputs validated server-side? Do ORM queries use parameterized statements without raw SQL escape hatches? Are deserialization inputs restricted to allowlists? For SSRF: is URL validation performed after DNS resolution (not before)? Are redirect destinations re-validated against the same policy? Is the URL scheme restricted to http/https?

**Implementation-Results questions**: Has DAST or fuzzing been performed? Are injection attempts visible in WAF or application logs? What is the false positive rate of input validation? Has SSRF-specific testing been performed (internal IP variants, cloud metadata endpoints, DNS rebinding, protocol smuggling)? Is outbound connection monitoring in place for application servers?

**Scoring**:
- **5 (Excellent)**: Comprehensive input validation framework. Parameterized queries everywhere. Context-aware output encoding. File upload sandboxing. DAST-verified with no injection findings. Deserialization restricted to allowlists.
- **4 (Good)**: Parameterized queries used consistently. Output encoding applied. Server-side validation for all user inputs. Minor gaps in less common contexts (CSS injection, SVG) or file upload validation.
- **3 (Adequate)**: Parameterized queries used but inconsistent input validation. Output encoding present for HTML but missing in other contexts. File uploads checked for extension but not content type.
- **2 (Weak)**: Some parameterized queries but raw SQL exists in places. Input validation only on frontend or only for common cases. No output encoding strategy. File uploads poorly validated.
- **1 (Missing)**: Raw SQL concatenation, no input validation, or direct user input in system commands.

**Quality check**: Confirm zero raw SQL concatenation. Verify output encoding is context-aware (different for HTML body, HTML attribute, JavaScript, URL, CSS). Check file upload validation includes content-type inspection, not just extension.

---

## A4: Data Protection & Cryptography

**Proposal questions**: Is sensitive data classified? Is encryption specified for data at rest (AES-256) and in transit (TLS 1.2+)? Are cryptographic algorithms approved and key management procedures defined?

**Implementation-Compliance questions**: Are approved algorithms actually used (no MD5, SHA1, DES, ECB)? Are keys stored in HSM, KMS, or vault — not in code? Are certificates managed with automated rotation?

**Implementation-Results questions**: Are TLS configurations scanned and graded A+? Is key rotation happening on schedule? Are there data exposure incidents in logs?

**Scoring**:
- **5 (Excellent)**: Data classification complete. AES-256/TLS 1.3 enforced. KMS-managed keys with automated rotation. PII encrypted at rest. No secrets in code. TLS graded A+. Certificate lifecycle fully automated.
- **4 (Good)**: Encryption at rest and in transit with approved algorithms. Keys in vault/KMS. Minor gaps such as manual key rotation or TLS 1.2 (not 1.3) in some services. Data classification exists but incomplete.
- **3 (Adequate)**: Encryption present but weak in places. Approved algorithms mostly used but some legacy endpoints on older TLS. Key management centralized but rotation manual and overdue.
- **2 (Weak)**: Encryption partial. Some data at rest unencrypted. Keys stored in config files rather than vault. Deprecated algorithms found (SHA1 for signing). No data classification.
- **1 (Missing)**: Plaintext sensitive data, hardcoded keys, or broken cryptography (MD5, DES, ECB mode).

**Quality check**: Confirm no MD5, SHA1 (for security), DES, or ECB mode in use. Verify keys are in KMS/vault, not in source code or config files. Check TLS version >= 1.2 on all endpoints.

---

## A5: Supply Chain & Dependency Security

**Proposal questions**: Is there a dependency policy (pinning, audit, approval)? Is SBOM generation planned? Are provenance verification mechanisms specified (SLSA, Sigstore)?

**Implementation-Compliance questions**: Are dependencies pinned with hash verification? Is SCA (Software Composition Analysis) in CI/CD? Are known vulnerabilities patched within SLA?

**Implementation-Results questions**: What is the current vulnerability count in dependencies? When was the last dependency audit? Are there unused or abandoned dependencies?

**Scoring**:
- **5 (Excellent)**: SBOM generated. SLSA L3+ provenance. Automated SCA with SLA enforcement. Dependency review process for new additions. No critical CVEs unpatched. Unused dependencies removed.
- **4 (Good)**: SCA in CI/CD with vulnerability alerts. Dependencies pinned with lock files. SBOM generated but no provenance verification. Critical CVEs patched within SLA. Some unused dependencies remain.
- **3 (Adequate)**: SCA tool in place but no SBOM. Inconsistent pinning. Vulnerability patching reactive rather than SLA-driven. No formal dependency approval process.
- **2 (Weak)**: Dependencies tracked informally. No SCA in CI/CD. Lock files present but hash verification absent. Known vulnerabilities left unpatched for extended periods.
- **1 (Missing)**: No dependency tracking, unpinned dependencies, or known critical CVEs unpatched.

**Quality check**: Verify SCA runs in CI/CD (not just locally). Confirm lock files exist with integrity hashes. Check for dependencies with known critical CVEs.

---

## A6: Secure Coding & Error Handling

**Proposal questions**: Are language-specific security guidelines referenced? Are error handling patterns defined (no stack traces in production, no sensitive data in errors)? Are resource limits specified?

**Implementation-Compliance questions**: Are SAST tools integrated? Do error responses leak internal details? Are resources bounded (connection pools, memory limits, timeouts)?

**Implementation-Results questions**: What does SAST report? Are there production errors exposing sensitive information? Are resource exhaustion incidents occurring?

**Scoring**:
- **5 (Excellent)**: SAST integrated with zero high-severity findings. Generic error responses in production. All resources bounded with limits and timeouts. Language-specific secure coding guidelines followed and verified.
- **4 (Good)**: SAST integrated with findings tracked and triaged. Error handling mostly correct with generic responses. Resources bounded for critical paths. Minor gaps in non-critical code paths.
- **3 (Adequate)**: SAST present with some unaddressed findings. Error handling inconsistent — some endpoints return stack traces. Resources partially bounded. Language-specific guidelines referenced but not enforced.
- **2 (Weak)**: SAST not in CI/CD (only manual runs). Error messages frequently leak internal details. Resource limits absent for most services. No language-specific security guidelines.
- **1 (Missing)**: No SAST. Stack traces in production. Unbounded resources. Critical coding flaws (buffer overflows, use-after-free, unhandled exceptions).

**Quality check**: Trigger an error in a non-production environment and verify the response reveals no internal details (no stack traces, no file paths, no SQL fragments). Confirm SAST runs on every PR.

---

## A7: UI/UX Security & Anti-Social Engineering

**Proposal questions**: Are anti-clickjacking measures (CSP frame-ancestors) specified? Do security-sensitive actions require explicit user confirmation? Are login/payment flows designed to resist phishing? Are consent patterns clear and non-deceptive?

**Implementation-Compliance questions**: Are X-Frame-Options and CSP headers set? Do destructive actions have confirmation dialogs? Are security indicators (HTTPS, verified badges) displayed correctly?

**Implementation-Results questions**: Are clickjacking or UI redress attacks detected? Do user behavior analytics show confusion in security-critical flows? Are there phishing reports targeting the application?

**Scoring**:
- **5 (Excellent)**: CSP with frame-ancestors. Explicit confirmation for all sensitive actions. Phishing-resistant login (passkeys/WebAuthn). No dark patterns. User research validates clarity of security-critical flows. Cookie consent is granular and symmetrical.
- **4 (Good)**: CSP headers set. Confirmation dialogs for destructive actions. Login flow follows anti-phishing best practices. Consent patterns clear. Minor gaps such as missing confirmation on one sensitive action.
- **3 (Adequate)**: Basic protections present (X-Frame-Options). Some confirmation dialogs but inconsistent. Security indicators displayed but not prominent. Consent present but pre-checked boxes or asymmetric accept/reject UI.
- **2 (Weak)**: Clickjacking protections incomplete. No confirmation for some destructive actions. Security indicators absent or misleading. Consent mechanism is confusing or uses dark patterns.
- **1 (Missing)**: No clickjacking protection. Deceptive UI patterns. Security-critical actions without confirmation. No consent mechanism.

**Quality check**: Verify CSP frame-ancestors header is set. Test that destructive actions (delete account, change email, revoke access) require explicit confirmation. Check consent UI for symmetry (accept and reject equally easy).
