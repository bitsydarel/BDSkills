# Google Security Review (/35)

Scoring criteria for the 7 Google Security Review dimensions. This step is **mandatory** and runs after all four lenses. For scoring scale and verdict thresholds, see [evaluation-scoring.md](evaluation-scoring.md). For GSR override rules and integration with core scoring, see the "Google Security Review integration" section in [evaluation-scoring.md](evaluation-scoring.md).

---

## GSR1: Design Document Security Completeness

**Proposal questions**: Does the design document include a dedicated security section covering assets, threats, mitigations, and residual risks? Are security requirements traced from threat model to design decisions? Does it identify trusted and untrusted inputs, privilege boundaries, and data classification?

**Implementation-Compliance questions**: Were all security requirements from the design document implemented? Are deviations documented with risk acceptance? Does the implementation match the security architecture described in the design?

**Implementation-Results questions**: Has the design document been updated to reflect post-launch security learnings? Are gap analyses feeding back into the next design iteration?

**Scoring**:
- **5 (Excellent)**: Dedicated security section with assets, threats, mitigations, and residual risks. Security requirements traced end-to-end from threat model through design to implementation. Data classification complete. Design reviewed by security-knowledgeable peer.
- **4 (Good)**: Security section present with threats and mitigations documented. Most security requirements traceable. Minor gaps in residual risk documentation or data classification.
- **3 (Adequate)**: Security considerations mentioned but not in a structured section. Some threats identified but mitigations not systematically mapped. Security requirements exist but not traced to design decisions.
- **2 (Weak)**: Security addressed as an afterthought — a paragraph or bullet list with no structured analysis. No traceability between threats and design decisions.
- **1 (Missing)**: No security section in design document, or no design document exists.

**Quality check**: Verify the design document answers: What are we protecting? From whom? How? What remains unmitigated and why is that acceptable?

---

## GSR2: Trusted Computing Base & Understandability

**Proposal questions**: Is the Trusted Computing Base (TCB) explicitly identified and minimized? Are security-critical components isolated with typed, narrow interfaces? Does the design use security-primitive libraries (SafeSQL, SafeHTML, safe URL builders) rather than raw string operations? Is the security-critical code small enough to be reviewable?

**Implementation-Compliance questions**: Is the TCB implemented as designed — minimal, isolated, and reviewable? Are typed interfaces enforced at compile time or runtime? Are security primitives (parameterized queries, context-aware escaping) used consistently?

**Implementation-Results questions**: Can a new team member understand the security boundaries within one day? Has the TCB grown beyond its original scope? Are security-critical code paths covered by focused review?

**Scoring**:
- **5 (Excellent)**: TCB explicitly identified, minimized, and isolated. Security-critical code uses typed interfaces (SafeSQL, SafeHTML) that make insecure usage a compile/lint error. TCB reviewable by one person in one session. Security invariants documented and enforced by type system or framework.
- **4 (Good)**: TCB identified and mostly isolated. Security primitives used for most operations. Minor TCB boundary leakage in non-critical areas. Code reviewable but requires domain knowledge.
- **3 (Adequate)**: Security-critical code identifiable but not explicitly isolated. Some use of security primitives mixed with raw operations. TCB scope informally understood but not documented.
- **2 (Weak)**: No explicit TCB. Security logic scattered across codebase. Raw string operations used for security-sensitive paths. Reviewability poor — security-critical code entangled with business logic.
- **1 (Missing)**: Security-critical code indistinguishable from general code. No security primitives. No concept of a trusted computing base.

**Quality check**: Can you point to the exact modules/classes that comprise the TCB? If not, the TCB is not well-defined.

---

## GSR3: Zero Trust Architecture Validation

**Proposal questions**: Does the design assume no implicit trust based on network location? Is every request authenticated and authorized regardless of origin? Is access context-aware (device posture, user identity, request context)? Is there a centralized policy enforcement point?

**Implementation-Compliance questions**: Are internal service-to-service calls authenticated (mTLS, service tokens)? Is network location insufficient for access — does access require identity + device + context? Is policy enforcement centralized and auditable?

**Implementation-Results questions**: Has zero trust been validated — do internal services reject unauthenticated requests? Are access decisions logged and reviewable? Has lateral movement testing confirmed containment?

