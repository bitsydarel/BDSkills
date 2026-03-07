# Calibration: Threat Analysis (Lens 1)

What good threat analysis looks like — reference examples for scoring T1-T4.

## T1-T2: Weak threat model (Score 1-2)

- "We use HTTPS and require login, so the system is secure."
- Attack surface described as "the API" with no endpoint enumeration.
- No STRIDE analysis — threats described vaguely as "hackers might try to break in."
- Trust boundaries not identified — all components treated as equally trusted.
- Risk described qualitatively ("medium risk") without criteria for what medium means.

## T1-T2: Adequate threat model (Score 3)

- External API endpoints listed with auth requirements, but internal service-to-service boundaries not mapped. "We'll add those later."
- STRIDE applied at the system level — Spoofing and Tampering addressed with mitigations, but Repudiation and Information Disclosure treated as one-liners ("we log stuff," "we use HTTPS").
- Trust boundaries mentioned in architecture doc but not annotated on diagrams. Data flow described narratively, not as a DFD.
- Risks listed with generic high/medium/low labels based on team discussion, but no DREAD scores or threat actor profiles. "We know credential stuffing is a risk."

## T1-T2: Strong threat model (Score 4-5)

- Every endpoint documented: `POST /api/auth/login` (public, unauthenticated), `GET /api/users/{id}` (authenticated, user-scoped), `POST /api/admin/users` (authenticated, admin-only).
- STRIDE applied per component:
  - **Spoofing**: JWT tokens could be forged if signing key is compromised → Mitigation: key rotation via KMS, short-lived tokens (15 min).
  - **Tampering**: Request body could be modified in transit → Mitigation: TLS 1.3, request signing for webhooks.
  - **Repudiation**: User denies performing an action → Mitigation: immutable audit log with user ID, timestamp, IP, action.
  - **Info Disclosure**: Error responses could reveal stack traces → Mitigation: generic error messages, correlation IDs for internal lookup.
  - **DoS**: Unbounded queries could exhaust resources → Mitigation: rate limiting (100 req/min per user), query complexity limits (depth 10, cost 1000).
  - **Elevation**: Regular user accesses admin endpoints → Mitigation: RBAC with server-side enforcement on every endpoint, object-level authz.
- Trust boundaries drawn on architecture diagram: external users → CDN → API gateway → backend services → database.
- Data Flow Diagrams annotate each boundary crossing with the validation performed.

## T3: Weak trust boundaries (Score 1-2)

- No trust boundaries identified. Architecture diagram shows boxes and arrows but no security annotations.
- Internal microservices communicate over plaintext HTTP. "They are behind the VPC."
- Data from external APIs consumed without validation — "we trust our payment provider."
- No DFDs. Sensitive data paths untraced. Nobody knows which services handle PII.

## T3: Adequate trust boundaries (Score 3)

- Trust boundaries identified for external-facing components (users to API gateway) but not between internal services. "Everything behind the gateway is trusted."
- DFDs started for the main user data flow but not for admin or background processing paths. PII handling partially traced — known for user service, unknown for analytics pipeline.
- Internal services use TLS but no mutual authentication. Network segmentation exists at the VPC level but not at the service level.
- External API responses loosely validated — checked for HTTP status codes but not against a response schema. Failure modes handled with generic retries.

## T3: Strong trust boundaries (Score 4-5)

- DFDs trace PII end-to-end: user browser → API gateway (TLS termination, JWT validation) → auth service (credential verification) → user DB (encrypted PII columns).
- Every trust boundary crossing annotated with: data validated, authentication checked, authorization enforced.
- mTLS between all internal services. Network policies restrict which services can talk to each other.
- External API consumption treated as trust crossing: responses validated against schema, failure modes handled gracefully, TLS certificate verified.
- Runtime monitoring detects anomalous cross-boundary flows (unexpected service-to-service calls).

## T4: Weak risk assessment (Score 1-2)

