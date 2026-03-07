# Lens 4: Compliance & Governance (/20)

Scoring criteria for the 4 Compliance & Governance dimensions. For scoring scale and verdict thresholds, see [evaluation-scoring.md](evaluation-scoring.md).

---

## G1: Regulatory Compliance

**Proposal questions**: Are applicable regulations identified (GDPR, HIPAA, PCI DSS, SOC 2, CCPA)? Are compliance requirements mapped to technical controls? Is regulatory scope defined (what data, what jurisdictions)?

**Implementation-Compliance questions**: Are required controls implemented? Is compliance documentation current? Are compliance gaps tracked with remediation timelines?

**Implementation-Results questions**: Has an audit or assessment confirmed compliance? Are there regulatory findings pending? Is continuous compliance monitoring in place?

**Scoring**:
- **5 (Excellent)**: All applicable regulations identified and mapped to technical controls. Audit-confirmed compliance. Continuous monitoring detects drift. No pending findings. Regulatory scope clearly defined with jurisdiction mapping.
- **4 (Good)**: Applicable regulations identified with most controls mapped and implemented. Audit completed with minor findings tracked. Compliance documentation current. Continuous monitoring planned or partially deployed.
- **3 (Adequate)**: Regulations identified but incomplete mapping to controls. Some controls implemented but untested against audit criteria. Compliance documentation exists but gaps noted.
- **2 (Weak)**: Regulatory requirements acknowledged but not systematically mapped. Controls partial. No audit conducted. Compliance gaps known but no remediation timeline.
- **1 (Missing)**: No regulatory analysis or known non-compliance without remediation plan.

**Quality check**: Confirm applicable regulations are explicitly listed (not assumed). Verify at least the top regulation (by risk) has a control mapping document.

---

## G2: Privacy by Design

**Proposal questions**: Is data minimization applied (collect only what is needed)? Is purpose limitation documented? Are consent mechanisms designed? Is right to erasure (RTBF) supported?

**Implementation-Compliance questions**: Can data subjects exercise their rights (access, correction, deletion, portability)? Is consent granular and revocable? Are data processing records maintained?

**Implementation-Results questions**: Are data subject requests being fulfilled within SLA? Is data retention enforced automatically? Have privacy impact assessments been conducted?

**Scoring**:
- **5 (Excellent)**: Data minimization enforced at collection. Granular, revocable consent. Automated DSAR fulfillment within SLA. DPIA conducted for high-risk processing. Data retention auto-enforced. Processing records maintained.
- **4 (Good)**: Data minimization practiced. Consent mechanism functional with granularity. DSARs handled within SLA but partially manual. Retention policies defined and mostly enforced. DPIA conducted for major features.
- **3 (Adequate)**: Privacy considered but data minimization incomplete. Consent present but not granular. DSAR fulfillment manual and slow. Retention policies defined but enforcement inconsistent.
- **2 (Weak)**: Excessive data collection without clear purpose. Consent mechanism exists but is all-or-nothing. DSARs handled ad-hoc. No retention enforcement. No DPIA.
- **1 (Missing)**: No privacy design. Excessive data collection. No mechanism for data subject rights. No consent management.

**Quality check**: Verify data subject rights are exercisable (test: can a user request deletion and have it fulfilled?). Confirm data retention policies exist with automated enforcement for at least the most sensitive data categories.

---

## G3: Security Governance & Policy

**Proposal questions**: Are security policies defined and accessible? Is a secure development lifecycle (SDL) in place? Are security roles and responsibilities assigned? Is security training provided?

**Implementation-Compliance questions**: Are SDL practices followed (threat modeling, code review, security testing)? Is there a security champion program? Are policy exceptions documented with risk acceptance?

**Implementation-Results questions**: Is SDL adoption measured? Are security training completion rates tracked? How are policy exceptions trending?

**Scoring**:
- **5 (Excellent)**: SDL integrated in development process with full adoption. Security champions embedded in each team. Regular security training with tracked completion. Policy exceptions documented with risk acceptance and executive sign-off. Governance metrics reported to leadership.
- **4 (Good)**: SDL practices followed for most projects. Security champions program exists. Security training provided at least annually. Policy exceptions tracked. Minor gaps in adoption measurement.
- **3 (Adequate)**: SDL partially adopted (threat modeling for major features, code review standard, security testing ad-hoc). Security training exists but attendance inconsistent. Policy exceptions informal.
- **2 (Weak)**: SDL exists on paper but not practiced. No security champions. Security training available but optional and rarely taken. Policy exceptions undocumented.
- **1 (Missing)**: No SDL. No security training. No security governance structure.

**Quality check**: Confirm SDL includes at minimum: threat modeling, secure code review, and security testing before release. Verify security training exists and is not just an annual checkbox.

---

## G4: Audit Trail & Accountability

**Proposal questions**: Are audit requirements defined for security-critical operations? Is non-repudiation ensured (who did what, when)? Are change management procedures in place?

**Implementation-Compliance questions**: Are audit logs tamper-evident? Is change management enforced (no direct production changes)? Are access reviews conducted periodically?

**Implementation-Results questions**: Can audit trails reconstruct security events for the past N months? Are access reviews finding and revoking stale permissions? Is change management compliance measured?

**Scoring**:
- **5 (Excellent)**: Tamper-evident audit trails. Enforced change management (no direct production changes). Quarterly access reviews with stale permissions revoked. Full reconstructability for 12+ months. Change management compliance measured and reported.
- **4 (Good)**: Audit trails comprehensive and centralized. Change management enforced for production. Access reviews conducted at least semi-annually. Reconstructability for 6+ months. Minor gaps in non-production environments.
- **3 (Adequate)**: Audit logging present but not tamper-evident. Change management mostly followed but with exceptions. Access reviews conducted ad-hoc. Reconstructability limited.
- **2 (Weak)**: Audit trails partial. Direct production changes happen occasionally. Access reviews rare. Stale permissions accumulate. Change management documented but not enforced.
- **1 (Missing)**: No audit trail. Direct production changes routine. No access reviews. No change management.

**Quality check**: Verify audit logs are tamper-evident (append-only store or cryptographic chaining). Confirm change management prevents direct production modifications. Check when the last access review was conducted.
