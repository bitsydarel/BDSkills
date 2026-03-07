---
name: bd-security-review
description: "Use this when reviewing task plans, features, bug-fixes, product proposals, and existing implementations through a Security lens. Evaluates threat analysis, application security, operational security, compliance & governance, and Google Security Review methodology across any domain (web, API, mobile, cloud, IoT, CI/CD, desktop, AI/ML) and any language. Maps to STRIDE, DREAD, MITRE ATT&CK, OWASP Top 10 (2021/2025), CWE Top 25, ASVS, CIS Benchmarks, SAMM, and SDL maturity models."
---

# Security Review

A structured security assessment grounded in the principle: **"Assume breach, verify everything."** While code and infrastructure reveal *how* a system is secured, the review evaluates *why* security decisions were made and whether they withstand adversarial thinking. Five focused passes — Threat Analysis, Application Security, Operational Security, Compliance & Governance, and a mandatory Google Security Review — assess plans, features, bug-fixes, products, ideas, and existing implementations. This five-pass design mirrors how top companies (Google, Microsoft, Netflix, Meta) and established frameworks (STRIDE, DREAD, MITRE ATT&CK, OWASP, ASVS, CIS, SAMM, SDL) evaluate security: threat modeling, defense-in-depth application controls, operational readiness, governance compliance, and structural security posture.

**Security-domain-agnostic evaluation**: The lenses evaluate security quality regardless of the target domain. Whether the system is a web application, REST API, mobile app, cloud infrastructure, IoT device, CI/CD pipeline, desktop application, or AI/ML system — the evaluation adapts to the target and assesses how well the system upholds its security contract. The criteria measure universal security qualities (threat modeling, authentication, input validation, encryption, logging, compliance) that apply across all domains.

**Domain & language adaptation**: The criteria use general security terminology as the primary language. All domains and languages must comply with the eight core security principles — these are universal and non-negotiable. When reviewing domain-specific systems, load the matching `domain-*.md` file to translate criteria to the domain's specific attack surface before scoring. When reviewing code, load the matching `language-*.md` file for language-specific vulnerability patterns and secure coding guidance. Available domain mappings: web, API, mobile, cloud-infra, distributed-systems, CI/CD, IoT, desktop, AI/ML. Available language mappings: Python, JavaScript/TypeScript, Java, Go, C#, C/C++, Rust, Swift, Kotlin, PostgreSQL. A well-secured system in any domain can achieve high scores — the principles are universal, only the attack surface is domain-specific.

## Core security principles

These 8 principles frame the security mindset. They are not a checklist — they are the lens through which every evaluation criterion operates.

1. **Assume breach, verify everything** — Zero trust mindset. Every component, user, and service must prove identity and authorization continuously.
2. **Shift left, secure by design** — Security starts at design, not deployment. Threat model before writing code. (Google Secure by Design, Microsoft SDL)
3. **Defense in depth** — No single control is sufficient. Layer protections across network, application, identity, and data boundaries.
4. **Least privilege everywhere** — Minimum necessary access for users, services, and processes. Default deny, explicit allow.
5. **Secure the supply chain** — Dependencies are attack surface. Audit, pin, verify, and monitor everything imported. (SLSA, SBOM, Sigstore)
6. **Protect the user, not just the system** — UI/UX security matters. Users should not need security expertise to stay safe. No dark patterns.
7. **Detect, respond, recover** — Prevention fails. The question is how fast you detect, how well you respond, and how completely you recover.
8. **Compliance enables, not constrains** — Regulatory frameworks encode hard-won security lessons. Use them as a floor, not a ceiling.

## Review modes

Two modes based on what is being reviewed:

- **Proposal review** — Evaluates plans, designs, specs, and ideas before implementation. Questions are forward-looking: "Does the design account for X?"
- **Implementation review** — Superset of proposal review, adding three layers:
  1. **Compliance check** — Did the implementation satisfy proposal-stage security requirements?
  2. **Outcome confirmation** — Are security controls working in production? What do logs, alerts, and pen test results show?
  3. **Iteration assessment** — Are vulnerabilities from post-launch findings feeding the next iteration cycle?