- Risks acknowledged informally: "We should probably worry about credential stuffing."
- No threat actor profiling — all attackers treated as generic "hackers."
- No quantification. Risks listed as "high/medium/low" without criteria.
- No risk register. Risk prioritization based on the loudest voice in the room.

## T4: Adequate risk assessment (Score 3)

- Risk register exists in a spreadsheet with identified threats, but scoring is qualitative (high/medium/low) based on team consensus rather than a formal framework like DREAD.
- Threat actors described generically — "external attackers" and "insiders" — without detailed profiling of capabilities, motivation, or likelihood.
- Top risks identified and discussed during design reviews, but not revisited after launch. No quarterly review cadence.
- Some threats validated against production data (e.g., login failures monitored), but no systematic correlation between threat model predictions and observed attack patterns.
- Risk acceptance decisions made informally in Slack threads rather than documented with executive sign-off.

## T4: Strong risk assessment (Score 4-5)

- Threat actor profiles documented:
  - **Script kiddies**: Automated scanning, known CVE exploitation. Likelihood: high. Impact: medium.
  - **Financially motivated criminals**: Credential stuffing, payment fraud, ransomware. Likelihood: high. Impact: high.
  - **Insider threat**: Privileged access abuse, data exfiltration. Likelihood: medium. Impact: critical.
  - **Nation-state**: Targeted APT, supply chain compromise. Likelihood: low. Impact: critical.
- Risk register with DREAD scoring, acceptance rationale, and quarterly review cadence.
- Incident data validates assumptions: actual credential stuffing attempts logged at 10K/day, matching threat model prediction.

## Worked DREAD scoring example

**Threat**: Credential stuffing against the login endpoint using leaked credential databases.

| Factor | Score | Rationale |
|--------|-------|-----------|
| **Damage** | 7 | Account takeover → unauthorized purchases, PII exposure, reputational harm. Not full system compromise. |
| **Reproducibility** | 9 | Highly reproducible: leaked credential lists are publicly available, tooling is automated (Sentry MBA, OpenBullet). |
| **Exploitability** | 8 | Requires minimal skill. Pre-built tools available. No need to find a novel vulnerability. |
| **Affected Users** | 6 | Users who reuse passwords across services (~65% of users per Google research). Not all users affected. |
| **Discoverability** | 10 | Login endpoint is public by definition. Attack technique is well-known and documented. |

**DREAD Score**: (7 + 9 + 8 + 6 + 10) / 5 = **8.0 → High Risk**

**Action**: Immediate remediation. Implement rate limiting (10 attempts/15 min per username), CAPTCHA after 5 failures, credential stuffing detection (impossible travel, known-leaked password check via HaveIBeenPwned API), and enforce MFA for accounts with failed login spikes.

**Contrast with lower-risk threat**: CSRF on a "change display name" endpoint would score DREAD ~3.2 (low damage, low affected users, requires specific setup) → Low Risk, remediate when convenient.

## Comparison table

| Aspect | Weak (Score 1-2) | Adequate (Score 3) | Strong (Score 4-5) |
|--------|------------------|-------------------|-------------------|
| T1: Attack surface | "Our API and website" | External endpoints listed with auth requirements, internal boundaries not mapped | Enumerated endpoints with auth requirements, exposure levels, and data formats |
| T2: Threat modeling | No STRIDE or ad-hoc "what could go wrong" | STRIDE at system level, major threats addressed, minor categories superficial | STRIDE per component with mitigations mapped to controls and test evidence |
| T3: Trust boundaries | Not identified | External boundaries identified, internal trust assumed, partial DFDs | DFD with annotated crossings, validation at every transition, runtime monitoring |
| T4: Risk assessment | "Medium risk" with no criteria | Risk register with qualitative scoring, generic threat actors, no review cadence | DREAD scores with worked examples, threat actor profiles, risk register with quarterly review |
