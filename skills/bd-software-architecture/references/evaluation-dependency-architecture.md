# Evaluation: Dependency Architecture (Lens 1)

Scoring rubric for criteria D1-D5. Each criterion includes proposal questions (forward-looking), implementation-compliance questions (did the build match the plan?), and implementation-results questions (what does the running system show?). Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## D1: Layer Separation & Dependency Direction

**What it evaluates**: Whether the system organizes code into layers with dependencies flowing from volatile details toward stable policies. The outer layers (UI, database) depend on inner layers (use cases, domain) — never the reverse.

### Proposal questions
- Does the design specify which layers exist and their responsibilities?
- Does the dependency direction between layers follow the inward rule?
- Are there any planned dependencies from domain/use cases toward infrastructure?
- Does the design specify how dependency inversion is achieved (interfaces, abstractions)?

### Implementation-compliance questions
- Do actual import statements confirm that dependencies flow inward?
- Are there any reverse dependencies (domain importing from UI, use case importing from data source implementation)?
- Does the folder/module structure reflect the planned layers?

### Implementation-results questions
- Can domain logic be executed in tests without any infrastructure running?
- Do static analysis tools (if present) confirm zero inward-dependency violations?
- When a framework is upgraded, how many domain/use case files require changes?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | All layers clearly defined with documented responsibilities. Zero reverse dependencies confirmed by automated checks (ArchUnit, lint rules, deptry). Framework upgrades require zero changes to domain or use case layers. Dependency direction enforced in CI/CD |
| 4 | Layers well-defined and dependency direction respected throughout. Minor gaps: one or two utility imports cross boundaries but do not carry framework dependencies. No automated enforcement but manual review catches violations |
| 3 | Layers exist and most dependencies flow correctly. Some use cases import from data source implementations directly. Domain layer mostly clean but has 1-2 infrastructure imports (e.g., JSON annotation, ORM decorator). Violations are exceptions, not the pattern |
| 2 | Layer concept acknowledged but poorly enforced. Multiple use cases directly instantiate data source implementations. Domain models contain framework annotations. Layer boundaries exist in folder names only — imports ignore them |
| 1 | No meaningful layer separation. Business logic mixed with UI and database code in the same files. Domain models are ORM entities with full framework coupling. Dependencies flow in all directions |

---

## D2: Abstraction at Boundaries

**What it evaluates**: Whether cross-layer communication uses interfaces, protocols, or abstract contracts rather than concrete implementations. Concrete implementations should be injected (via DI), never imported directly by consumers.

### Proposal questions
- Does the design specify interfaces/contracts at layer boundaries?
- Is dependency injection planned for wiring concrete implementations?
- Are data source contracts defined separately from their implementations?
- Do interface contracts define all possible outcomes, including error conditions?

### Implementation-compliance questions
- Do repositories/services depend on contracts (interfaces), not concrete data source classes?
- Are concrete implementations injected via a DI container or manual injection?
- Can a data source implementation be swapped without modifying its consumers?
- Do all implementations of an interface honor the full contract — no additional exceptions, no missing behaviors, no weaker postconditions (LSP)?
- Can implementations be swapped without changing consumer behavior?

### Implementation-results questions
- Are tests using mock/fake implementations of contracts?
- When a new data source is added (e.g., switching from REST to GraphQL), how many files outside the data source layer change?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every cross-layer boundary uses an explicit interface/contract. All concrete implementations injected via DI. Data source contracts are framework-agnostic. Implementations are interchangeable — swapping one for another requires no consumer changes. Swapping an implementation requires changing only the DI configuration and the new implementation file |
| 4 | Most boundaries use interfaces. DI is used consistently. One or two boundaries skip the interface where the abstraction would be trivial (e.g., simple value mapping). Swap requires minimal changes beyond DI config |
| 3 | Interfaces exist at the main boundaries (data sources) but some repositories or services are used directly without abstraction. DI is used but inconsistently — some concrete classes are instantiated directly in use cases. Interfaces exist but some implementations introduce behaviors not in the contract |
| 2 | Few interfaces exist. Most cross-layer calls use concrete classes directly. DI may be present but is not the primary wiring mechanism. Swapping an implementation requires changing multiple consumer files |
| 1 | No interfaces at boundaries. All dependencies are concrete. No DI — classes instantiate their own dependencies. Implementations routinely violate their interface contracts. Swapping any implementation requires rewriting every consumer |

---

## D3: Framework Independence

**What it evaluates**: Whether domain models and use cases are free from framework imports. Business rules should be expressible and testable using only the language's standard library. Framework code belongs in the outer layers (data sources, presentation).

### Proposal questions
- Does the design specify that domain models will be framework-agnostic?
- Are use cases designed to contain only business logic, with no framework orchestration?
- Is there a plan for keeping framework code out of inner layers?

