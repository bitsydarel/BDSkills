# Evaluation scoring

Scoring scale, system complexity classification, weighting guide, and verdict thresholds for the software architecture review.

## Scoring scale

| Score | Label | Boundary Definition |
|-------|-------|---------------------|
| 5 | Excellent | All requirements for the criterion met with evidence. Architecture decisions documented and verified (fitness functions, static analysis, peer review). No known gaps. Exceeds the complexity level's required controls — applies practices from the level above |
| 4 | Good | All core requirements met. Minor gaps exist but none in structurally critical areas. Controls implemented and functioning but not all independently verified. Meets the complexity level's required controls fully |
| 3 | Adequate | Core intent addressed but with notable gaps. The "what" is present but the "how well" falls short. Some controls implemented partially, or implemented fully but untested. Meets ~60-80% of the complexity level's required controls |
| 2 | Weak | Significant gaps. The topic is acknowledged but controls are incomplete, incorrectly implemented, or unverified. Meets <60% of the complexity level's required controls. Requires rework before production |
| 1 | Missing | Not addressed, fundamentally flawed, or actively harmful (e.g., circular dependencies between all modules, framework imports in domain models, no layer separation). The absence of the control is itself a structural defect |

### Score boundary decision aid

When uncertain between two adjacent scores, use these questions:

| Deciding Between | Ask |
|-----------------|-----|
| **5 vs 4** | Is there independent verification (fitness functions, ArchUnit tests, static analysis) confirming the architecture holds? Are constraints enforced automatically in CI/CD? |
| **4 vs 3** | Are all structurally critical areas fully covered? Could a new developer accidentally violate the architecture? Are boundaries tested, not just documented? |
| **3 vs 2** | Is the core architectural pattern present and functioning for the most common paths? Or is it only partially implemented with major scenarios creating violations? |
| **2 vs 1** | Does any intentional structure exist? Is the current state better than having no architecture at all? Or does the existing structure create false confidence (architecture theater)? |

**Tie-breaker rule**: When evidence is ambiguous between two scores, assign the lower score. Architecture reviews should under-score rather than over-score to avoid false confidence in structural integrity.

## System complexity classification

Adjust scoring expectations based on the system's complexity level. The same architectural gap carries different weight depending on context — a missing abstraction layer in a CLI tool is less severe than in a distributed payment system.

| Level | Characteristics | Examples | Scoring Adjustment |
|-------|----------------|----------|-------------------|
| **Simple** | Single process, single team, <10K LOC, no external integrations, internal tool | CLI utilities, scripts, internal dashboards, prototypes | Scores of 3 are acceptable in Q3 (Scalability) and S1 (Physical Enforcement). Focus evaluation on D1-D3, C1, B1. DA4 (Distributed Data Coordination) not applicable for single-database systems — score N/A, treated as 5 for calculation purposes. DA1-DA3 and DA5 scored normally; scores of 3 acceptable |
| **Standard** | Single deployable, 1-3 teams, 10K-100K LOC, database + API, moderate user base | Mobile apps, web apps, REST APIs, CRUD services | Full scoring expectations. All criteria apply at face value. DA4 not applicable for single-database systems |
| **Complex** | Multiple deployables, 3-10 teams, 100K-1M LOC, multiple integrations, significant user base | Microservice systems, platform products, multi-tenant SaaS | Elevated expectations for D4 (Acyclicity), D5 (External Dependencies), B4 (Feature Isolation), Q2 (Modifiability). Score of 3 in these = effectively 2. Elevated expectations for DA2 (Consistency), DA3 (Data Isolation), DA4 (Distributed Coordination). Score of 3 in DA3 or DA4 = effectively 2 for Complex systems |
| **Enterprise** | Organization-spanning, 10+ teams, >1M LOC, mission-critical, regulatory requirements | Payment systems, healthcare platforms, financial infrastructure, large-scale distributed systems | Maximum rigor across all criteria. Scores of 3 in any Lens 1 criterion = effectively 2. Require fitness functions (S1 score of 5 requires automated enforcement). ADRs (S3) mandatory for score above 2. DA2 consistency documentation mandatory (score below 3 unacceptable). DA3 data ownership must be formally enforced. DA4 must have tested compensation paths. DA5 must have load-tested scaling strategy |

### Applying complexity classification

1. **Determine level** at the start of every review based on the system characteristics
2. **Note the level** in the review output header
3. **Apply adjustments** when scoring: use the table above to recalibrate expectations
4. **Explain calibration** in rationale when a score differs from what a naive reading would suggest

