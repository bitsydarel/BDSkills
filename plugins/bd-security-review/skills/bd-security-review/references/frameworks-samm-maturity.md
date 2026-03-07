# Frameworks: OWASP SAMM 2.0 Maturity Assessment

Comprehensive OWASP Software Assurance Maturity Model 2.0 reference for assessing and improving security programs. Maps all 15 SAMM practices to applicable security review criteria — not only G3. For the quick-reference table of maturity models (Microsoft SDL, BSIMM, SLSA), see [frameworks-sdl-maturity.md](frameworks-sdl-maturity.md). For framework scoping rules, see [frameworks-framework-scoping.md](frameworks-framework-scoping.md).

## SAMM overview

SAMM 2.0 defines **5 Business Functions**, each containing **3 Security Practices** (15 total). Each practice has **2 Streams** representing parallel activity tracks, and **3 Maturity Levels** per stream. A tacit Level 0 means no activity is performed.

| Business Function | Focus |
|-------------------|-------|
| Governance | Strategy, policy, and education for the security program |
| Design | Threat assessment, requirements, and architecture decisions |
| Implementation | Secure build, deployment, and defect management |
| Verification | Architecture review, requirements testing, and security testing |
| Operations | Incident management, environment hardening, and operational management |

---

## SAMM-to-criteria mapping

Master table mapping all 15 practices to primary and secondary review criteria. Use this to identify which SAMM practices are relevant when scoring each criterion.

| Business Function | Practice | Stream A | Stream B | Primary Criterion | Secondary Criteria |
|-------------------|----------|----------|----------|-------------------|-------------------|
| Governance | Strategy & Metrics | Create and Promote | Measure and Improve | G3 | G1 |
| Governance | Policy & Compliance | Policy and Standards | Compliance Management | G1 | G3, G4 |
| Governance | Education & Guidance | Training and Awareness | Organization and Culture | G3 | A6 |
| Design | Threat Assessment | Application Risk Profile | Threat Modeling | T4 | T1, T2 |
| Design | Security Requirements | Software Requirements | Supplier Security | T3 | A1-A7 |
| Design | Secure Architecture | Architecture Design | Technology Management | T3 | A4, O3 |
| Implementation | Secure Build | Build Process | Software Dependencies | A6 | A5 |
| Implementation | Secure Deployment | Deployment Process | Secret Management | O3 | A4 |
| Implementation | Defect Management | Defect Tracking | Metrics and Feedback | A6 | O2 |
| Verification | Architecture Assessment | Architecture Validation | Architecture Mitigation | T2 | T1, T3 |
| Verification | Requirements-driven Testing | Control Verification | Misuse/Abuse Testing | A3 | A1, A2 |
| Verification | Security Testing | Scalable Baseline | Deep Understanding | A3 | A6 |
| Operations | Incident Management | Incident Detection | Incident Response | O2 | O1 |
| Operations | Environment Management | Configuration Hardening | Patching and Updating | O3 | A5 |
| Operations | Operational Management | Data Protection | System Decommissioning | O4 | G2 |

---

## Maturity levels per practice

### Governance

#### Strategy & Metrics

| Level | Stream A: Create and Promote | Stream B: Measure and Improve | Score Interpretation |
|-------|------------------------------|-------------------------------|---------------------|
| 1 | Identify security objectives and means of measuring program effectiveness | Identify organizational risk tolerance drivers and define relevant metrics | G3: Score 2 |
| 2 | Establish a unified strategic roadmap for software security across the organization | Publish unified strategy with established targets and key performance indicators | G3: Score 3-4 |
| 3 | Align security initiatives with organizational indicators and asset values to support growth | Use metrics data to continuously refine strategy according to evolving organizational needs | G3: Score 5 |

**Assessment questions**: Is there a documented software security strategy? (L1+) · Are security metrics collected and reported to leadership? (L2+) · Does the security program have measurable improvement targets tied to business outcomes? (L3)

---

#### Policy & Compliance

| Level | Stream A: Policy and Standards | Stream B: Compliance Management | Score Interpretation |
|-------|-------------------------------|--------------------------------|---------------------|
| 1 | Identify governance and compliance drivers; establish a foundational security baseline | Identify external compliance obligations and map them to existing policies | G1: Score 2 |
| 2 | Create security requirements that apply across all applications in the organization | Publish compliance-specific application requirements and test guidance | G1: Score 3-4 |
| 3 | Continuously measure how well applications adhere to organizational policies and standards | Track and report on individual applications' compliance with regulatory requirements | G1: Score 5 |

**Assessment questions**: Are applicable regulatory requirements identified and documented? (L1+) · Are security policies mapped to compliance requirements with evidence? (L2+) · Is compliance verification automated with continuous monitoring? (L3)

---

#### Education & Guidance

