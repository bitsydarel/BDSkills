# Feedback template

Structured output format for Security reviews. For filled examples, see [feedback-example-proposal.md](feedback-example-proposal.md) and [feedback-example-implementation.md](feedback-example-implementation.md).

## Severity levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Active vulnerability or missing control that could lead to breach | Must resolve before proceeding |
| **Major** | Significant security gap that increases attack surface or weakens defense | Should resolve before launch |
| **Minor** | Small gap or hardening opportunity | Consider addressing |
| **Suggestion** | Defense-in-depth enhancement | Optional |

## Full review template

```markdown
## Security Review

**Input**: [What was reviewed — e.g., "Payment Processing API v2 Design Spec"]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Security
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### Lens 1: Threat Analysis scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| T1 | Attack Surface & Entry Point Mapping | /5 | |
| T2 | Threat Modeling (STRIDE Analysis) | /5 | |
| T3 | Trust Boundaries & Data Flow Security | /5 | |
| T4 | Adversary & Risk Assessment | /5 | |
| | **Lens 1 Total** | **/20** | |

### Lens 2: Application Security scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| A1 | Authentication & Session Management | /5 | |
| A2 | Authorization & Access Control | /5 | |
| A3 | Input Validation & Injection Prevention | /5 | |
| A4 | Data Protection & Cryptography | /5 | |
| A5 | Supply Chain & Dependency Security | /5 | |
| A6 | Secure Coding & Error Handling | /5 | |
| A7 | UI/UX Security & Anti-Social Engineering | /5 | |
| | **Lens 2 Total** | **/35** | |

### Lens 3: Operational Security scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| O1 | Security Logging & Monitoring | /5 | |
| O2 | Incident Detection & Response | /5 | |
| O3 | Infrastructure & Configuration Hardening | /5 | |
| O4 | Resilience, Recovery & Continuity | /5 | |
| | **Lens 3 Total** | **/20** | |

### Lens 4: Compliance & Governance scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| G1 | Regulatory Compliance | /5 | |
| G2 | Privacy by Design | /5 | |
| G3 | Security Governance & Policy | /5 | |
| G4 | Audit Trail & Accountability | /5 | |
| | **Lens 4 Total** | **/20** | |

### Google Security Review scorecard (/35)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| GSR1 | Design Document Security Completeness | /5 | |
| GSR2 | Trusted Computing Base & Understandability | /5 | |
| GSR3 | Zero Trust Architecture Validation | /5 | |
| GSR4 | Binary Authorization & Build Integrity | /5 | |
| GSR5 | Structural Security Posture | /5 | |
| GSR6 | Adversary-Centric Threat Profiling | /5 | |
| GSR7 | Vulnerability Pattern Awareness | /5 | |
| | **GSR Total** | **/35** | |

### Overall score

| Lens | Score | Max | % |
|------|-------|-----|---|
| Lens 1: Threat Analysis | | 20 | |
| Lens 2: Application Security | | 35 | |
| Lens 3: Operational Security | | 20 | |
| Lens 4: Compliance & Governance | | 20 | |
| **Core Total** | | **95** | |
| Google Security Review | | 35 | |
| **Combined Total** | | **130** | |

**Weakest lens**: [Lens name and percentage]
**Critical override triggered**: [Yes/No — any criterion scored 1?]
**GSR override triggered**: [Yes/No — any GSR criterion scored 1, GSR total < 14/35, or GSR-Core amplification pair?]

### Security compliance checklist (implementation reviews only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| All entry points identified and tested | [Yes/No/Partial] | |
| Authentication controls verified | [Yes/No/Partial] | |
| Authorization tested at object level | [Yes/No/Partial] | |
| Input validation confirmed (DAST/fuzzing) | [Yes/No/Partial] | |
| Encryption at rest and transit verified | [Yes/No/Partial] | |
| Dependencies scanned and patched | [Yes/No/Partial] | |
| Security logging confirmed in production | [Yes/No/Partial] | |
| Incident response plan tested | [Yes/No/Partial] | |
| Compliance requirements mapped | [Yes/No/Partial] | |
| Secrets management verified | [Yes/No/Partial] | |

### Critical issues
- [ ] [Issue] — [Criterion ID + Name] — [Required action]

### Major issues
- [ ] [Issue] — [Criterion ID + Name] — [Recommended action]

### Minor issues
- [ ] [Issue] — [Criterion ID + Name] — [Suggestion]

### Strengths
- [What is well-done from a security perspective]

### Top recommendation
[One highest-priority security action]

### Key question for the team
[The single most important security question to answer]
```

## Quick review template

```markdown
## Security Review (quick)

**Input**: [...] | **Mode**: [...] | **Verdict**: [...] | **Core**: /95 | **GSR**: /35 | **Combined**: /130

**Lens Scores**: T: /20 | A: /35 | O: /20 | G: /20 | GSR: /35
**Weakest Lens**: [Lens name and %]
**GSR Override**: [Yes/No]
**Top Risks**: [1-2 highest security concerns]
**Strengths**: [1-2 positive security signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```

## Guidance note

Prioritize the top 5-10 critical and major issues. Avoid overwhelming the reader with exhaustive lists of every possible security improvement. Focus on issues that represent actual exploitable risk, not theoretical edge cases. The goal is actionable security feedback that the team can remediate in priority order, not a comprehensive audit of everything that could theoretically go wrong. When in doubt, ask: "Could an attacker actually exploit this?" and "What is the blast radius if they do?"
