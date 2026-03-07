# Calibration: Google Security Review

What good Google Security Review looks like — reference examples for scoring GSR1-GSR7.

## GSR1: Weak design document security (Score 1-2)

- Design document has no security section. Security mentioned only as "we'll add HTTPS."
- No data classification. No identification of trusted vs. untrusted inputs.
- Security requirements exist in a separate wiki page nobody references during development.
- Threats not traced to design decisions — security and design are disconnected documents.

## GSR1: Adequate design document security (Score 3)

- Security section exists but reads as a checklist: "Use TLS, hash passwords, validate input."
- Some threats identified (credential stuffing, injection) but mitigations listed generically without tracing to specific design components.
- Data classification started — PII fields identified in user table but not traced through all services that handle them.
- Design reviewed by team but no security-knowledgeable reviewer involved.

## GSR1: Strong design document security (Score 4-5)

- Dedicated security section covering: assets (user credentials, payment tokens, PII), threats (credential stuffing, token theft, insider data exfiltration), mitigations (Argon2id, short-lived JWTs, field-level encryption), and residual risks (offline brute force against leaked hashes — accepted, mitigated by hash strength).
- Security requirements traced: Threat T3 (token theft) → Design Decision D7 (15-min token expiry + refresh rotation) → Implementation: `TokenService.rotate()`.
- Data classification matrix: which fields are PII, where they flow, who can access them, and retention policy.

## GSR2: Weak TCB (Score 1-2)

- No concept of a trusted computing base. Security logic scattered across controllers, middleware, and utilities.
- Raw SQL string concatenation used alongside parameterized queries. "It depends on which developer wrote it."
- Auth checks implemented differently in each route handler. No shared auth middleware.
- Security-critical code entangled with business logic — cannot be reviewed in isolation.

## GSR2: Adequate TCB (Score 3)

- Auth middleware exists and handles most routes, but some endpoints bypass it with inline checks.
- Parameterized queries used for most database access, but some legacy endpoints use string interpolation.
- Security-critical code identifiable (auth module, crypto utils) but not isolated — business logic imports and calls security functions directly with no interface boundary.
- A new developer could eventually find the security boundaries but it would take exploration.

## GSR2: Strong TCB (Score 4-5)

- TCB explicitly documented: `auth/`, `crypto/`, `policy/` directories. Total: ~2,000 lines reviewable in one session.
- Typed interfaces enforce security: `SafeQuery` type accepted by database layer (raw strings rejected at compile time). `HtmlSafeString` type required by template renderer.
- Security invariants enforced by framework: all routes go through auth middleware (no opt-out without explicit `@PublicEndpoint` annotation that triggers security review).
- New team member can understand security boundaries from the architecture doc within a day.

## GSR3: Weak zero trust (Score 1-2)

- "Our services are in a VPC, so they're secure." Internal services communicate over plaintext HTTP.
- No service-to-service authentication. Any pod in the cluster can call any service.
- Access control based on network segmentation alone. Once inside the VPN, full access.
- No centralized policy engine. Access rules scattered across service configs.

## GSR3: Adequate zero trust (Score 3)

- Internal services use API keys or service tokens for authentication, but not mTLS.
- Network segmentation limits which services can communicate (security groups / network policies).
- Some critical services (payment, auth) require additional identity verification for callers.
- No centralized policy engine — each service manages its own access rules.
- Access decisions logged for critical services but not for all internal calls.

## GSR3: Strong zero trust (Score 4-5)

- Service mesh (Istio/Linkerd) enforces mTLS for all service-to-service communication. No plaintext internal traffic.
- Every request authenticated and authorized: identity (who) + device/service posture (what) + context (when/where/how).
- Centralized policy engine (OPA/Cedar) makes access decisions. Policies versioned and auditable.
- Lateral movement testing confirms: compromising service A does not grant access to service B's data.
- All access decisions logged and reviewable. Anomalous access patterns alerted.

## GSR4: Weak build integrity (Score 1-2)

- Developers deploy from their laptops using `kubectl apply`. No CI/CD pipeline required.
- Code review optional — "we trust our developers." Some PRs merged without review.
- No artifact signing. Docker images tagged `latest` in production.
- Configuration changed directly in production via SSH or cloud console.

## GSR4: Adequate build integrity (Score 3)

- CI/CD pipeline builds and deploys. Code review required by policy but the tooling allows force-merge.
- Build artifacts stored in registry but not signed. Images tagged with git SHA (better than `latest`).
- Most config managed as code (Terraform, Helm), but some production settings changed manually for emergencies.
- No deploy-time admission control — any image from the registry can be deployed.

## GSR4: Strong build integrity (Score 4-5)

- Binary Authorization enforced: Kubernetes admission controller rejects unsigned images. Only images signed by the CI pipeline and code review attestor deploy.
- Non-author code review enforced by tooling — PRs cannot merge without approval from someone other than the author.
- Build provenance captured: SLSA Level 3 — builds hermetic, provenance signed, source and build platforms verified.
- Config-as-code for everything — no manual production changes. Emergency deploy process exists but is audited and requires two-party approval.

## GSR5: Weak structural security (Score 1-2)

- Security depends entirely on developers remembering the rules. "We have a security wiki."
- Raw SQL construction, manual HTML escaping, hand-rolled crypto wrappers.
- APIs default to unsafe: `allowAllOrigins: true`, `validateInput: false` unless developers opt in.
- Same vulnerability class (XSS, SQLi) found and patched repeatedly in different modules.

## GSR5: Adequate structural security (Score 3)