| Level | Stream A: Training and Awareness | Stream B: Organization and Culture | Score Interpretation |
|-------|----------------------------------|-----------------------------------|---------------------|
| 1 | Offer resources on secure development topics; conduct basic security awareness training | Designate a Security Champion within each development team | G3: Score 2 |
| 2 | Provide technology-specific and role-specific guidance on secure development | Develop a secure software center of excellence promoting thought leadership | G3: Score 3-4 |
| 3 | Create internal training facilitated by developers across teams with standardized guidelines | Build a comprehensive secure software community encompassing all personnel in AppSec | G3: Score 5 |

**Assessment questions**: Is security awareness training mandatory for all developers? (L1+) · Is role-specific secure coding training provided? (L2+) · Is training effectiveness measured with improvement tracking? (L3)

---

### Design

#### Threat Assessment

| Level | Stream A: Application Risk Profile | Stream B: Threat Modeling | Score Interpretation |
|-------|-----------------------------------|--------------------------|---------------------|
| 1 | Perform basic assessments to understand likelihood and impact of an attack | Conduct best-effort threat modeling using brainstorming, diagrams, and simple checklists | T4: Score 2; T2: Score 2 |
| 2 | Standardize and centralize risk profiles so stakeholders can access comprehensive application risk data | Standardize threat modeling with consistent training, processes, and tools across the organization | T4: Score 3-4; T2: Score 3-4 |
| 3 | Periodically review risk profiles to maintain accuracy and reflect current threat landscape | Optimize and automate threat modeling across the organization | T4: Score 5; T2: Score 5 |

**Assessment questions**: Are application risk profiles maintained for critical systems? (L1+) · Is a standardized threat modeling methodology applied organization-wide? (L2+) · Are threat models automatically updated when architecture changes? (L3)

---

#### Security Requirements

| Level | Stream A: Software Requirements | Stream B: Supplier Security | Score Interpretation |
|-------|-------------------------------|----------------------------|---------------------|
| 1 | Consider security explicitly during the requirements process; map high-level security objectives to functional requirements | Evaluate external suppliers based on organizational security requirements | T3: Score 2 |
| 2 | Increase detail by analyzing business logic and identified risks; make structured requirements available to teams | Build security into supplier agreements to ensure compliance with organizational requirements | T3: Score 3-4 |
| 3 | Mandate security requirements process for all software projects with a requirements framework all teams must use | Provide external suppliers with clear security objectives to ensure adequate coverage | T3: Score 5 |

**Assessment questions**: Are security requirements part of the software requirements process? (L1+) · Are security requirements derived from threat models and business risk? (L2+) · Is there a mandatory security requirements framework across all projects? (L3)

---

#### Secure Architecture

| Level | Stream A: Architecture Design | Stream B: Technology Management | Score Interpretation |
|-------|------------------------------|-------------------------------|---------------------|
| 1 | Insert consideration of proactive security guidance into the software design process | Identify and catalog technologies, frameworks, and integrations used in solutions | T3: Score 2; A4: Score 2 |
| 2 | Direct design toward known secure services and secure-by-default designs; establish common patterns | Standardize technologies and frameworks across applications for consistency | T3: Score 3-4; A4: Score 3-4 |
| 3 | Formally control the design process and validate utilization of secure components via reference architectures | Impose use of standard technologies on all development with mandatory compliance | T3: Score 5; A4: Score 5 |

**Assessment questions**: Is security guidance integrated into the architecture design process? (L1+) · Are approved security patterns and reference architectures available? (L2+) · Is architecture compliance verified against reference architectures? (L3)

---

### Implementation

#### Secure Build

| Level | Stream A: Build Process | Stream B: Software Dependencies | Score Interpretation |
|-------|------------------------|-------------------------------|---------------------|
| 1 | Build process is repeatable and consistent with formal definitions | Create Bill of Materials and opportunistically analyze dependencies | A6: Score 2; A5: Score 2 |
| 2 | Build process optimized and integrated with security tooling in the pipeline | Evaluate dependencies and ensure timely reaction to situations posing risk | A6: Score 3-4; A5: Score 3-4 |
| 3 | Build process prevents known defects from entering production via mandatory security checks | Treat dependency security issues with the same rigor as internal code defects | A6: Score 5; A5: Score 5 |

**Assessment questions**: Is the build process automated and repeatable? (L1+) · Is SAST integrated into the build pipeline? (L2+) · Do mandatory security gates block non-compliant builds? (L3)

---

#### Secure Deployment

