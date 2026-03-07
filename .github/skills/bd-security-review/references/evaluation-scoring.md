# Evaluation scoring

Scoring scale, weighting guide, and verdict thresholds for the security review.

## Scoring scale

| Score | Label | Boundary Definition |
|-------|-------|-------------------|
| 5 | Excellent | All requirements for the criterion met with evidence. Controls tested and verified (pen test, DAST, audit). No known gaps. Exceeds the risk level's required controls — applies practices from the level above |
| 4 | Good | All core requirements met. Minor gaps exist but none in high-impact areas. Controls implemented and functioning but not all independently verified. Meets the risk level's required controls fully |
| 3 | Adequate | Core intent addressed but with notable gaps. The "what" is present but the "how well" falls short. Some controls implemented partially, or implemented fully but untested. Meets ~60-80% of the risk level's required controls |
| 2 | Weak | Significant gaps. The topic is acknowledged but controls are incomplete, incorrectly implemented, or unverified. Meets <60% of the risk level's required controls. Requires rework before production |
| 1 | Missing | Not addressed, fundamentally flawed, or actively dangerous (e.g., hardcoded secrets, plaintext passwords). The absence of the control is itself a vulnerability |

### Score boundary decision aid

When uncertain between two adjacent scores, use these questions:

| Deciding Between | Ask |
|-----------------|-----|
| **5 vs 4** | Is there independent verification (pen test, audit, DAST results) confirming the control works? Are controls updated proactively based on threat intelligence? |
| **4 vs 3** | Are all high-impact areas fully covered? Could an attacker find a gap in a targeted assessment? Are controls tested, not just implemented? |
| **3 vs 2** | Is the core control present and functioning for the most common attack vector? Or is it only partially implemented with major scenarios uncovered? |
| **2 vs 1** | Does anything exist? Is the current state better than having no control at all? Or does the existing implementation create false confidence (security theater)? |

**Tie-breaker rule**: When evidence is ambiguous between two scores, assign the lower score. Security reviews should under-score rather than over-score to avoid false confidence.

## Lens weighting guide

Default weighting is equal across all criteria within each lens. Adjust emphasis by input type:

| Input Type | Higher Weight Lenses/Criteria | Lower Weight |
|-----------|-------------------------------|-------------|
| New feature proposal | Lens 1 (Threat Analysis), A1-A3 | O1-O4, G3-G4 |
| API design/spec | A1-A3, A7, T1-T2 | G3-G4, O4 |
| Bug fix | A3, A6, O1-O2 | T4, G1-G4 |
| Infrastructure change | O3-O4, T3, A5 | A7, G2 |
| Deployment plan | O1-O4, A5, T1 | A7, G2 |
| Existing system audit | All lenses equally | None |
| Data handling feature | A4, G1-G2, T3 | O4, A7 |
| Auth system change | A1-A2, T2, G4 | A5, O4 |
| Compliance assessment | G1-G4, O1, O3 | T4, A7 |

Weighting adjusts emphasis in the rationale, not the scoring scale. All criteria still receive a 1-5 score.

## Verdict thresholds

### Proposal reviews

| Verdict | Overall % | Lens Minimum | Meaning |
|---------|-----------|-------------|---------|
| **Proceed** | >= 80% (76+/95) | AND no lens below 60% | Strong security posture; ready to build |
| **Proceed with Conditions** | >= 60% (57+/95) | AND no lens below 40% | Viable but security gaps need addressing before launch |
| **Rework Required** | < 60% (<57/95) | OR any lens below 40% | Fundamental security gaps; return to design |

### Implementation reviews

| Verdict | Overall % | Lens Minimum | Meaning |
|---------|-----------|-------------|---------|
| **Meets Standards** | >= 80% (76+/95) | AND no lens below 60% | Security controls effective and verified |
| **Needs Improvement** | >= 60% (57+/95) | AND no lens below 40% | Controls present but gaps require remediation |
| **Critical Gaps** | < 60% (<57/95) | OR any lens below 40% | Serious vulnerabilities; immediate remediation required |

### Critical rules

Regardless of total score:
- **Critical override**: Any single criterion scoring 1 = cannot receive "Proceed" or "Meets Standards" verdict
- **Weakest-link rule**: Any lens scoring below 40% of its maximum = automatic "Rework Required" / "Critical Gaps" regardless of overall score
- **Lens 1 + Lens 2 critical pair**: Both Lens 1 (Threat Analysis) and Lens 2 (Application Security) scoring below 50% = automatic "Rework Required" / "Critical Gaps"

---

## Multi-lens integration

Security findings often span multiple lenses. Use these rules to handle cross-lens interactions and prioritize findings.

### Cross-lens amplification rules

When a finding appears in multiple lenses, its severity amplifies. These combinations indicate systemic issues, not isolated gaps.

| Finding in Lens A | + Finding in Lens B | Amplification |
|-------------------|-------------------|---------------|
| T2: No threat model for auth flows | A1: Weak authentication | **Amplified to Critical** — auth was not designed securely AND implemented poorly; attacker path is clear |
| T3: Trust boundaries not enforced | A3: Input validation gaps | **Amplified to Critical** — untrusted data crosses boundaries without validation; injection likely |
| A4: Weak encryption | G1: Regulatory non-compliance | **Amplified to Critical** — data protection failure with regulatory exposure; breach = enforcement action |
| A5: No supply chain controls | O3: No infrastructure scanning | **Amplified to High** — neither application nor infrastructure dependencies are verified; blind to compromise |
| O1: No security logging | O2: No incident response | **Amplified to Critical** — cannot detect AND cannot respond; breaches persist indefinitely |
| A1: Weak auth | A2: Weak authz | **Amplified to Critical** — an attacker who bypasses auth also has no authz barrier; full access |
| G2: Excessive data collection | G4: No audit trail | **Amplified to High** — collecting data you cannot account for; regulatory and forensic exposure |
| T1: Incomplete attack surface | O3: Default configurations | **Amplified to High** — unknown entry points with weak defaults; attacker discovers before defender |

