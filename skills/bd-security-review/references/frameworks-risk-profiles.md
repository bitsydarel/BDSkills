# Frameworks: Risk Profiles

Risk profile matrix for calibrating security expectations to the application's risk level. Use this to determine which controls are required vs. recommended at each level, and to set scoring expectations accordingly.

## Risk level classification

Classify the review target into one of four risk levels based on the highest applicable trigger.

| Risk Level | Data Sensitivity | User Scale | Regulatory Exposure | Business Impact of Breach |
|------------|-----------------|------------|--------------------|--------------------------:|
| **Critical** | PCI cardholder data, PHI, government classified | >1M users or enterprise-critical | PCI DSS, HIPAA, FedRAMP, SOX | Existential — regulatory shutdown, class-action |
| **High** | PII (SSN, financial), authentication credentials | >100K users | GDPR, CCPA, SOC 2 Type II | Severe — fines >$1M, major reputation damage |
| **Medium** | Internal business data, user preferences, analytics | >1K users | SOC 2 Type I, industry standards | Moderate — operational disruption, customer churn |
| **Low** | Public data, non-sensitive configuration | <1K users, internal tools | None or minimal | Minor — limited blast radius, easily recoverable |

**Selection rule**: If any single trigger column qualifies for a higher risk level, the entire application is classified at that level. A public-facing app handling PCI data for 50 users is still **Critical**.

---

## Required controls per risk level

### Critical

All controls from High, plus:

- **T1-T4**: Full STRIDE per component with threat trees. DREAD scoring for all identified threats. Risk register with quarterly review. Threat intelligence feeds integrated
- **A1**: MFA mandatory for all users. Passkey/WebAuthn support. Session rotation on every privilege change. Credential stuffing detection active
- **A2**: Formal ABAC or ReBAC with policy engine. Automated IDOR testing in CI. Privilege escalation monitoring
- **A3**: DAST and fuzzing on every release candidate. Input validation framework with schema-per-endpoint
- **A4**: HSM-managed keys. Field-level encryption for sensitive data. Automated key rotation. TLS 1.3 enforced. Data classification complete
- **A5**: SLSA Level 3+. SBOM published with releases. Provenance attestation verified before deployment
- **A6**: SAST with zero high-severity findings. DAST quarterly. Formal secure coding standard enforced
- **A7**: Phishing-resistant login (passkeys). No dark patterns. User research on security flows
- **O1**: Security event taxonomy defined. SIEM with <15min MTTD. Tamper-evident log storage. 12+ month retention
- **O2**: MITRE-mapped detection. Tested playbooks. <4hr MTTR. Annual game days
- **O3**: CIS Benchmarks enforced. IaC-only changes. Automated drift detection. 48hr critical patch SLA
- **O4**: Tested DR with met RPO/RTO. Chaos engineering. Multi-region deployment. No SPOFs
- **G1-G4**: Audit-confirmed compliance. Continuous monitoring. Tamper-evident audit trails. Quarterly access reviews

### High

All controls from Medium, plus:

- **T1-T4**: STRIDE per component. DREAD scoring for high-impact threats. Risk register maintained
- **A1**: MFA available and enforced for sensitive operations. Session expiration and rotation. Brute-force protection with CAPTCHA
- **A2**: Object-level authorization on all endpoints. Default-deny at API gateway. Automated authz tests
- **A3**: Parameterized queries everywhere. Context-aware output encoding. File upload content validation
- **A4**: KMS-managed keys with rotation schedule. mTLS for internal services. No secrets in code
- **A5**: SCA in CI/CD with SLA enforcement. Lock file hash verification. SBOM generated
- **A6**: SAST in CI/CD with triage SLA. Generic error responses. All resources bounded
- **A7**: CSP with frame-ancestors. Confirmation for all destructive actions. Granular cookie consent
- **O1**: Security events logged and shipped to centralized storage. Alerting on critical events. PII scrubbed
- **O2**: Incident response plan tested at least annually. Detection rules for top threats. MTTR tracked
- **O3**: Secrets in vault with rotation. Infrastructure scanning in CI/CD. Patch SLA enforced
- **O4**: DR plan with defined RPO/RTO tested at least once. Backups verified quarterly. Circuit breakers on critical paths
- **G1-G4**: Regulations mapped to controls with evidence. DSAR fulfillment within SLA. SDL practiced. Access reviews semi-annually

### Medium

All controls from Low, plus:

- **T1-T4**: Attack surface mapped for external interfaces. STRIDE at system level. Trust boundaries identified
- **A1**: Password hashing with approved algorithms. Session expiration. Basic brute-force protection
- **A2**: Role-based access control. Server-side authorization checks. Default-deny for sensitive endpoints
- **A3**: Parameterized queries for all database access. Server-side input validation. Output encoding for HTML
- **A4**: TLS on all external endpoints. Secrets not in source code. Encryption at rest for sensitive fields
- **A5**: SCA tool in CI/CD. Dependencies pinned with lock files. Vulnerability alerts configured
- **A6**: SAST tool available. Error handling reviewed. Resource limits on public endpoints
- **A7**: X-Frame-Options set. Confirmation on destructive actions. Cookie consent present
- **O1**: Security events logged (auth, authz, admin actions). Centralized log storage
- **O2**: Incident response plan documented. Escalation path defined. On-call rotation exists
- **O3**: Secrets in vault or env vars (not in code). Basic hardening applied. Patching on schedule
- **O4**: Backups configured. RPO/RTO defined. Basic graceful degradation
- **G1-G4**: Applicable regulations identified. Privacy policy current. Security training available