| Level | Stream A: Deployment Process | Stream B: Secret Management | Score Interpretation |
|-------|-----------------------------|-----------------------------|---------------------|
| 1 | Deployment processes are fully documented with formalized secure tooling | Introduce basic protection measures to limit access to production secrets | O3: Score 2 |
| 2 | Deployment includes security verification milestones with automated testing across all stages | Inject secrets dynamically from hardened storages during deployment; audit all human access | O3: Score 3-4 |
| 3 | Deployment is fully automated with automated verification of all critical milestones and integrity checks | Regularly rotate secrets and enforce proper usage practices across all environments | O3: Score 5 |

**Assessment questions**: Are deployment processes documented and secured? (L1+) · Are secrets managed via a dedicated vault with access auditing? (L2+) · Is secret rotation automated with usage enforcement? (L3)

---

#### Defect Management

| Level | Stream A: Defect Tracking | Stream B: Metrics and Feedback | Score Interpretation |
|-------|--------------------------|-------------------------------|---------------------|
| 1 | All security defects tracked within each project with informed decision-making | Regularly examine historical defects and identify basic improvements from fundamental metrics | A6: Score 2; O2: Score 2 |
| 2 | Defect tracking influences deployment process; consistent severity rating with defined SLAs | Collect standardized defect metrics; use them to prioritize centrally driven initiatives | A6: Score 3-4; O2: Score 3-4 |
| 3 | Cross-component defect tracking reduces new defects; SLAs enforced with system integration | Continuously improve metrics and correlate with other sources for data-driven security strategy | A6: Score 5; O2: Score 5 |

**Assessment questions**: Are security defects tracked with consistent severity ratings? (L1+) · Are there defined SLAs for security defect resolution by severity? (L2+) · Are defect metrics correlated with other security data to drive program improvement? (L3)

---

### Verification

#### Architecture Assessment

| Level | Stream A: Architecture Validation | Stream B: Architecture Mitigation | Score Interpretation |
|-------|----------------------------------|----------------------------------|---------------------|
| 1 | Ad-hoc review of architecture for unmitigated security threats | Review architecture to ensure baseline mitigations are in place for typical risks | T2: Score 2 |
| 2 | Validate architecture security mechanisms systematically | Review complete provision of security mechanisms and analyze against known threats | T2: Score 3-4 |
| 3 | Review architecture components' effectiveness with continuous assessment | Feed architecture review results back into enterprise architecture and design principles | T2: Score 5 |

**Assessment questions**: Are architecture reviews conducted for security threats? (L1+) · Are security mechanisms validated against the threat model? (L2+) · Do architecture review findings improve enterprise-wide reference architectures? (L3)

---

#### Requirements-driven Testing

| Level | Stream A: Control Verification | Stream B: Misuse/Abuse Testing | Score Interpretation |
|-------|-------------------------------|-------------------------------|---------------------|
| 1 | Test for software security controls; opportunistically find basic vulnerabilities | Execute security fuzzing testing to discover vulnerabilities through automated input manipulation | A3: Score 2 |
| 2 | Derive test cases from documented security requirements; review application-specific risks | Create and test abuse cases and business logic flaw tests to evaluate control quality | A3: Score 3-4 |
| 3 | Maintain security level via regression testing with security unit tests after bug fixes and changes | Conduct denial of service and security stress testing to continuously improve resilience | A3: Score 5 |

**Assessment questions**: Are security controls tested against requirements? (L1+) · Are abuse cases and business logic flaw tests created and maintained? (L2+) · Are security regression tests run automatically on every change? (L3)

---

#### Security Testing

| Level | Stream A: Scalable Baseline | Stream B: Deep Understanding | Score Interpretation |
|-------|---------------------------|------------------------------|---------------------|
| 1 | Deploy automated security testing tools to identify common vulnerabilities across applications | Expert practitioners conduct manual security assessments of high-risk components | A3: Score 2; A6: Score 2 |
| 2 | Customize automated tests for specific applications; supplement with regular manual penetration testing | Manual penetration testing becomes systematic and integrated with development cycles | A3: Score 3-4; A6: Score 3-4 |
| 3 | Security testing embedded in build and deployment pipeline for continuous automated detection | Experts prioritize components by risk and change history for ongoing deep assessment | A3: Score 5; A6: Score 5 |

**Assessment questions**: Are automated security scans run across all applications? (L1+) · Are manual penetration tests conducted regularly? (L2+) · Is security testing integrated into CI/CD with continuous monitoring? (L3)

---

### Operations

#### Incident Management

| Level | Stream A: Incident Detection | Stream B: Incident Response | Score Interpretation |
|-------|-----------------------------|-----------------------------|---------------------|
| 1 | Use available log data for best-effort detection of possible security incidents | Identify roles and responsibilities for incident response | O2: Score 2; O1: Score 2 |
| 2 | Follow an established, documented process for incident detection with emphasis on automated log evaluation | Formal incident response process established with staff trained in their roles | O2: Score 3-4; O1: Score 3-4 |
| 3 | Proactively managed process for detection of incidents with advanced correlation and alerting | Employ a dedicated, well-trained incident response team | O2: Score 5; O1: Score 5 |

