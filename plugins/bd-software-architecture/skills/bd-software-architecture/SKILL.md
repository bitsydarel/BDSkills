---
name: bd-software-architecture
description: "This skill should be used when reviewing task plans, features, bug-fixes, product proposals, and existing implementations through a Software Architecture lens. Evaluates dependency direction, component design, boundary enforcement, testability, and structural integrity across any architecture style. Triggers: architecture review, software architecture, dependency analysis, component design review, boundary enforcement, structural integrity, database architecture, architecture decision records, SOLID principles, Clean Architecture, architecture anti-patterns, system design review, code structure review."
---

# Software Architecture Review

A structured architecture assessment grounded in the Second Law of Software Architecture: **"Why is more important than how."** While code reveals *how* a system is structured, the review evaluates *why* design choices were made. Six focused lenses — Dependency Architecture, Component Design, Data Flow & Boundaries, Quality Attributes, Structural Integrity, and Database Architecture — assess plans, features, bug-fixes, products, ideas, and existing implementations. This six-lens design mirrors how top companies (Google, Netflix, Uber, Microsoft, AWS) and established methods (ATAM, ISO 25010, Architecture Fitness Functions) evaluate architecture: dependency correctness, component responsibility, boundary enforcement, quality attributes, and structural self-enforcement.

**Architecture-agnostic evaluation**: The lenses evaluate architectural quality regardless of the chosen architecture style, folder structure, or technology stack. Whether the system follows Clean Architecture, Hexagonal, CQRS, Modular Monolith, Microservices, or a custom approach — the evaluation adapts to the chosen model and assesses how well the system upholds its own architectural contract. The criteria measure universal qualities (dependency direction, boundary enforcement, testability, evolvability) that apply across all architecture styles.

**Architecture adaptation**: The criteria use Clean Architecture terminology as the primary language. All architecture styles must comply with the three core principles (Dependency Rule, Separation of Concerns, Independence) and SOLID — these are universal and non-negotiable. When reviewing systems using other architecture styles, load the matching `frameworks-mapping-*.md` file to translate criteria to the system's equivalent components before scoring. Available mappings: MVC, serverless, event-driven, hexagonal, microservices, functional. A well-structured system in any style can achieve high scores — the principles are universal, only the vocabulary is style-specific.

## Core architecture principles

These 9 principles frame the architecture mindset. They are not a checklist — they are the lens through which every evaluation criterion operates.

1. **Dependencies flow inward, never outward** — High-level policies (domain, use cases) must never depend on low-level details (UI, databases, frameworks). The Dependency Inversion Principle is non-negotiable. (Clean Architecture, DOMA layer design)
2. **Design from the domain outward** — Start with the domain model and use cases, then add infrastructure. Business rules must be expressible and testable without any framework. (DDD, Google design doc "Context and Scope")
3. **Boundaries enforce contracts, not conventions** — Architectural boundaries must be physically enforced through module structure, visibility rules, and public APIs — not just documented in wikis. (Netflix Conformity Monkey, fitness functions)
4. **Components communicate through abstractions** — Every cross-boundary interaction uses interfaces or protocols. Concrete implementations are injected, never instantiated directly. (SOLID DIP, Uber DOMA gateways)
5. **Why is more important than how** — Every architectural decision must be traceable to a reason. Code shows *how*; ADRs, design docs, and reviews must capture *why*. Without "why," teams re-debate settled decisions and cannot evaluate whether constraints have changed. (Second Law of Software Architecture, Five Whys, Google Design Docs)
6. **Data transforms at boundaries, not in transit** — DTOs, view models, and external formats are translated at the architectural boundary that owns them. Domain models travel freely within the core. (Clean Architecture, DOMA domain agnosticism)
7. **Feature modules form a directed acyclic graph** — Module dependencies must be acyclic. Any cycle indicates a missing abstraction or a boundary drawn in the wrong place. (SOLID, fitness functions)
8. **Testability is a design constraint, not an afterthought** — If a component cannot be tested in isolation (without its framework, database, or network), the architecture has failed. (ATAM, Netflix chaos engineering)
9. **SOLID applies at every level** — SRP (one reason to change), OCP (extend without modifying), LSP (implementations honor contracts), ISP (focused interfaces), DIP (depend on abstractions). These apply to individual components AND to architectural boundaries. A bloated interface at a module boundary violates ISP just as a class with multiple responsibilities violates SRP.