- ORM used for most database access (structural SQLi prevention) but raw query escape hatches used in ~20% of queries.
- Template engine auto-escapes HTML by default, but developers bypass it for rich content without sanitization.
- Some framework-level protections (CSRF tokens, security headers) but not comprehensive.
- Mix of structural and manual security — depends on which module and which developer.

## GSR5: Strong structural security (Score 4-5)

- ORM-only data access — no raw SQL escape hatch available. SQL injection structurally eliminated.
- Auto-escaping template engine with no bypass except through explicitly named `renderUnsanitized()` that requires security review.
- Memory-safe language eliminates buffer overflow class entirely.
- APIs default safe: CORS deny-all, input validation required (type-checked schemas), auth required (opt-out requires annotation).
- Team tracks eliminated vulnerability classes: "SQLi: structurally eliminated since v2.0. XSS: structurally eliminated since v3.1."

## GSR6: Weak adversary profiling (Score 1-2)

- Adversaries described as "hackers" or "bad actors" with no further detail.
- No insider threat consideration. "Our employees are trustworthy."
- Controls designed without adversary model — security measures chosen from checklists, not threat-informed.
- No kill chain analysis. No understanding of how an attacker progresses through the system.

## GSR6: Adequate adversary profiling (Score 3)

- Two adversary categories considered: external attackers (credential stuffing, injection) and insiders (accidental data exposure).
- Some insider threat mitigations: access logging, principle of least privilege for database access.
- No kill chain mapping. Detection focused on known attack signatures, not adversary progression.
- Controls address common attacks but not calibrated to specific adversary capabilities.

## GSR6: Strong adversary profiling (Score 4-5)

- All 7 categories profiled:
  - **Nation-state**: APT, supply chain compromise. Likelihood: low. Impact: critical. Mitigations: SLSA, supply chain monitoring.
  - **Organized crime**: Credential stuffing, payment fraud. Likelihood: high. Impact: high. Mitigations: rate limiting, fraud detection.
  - **Insider**: Privileged access abuse. Likelihood: medium. Impact: critical. Mitigations: separation of duties, access anomaly detection.
  - **Hacktivist**: DDoS, defacement. Likelihood: medium. Impact: medium. Mitigations: CDN, WAF.
  - **Competitor**: Data scraping, intelligence. Likelihood: medium. Impact: medium. Mitigations: rate limiting, access controls.
  - **Opportunistic**: Automated scanning, known CVEs. Likelihood: high. Impact: variable. Mitigations: patching, WAF.
  - **Automated**: Bots, credential stuffing at scale. Likelihood: high. Impact: medium. Mitigations: bot detection, CAPTCHA.
- Insider threat matrix: DBA can access all data → mitigated by audit logging + anomaly detection. DevOps can deploy → mitigated by Binary Authorization.
- Kill chain mapped: recon (detected by WAF) → initial access (auth controls) → lateral movement (zero trust containment) → exfiltration (DLP, anomaly detection).

## GSR7: Weak vulnerability pattern awareness (Score 1-2)

- Vulnerabilities fixed one at a time with no root cause analysis. "We patched the XSS."
- Same vulnerability class (stored XSS) found in three different features over six months.
- No awareness of CWE Top 25 or domain-specific vulnerability patterns.
- No post-mortem process for security findings.

## GSR7: Adequate vulnerability pattern awareness (Score 3)

- Team aware of OWASP Top 10 and uses it as a reference during code review.
- Post-mortems written for critical vulnerabilities but follow-up actions not tracked.
- Root cause analysis performed ad hoc — some bugs traced to missing input validation, but no systematic pattern tracking.
- Vulnerability recurrence not measured. "We think we fixed all the XSS."

## GSR7: Strong vulnerability pattern awareness (Score 4-5)

- Root cause analysis for all critical/high vulnerabilities. Findings categorized by CWE.
- Dominant patterns tracked: "72% of our vulnerabilities in the last year were CWE-79 (XSS) and CWE-89 (SQLi). Both now structurally eliminated."
- Project Zero publications and CVE trends reviewed quarterly for relevant vulnerability classes.
- Post-mortems feed architectural improvements: "3 XSS bugs in user-generated content → switched to auto-escaping template engine (structural fix)."
- Recurrence rate measured and declining: "XSS recurrence: 5 in Q1 → 2 in Q2 → 0 since Q3 (structural elimination)."

## Comparison table

| Aspect | Weak (Score 1-2) | Adequate (Score 3) | Strong (Score 4-5) |
|--------|------------------|-------------------|-------------------|
| GSR1: Design doc security | No security section or afterthought paragraph | Security checklist exists, partial threat-to-design tracing | Structured section with end-to-end traceability |
| GSR2: TCB | Security logic scattered, raw operations | Security modules exist but not isolated, mixed primitives | Explicit TCB with typed interfaces, structurally enforced |
| GSR3: Zero trust | Network perimeter = trust boundary | Service tokens, some segmentation, no centralized policy | mTLS everywhere, centralized policy, lateral movement tested |
| GSR4: Build integrity | Deploy from laptop, optional review | CI/CD exists, review required but bypassable, unsigned artifacts | Binary Authorization, SLSA Level 3, config-as-code enforced |
| GSR5: Structural security | Developer discipline only, unsafe defaults | ORM for most queries, some framework protections | Vulnerability classes eliminated structurally, safe-by-default APIs |
| GSR6: Adversary profiling | Generic "hackers", no insider threat model | 2 categories, basic insider mitigations, no kill chain | 7 categories profiled, insider matrix, kill chain mapped |
| GSR7: Vulnerability patterns | Patch-and-move-on, no root cause analysis | OWASP-aware, ad hoc post-mortems | CWE-categorized, recurrence tracked, structural elimination |