**Scoring**:
- **5 (Excellent)**: Full zero trust implementation — every request authenticated and authorized regardless of network. Context-aware access (identity + device posture + request context). Centralized policy engine. Lateral movement tested and contained. Service mesh or equivalent enforces mTLS universally.
- **4 (Good)**: Zero trust principles applied — internal services authenticated with mTLS or service tokens. Context-aware access for sensitive operations. Policy enforcement centralized for most services. Minor gaps in legacy or non-critical internal paths.
- **3 (Adequate)**: Some zero trust elements — internal services use service tokens but not mTLS. Network segmentation supplements identity-based access. No centralized policy engine. Access decisions based on identity but not device context.
- **2 (Weak)**: Network-perimeter security model — services behind VPC/firewall considered trusted. Internal traffic unencrypted or unauthenticated. "If it's inside the network, it's safe."
- **1 (Missing)**: No zero trust consideration. Internal services communicate freely without authentication. Network location is the sole access control.

**Quality check**: Ask: "If an attacker compromises one internal service, what else can they access without additional authentication?" The answer reveals zero trust maturity.

---

## GSR4: Binary Authorization & Build Integrity

**Proposal questions**: Does the design require that only reviewed, tested, and signed code can be deployed? Is there a non-author review requirement for all production changes? Is build provenance captured and verifiable? Is configuration treated as code with the same review/deploy controls?

**Implementation-Compliance questions**: Is Binary Authorization (or equivalent admission control) enforced at deploy time? Are builds reproducible with signed provenance attestations? Do production deployments reject unsigned or unreviewed artifacts? Is config-as-code enforced — no manual production configuration changes?

**Implementation-Results questions**: Have unauthorized deployment attempts been detected and blocked? Is the full provenance chain auditable from commit to production artifact? Has the build pipeline been tested against supply chain attacks?

**Scoring**:
- **5 (Excellent)**: Binary Authorization enforced — only signed, reviewed, tested artifacts deploy. Non-author code review required. Build provenance with SLSA Level 3+. Config-as-code with same review gates. Pipeline hardened against supply chain attacks. Unauthorized deploys blocked and alerted.
- **4 (Good)**: Deploy-time admission control enforced. Code review required for all production changes. Build provenance captured (SLSA Level 2). Config-as-code for most settings. Minor gaps in emergency deploy paths or config exceptions.
- **3 (Adequate)**: Code review required but not enforced by tooling — policy exists but can be bypassed. Build artifacts not signed. Some config managed as code but manual overrides possible. No deploy-time admission control.
- **2 (Weak)**: Code review optional or inconsistent. No artifact signing or provenance. Manual deployments possible. Configuration changes made directly in production.
- **1 (Missing)**: No review requirement for production deploys. Builds not reproducible. No provenance tracking. Anyone with access can deploy anything.

**Quality check**: Can you trace any production artifact back to its source commit, reviewer, and test results? If not, build integrity is incomplete.

---

## GSR5: Structural Security Posture

**Proposal questions**: Does the design eliminate vulnerability classes structurally rather than relying on developer discipline? Are APIs secure by default (opt-in to danger, not opt-in to safety)? Does the architecture make the secure path the easiest path?

**Implementation-Compliance questions**: Are vulnerability classes eliminated at the framework/language level (e.g., parameterized queries by default, auto-escaping templates, memory-safe languages)? Do APIs default to the safe option — are unsafe operations explicitly named and gated? Are there structural protections that prevent common vulnerability patterns regardless of developer awareness?

**Implementation-Results questions**: Has vulnerability scanning confirmed the absence of eliminated vulnerability classes? Are new vulnerability classes from post-launch research being addressed structurally? Is the ratio of structural fixes to individual patches increasing over time?

**Scoring**:
- **5 (Excellent)**: Multiple vulnerability classes eliminated structurally — SQL injection impossible via ORM-only data access, XSS eliminated via auto-escaping templating, memory safety via language choice. APIs default safe with explicitly named unsafe escapes. Developer cannot accidentally introduce eliminated vulnerability classes. Structural elimination tracked and measured.
- **4 (Good)**: Major vulnerability classes addressed structurally. Secure-by-default APIs for most operations. Minor areas where developer discipline still required. Framework guardrails catch common mistakes.
- **3 (Adequate)**: Some structural protections in place (e.g., parameterized queries) but not comprehensive. Mix of secure-by-default and opt-in security. Some vulnerability classes require developer awareness to prevent.
- **2 (Weak)**: Security relies primarily on developer discipline and code review. Few structural protections. APIs default to unsafe behavior. "Security guidelines" exist but enforcement is manual.
- **1 (Missing)**: No structural security approach. All security depends on individual developer knowledge and vigilance. No framework-level protections.