### Low

Minimum viable security:

- **T1-T4**: Major entry points identified. Basic risk awareness
- **A1**: Password-based auth with reasonable policy. Session timeout configured
- **A2**: Basic role checks. Admin functions separated from user functions
- **A3**: Parameterized queries for database access. Input length limits
- **A4**: HTTPS on external endpoints. No hardcoded secrets
- **A5**: Lock file committed. Known critical CVEs patched
- **A6**: No stack traces in production. Basic error handling
- **A7**: Basic security headers set
- **O1**: Application logging sufficient for debugging security issues
- **O2**: Someone is contactable for security incidents
- **O3**: Default credentials changed. Unnecessary services disabled
- **O4**: Backups exist
- **G1-G4**: Applicable regulations known. Basic privacy notice

---

## GSR expectations per risk level

### Critical

All controls from High, plus:

- **GSR1**: Design document with full security section reviewed by dedicated security reviewer. End-to-end traceability. Data classification complete
- **GSR2**: TCB explicitly documented, minimized, isolated. Typed security interfaces enforced at compile/lint time. TCB reviewable in one session
- **GSR3**: Full zero trust — mTLS everywhere, centralized policy engine, context-aware access, lateral movement tested
- **GSR4**: Binary Authorization enforced. SLSA Level 3+. Config-as-code with review gates. Emergency deploy audited
- **GSR5**: Multiple vulnerability classes structurally eliminated. Safe-by-default APIs. Structural elimination tracked and measured
- **GSR6**: All 7 adversary categories profiled. Insider threat matrix for all privileged roles. Kill chain mapped with detection at each stage. Red team validated
- **GSR7**: Root cause analysis for all vulnerabilities. Recurrence rate tracked. Structural elimination prioritized. Post-mortems feed architecture

### High

All controls from Medium, plus:

- **GSR1**: Design document with security section including threats, mitigations, and residual risks. Most requirements traceable
- **GSR2**: TCB identified and mostly isolated. Security primitives used for most operations
- **GSR3**: Internal services authenticated with mTLS or service tokens. Context-aware access for sensitive operations. Centralized policy for most services
- **GSR4**: Deploy-time admission control. Code review enforced by tooling. Build provenance captured (SLSA Level 2). Config-as-code for most settings
- **GSR5**: Major vulnerability classes addressed structurally. Secure-by-default APIs for most operations
- **GSR6**: 3-5 adversary categories profiled. Insider threat considered with separation of duties. Kill chain awareness informs detection
- **GSR7**: Root cause analysis for critical/high vulnerabilities. Major patterns known. Post-mortems documented

### Medium

All controls from Low, plus:

- **GSR1**: Security considerations documented with some threat-to-design tracing
- **GSR2**: Security-critical code identifiable with some use of security primitives
- **GSR3**: Some zero trust elements — service tokens, network segmentation supplements identity
- **GSR4**: Code review required by policy. Build artifacts stored centrally. Some config-as-code
- **GSR5**: Some structural protections (ORM, auto-escaping templates)
- **GSR6**: Adversary thinking present for major threat categories
- **GSR7**: OWASP Top 10 awareness. Some post-mortem practice

### Low

Minimum viable:

- **GSR1**: Basic security considerations documented
- **GSR2**: Security-critical code roughly identifiable
- **GSR3**: Basic awareness of zero trust concepts
- **GSR4**: Code review practiced. Version control used
- **GSR5**: Basic framework protections (parameterized queries)
- **GSR6**: Basic threat actor awareness
- **GSR7**: Known vulnerability types considered

---

## Scoring expectations by risk level

The risk level sets the **floor** for what score each control can receive. A control that would score 4 at Low risk may only score 3 at Critical risk if it lacks the depth required at that level.

| Scoring Aspect | Low | Medium | High | Critical |
|---------------|-----|--------|------|----------|
| Minimum expected overall score for "Proceed" | 60% | 70% | 80% | 85% |
| Controls at the "required" level earn | Score 3 | Score 3 | Score 3 | Score 3 |
| Controls exceeding the level above earn | Score 4-5 | Score 4-5 | Score 4-5 | Score 4-5 |
| Controls below the required level earn | Score 1-2 | Score 1-2 | Score 1-2 | Score 1-2 |
| Missing controls at required level | Acceptable if documented | Flag as gap | Score 2 max | Score 1 |

**Scoring rule**: A control is scored against its risk level's requirements, not against absolute perfection. An internal tool (Low risk) with basic auth and session timeout scores 3 on A1. The same implementation for a banking app (Critical risk) scores 2 on A1 because MFA, passkeys, and credential stuffing protection are required.

---

## Risk level determination checklist

Use these questions to quickly classify:

1. **Does the system handle payment card data?** Yes → Critical (PCI DSS)
2. **Does the system handle health records?** Yes → Critical (HIPAA)
3. **Does the system process PII for >100K users?** Yes → High
4. **Is the system subject to GDPR or CCPA?** Yes → at least High
5. **Does the system handle authentication credentials for other systems?** Yes → at least High
6. **Is the system internal-only with <1K users and no sensitive data?** Yes → Low
7. **None of the above?** Default to Medium
