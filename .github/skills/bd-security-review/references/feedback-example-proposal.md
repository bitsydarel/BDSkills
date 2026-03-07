# Feedback example: Proposal review

Filled review example demonstrating how to apply the security review template for proposal-mode reviews. For the template itself, see [feedback-template.md](feedback-template.md).

---

## Example: User Authentication Feature — Proposal Review

```markdown
## Security Review

**Input**: User Authentication System Design — Web + Mobile (SSO, MFA, password reset)
**Review Mode**: Proposal Review
**Perspective**: Security
**Verdict**: Proceed with Conditions

### Lens 1: Threat Analysis scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| T1 | Attack Surface & Entry Point Mapping | 4/5 | All auth endpoints documented (login, register, reset, MFA verify, OAuth callback). Missing rate-limit specs per endpoint. |
| T2 | Threat Modeling (STRIDE Analysis) | 3/5 | STRIDE applied to login flow but not to password reset or OAuth callback. Token spoofing scenarios undocumented. |
| T3 | Trust Boundaries & Data Flow Security | 4/5 | Clear DFD showing mobile app → API gateway → auth service → user DB. OAuth provider trust boundary well-defined. |
| T4 | Adversary & Risk Assessment | 3/5 | Credential stuffing and phishing identified as primary threats. No DREAD scoring or threat actor profiling for insider risk. |
| | **Lens 1 Total** | **14/20** | |

### Lens 2: Application Security scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| A1 | Authentication & Session Management | 4/5 | Argon2 for passwords, JWT with 15-min access + 7-day refresh rotation. MFA via TOTP. Missing: WebAuthn/passkey support, session binding to device fingerprint. |
| A2 | Authorization & Access Control | 4/5 | RBAC defined with admin/user/readonly roles. API endpoints mapped to required permissions. Missing: object-level authz for user profile endpoints. |
| A3 | Input Validation & Injection Prevention | 3/5 | Input validation mentioned but no specific library or framework chosen. Email validation regex not specified. No mention of output encoding for error messages. |
| A4 | Data Protection & Cryptography | 4/5 | TLS 1.3 required, PII encrypted at rest with AES-256-GCM, key rotation via AWS KMS. Password hashing with Argon2id. |
| A5 | Supply Chain & Dependency Security | 3/5 | Auth libraries specified (passport.js, jose) but no pinning policy or SBOM requirement. No provenance checks. |
| A6 | Secure Coding & Error Handling | 3/5 | Generic error responses specified for auth failures ("Invalid credentials") but no SAST integration plan. Rate limiting mentioned but not specified. |
| A7 | UI/UX Security & Anti-Social Engineering | 4/5 | Login flow resists phishing with clear domain display. Password strength meter included. No dark patterns in MFA enrollment. Missing: explicit clickjacking protection spec. |
| | **Lens 2 Total** | **25/35** | |

### Lens 3: Operational Security scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| O1 | Security Logging & Monitoring | 4/5 | Auth events (login success/fail, MFA, password reset) logged with correlation IDs. Shipped to Datadog. Missing: PII scrubbing spec for logs. |
| O2 | Incident Detection & Response | 3/5 | Account takeover detection planned (impossible travel, credential stuffing patterns) but no response playbook documented. |
| O3 | Infrastructure & Configuration Hardening | 3/5 | Auth service containerized with non-root user. Secrets in AWS Secrets Manager. Missing: CIS benchmark reference, network segmentation spec. |
| O4 | Resilience, Recovery & Continuity | 3/5 | Auth service stateless with horizontal scaling. No mention of graceful degradation if IdP is unavailable. |
| | **Lens 3 Total** | **13/20** | |

### Lens 4: Compliance & Governance scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| G1 | Regulatory Compliance | 4/5 | GDPR and CCPA requirements identified for user data. SOC 2 CC6.1 mapped to auth controls. Missing: HIPAA assessment if health data involved. |
| G2 | Privacy by Design | 4/5 | Minimal data collection for auth. Consent for optional biometric MFA. Account deletion flow includes auth data purge. |
| G3 | Security Governance & Policy | 3/5 | References company SDL but no auth-specific security review gate before launch. |
| G4 | Audit Trail & Accountability | 3/5 | Auth events auditable but no retention policy specified. Admin action logging not mentioned. |
| | **Lens 4 Total** | **14/20** | |

### Google Security Review scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| GSR1 | Design Document Security Completeness | 3/5 | Security section exists with threats and mitigations but no end-to-end traceability from threat model to design decisions. Data classification not documented. |
| GSR2 | Trusted Computing Base & Understandability | 3/5 | Auth module identifiable but not isolated with typed interfaces. Mix of parameterized queries and unspecified validation library. |
| GSR3 | Zero Trust Architecture Validation | 3/5 | Trust boundaries well-defined (mobile → API gateway → auth service) but no mTLS between internal services. No centralized policy engine. |
| GSR4 | Binary Authorization & Build Integrity | 2/5 | No mention of artifact signing, deploy-time admission control, or build provenance. Code review assumed but not enforced by tooling. |
| GSR5 | Structural Security Posture | 3/5 | Argon2id for passwords (structural), but validation framework unspecified — developers could introduce injection. Secure-by-default not systematically designed. |
| GSR6 | Adversary-Centric Threat Profiling | 3/5 | Credential stuffing and phishing identified but no formal adversary categories, no insider threat matrix, no kill chain mapping. |
| GSR7 | Vulnerability Pattern Awareness | 2/5 | No evidence of root cause analysis or dominant pattern awareness. Design addresses OWASP Top 10 implicitly but not mapped to specific vulnerability patterns. |
| | **GSR Total** | **19/35** | |

### Overall score

| Lens | Score | Max | % |
|------|-------|-----|---|
| Lens 1: Threat Analysis | 14 | 20 | 70% |
| Lens 2: Application Security | 25 | 35 | 71% |
| Lens 3: Operational Security | 13 | 20 | 65% |
| Lens 4: Compliance & Governance | 14 | 20 | 70% |
| **Core Total** | **66** | **95** | **69%** |
| Google Security Review | 19 | 35 | 54% |
| **Combined Total** | **85** | **130** | **65%** |

**Weakest lens**: Lens 3: Operational Security (65%)
**Critical override triggered**: No
**GSR override triggered**: No — no GSR criterion scored 1, GSR total above 40% threshold (19/35 = 54%)

### Critical issues
- [ ] Complete STRIDE analysis for password reset and OAuth callback flows — T2 — Apply STRIDE to all auth entry points, not just login

### Major issues
- [ ] Add object-level authorization for user profile endpoints — A2 — Specify IDOR protection for GET/PUT /users/{id}
- [ ] Define input validation framework and library — A3 — Select and document validation library with allowlist approach
- [ ] Create incident response playbook for account takeover — O2 — Document detection triggers, escalation path, and remediation steps
- [ ] Add dependency pinning and SBOM requirement — A5 — Pin all auth library versions with lock file hash verification
- [ ] Specify rate limiting per endpoint — A6 — Define requests/minute for login (10), register (5), reset (3)

### Minor issues
- [ ] Add WebAuthn/passkey support to roadmap — A1 — Plan passkey support as phishing-resistant MFA option
- [ ] Specify PII scrubbing for auth logs — O1 — Ensure email addresses and IPs are hashed or masked in logs
- [ ] Document log retention policy — G4 — Specify 12-month retention for auth audit logs

### Strengths
- Strong cryptographic choices (Argon2id, AES-256-GCM, TLS 1.3)
- Clear trust boundary definition between mobile app, API gateway, and auth service
- Privacy-conscious design with minimal data collection and deletion support
- Good separation of access/refresh token lifecycle

### Top recommendation
Complete STRIDE threat modeling for all auth flows (password reset and OAuth callback are high-value attack targets without formal threat analysis).

### Key question for the team
What is the account takeover response procedure if credential stuffing is detected at scale — do you lock accounts, force MFA, or rate-limit by IP?
```