For proposals, questions are forward-looking. For implementations, apply ALL proposal-stage criteria first, then evaluate real-world security posture and iteration behavior.

## Evaluation lenses and criteria

Four lenses, 19 criteria, each scored 1-5. Maximum score: 95. Each lens has a matching evaluation file in `references/` (named `evaluation-{lens}.md`) plus a shared scoring file ([evaluation-scoring.md](references/evaluation-scoring.md)) with verdict rules and thresholds.

### Lens 1: Threat Analysis (/20)

1. **Attack Surface & Entry Point Mapping** — Identifies all external interfaces, data ingress/egress points, and exposed functionality.
2. **Threat Modeling (STRIDE Analysis)** — Applies Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation to each component.
3. **Trust Boundaries & Data Flow Security** — Maps trust transitions, validates data crossing boundaries, enforces zero trust.
4. **Adversary & Risk Assessment** — Profiles threat actors, quantifies risk using DREAD, prioritizes by likelihood and impact.

### Lens 2: Application Security (/35)

5. **Authentication & Session Management** — Verifies identity proofing, credential handling, session lifecycle, and MFA.
6. **Authorization & Access Control** — Evaluates permission models, RBAC/ABAC, object-level authorization, and default-deny posture.
7. **Input Validation & Injection Prevention** — Checks all input handling: SQL, XSS, command, path traversal, deserialization, file upload.
8. **Data Protection & Cryptography** — Assesses encryption at rest/transit, key management, hashing, and certificate handling.
9. **Supply Chain & Dependency Security** — Evaluates dependency auditing, pinning, SBOM, provenance verification, and update policy.
10. **Secure Coding & Error Handling** — Checks language-specific pitfalls, error disclosure, resource management, and memory safety.
11. **UI/UX Security & Anti-Social Engineering** — Evaluates clickjacking protection, phishing-resistant UI, consent patterns, and dark pattern avoidance.

### Lens 3: Operational Security (/20)

12. **Security Logging & Monitoring** — Assesses audit trail completeness, SIEM integration, alerting, and log integrity.
13. **Incident Detection & Response** — Evaluates detection rules, response playbooks, escalation paths, and mean time to respond.
14. **Infrastructure & Configuration Hardening** — Checks secrets management, least-privilege infra, CIS benchmarks, and patch cadence.
15. **Resilience, Recovery & Continuity** — Assesses disaster recovery, backup verification, chaos engineering, and business continuity.

### Lens 4: Compliance & Governance (/20)

16. **Regulatory Compliance** — Verifies applicable regulations (GDPR, HIPAA, PCI DSS 4.0, SOC 2, CCPA) are addressed.
17. **Privacy by Design** — Evaluates data minimization, purpose limitation, consent management, and right to erasure.
18. **Security Governance & Policy** — Checks security policies, SDL practices, risk acceptance processes, and security training.
19. **Audit Trail & Accountability** — Assesses non-repudiation, change management, evidence preservation, and accountability chains.

### Google Security Review (mandatory, /35)

Seven criteria scored after all four lenses. GSR can escalate the verdict downward but never inflate it. For GSR override rules and integration with core scoring, see [evaluation-scoring.md](references/evaluation-scoring.md).

20. **Design Document Security Completeness** — Structured security section with assets, threats, mitigations, residual risks, and end-to-end traceability.
21. **Trusted Computing Base & Understandability** — TCB identified, minimized, isolated with typed interfaces (SafeSQL, SafeHTML). Reviewable by one person.
22. **Zero Trust Architecture Validation** — No network trust. Every request authenticated/authorized. Context-aware access. Centralized policy. (Extends T3)
23. **Binary Authorization & Build Integrity** — Non-author review, signed provenance, deploy-time admission control, config-as-code. (Extends A5)
24. **Structural Security Posture** — Eliminate vulnerability classes structurally. Secure-by-default APIs. Secure path = easiest path.
25. **Adversary-Centric Threat Profiling** — 7 adversary categories, insider threat matrix, kill chain mapping. (Extends T4)
26. **Vulnerability Pattern Awareness** — Root cause analysis, dominant patterns (Project Zero, CWE Top 25), structural elimination over patching.