## Lens weighting guide

Default weighting is equal across all criteria within each lens. Adjust emphasis by input type:

| Input Type | Higher Weight Lenses/Criteria | Lower Weight |
|-----------|-------------------------------|-------------|
| New feature proposal | Lens 1 (Dependencies), C1, C3, B1 | S1, Q3 |
| Refactoring plan | Lens 1, Lens 3 (Boundaries), Q2 | Q3, S4 |
| Migration plan | D5, Lens 3, Q2, S4 | C3, C4 |
| API design/spec | D2, D5, C4, B1-B2 | S1, Q3 |
| Microservice decomposition | D4, D5, B4, Q2, Q3 | C3, S1 |
| Bug fix | B1, B3, C1, D1 | S3, S4, Q3 |
| Existing system audit | All lenses equally | None |
| New project setup | S1, S2, D1, D3 | Q3, Q4 |
| Database-heavy design | DA1, DA2, DA3 | DA4, DA5 |
| Distributed system design | DA3, DA4, DA2 | DA1 |
| Data migration plan | DA3, DA5, DA1 | DA4 |

Weighting adjusts emphasis in the rationale, not the scoring scale. All criteria still receive a 1-5 score.

## Verdict thresholds

### Proposal reviews

| Verdict | Overall % | Lens Minimum | Meaning |
|---------|-----------|-------------|---------|
| **Proceed** | >= 80% (108+/135) | AND no lens below 60% | Strong architecture; ready to build |
| **Proceed with Conditions** | >= 60% (81+/135) | AND no lens below 40% | Viable but architectural gaps need addressing before launch |
| **Rework Required** | < 60% (<81/135) | OR any lens below 40% | Fundamental architectural gaps; return to design |

### Implementation reviews

| Verdict | Overall % | Lens Minimum | Meaning |
|---------|-----------|-------------|---------|
| **Meets Standards** | >= 80% (108+/135) | AND no lens below 60% | Architecture controls effective and verified |
| **Needs Improvement** | >= 60% (81+/135) | AND no lens below 40% | Structure present but gaps require remediation |
| **Critical Gaps** | < 60% (<81/135) | OR any lens below 40% | Serious structural defects; immediate remediation required |

### Critical rules

Regardless of total score:
- **Critical override**: Any single criterion scoring 1 = cannot receive "Proceed" or "Meets Standards" verdict
- **Weakest-link rule**: Any lens scoring below 40% of its maximum = automatic "Rework Required" / "Critical Gaps" regardless of overall score
- **Dependency-floor rule**: Lens 1 (Dependency Architecture) scoring below 50% caps all other lens criteria at a maximum score of 4 — dependency violations undermine every other architectural quality

---

## Multi-lens integration

Architecture findings often span multiple lenses. Use these rules to handle cross-lens interactions and prioritize findings.

### Cross-lens amplification rules

When a finding appears in multiple lenses, its severity amplifies. These combinations indicate systemic issues, not isolated gaps.

| Finding in Lens A | + Finding in Lens B | Amplification |
|-------------------|---------------------|---------------|
| D1: Layer violations present | C1: Components have mixed responsibilities | **Amplified to Critical** — dependencies are wrong AND components are ill-defined; structure is collapsing from both directions |
| D3: Framework in domain/use cases | Q1: Components untestable in isolation | **Amplified to Critical** — framework coupling makes testing impossible; the two failures share the same root cause |
| D4: Circular dependencies between modules | B4: Cross-feature deep imports | **Amplified to Critical** — modules are cyclically coupled AND boundary violations exist; features cannot be developed independently |
| B2: DTOs leaking across boundaries | D2: No abstractions at boundaries | **Amplified to Critical** — no contracts AND implementation details crossing layers; any change cascades everywhere |
| B3: Vendor errors not translated | Q4: Errors not traceable across layers | **Amplified to High** — raw vendor errors propagate AND observability is missing; debugging requires reading implementation code |
| C1: God components with mixed concerns | Q2: Changes cascade across modules | **Amplified to High** — poor responsibility assignment directly causes poor change isolation; the system resists modification |
| S1: No physical enforcement | D1: Layer violations present | **Amplified to Critical** — nothing prevents violations AND violations exist; the architecture is aspirational, not real |
| S3: No ADRs or design documentation | S4: Architecture cannot evolve incrementally | **Amplified to High** — no documentation AND no evolutionary readiness; teams cannot reason about change because decisions are undocumented |
| DA3: Shared write access to same database | B4: Cross-feature deep imports (Lens 3) | **Amplified to Critical** — data AND code boundaries both violated; features cannot be independently developed, tested, or deployed |
| DA2: Implicit consistency assumptions (no CAP positioning) | DA4: No saga or coordination pattern | **Amplified to Critical** — the system neither documents what consistency it needs nor implements patterns to achieve it; distributed data is in an undefined correctness state |
| DA1: Wrong data model for access patterns | Q3: Scalability blocked by architectural bottleneck (Lens 4) | **Amplified to High** — the scalability problem is rooted in the wrong data model choice; query tuning and infrastructure scaling will not resolve the root cause |
| DA5: No data scaling strategy | Q3: No scalability design (Lens 4) | **Amplified to Critical** — both the architectural layer (Q3) and the data layer (DA5) lack scaling consideration; the system has no path to growth |
| DA3: No data ownership | S3: No ADRs (Lens 5) | **Amplified to High** — data ownership is undefined AND undocumented; any developer can write to any table and there is no record of intended boundaries |
| D1: Layer violations present (Lens 1) | DA3: Shared database access | **Amplified to Critical** — code boundaries are wrong AND data boundaries are wrong; the architecture is compromised at both the dependency and data layer |