## Review modes

Two modes based on what is being reviewed:

- **Proposal review** — Evaluates plans, designs, specs, and ideas before implementation. If no architecture is defined, propose one grounded in the principles above. If an architecture is present, evaluate it — confirm what is sound, and propose concrete alternatives for what falls short. Questions are forward-looking: "Does the design account for X?" (Mirrors Google design doc review)
- **Implementation review** — Superset of proposal review, adding three layers:
  1. **Compliance check** — Did the implementation satisfy proposal-stage architecture requirements? If no architecture was established, evaluate the emergent structure and propose one retroactively.
  2. **Outcome confirmation** — Are architecture qualities holding in production? What do metrics, build times, and change velocity show? If the current architecture is sound, confirm it. If it is degrading, propose targeted alternatives with migration paths.
  3. **Iteration assessment** — Are architecture violations from post-launch findings feeding the next iteration cycle?

For proposals, questions are forward-looking. For implementations, apply ALL proposal-stage criteria first, then evaluate real-world structural health and iteration behavior. In both modes: when the architecture works, say so and explain why; when it doesn't, propose specific alternatives with tradeoff analysis. The review must evaluate against all applicable architecture models and industry frameworks documented in the `frameworks-*.md` references — not just one style.

## Evaluation lenses and criteria

Six lenses, 27 criteria, each scored 1-5. Maximum score: 135. Each lens has a matching evaluation file in `references/` (named `evaluation-{lens}.md`) plus a shared scoring file ([evaluation-scoring.md](references/evaluation-scoring.md)) with verdict rules and thresholds.

### Lens 1: Dependency Architecture (/25)

1. **Layer Separation & Dependency Direction** — Dependencies flow inward. Presentation depends on use cases, use cases on repositories/services via abstractions, domain depends on nothing.
2. **Abstraction at Boundaries** — Cross-layer communication uses interfaces/contracts. Concrete implementations injected, not imported directly. Implementations honor their interface contracts — no unexpected exceptions, side effects, or behavioral differences (LSP).
3. **Framework Independence** — Domain models and use cases contain no framework imports. Business rules testable without infrastructure.
4. **Dependency Graph Acyclicity** — Module dependency graph is a DAG. No circular imports between features or layers.
5. **External Dependency Management** — Third-party libraries wrapped behind abstractions. Vendor lock-in contained to data source implementations.

### Lens 2: Component Design (/25)

6. **Single Responsibility & Cohesion** — Each component has one reason to change. Use cases represent business intentions, repositories manage data, services provide capabilities.
7. **Repository vs Service Clarity** — Data-oriented operations in repositories; capability-oriented operations in services. No ambiguous "managers" or "helpers."
8. **Use Case Design & Composition** — Use cases represent standalone business intentions. Composition shallow (1-2 levels), acyclic, no shared implementation details.
9. **Public API & Encapsulation** — Each feature module exposes minimal public API. Interfaces are focused — consumers depend only on methods they use (ISP). Internal components (repos, services, DTOs, data sources) remain private.
10. **Domain Model Purity** — Domain models are framework-agnostic value objects or entities with no infrastructure dependencies.

### Lens 3: Data Flow & Boundaries (/20)

11. **Data Flow Traceability** — Path from external input to persistence and back is traceable. The system's declared data flow is followed consistently across all features.
12. **Boundary-Appropriate Data Transformation** — DTOs stay within data source implementations. Domain models used between layers. Transformations at boundaries.
13. **Error Translation & Propagation** — Vendor errors (HTTP, DB) translated to domain exceptions at data source boundary. Use cases catch domain exceptions, not vendor errors.
14. **Feature Module Isolation** — Cross-feature imports go through public APIs only. No deep imports into another feature's internal structure.