**Application rule**: When two findings from different lenses match an amplification pair, escalate the combined finding one severity level above the higher individual severity. Note the amplification in the review output with both lens references.

### Finding prioritization matrix (P1-P4)

Classify every finding into a priority level based on exploitability and impact. This determines remediation urgency.

| Priority | Exploitability | Impact | Remediation SLA | Examples |
|----------|---------------|--------|----------------|---------|
| **P1 — Critical** | Exploitable now with public tools or trivial effort | System compromise, data breach, or regulatory violation | Immediate (hotfix within 24h) | SQL injection in production, hardcoded admin credentials, plaintext PII in public S3 bucket, auth bypass |
| **P2 — High** | Exploitable with moderate effort or specific conditions | Significant data exposure, account takeover, or compliance failure | Within current sprint (1-2 weeks) | Missing MFA on admin, IDOR on user data, unpatched critical CVE, no rate limiting on login |
| **P3 — Medium** | Requires chained exploits or insider access | Limited data exposure, service disruption, or partial compliance gap | Within current quarter | Missing CSP, verbose error messages, outdated TLS version, incomplete logging |
| **P4 — Low** | Theoretical or defense-in-depth improvement | Minimal direct impact, improved security posture | Backlog (track and remediate when convenient) | Missing SRI on CDN resources, info disclosure in headers, documentation drift |

### Priority assignment rules

1. **Start with impact**: What is the worst-case outcome if this finding is exploited?
2. **Adjust by exploitability**: A high-impact finding that requires nation-state capability may be P3, not P1
3. **Check amplification**: Cross-lens amplification (above) can elevate priority by one level
4. **Risk level context**: The same finding may be P3 for a Low-risk internal tool but P1 for a Critical-risk payment system. Use the risk profile from [frameworks-risk-profiles.md](frameworks-risk-profiles.md)
5. **Group related findings**: If 3+ findings share a root cause (e.g., no input validation framework), report the root cause at the highest priority of any individual finding

### Cross-lens pattern detection

During the synthesis step (Step 7 in the review workflow), look for these systemic patterns:

| Pattern | Indicators | What It Means |
|---------|-----------|---------------|
| **Design gap** | Low scores in Lens 1 (T1-T4) AND corresponding low scores in Lens 2 | Threats were not identified at design time, leading to missing controls in implementation |
| **Implementation gap** | High scores in Lens 1 but low in Lens 2 | Threats were identified but controls were not implemented. Execution failure |
| **Operational gap** | High scores in Lens 2 but low in Lens 3 | Controls exist but cannot be monitored, tested, or maintained. Sustainability failure |
| **Governance gap** | Low Lens 4 with moderate Lens 1-3 | Security exists informally but without process. One key person leaving breaks everything |
| **Security theater** | Moderate scores across all lenses but no verification evidence | Controls appear present but are untested. False confidence. Reclassify all "adequate" scores to "weak" if no evidence supports them |

---

## Google Security Review integration

The Google Security Review (GSR) is a **mandatory** step that runs after all four lenses. It scores 7 criteria (GSR1-GSR7) at 5 points each = /35. For detailed scoring criteria, see [evaluation-google-security-review.md](evaluation-google-security-review.md).

### Scoring relationship

- **Core verdict** is determined by the /95 score using existing thresholds (unchanged)
- **GSR score** is reported alongside the core score: Core /95 + GSR /35 = Combined /130
- **GSR can only escalate** — it can downgrade a verdict but never upgrade one

### GSR override rules (escalation only)

These rules prevent a "Proceed" or "Meets Standards" verdict regardless of core score:

| Rule | Condition | Effect |
|------|-----------|--------|
| **GSR critical override** | Any single GSR criterion scores 1 | Prevents "Proceed" / "Meets Standards" |
| **GSR floor override** | GSR total below 40% (< 14/35) | Prevents "Proceed" / "Meets Standards" |
| **GSR-Core amplification** | Both criteria in a pair score ≤ 2 | Automatic "Rework Required" / "Critical Gaps" |

### GSR-Core amplification pairs

When both the GSR criterion and the core criterion it extends score ≤ 2, the combined weakness indicates a systemic gap that triggers automatic "Rework Required" / "Critical Gaps":

| GSR Criterion | Core Criterion | What the Pair Indicates |
|--------------|----------------|------------------------|
| GSR3 (Zero Trust) | T3 (Trust Boundaries) | No trust boundary design AND no zero trust enforcement — lateral movement unconstrained |
| GSR4 (Build Integrity) | A5 (Supply Chain) | No supply chain controls AND no build integrity — unverified code in production |
| GSR6 (Adversary Profiling) | T4 (Risk Assessment) | No risk assessment AND no adversary model — security controls not threat-informed |

### GSR weighting by input type

GSR criteria apply to all input types but emphasis shifts:

| Input Type | Higher Weight GSR Criteria | Lower Weight GSR Criteria |
|-----------|---------------------------|--------------------------|
| New feature proposal | GSR1, GSR5, GSR3 | GSR4, GSR7 |
| API design/spec | GSR2, GSR3, GSR5 | GSR7 |
| Infrastructure change | GSR3, GSR4 | GSR1, GSR7 |
| Deployment plan | GSR4, GSR3 | GSR1, GSR5 |
| Existing system audit | All equally | None |
| Auth system change | GSR3, GSR2, GSR6 | GSR7 |
| Bug fix | GSR7, GSR5 | GSR1, GSR6 |