### Implementation-compliance questions
- Do domain model files import any framework packages (ORM, HTTP, serialization, UI)?
- Do use case files import framework-specific classes?
- Can domain models be instantiated in a plain unit test without framework setup?

### Implementation-results questions
- How many domain/use case files change when upgrading the framework version?
- Can the business logic be ported to a different framework by rewriting only the outer layers?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Domain models and use cases have zero framework imports. All business rules testable with no framework boot. Framework upgrade changes zero domain/use case files. Clear separation documented and enforced |
| 4 | Domain models are framework-free. Use cases have minimal framework presence (e.g., a DI annotation but no framework logic). Business rules testable without full framework boot |
| 3 | Domain models mostly clean but carry 1-2 framework annotations (e.g., `@Entity`, `@JsonSerializable`). Use cases are largely framework-free but occasionally reference framework types in signatures |
| 2 | Domain models have significant framework coupling (ORM base classes, serialization mixins). Use cases import framework utilities. Testing requires partial framework boot |
| 1 | Domain models are framework classes (extend ORM model, include HTTP logic). Use cases are framework controllers in disguise. Cannot test without full framework running |

---

## D4: Dependency Graph Acyclicity

**What it evaluates**: Whether the module dependency graph forms a Directed Acyclic Graph (DAG). Circular dependencies between features or layers indicate missing abstractions or boundaries drawn incorrectly. Cycles make it impossible to build, test, or reason about modules independently.

### Proposal questions
- Does the design specify module boundaries that avoid circular dependencies?
- Are shared concerns (e.g., authentication, logging) extracted into separate modules rather than creating mutual dependencies?
- When Feature A needs Feature B's data, does the design route through public APIs or shared abstractions?

### Implementation-compliance questions
- Does static analysis confirm zero circular imports between feature modules?
- Are there any mutual dependencies between layers (e.g., use case imports from data source, data source imports from use case)?
- Do feature modules depend on each other only through public APIs?

### Implementation-results questions
- Can each feature module be compiled/tested independently?
- When adding a new feature, does it require modifying existing features to resolve import cycles?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Dependency graph confirmed acyclic by automated tooling (build system, lint rules). Each feature module compiles independently. Shared concerns extracted into dedicated modules. New features add to the graph without creating cycles |
| 4 | No circular dependencies detected manually. Module boundaries are clean. One or two shared utilities exist but do not create semantic cycles. No automated enforcement |
| 3 | Most modules are acyclic. One or two cycles exist between closely related features, acknowledged as tech debt. Shared modules are mostly well-factored |
| 2 | Multiple circular dependencies between features. Some features cannot be compiled without loading most of the codebase. Shared concerns spread across modules create implicit coupling |
| 1 | Pervasive circular dependencies. Features import freely from each other's internals. The dependency graph is effectively a single tangled mass. Cannot isolate any module for independent compilation or testing |

---

## D5: External Dependency Management

**What it evaluates**: Whether third-party libraries and external systems are wrapped behind abstractions, containing vendor lock-in to data source implementations. Changing a third-party library should require modifications only within its adapter layer, not throughout business logic.

### Proposal questions
- Does the design identify which third-party libraries are used and where they are contained?
- Are external APIs wrapped behind domain-relevant interfaces?
- Is there a strategy for dependency pinning, auditing, or update policy?

### Implementation-compliance questions
- Are third-party imports confined to data source implementations and presentation layers?
- Can a third-party library be replaced by modifying only its adapter (data source implementation)?
- Do use cases reference third-party types in their signatures?

### Implementation-results questions
- When a third-party library releases a breaking change, how many files require modification?
- Are third-party library versions pinned and regularly audited?
- Is there evidence of successful library swaps or upgrades contained to adapter layers?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | All third-party dependencies wrapped behind project-owned interfaces. Library swaps demonstrated to require only adapter layer changes. Dependencies pinned with lockfile, audited regularly, and vulnerability scanning in CI |
| 4 | Most third-party dependencies properly wrapped. One or two well-justified exceptions (e.g., standard library extensions). Dependencies pinned with lockfile. Swapping the primary HTTP client or database driver would require changes only in data source implementations |
| 3 | Major third-party dependencies wrapped but some leak into repositories or services. Swapping would require changes in the data source layer plus a few repository adjustments. Dependencies pinned but not regularly audited |
| 2 | Third-party libraries imported directly throughout use cases and repositories. Significant vendor lock-in. Swapping a library would require changes across multiple layers. Dependencies present but not carefully managed |
| 1 | Third-party types used as domain models. Business logic contains vendor-specific API calls. No wrapping, no abstraction. The application is inseparable from its dependencies. No dependency pinning or auditing |
