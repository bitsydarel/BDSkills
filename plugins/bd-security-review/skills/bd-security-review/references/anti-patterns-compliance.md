# Anti-patterns: Compliance & Governance

Security anti-patterns related to regulatory compliance, privacy, consent, and documentation. Each pattern includes signs to look for, its impact, and a concrete fix.

## Dark Pattern Consent — Major

**Signs**: Pre-checked consent boxes for data sharing. "Accept All" button prominent while "Manage Preferences" is hidden or multi-step. Cookie banners that are technically non-functional (tracking starts regardless of choice). Consent buried in Terms of Service. Withdrawal of consent harder than granting it.

**Impact**: Regulatory violations (GDPR fines up to 4% global revenue). User trust erosion when data practices are exposed. Legal liability from non-consensual data processing. Reputational damage from public enforcement actions.

**Fix**: Implement granular consent with equal prominence for accept and reject options. Ensure consent is freely given, specific, informed, and unambiguous (GDPR Art 7). Make withdrawal as easy as granting. Verify that tracking/processing actually stops when consent is withdrawn. Test consent flows with real users.

**Detection**:
- *Code patterns*: Pre-checked consent checkboxes (`checked={true}` by default); tracking scripts loading before consent handler; asymmetric button styling (accept: primary, reject: text link); consent stored but not enforced in tracking code
- *Review questions*: Does tracking stop when consent is withdrawn? Are accept and reject options equally prominent? Is consent freely given (no forced bundling)?
- *Test methods*: Reject cookies and verify tracking scripts do not fire (check network requests). Compare click effort for accepting vs rejecting. Withdraw consent and verify tracking ceases

---

## Compliance Checkbox Mentality — Major

**Signs**: Compliance treated as an annual audit event, not continuous. Controls documented but not tested. SOC 2 report generated from a questionnaire without evidence. PCI DSS SAQ completed by a developer who skimmed the questions. "We're GDPR compliant" but no DPIA, DPO, or data subject rights process exists.

**Impact**: Audit findings discovered too late to remediate. Compliance gaps become security gaps (the frameworks encode real security requirements). False compliance declarations create legal liability. Regulatory penalties when investigated after a breach.

**Fix**: Implement continuous compliance monitoring. Require evidence (screenshots, scan reports, test results) for every control. Automate compliance checks where possible (CIS benchmarks, SAST results, dependency scanning). Treat regulatory requirements as minimum security standards, not maximum effort.

**Detection**:
- *Code patterns*: Compliance documents referencing deprecated versions (PCI DSS 3.x when 4.0 is current); control evidence consisting only of self-attestation; SOC 2 controls without implementation artifacts
- *Review questions*: For each claimed compliance control, can you show me the evidence? When was the last external audit? Are compliance checks automated or manual?
- *Test methods*: Request evidence for 3 randomly selected compliance controls. Verify automated compliance checks exist (CIS scan results, SCA reports). Check compliance document dates against current framework versions

---

## Documentation Drift — Minor

**Signs**: Architecture diagrams do not reflect current implementation. Threat model references components that were removed or replaced. Security policies describe controls that were never implemented. Runbooks reference tools or procedures that have changed. Compliance documentation describes a different system than what is deployed.

**Impact**: Incident response is misdirected by outdated documentation. Compliance audits fail when documentation does not match reality. New team members implement insecure patterns based on outdated guidance. Threat models miss current attack surface.

**Fix**: Version security documentation alongside code. Review and update threat models, architecture diagrams, and runbooks after every significant change. Automate where possible (SBOM, infrastructure diagrams from IaC). Include documentation updates in Definition of Done for security-relevant changes.

**Detection**:
- *Code patterns*: Architecture diagrams with `.drawio`/`.puml` last modified >6 months ago while code changed significantly; threat model referencing removed components; runbooks referencing deprecated tools
- *Review questions*: Does the architecture diagram match the current deployment? When was the threat model last updated? Do runbooks reference current tools and procedures?
- *Test methods*: Compare architecture diagram components against actual infrastructure. Check threat model component list against current service inventory. Walk through a runbook and verify each step is current

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Dark Pattern Consent | Major | A7: UI/UX Security, G2: Privacy | Both |
| Compliance Checkbox Mentality | Major | G1: Regulatory Compliance | Both |
| Documentation Drift | Minor | G3: Governance | Both |
