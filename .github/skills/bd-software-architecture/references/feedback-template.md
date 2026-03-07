# Feedback template

Structured output format for Software Architecture reviews. For filled examples, see [feedback-example-proposal.md](feedback-example-proposal.md) and [feedback-example-implementation.md](feedback-example-implementation.md).

## Severity levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Core architectural invariant violated or missing; structural integrity compromised | Must resolve before proceeding |
| **Major** | Significant structural gap that weakens boundaries, increases coupling, or degrades quality attributes | Should resolve before launch |
| **Minor** | Small gap or improvement opportunity that does not compromise structural integrity | Consider addressing |
| **Suggestion** | Defense-in-depth enhancement or evolutionary improvement | Optional |

## Full review template

```markdown
## Software Architecture Review

**Input**: [What was reviewed — e.g., "Payment Processing Feature Design Spec"]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Software Architecture
**System Complexity**: [Simple / Standard / Complex / Enterprise]
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### Lens 1: Dependency Architecture scorecard (/25)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| D1 | Layer Separation & Dependency Direction | /5 | |
| D2 | Abstraction at Boundaries | /5 | |
| D3 | Framework Independence | /5 | |
| D4 | Dependency Graph Acyclicity | /5 | |
| D5 | External Dependency Management | /5 | |
| | **Lens 1 Total** | **/25** | |

### Lens 2: Component Design scorecard (/25)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| C1 | Single Responsibility & Cohesion | /5 | |
| C2 | Repository vs Service Clarity | /5 | |
| C3 | Use Case Design & Composition | /5 | |
| C4 | Public API & Encapsulation | /5 | |
| C5 | Domain Model Purity | /5 | |
| | **Lens 2 Total** | **/25** | |

### Lens 3: Data Flow & Boundaries scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| B1 | Data Flow Traceability | /5 | |
| B2 | Boundary-Appropriate Data Transformation | /5 | |
| B3 | Error Translation & Propagation | /5 | |
| B4 | Feature Module Isolation | /5 | |
| | **Lens 3 Total** | **/20** | |

### Lens 4: Quality Attributes scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| Q1 | Testability | /5 | |
| Q2 | Modifiability & Change Isolation | /5 | |
| Q3 | Scalability & Performance Design | /5 | |
| Q4 | Observability & Debuggability | /5 | |
| | **Lens 4 Total** | **/20** | |

### Lens 5: Structural Integrity scorecard (/20)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| S1 | Physical Structure Enforces Rules | /5 | |
| S2 | Naming & Convention Consistency | /5 | |
| S3 | Architecture Decision Records | /5 | |
| S4 | Evolutionary Architecture Readiness | /5 | |
| | **Lens 5 Total** | **/20** | |

### Lens 6: Database Architecture scorecard (/25)

| # | Criterion | Score | Rationale |
|---|-----------|-------|-----------|
| DA1 | Data Model Selection & Justification | /5 | |
| DA2 | Consistency & Trade-off Awareness | /5 | |
| DA3 | Data Isolation & Ownership | /5 | |
| DA4 | Distributed Data Coordination | /5 | N/A for Simple single-database systems |
| DA5 | Data Scalability Strategy | /5 | |
| | **Lens 6 Total** | **/25** | |

### Overall score

| Lens | Score | Max | % |
|------|-------|-----|---|
| Lens 1: Dependency Architecture | | 25 | |
| Lens 2: Component Design | | 25 | |
| Lens 3: Data Flow & Boundaries | | 20 | |
| Lens 4: Quality Attributes | | 20 | |
| Lens 5: Structural Integrity | | 20 | |
| Lens 6: Database Architecture | | 25 | |
| **Total** | | **135** | |

**Weakest lens**: [Lens name and percentage]
**Critical override triggered**: [Yes/No — any criterion scored 1?]
**Dependency-floor rule triggered**: [Yes/No — Lens 1 below 50%?]

### Architecture compliance checklist (implementation reviews only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Dependencies flow inward (no outward violations) | [Yes/No/Partial] | |
| All cross-layer communication uses abstractions | [Yes/No/Partial] | |
| Domain models and use cases are framework-free | [Yes/No/Partial] | |
| Module dependency graph is acyclic | [Yes/No/Partial] | |
| DTOs contained within data source implementations | [Yes/No/Partial] | |
| Vendor errors translated at data source boundary | [Yes/No/Partial] | |
| Cross-feature imports use public APIs only | [Yes/No/Partial] | |
| All components testable in isolation via DI | [Yes/No/Partial] | |
| Directory structure physically enforces boundaries | [Yes/No/Partial] | |
| Architecture decisions documented in ADRs | [Yes/No/Partial] | |
| Data model selection justified against access patterns | [Yes/No/Partial] | |
| Consistency requirements documented (CAP/PACELC positioning) | [Yes/No/Partial] | |
| Each database/schema has a single owner (no shared writes) | [Yes/No/Partial] | |
| Cross-service data operations use saga/CQRS (no 2PC) | [Yes/No/N/A] | |
| Data scaling strategy documented with growth projections | [Yes/No/Partial] | |

### Critical issues
- [ ] [Issue] — [Criterion ID + Name] — [Required action]

### Major issues
- [ ] [Issue] — [Criterion ID + Name] — [Recommended action]

### Minor issues
- [ ] [Issue] — [Criterion ID + Name] — [Suggestion]

### Architecture proposal (when applicable)
[When no architecture exists or the current one requires rework, propose a concrete alternative here. Include: layer structure, key boundaries, dependency direction, component responsibilities, and rationale for each choice. Reference relevant frameworks from `references/frameworks-*.md`.]

### Strengths
- [What is well-done from an architecture perspective]

### Top recommendation
[One highest-priority architecture action]

### Key question for the team
[The single most important architecture question to answer]
```

## Quick review template

```markdown
## Software Architecture Review (quick)

**Input**: [...] | **Mode**: [...] | **Complexity**: [...] | **Verdict**: [...] | **Score**: /135

**Lens Scores**: D: /25 | C: /25 | B: /20 | Q: /20 | S: /20 | DA: /25
**Weakest Lens**: [Lens name and %]
**Dependency-Floor**: [Yes/No]
**Top Risks**: [1-2 highest architecture concerns]
**Strengths**: [1-2 positive architecture signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```

## Guidance note

Prioritize the top 5-10 critical and major issues. Avoid overwhelming the reader with exhaustive lists of every possible architecture improvement. Focus on issues that represent actual structural risk — violations that will compound over time, create coupling that resists change, or prevent testing and evolution. The goal is actionable architecture feedback that the team can remediate in priority order, not a comprehensive audit of every naming inconsistency. When in doubt, ask: "Will this violation compound over the next 6 months?" and "How many files would a developer need to change to fix this?"