**Application rule**: When two findings from different lenses match an amplification pair, escalate the combined finding one severity level above the higher individual severity. Note the amplification in the review output with both lens references.

### Finding prioritization matrix (P1-P4)

Classify every finding into a priority level based on structural impact and blast radius. This determines remediation urgency.

| Priority | Structural Impact | Blast Radius | Remediation SLA | Examples |
|----------|------------------|-------------|----------------|---------|
| **P1 — Critical** | Violates core architectural invariant | System-wide; affects all features or all layers | Immediate (block feature work) | Circular dependency between core modules, framework imports in domain, no layer separation, shared mutable state across features |
| **P2 — High** | Weakens architectural boundary | Multiple features or multiple layers affected | Within current sprint (1-2 weeks) | DTOs leaking across boundaries, missing abstractions at data source layer, god repository serving multiple features, no error translation |
| **P3 — Medium** | Degrades quality attribute or local structure | Single feature or single layer affected | Within current quarter | Missing DI in one feature, inconsistent naming in new module, use case doing formatting, missing ADR for recent decision |
| **P4 — Low** | Cosmetic or defense-in-depth improvement | Contained to single component | Backlog (track and address when convenient) | Naming inconsistency in internal component, missing barrel export, slightly deep composition chain |

### Priority assignment rules

1. **Start with structural impact**: Does this finding violate a core principle (Dependency Rule, Single Responsibility, DAG requirement)?
2. **Adjust by blast radius**: A dependency violation in a shared module is P1; the same violation in a leaf module may be P2
3. **Check amplification**: Cross-lens amplification (above) can elevate priority by one level
4. **Complexity level context**: The same finding may be P3 for a Simple CLI tool but P1 for an Enterprise payment system. Use the system complexity classification
5. **Group related findings**: If 3+ findings share a root cause (e.g., no dependency injection framework), report the root cause at the highest priority of any individual finding

### Cross-lens pattern detection

During the synthesis step (Step 9 in the review workflow), look for these systemic patterns:

| Pattern | Indicators | What It Means |
|---------|-----------|---------------|
| **Design gap** | Low Lens 1 (D1-D5) AND corresponding low Lens 2 (C1-C5) | Architecture was not designed intentionally; components emerged without structural guidance |
| **Enforcement gap** | High Lens 1 but low Lens 5 (S1-S4) | Good architecture on paper but nothing prevents violations. One sprint away from degradation |
| **Boundary erosion** | High Lens 2 but low Lens 3 (B1-B4) | Components are well-defined but boundaries between them are leaking. Data coupling replacing structural coupling |
| **Quality disconnect** | High Lens 1-3 but low Lens 4 (Q1-Q4) | Structure is clean but quality attributes (testability, modifiability) are not achieved. Architecture serves the diagram, not the developers |
| **Architecture theater** | Moderate scores across all lenses but no enforcement evidence | Structure appears present but is convention-only. One new team member or tight deadline breaks everything. Reclassify "adequate" scores to "weak" if no enforcement evidence exists |
| **Data architecture gap** | Low DA1-DA3 AND high Lens 1-3 | Code architecture is sound but data decisions were not treated as architecture; the system will face data-layer crises as it grows |
| **Distributed data naivety** | Standard or Complex system with DA4 score of 1-2 | Multi-database operations assumed to work correctly without coordination; consistency incidents are likely |
