# Calibration: Compliance & Governance (Lens 4)

What good compliance and governance looks like — reference examples for scoring G1-G4.

## G1: Weak regulatory compliance (Score 1-2)

- "We are GDPR compliant" but no data processing records, no DPO, no DPIA.
- PCI DSS SAQ filled out by a developer who "looked at it briefly." No evidence collected for any control.
- Applicable regulations never formally identified — the team assumes they need GDPR because "we have European users" but has not checked CCPA, HIPAA, or sector-specific requirements.
- Compliance treated as an annual audit event. Controls documented once, never verified.
- "We will deal with compliance when we get audited."

## G1: Adequate regulatory compliance (Score 3)

- GDPR and PCI DSS identified as applicable. CCPA and sector-specific requirements acknowledged but not yet assessed.
- GDPR data processing records started but incomplete — covers primary user data flows, misses analytics and third-party integrations.
- PCI DSS controls partially mapped to implementation. Self-assessment questionnaire filled out with some evidence gaps.
- No formal audit conducted. Compliance gaps known informally but no remediation timeline or tracking mechanism.
- Compliance reviewed annually before contract renewals rather than continuously monitored.

## G1: Strong regulatory compliance (Score 4-5)

- Applicable regulations explicitly identified and mapped: GDPR (EU users), CCPA (CA users), PCI DSS 4.0 (payment data), SOC 2 (enterprise customers), HIPAA (if health data).
- Each regulation mapped to technical controls with evidence:
  - GDPR Art 32: Encryption at rest (AES-256-GCM, evidence: AWS KMS audit log), encryption in transit (TLS 1.3, evidence: SSL Labs A+ grade).
  - PCI DSS Req 6.4.3: Script integrity for payment pages (evidence: SRI hashes, CSP report-uri).
  - SOC 2 CC6.1: Logical access controls (evidence: quarterly access review reports).
- Continuous compliance monitoring: automated checks detect drift from required controls.
- Audit-confirmed compliance with no unresolved findings. Regulatory scope document maintained.

## G2: Weak privacy by design (Score 1-2)

- Privacy policy copied from a template with company name find-and-replaced. No one on the team has read it.
- Collects full name, email, phone, address, date of birth, and device info for a simple to-do app. "We might need it later."
- Cookie consent is an all-or-nothing banner: "By using this site, you agree to our cookies." Tracking starts on page load regardless.
- No mechanism for data subject requests — if a user emails asking for their data, the team manually queries the database.
- Data retained indefinitely. No deletion policy. User account deletion hides the profile but retains all data in the database.

## G2: Adequate privacy by design (Score 3)

- Privacy policy written by legal team and published. Team has read it but does not reference it during feature development.
- Data minimization discussed but not enforced — some forms collect optional fields by default. Fields added "in case we need them" without DPIA.
- Cookie consent has accept/reject but withdrawal does not fully stop tracking — first-party analytics continue for the session. Third-party scripts honor withdrawal.
- DSAR handled manually, typically within 2 weeks. No automated tooling. Process documented but not tested with mock requests.
- Retention policy defined ("delete after 2 years of inactivity") but enforcement is a manual quarterly job that sometimes slips.

## G2: Strong privacy by design (Score 4-5)

- Data minimization enforced at collection: only name, email, and payment token stored. Address collected only when shipping is required, then purged after delivery.
- Consent: granular opt-in for marketing, analytics, and third-party sharing. Accept and reject buttons have equal prominence and equal click cost. Tracking verifiably stops when consent is withdrawn.
- DSAR fulfillment automated within 72 hours. Verified with test requests quarterly.
- Retention policies enforced automatically: 90-day deletion for inactive accounts, transaction records kept 7 years per PCI requirement, then purged.
- DPIA conducted for high-risk processing (profiling, sensitive data, large-scale monitoring). Results documented and reviewed.
- Processing records maintained per GDPR Art 30, updated when new data processing activities are added.

## G3: Weak security governance (Score 1-2)