## Security knowledge signals

When scoring criteria, check whether the work demonstrates knowledge across four areas. These are quality signals within existing evaluations, not additional scored criteria:

- **Threat Intelligence** — Attack surface awareness, adversary thinking, risk quantification → signals in T1-T4
- **Defensive Engineering** — Secure coding depth, auth/authz rigor, input validation discipline → signals in A1-A7
- **Operational Maturity** — Detection capability, response readiness, infrastructure hardening → signals in O1-O4
- **Governance Awareness** — Regulatory knowledge, privacy engineering, audit discipline → signals in G1-G4

## Review workflow

### 1. Ingest input
Identify mode (proposal/implementation), artifact type, domain(s), and language(s).

### 2. Load references
Load reference files from `references/` progressively by prefix. Only load what the current step requires. **When `review-depth: comprehensive`** (e.g., invoked by bd-plan-reviewer): treat "contextual" and "on demand" references as mandatory for every scored lens — load the matching anti-pattern file and calibration file proactively for each lens you score, not only when uncertainty or contextual triggers arise.

**Always load** (scoring framework, output format, and risk calibration):
- `evaluation-scoring.md` — verdict thresholds, multi-lens integration, and GSR override rules
- `feedback-template.md` — output structure
- `frameworks-risk-profiles.md` — risk-level-appropriate control expectations
- `frameworks-framework-scoping.md` — STRIDE, DREAD, MITRE, CIS, ASVS depth scoping

**Per-domain** (load based on the review target):
- `domain-guide.md` — always read first for classification and multi-domain conflict resolution
- `domain-*.md` — load the file(s) matching the target domain (e.g., `domain-web.md` for a web app, `domain-api.md` for an API)

**Per-language** (load when reviewing code):
- `language-guide.md` — always read first for polyglot evaluation methodology
- `language-*.md` — load the file(s) matching the target language or database (e.g., `language-python.md`, `language-go.md`, `language-postgresql.md`, `language-mongodb.md`)

**Per-lens** (load the matching `evaluation-*.md` file when scoring that lens):
- e.g., when scoring Threat Analysis, load `evaluation-threat-analysis.md`

**Contextual** (load based on findings):
- `frameworks-*.md` — load relevant framework files when threat modeling methodology, compliance standards, maturity assessment, or remediation guidance are pertinent
- `anti-patterns-*.md` — load the anti-pattern file matching the security issue category being evaluated
- `feedback-example-proposal.md` or `feedback-example-implementation.md` — load the one matching the review mode

**On demand** (when uncertain about a score boundary):
- `calibration-*.md` — load the calibration file matching the lens in question for weak/adequate/strong examples

### 3. Lens 1 — Threat Analysis
Map attack surface, apply STRIDE to each entry point, identify trust boundaries, assess adversary risk using DREAD. Score T1-T4.

### 4. Lens 2 — Application Security
Evaluate auth, authz, input handling, data protection, supply chain, coding practices, and UI/UX security. Apply domain-specific OWASP mapping and language-specific vulnerability checks. Score A1-A7.

### 5. Lens 3 — Operational Security
Assess logging/monitoring, detection/response, infrastructure hardening, and resilience/recovery. Score O1-O4.

### 6. Lens 4 — Compliance & Governance
Check applicable regulations, privacy design, governance policies, and audit trails. Score G1-G4.

### 7. Google Security Review (mandatory)
Apply all 7 GSR criteria regardless of input type. Score GSR1-GSR7. This step always runs — it is not optional. GSR scores can escalate the verdict downward (prevent "Proceed" / "Meets Standards") but never inflate it upward.