### Lens 4: Quality Attributes (/20)

15. **Testability** — Every component testable in isolation through architectural decoupling. No test requires running database, network, or framework.
16. **Modifiability & Change Isolation** — Changes to a data source, UI framework, or external API contained within one module. Blast radius predictable.
17. **Scalability & Performance Design** — Architecture supports horizontal scaling where needed. Performance-critical paths identified, bottlenecks addressable without restructuring.
18. **Observability & Debuggability** — Architecture supports logging, tracing, and monitoring at boundary crossings. Errors traceable from symptom to root cause across layers.

### Lens 5: Structural Integrity (/20)

19. **Physical Structure Enforces Rules** — Directory layout, module visibility, and build configuration physically prevent dependency violations — not just convention.
20. **Naming & Convention Consistency** — Layers, components, and files follow consistent naming that makes their role immediately apparent.
21. **Architecture Decision Records** — Significant architecture decisions documented with context, options considered, rationale (*why* this option, *why not* the alternatives), and consequences. Prevents the Groundhog Day anti-pattern.
22. **Evolutionary Architecture Readiness** — Architecture accommodates incremental change without wholesale restructuring. New features are added through extension, not modification of existing code (OCP). Feature additions follow established patterns.

### Lens 6: Database Architecture (/25)

23. **Data Model Selection & Justification** — Database type (relational, document, key-value, column-family, graph, NewSQL) explicitly chosen based on access patterns and business requirements. Polyglot persistence decisions independently justified with integration boundaries defined.
24. **Consistency & Trade-off Awareness** — CAP theorem positioning documented. ACID vs BASE choice intentional with compensation strategies for eventual consistency paths. PACELC trade-offs evaluated for distributed or geo-distributed components.
25. **Data Isolation & Ownership** — Each database or schema owned by a single service or feature. No cross-boundary write access. Cross-service data reads go through the owning service's API, not direct database access.
26. **Distributed Data Coordination** — Cross-service data operations coordinated through saga, CQRS, or event sourcing. No distributed transactions (2PC/XA). Sagas have defined compensation steps for all failure scenarios. (N/A for Simple single-database systems.)
27. **Data Scalability Strategy** — Horizontal vs vertical scaling decision documented with growth projections. Sharding key selection justified. Replication topology defined with lag monitoring. Connection pooling sized for expected concurrency.

Note: Security is evaluated by the bd-security-review skill; this skill covers structural architecture quality. Database authentication and access controls are within scope of bd-security-review; database architectural decisions (data model selection, consistency guarantees, ownership boundaries, scalability strategy) are within scope of this skill.

## Architecture knowledge signals

Quality signals that inform score rationale (not separate scores). When a signal is present, note it in the criterion's rationale text. When a signal is absent in a context where it should be present, treat it as evidence for a lower score. Use signals as tie-breakers when uncertain between adjacent scores (e.g., 3 vs 4). Prefix key: D = Dependency Architecture, C = Component Design, B = Data Flow & Boundaries, Q = Quality Attributes, S = Structural Integrity, DA = Database Architecture.

- **Structural Thinking** — Layer awareness, boundary enforcement, dependency direction understanding → signals in D1-D5, B1-B4
- **Component Craft** — Responsibility assignment, abstraction quality, encapsulation discipline → signals in C1-C5
- **Quality Awareness** — Testability rigor, modifiability planning, performance foresight → signals in Q1-Q4
- **Evolutionary Design** — Decision documentation, pattern consistency, change accommodation → signals in S1-S4
- **Data Architecture Awareness** — Data model fitness, consistency positioning, ownership boundaries, distributed coordination → signals in DA1-DA5

## Review workflow

