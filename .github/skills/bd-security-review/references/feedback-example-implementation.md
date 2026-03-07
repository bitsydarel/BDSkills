# Feedback example: Implementation review

Filled review example demonstrating how to apply the security review template for implementation-mode reviews. For the template itself, see [feedback-template.md](feedback-template.md).

---

## Example: Payment Processing System — Implementation Review

```markdown
## Security Review

**Input**: Payment Processing System — Stripe integration, PCI DSS scope, recurring billing
**Review Mode**: Implementation Review
**Perspective**: Security
**Verdict**: Critical Gaps (escalated from Needs Improvement by GSR override — GSR6+T4 amplification pair)

### Lens 1: Threat Analysis scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| T1 | Attack Surface & Entry Point Mapping | 3/5 | Payment API endpoints documented but webhook receiver lacks authentication spec. Admin billing dashboard not in attack surface inventory. |
| T2 | Threat Modeling (STRIDE Analysis) | 2/5 | No formal threat model found. Payment flow described but STRIDE not applied. Tampering risks for price manipulation not analyzed. |
| T3 | Trust Boundaries & Data Flow Security | 3/5 | Stripe API calls go through backend (good — no client-side tokenization bypass). But internal microservice-to-microservice payment data flows lack mTLS. |
| T4 | Adversary & Risk Assessment | 2/5 | No documented threat actor analysis. Payment systems attract financially motivated attackers — this requires explicit DREAD scoring. |
| | **Lens 1 Total** | **10/20** | |

### Lens 2: Application Security scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| A1 | Authentication & Session Management | 4/5 | Payment actions require re-authentication. Session timeout is 15 min for billing admin. MFA enforced for refund operations. |
| A2 | Authorization & Access Control | 3/5 | Role-based access for billing admin vs support vs user. But refund endpoint lacks amount-based authorization (support can refund any amount). |
| A3 | Input Validation & Injection Prevention | 4/5 | All payment inputs validated server-side. Currency/amount validation prevents negative values. Stripe webhook signatures verified. |
| A4 | Data Protection & Cryptography | 4/5 | PAN never touches servers (Stripe Elements). PCI DSS SAQ-A eligible. Payment metadata encrypted at rest. API keys in vault. |
| A5 | Supply Chain & Dependency Security | 3/5 | Stripe SDK pinned but other payment-adjacent dependencies (PDF invoice generator, email service) not audited. No SBOM. |
| A6 | Secure Coding & Error Handling | 3/5 | Payment errors return generic messages to users. But internal error logs include full Stripe API responses with partial card data. |
| A7 | UI/UX Security & Anti-Social Engineering | 4/5 | Clear payment confirmation with amount/recipient. Refund flow has explicit confirmation. No dark patterns in recurring billing consent. |
| | **Lens 2 Total** | **25/35** | |

### Lens 3: Operational Security scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| O1 | Security Logging & Monitoring | 3/5 | Payment events logged but not correlated with user sessions. No anomaly detection for unusual payment patterns. |
| O2 | Incident Detection & Response | 2/5 | No payment fraud detection rules. No documented response procedure for payment data breach. Stripe's fraud detection relied upon entirely. |
| O3 | Infrastructure & Configuration Hardening | 3/5 | Payment service isolated in separate VPC (good). But database credentials rotated manually, not automated. |
| O4 | Resilience, Recovery & Continuity | 3/5 | Idempotency keys prevent double charges. But no graceful degradation when Stripe is down — users see 500 errors. |
| | **Lens 3 Total** | **11/20** | |

### Lens 4: Compliance & Governance scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| G1 | Regulatory Compliance | 4/5 | PCI DSS SAQ-A completed. GDPR data processing agreement with Stripe. Missing: PCI DSS 4.0 requirement 6.4.3 (script integrity for payment pages). |
| G2 | Privacy by Design | 3/5 | Payment data minimized (Stripe handles PAN). But transaction history retained indefinitely with no documented retention policy. |
| G3 | Security Governance & Policy | 3/5 | Annual PCI assessment scheduled. But no security review gate for payment flow changes. |
| G4 | Audit Trail & Accountability | 3/5 | Payment transactions auditable via Stripe dashboard. Internal admin actions (refunds, adjustments) logged but not tamper-evident. |
| | **Lens 4 Total** | **13/20** | |

### Google Security Review scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| GSR1 | Design Document Security Completeness | 2/5 | No formal design document with security section found. Payment flow described in tickets but no structured threat-to-design traceability. |
| GSR2 | Trusted Computing Base & Understandability | 3/5 | Payment service isolated in separate VPC (good boundary) but internal security logic not isolated with typed interfaces. Error logs leaking partial card data indicates TCB boundary leakage. |
| GSR3 | Zero Trust Architecture Validation | 2/5 | Internal microservice-to-microservice payment data flows lack mTLS. Network segmentation (VPC) used as primary trust mechanism. |
| GSR4 | Binary Authorization & Build Integrity | 3/5 | CI/CD pipeline exists but no artifact signing or deploy-time admission control mentioned. Manual credential rotation suggests manual deployment practices. |
| GSR5 | Structural Security Posture | 3/5 | Stripe Elements eliminates PAN handling (structural). Server-side validation for payment inputs. But error logging gap and manual rotation indicate areas where developer discipline is still required. |
| GSR6 | Adversary-Centric Threat Profiling | 2/5 | No documented threat actor analysis for a payment system — a high-value target for financially motivated attackers. No insider threat matrix despite support agents having refund access. |
| GSR7 | Vulnerability Pattern Awareness | 2/5 | No evidence of root cause analysis. Partial card data in error logs suggests lack of awareness of common data leakage patterns. No post-mortem process visible. |
| | **GSR Total** | **17/35** | |

### Overall score

| Lens | Score | Max | % |
|------|-------|-----|---|
| Lens 1: Threat Analysis | 10 | 20 | 50% |
| Lens 2: Application Security | 25 | 35 | 71% |
| Lens 3: Operational Security | 11 | 20 | 55% |
| Lens 4: Compliance & Governance | 13 | 20 | 65% |
| **Core Total** | **59** | **95** | **62%** |
| Google Security Review | 17 | 35 | 49% |
| **Combined Total** | **76** | **130** | **58%** |

**Weakest lens**: Lens 1: Threat Analysis (50%)
**Critical override triggered**: No — but Lens 1 is close to 40% threshold
**GSR override triggered**: Yes — GSR-Core amplification pair triggered: GSR6 (Adversary Profiling, 2) + T4 (Risk Assessment, 2) both ≤ 2 → automatic "Critical Gaps"

### Security compliance checklist (implementation reviews only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| All entry points identified and tested | Partial | Webhook receiver and admin dashboard missing from inventory |
| Authentication controls verified | Yes | Re-auth and MFA for sensitive payment actions |
| Authorization tested at object level | Partial | Refund endpoint lacks amount-based authorization |
| Input validation confirmed (DAST/fuzzing) | Yes | Payment inputs validated, Stripe webhook signatures verified |
| Encryption at rest and transit verified | Yes | PAN never on servers, metadata encrypted, TLS enforced |
| Dependencies scanned and patched | Partial | Stripe SDK pinned but adjacent dependencies unaudited |
| Security logging confirmed in production | Partial | Logged but not correlated or anomaly-detected |
| Incident response plan tested | No | No payment-specific incident response playbook |
| Compliance requirements mapped | Partial | PCI SAQ-A done but 4.0 gaps exist |
| Secrets management verified | Partial | In vault but manual rotation |

### Critical issues
- [ ] Perform formal threat modeling for payment flows — T2 — Apply STRIDE to payment creation, webhook processing, refund, and recurring billing flows
- [ ] Create payment fraud detection rules — O2 — Implement anomaly detection for unusual amounts, frequencies, geographic patterns

### Major issues
- [ ] Add amount-based authorization for refund endpoint — A2 — Support agents should have a refund limit requiring manager approval above threshold
- [ ] Scrub partial card data from internal error logs — A6 — Stripe API responses in logs may contain last-4 digits and expiry; apply PII filter
- [ ] Implement payment anomaly monitoring — O1 — Correlate payment events with user sessions, flag unusual patterns
- [ ] Create payment breach response playbook — O2 — Document steps for suspected payment data exposure including Stripe notification
- [ ] Automate database credential rotation — O3 — Move from manual to automated rotation with vault TTL
- [ ] Address PCI DSS 4.0 requirement 6.4.3 — G1 — Implement script integrity monitoring for payment pages
- [ ] Define transaction data retention policy — G2 — Set retention period aligned with regulatory requirements, automate purge

### Minor issues
- [ ] Add graceful degradation for Stripe outages — O4 — Queue payments and show user-friendly status instead of 500 errors
- [ ] Generate SBOM for payment service — A5 — Include all direct and transitive dependencies
- [ ] Make admin audit logs tamper-evident — G4 — Ship to append-only storage with integrity verification

### Strengths
- PAN never touches servers — excellent PCI scope reduction via Stripe Elements
- Re-authentication required for payment actions with MFA for refunds
- Idempotency keys prevent double charges
- Payment service isolated in separate VPC
- Clear, non-deceptive UI for payment confirmation and recurring billing consent

### Top recommendation
Conduct formal STRIDE threat modeling for all payment flows — the payment system is a high-value target with no documented threat analysis, and this gap undermines confidence in all other security controls.

### Key question for the team
If a webhook authentication bypass is discovered, how quickly can you detect fraudulent payment events and what is your rollback procedure for affected transactions?
```