**Assessment questions**: Is log data reviewed for security incidents? (L1+) · Is incident detection automated with documented response procedures? (L2+) · Is there a dedicated incident response team with proactive detection capabilities? (L3)

---

#### Environment Management

| Level | Stream A: Configuration Hardening | Stream B: Patching and Updating | Score Interpretation |
|-------|----------------------------------|-------------------------------|---------------------|
| 1 | Perform best-effort hardening of configurations based on readily available information | Perform best-effort patching of system and application components | O3: Score 2; A5: Score 2 |
| 2 | Consistent hardening following established baselines and guidance | Regular patching across the full stack with timely delivery to customers | O3: Score 3-4; A5: Score 3-4 |
| 3 | Actively monitor configurations for non-conformance to baselines; handle deviations as security defects | Actively monitor update status and manage missing patches as security defects | O3: Score 5; A5: Score 5 |

**Assessment questions**: Are configuration baselines defined and applied? (L1+) · Is patch management consistent with defined SLAs across the full stack? (L2+) · Are configuration deviations and missing patches treated as security defects? (L3)

---

#### Operational Management

| Level | Stream A: Data Protection | Stream B: System Decommissioning | Score Interpretation |
|-------|--------------------------|----------------------------------|---------------------|
| 1 | Implement basic data protection practices | Decommission unused applications and services as identified | O4: Score 2; G2: Score 2 |
| 2 | Establish a catalog documenting data assets; create formal policies governing their safeguarding | Create standardized procedures for retiring obsolete systems and transitioning from outdated dependencies | O4: Score 3-4; G2: Score 3-4 |
| 3 | Continuously monitor adherence to protective policies through automation; periodically refresh documentation | Proactively plan migrations for unsupported technologies and legacy software versions | O4: Score 5; G2: Score 5 |

**Assessment questions**: Are data assets cataloged with protection policies? (L1+) · Is there a formal process for system decommissioning and legacy migration? (L2+) · Is data protection compliance monitored continuously with automated enforcement? (L3)

---

## SAMM maturity to review score mapping

| SAMM Level | What It Means | Review Score Interpretation |
|------------|---------------|---------------------------|
| Level 0 (Implicit) | No formal practices. Security depends on individual initiative | Score 1 on mapped criteria. G3: Score 1 |
| Level 1 (Initial) | Ad-hoc practices emerging. Some teams do some things | Score 2 on mapped criteria. G3: Score 2 |
| Level 2 (Managed) | Defined practices adopted across teams with some measurement | Score 3-4 on mapped criteria. G3: Score 3-4 |
| Level 3 (Optimized) | Measured, improved, and adapted practices across the organization | Score 4-5 on mapped criteria. G3: Score 5 |

**Important caveat**: SAMM maturity level does NOT directly set the score for non-G3 criteria. A Level 3 SAMM program with weak implementation can still score 2 on A1. SAMM maturity provides *governance context* — it tells you whether weak scores are systemic (low maturity) or isolated (high maturity with implementation gaps). Use the criterion-specific evaluation rubrics in the matching `evaluation-*.md` files for scoring, then use SAMM to contextualize findings in the synthesis step.

---

## Using SAMM in the review workflow

| Review Step | SAMM Usage |
|-------------|-----------|
| Step 1: Ingest input | Note any SAMM assessment results provided as input. Determine if organizational maturity context is available |
| Step 5: Lens 4 | Use SAMM-to-criteria mapping to evaluate G3. If SAMM assessment data is available, reference maturity levels. If not, use assessment questions as interview prompts |
| Step 6: Synthesize | Use SAMM maturity level to contextualize cross-lens patterns. Low maturity + low scores = governance gap (systemic). High maturity + low scores = implementation gap (isolated). See [evaluation-scoring.md](evaluation-scoring.md) for cross-lens patterns |
| Step 7: Output | For G3 scores 1-3, recommend specific SAMM practices to improve. Reference practice names and target maturity levels |

---

## SAMM vs BSIMM

| Aspect | SAMM | BSIMM |
|--------|------|-------|
| Approach | Prescriptive (what to do) | Descriptive (what others do) |
| Audience | Any organization building software | Organizations benchmarking against peers |
| Structure | 5 Functions, 15 Practices, 2 Streams each | 4 Domains, 12 Practices, 122 Activities |
| Maturity | 3 levels per practice | Measured by activity count |
| Best For | Building a security program | Benchmarking an existing program |
| Use in Review | Score G3 against SAMM target levels | Compare maturity to industry peers |

For BSIMM quick reference, see [frameworks-sdl-maturity.md](frameworks-sdl-maturity.md).