**Quality check**: For each major vulnerability class (SQLi, XSS, CSRF, IDOR, deserialization), ask: "Can a developer who has never heard of this vulnerability accidentally introduce it?" If yes, it is not structurally eliminated.

---

## GSR6: Adversary-Centric Threat Profiling

**Proposal questions**: Are specific adversary categories profiled (nation-state, organized crime, insider, hacktivist, competitor, opportunistic, automated)? Is there an insider threat matrix covering privileged roles? Are adversary capabilities mapped to kill chain stages? Does the threat profile inform control prioritization?

**Implementation-Compliance questions**: Are controls calibrated to the profiled adversary capabilities? Is insider threat mitigated through separation of duties, access logging, and anomaly detection? Are detection capabilities aligned to the expected adversary kill chain?

**Implementation-Results questions**: Has red teaming validated the threat profile assumptions? Are real-world incident patterns consistent with profiled threats? Is the adversary profile updated based on threat intelligence?

**Scoring**:
- **5 (Excellent)**: All 7 adversary categories profiled with capabilities, motivation, and likelihood. Insider threat matrix covering all privileged roles with mitigations. Kill chain mapping (reconnaissance through impact) with detection at each stage. Red team exercises validate the model. Threat intelligence feeds update profiles.
- **4 (Good)**: Major adversary categories profiled (3-5 categories). Insider threat considered with separation of duties for critical operations. Kill chain awareness informs detection rules. Profiles updated periodically.
- **3 (Adequate)**: Adversary thinking present but generic — "external attackers" and "insiders" without detailed profiling. No kill chain mapping. Some insider threat mitigations (access logging) but no formal matrix. Controls not explicitly mapped to adversary capabilities.
- **2 (Weak)**: Adversaries described generically as "hackers" or "threat actors." No capability profiling. No insider threat consideration beyond basic access control. Controls designed without adversary model.
- **1 (Missing)**: No adversary profiling. Security controls designed without considering who the attacker is or what they can do.

**Quality check**: Verify the threat profile answers: Who would attack this system? What are their capabilities? What is their kill chain? Which stage do we detect and disrupt?

---

## GSR7: Vulnerability Pattern Awareness

**Proposal questions**: Has root cause analysis been applied to known vulnerabilities in similar systems? Are dominant vulnerability patterns (from Project Zero, CWE Top 25, domain-specific research) identified and addressed? Does the design prioritize structural elimination of vulnerability classes over individual patching?

**Implementation-Compliance questions**: Are dominant vulnerability patterns from CWE Top 25 and domain research addressed in the codebase? Is the team's vulnerability remediation approach focused on eliminating root causes rather than patching individual instances? Are post-mortems feeding structural improvements?

**Implementation-Results questions**: Is the recurrence rate of previously-fixed vulnerability classes declining? Are vulnerability scan results showing elimination of structurally addressed classes? Does the team track vulnerability patterns across releases?

**Scoring**:
- **5 (Excellent)**: Root cause analysis applied to all vulnerabilities found. Dominant patterns identified from CWE Top 25 and domain-specific research (Project Zero publications, CVE trends). Structural elimination prioritized — recurring vulnerability classes addressed at framework/architecture level. Recurrence rate tracked and declining. Post-mortems feed architectural improvements.
- **4 (Good)**: Root cause analysis for critical and high vulnerabilities. Major vulnerability patterns known and addressed. Mix of structural and individual fixes, trending toward structural. Post-mortems documented with follow-up actions.
- **3 (Adequate)**: Vulnerabilities fixed individually without systematic root cause analysis. Some awareness of common patterns (OWASP Top 10) but not mapped to codebase. Fixes address symptoms rather than causes. Limited post-mortem practice.
- **2 (Weak)**: Patch-and-move-on approach to vulnerabilities. No root cause analysis. No awareness of dominant patterns. Same vulnerability classes reappear across releases.
- **1 (Missing)**: No vulnerability pattern awareness. No post-mortem process. Vulnerabilities addressed reactively with no learning loop.

**Quality check**: Ask: "What are the top 3 vulnerability patterns in systems like this, and how does this design address each one?" If the team cannot answer, pattern awareness is insufficient.