### 1. Ingest input
Identify mode (proposal/implementation), artifact type (design doc, code, diagram, spec), and technology stack. Seek the "why" behind architectural decisions — check ADRs, design docs, inline documentation, and commit messages. When "why" is not documented, flag the missing rationale as evidence for S3 (Architecture Decision Records) and note it as context for affected criteria. Apply the Five Whys when investigating structural problems to reach root cause, not symptoms.

### 2. Load references
Load reference files from `references/` progressively by prefix. Only load what the current step requires. **When `review-depth: comprehensive`** (e.g., invoked by bd-plan-reviewer): treat "contextual" and "on demand" references as mandatory for every scored lens — load the matching anti-pattern file and calibration file proactively for each lens you score, not only when uncertainty or contextual triggers arise.

**Always load** (scoring framework and output format):
- `evaluation-scoring.md` — verdict thresholds, cross-lens integration, and critical rules
- [feedback-template.md](references/feedback-template.md) — output structure

**Per-lens** (load the matching `evaluation-*.md` file when scoring that lens):
- e.g., when scoring Dependency Architecture, load `evaluation-dependency-architecture.md`
- e.g., when scoring Database Architecture, load `evaluation-database-architecture.md`

**Contextual** (load based on findings):

| When the system... | Load |
|--------------------|------|
| Uses non-Clean-Architecture style | `frameworks-mapping-{style}.md` matching the style |
| Involves multiple databases, distributed transactions, consistency trade-offs, or data scalability | `frameworks-database-architecture.md` |
| Uses PostgreSQL | `frameworks-technology-postgresql.md` |
| Uses MongoDB | `frameworks-technology-mongodb-{focus}.md` matching review focus: data-design, scaling, or operations |
| Uses Keycloak or centralized IdP | `frameworks-technology-keycloak-{focus}.md` matching review focus: core, operations, or antipatterns |
| Needs architecture style context, tradeoff analysis, or scale guidance | Relevant `frameworks-*.md` file |

- `anti-patterns-*.md` — load the anti-pattern file matching the architecture issue category being evaluated
- `feedback-example-proposal.md` or `feedback-example-implementation.md` — load the one matching the review mode

**On demand** (when uncertain about a score boundary):
- `calibration-*.md` — load the calibration file matching the lens in question for weak/adequate/strong examples

### 3. Lens 1 — Dependency Architecture
Load [evaluation-dependency-architecture.md](references/evaluation-dependency-architecture.md). Evaluate layer separation, abstraction at boundaries, framework independence, DAG enforcement, and external dependency management. Score D1-D5.

### 4. Lens 2 — Component Design
Load [evaluation-component-design.md](references/evaluation-component-design.md). Evaluate single responsibility, repository vs service clarity, use case design, public API encapsulation, and domain model purity. Score C1-C5.

### 5. Lens 3 — Data Flow & Boundaries
Load [evaluation-data-flow-boundaries.md](references/evaluation-data-flow-boundaries.md). Evaluate data flow traceability, boundary-appropriate data transformation, error translation, and feature module isolation. Score B1-B4.

### 6. Lens 4 — Quality Attributes
Load [evaluation-quality-attributes.md](references/evaluation-quality-attributes.md). Evaluate testability, modifiability, scalability design, and observability. Score Q1-Q4.

### 7. Lens 5 — Structural Integrity
Load [evaluation-structural-integrity.md](references/evaluation-structural-integrity.md). Evaluate physical structure enforcement, naming consistency, architecture decision records, and evolutionary readiness. Score S1-S4.

### 8. Lens 6 — Database Architecture
Load [evaluation-database-architecture.md](references/evaluation-database-architecture.md). Evaluate data model selection, consistency trade-offs, data ownership, distributed coordination, and scalability strategy. Score DA1-DA5. Skip DA4 for Simple single-database systems (score N/A, treated as 5 for calculation purposes). Load [frameworks-database-architecture.md](references/frameworks-database-architecture.md) for CAP/PACELC reference and data model selection guide.