- SDL exists on paper: a wiki page from 3 years ago that no one references during development.
- No security champions. Security is the responsibility of "the security team" (which is one person who also does IT).
- Security training: a 30-minute video watched during onboarding, never again. No verification of learning.
- Policy exceptions undocumented. Developers disable security checks "temporarily" with no tracking or sunset date.
- No security review gate before launch. Features ship without anyone asking "what could go wrong?"

## G3: Adequate security governance (Score 3)

- SDL documented and referenced in onboarding. Developers are aware of the process but skip steps for smaller features.
- Threat modeling done for major features but not for smaller changes, bug fixes, or infrastructure updates.
- Security training: 1-hour annual awareness session. Completion tracked. No role-specific secure coding training or hands-on exercises.
- No security champions program. Security questions routed to one senior engineer who reviews when available.
- Policy exceptions documented in Jira but no formal risk acceptance process — exceptions approved by team lead without executive sign-off or sunset dates.

## G3: Strong security governance (Score 4-5)

- SDL integrated in the development process: threat model → code review → SAST → DAST → pen test → deployment gate.
- Security champions in each team. Monthly security sync across champions. Champions conduct first-pass security review of PRs.
- Training: annual security awareness + role-specific secure coding training. Completion tracked and reported. Training updated annually with current threat landscape.
- Policy exceptions: documented with risk acceptance, reviewed quarterly, sunset dates enforced. Executive sign-off required for exceptions to critical controls.
- Security maturity measured (BSIMM/SAMM) with year-over-year improvement targets.
- Governance metrics reported to leadership: vulnerability remediation SLA compliance, security training completion, policy exception trends.

## G4: Weak audit trail (Score 1-2)

- Audit trail: "We can check the database `updated_at` column." No record of who changed what.
- No access reviews — permissions granted and never revoked. Former employees still have active accounts.
- Direct production changes: developers can SSH into prod and run SQL queries. No record of these interventions.
- Change management: "Push to main and it deploys." No approval, no review, no rollback plan.
- Compliance asks "who accessed patient data last Tuesday?" Answer: "We have no way to know."

## G4: Adequate audit trail (Score 3)

- Audit logs capture admin actions and data access events. Application-level changes (user updates, permission changes) logged with user ID and timestamp.
- Logs stored in CloudWatch with 6-month retention. Not tamper-evident — anyone with AWS access could modify or delete logs.
- Change management via PR review for most changes, but emergency hotfixes bypass the process with no post-hoc review or documentation.
- Access reviews conducted annually but stale permissions accumulate between reviews. Offboarding checklist exists but is occasionally missed.
- Compliance can answer "who accessed what" for recent events but reconstructing a timeline older than 3 months requires significant manual effort.

## G4: Strong audit trail (Score 4-5)

- Tamper-evident audit trails: append-only storage with cryptographic chaining or immutable cloud logs (CloudTrail, GCS audit logs).
- All admin actions, data access, and configuration changes recorded with: who, what, when, from where, and why.
- Enforced change management: all production changes via PR with approval. No direct access. Emergency change process documented with post-hoc review.
- Quarterly access reviews with automated revocation of unused permissions. Stale permissions detected and flagged.
- Full reconstructability: audit trail can reconstruct security events for the past 12+ months.
- Change management compliance measured: percentage of changes going through the approved process. Violations tracked and addressed.

## Comparison table

| Criterion | Weak (Score 1-2) | Adequate (Score 3) | Strong (Score 4-5) |
|-----------|------------------|-------------------|-------------------|
| G1: Regulatory Compliance | "We are compliant" with no evidence | Regulations identified, partial control mapping, no formal audit | Regulations mapped to controls with audit evidence, continuous monitoring |
| G2: Privacy by Design | Excessive data collection, all-or-nothing consent | Accept/reject consent, manual DSARs, retention policy defined but loosely enforced | Data minimization, granular consent, automated DSARs, enforced retention |
| G3: Security Governance | SDL on paper only, no training, no champions | SDL documented, annual training, threat modeling for major features, no champions | SDL integrated in dev process, security champions, tracked training, measured maturity |
| G4: Audit Trail | `updated_at` column, direct prod access, no access reviews | Admin and data access logged, annual access reviews, PR-based changes with hotfix gaps | Tamper-evident logs, enforced change management, quarterly access reviews, 12+ month reconstructability |