### 8. Synthesize
Identify cross-lens patterns, classify issues by severity, apply the weakest-link verdict rule. Check for critical overrides (any criterion scored 1). Integrate GSR results: check for GSR criterion scores of 1, GSR total below 40%, and GSR-Core amplification pairs.

### 9. Identify anti-patterns
Flag security failure modes using the loaded anti-pattern references.

### 10. Produce structured output
Write the review following the feedback template. Include per-lens scorecards, overall verdict, issues by severity, strengths, top recommendation, and key question.

## Anti-patterns

Common security failure modes to detect during review — each with detailed Signs, Impact, Fix, and Detection guidance. Load the `anti-patterns-*.md` file matching the issue category.

**Cross-cutting**: Security Theater [Critical], Inconsistent Security Levels [Minor] — [details](references/anti-patterns-cross-cutting.md)
**Auth & Sessions** (Lens 2): Auth Bypass Backdoor, Session Immortality, Permission Creep [Major] — [details](references/anti-patterns-auth-sessions.md)
**Data & Crypto** (Lens 2): Crypto Cargo Cult [Critical], HTTPS Everywhere Myth, Secret Sprawl [Major] — [details](references/anti-patterns-data-crypto.md)
**Input Validation** (Lens 2): Trust the Client [Critical], Input Validation Theater, Error Message Oracle [Major], Oversharing APIs [Minor] — [details](references/anti-patterns-input-validation.md)
**Supply Chain** (Lens 2): Dependency Graveyard, Supply Chain Ignorance [Major] — [details](references/anti-patterns-supply-chain.md)
**Infrastructure** (Lens 3): Logging Blind Spots, Missing Rate Limiting [Major], Verbose Debug in Production [Minor] — [details](references/anti-patterns-infrastructure.md)
**Compliance** (Lens 4): Dark Pattern Consent, Compliance Checkbox Mentality [Major], Documentation Drift [Minor] — [details](references/anti-patterns-compliance.md)

**Vulnerability-specific deep dives** — Bypass techniques, detection strategies, and mitigation patterns for high-impact vulnerability types. Load when reviewing code or designs involving these attack surfaces:
- SSRF — [details](references/anti-patterns-ssrf.md)
- Insecure Deserialization — [details](references/anti-patterns-deserialization.md)
- Path Traversal — [details](references/anti-patterns-path-traversal.md)
- OS Command Injection — [details](references/anti-patterns-command-injection.md)
- XSS (Advanced Patterns) — [details](references/anti-patterns-xss.md)
- Insecure File Upload — [details](references/anti-patterns-file-upload.md)
- Race Conditions — [details](references/anti-patterns-race-conditions.md)
- XXE Injection — [details](references/anti-patterns-xxe.md)
- Template Injection (SSTI) — [details](references/anti-patterns-template-injection.md)
- Prototype Pollution — [details](references/anti-patterns-prototype-pollution.md)
- SSL/TLS Pinning — [details](references/anti-patterns-ssl-pinning.md)
- Man-in-the-Middle (MITM) — [details](references/anti-patterns-mitm.md)

## Calibration

When uncertain about a score boundary (2 vs 3, 3 vs 4), load the matching calibration file (prefixed `calibration-`) from `references/` for weak/adequate/strong examples. Each lens has a dedicated calibration file. For cross-lens calibration, see `calibration-cross-lens.md`.

## Security frameworks & domain/language context

The frameworks references (prefixed `frameworks-`) contain standards-grounded evaluation context — OWASP, STRIDE/DREAD, MITRE ATT&CK, compliance standards, SAMM/SDL maturity models, risk profiles, and threat modeling guides. The domain references (prefixed `domain-`) provide domain-specific security heuristics. The language references (prefixed `language-`) provide language-specific and database-specific secure coding guidance (e.g., `language-postgresql.md` for PostgreSQL security, `language-mongodb.md` for MongoDB security). Load the relevant `frameworks-*.md`, `domain-*.md`, and `language-*.md` files contextually per Step 2 and apply across lenses.