### 8b. Implementation-only: Compliance & outcomes (skip for proposals)
For implementation reviews, evaluate:
1. **Compliance check** — Did the implementation satisfy proposal-stage architecture requirements? Fill the Architecture Compliance Checklist from the feedback template.
2. **Outcome confirmation** — Are architecture qualities holding? What do metrics, build times, and change velocity show? Fill the Outcome Confirmation table.
3. **Iteration assessment** — Are architecture violations feeding the next iteration cycle?

### 9. Synthesize
Identify cross-lens patterns, classify issues by severity, apply the weakest-link verdict rule. Check for critical overrides (any criterion scored 1). Check dependency-floor rule (Lens 1 below 50% caps other lenses at 4).

### 10. Check anti-patterns
Cross-reference findings from Steps 3-8 against the loaded anti-pattern references. Use anti-patterns to validate severity classifications and identify systemic failure modes. Anti-pattern matches are reported as issues in the structured output (Step 11), not as a separate section.

### 11. Produce structured output
Write the review following the feedback template. Include per-lens scorecards, overall verdict, issues by severity, strengths, top recommendation, and key question.

## Anti-patterns

Common architecture failure modes to detect during review — each with detailed Signs, Impact, Fix, and Detection guidance. Load the `anti-patterns-*.md` file matching the issue category.

**Dependency** (Lens 1): Framework in Domain [Critical], Cyclic Dependencies [Critical], Rigid Coupling [Major], Distributed Monolith [Critical] — [details](references/anti-patterns-dependency.md)
**Component** (Lens 2): God Repository [Major], Logic in Presentation [Critical], Use Case for Formatting [Minor], Golden Hammer [Major], Ambiguous Components [Minor] — [details](references/anti-patterns-component.md)
**Boundary** (Lens 3): Deep Imports [Major], Leaking DTOs [Major], Missing Error Translation [Major], Feature Coupling [Critical], Shared Database Anti-Pattern [Critical] — [details](references/anti-patterns-boundary.md)
**Quality** (Lens 4): Untestable Architecture [Critical], Observability Blind Spots [Major], Premature Optimization [Minor], Missing Performance Budget [Major], Tight Coupling to Test Doubles [Minor] — [details](references/anti-patterns-quality.md)
**Evolutionary** (Lens 5): Big Ball of Mud [Critical], Architecture Astronaut [Major], Premature Abstraction [Minor], Documentation Drift [Minor], Lava Flow [Major], API Versioning Neglect [Major] — [details](references/anti-patterns-evolutionary.md)
**Database** (Lens 6): Database as God Object [Critical], Implicit Consistency Assumptions [Critical], Hot Partition Anti-Pattern [Major], Read Replica Staleness Blindness [Major], Connection Pool Exhaustion [Major] — [details](references/anti-patterns-database.md)

## Calibration

When uncertain about a score boundary (2 vs 3, 3 vs 4), load the matching calibration file (prefixed `calibration-`) from `references/` for weak/adequate/strong examples. Each lens has a dedicated calibration file. For cross-lens calibration (findings spanning multiple lenses), see [calibration-cross-lens.md](references/calibration-cross-lens.md).

## Reference file inventory

All reference files live in `references/`, grouped by prefix. Loading rules are defined in Step 2.

- **`evaluation-*.md`** (7 files) — per-lens scoring criteria + shared scoring/verdict rules
- **`calibration-*.md`** (11 files) — weak/adequate/strong examples for score boundary decisions
- **`anti-patterns-*.md`** (6 files) — architecture failure modes by category (dependency, component, boundary, quality, evolutionary, database)
- **`frameworks-*.md`** (11 files) — architecture styles, SOLID, ATAM/CBAM, DOMA, Well-Architected, fitness functions, review methods, database architecture
- **`frameworks-mapping-*.md`** (6 files) — criteria translation for non-Clean-Architecture styles (hexagonal, MVC, serverless, event-driven, microservices, functional)
- **`frameworks-technology-*.md`** (10 files) — stack-specific guidance (mobile, backend, PostgreSQL, MongoDB, Keycloak)
- **`feedback-*.md`** (3 files) — output template + scored examples (proposal, implementation)
