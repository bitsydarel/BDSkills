# Evaluation: Component Design (Lens 2)

Scoring rubric for criteria C1-C5. Each criterion includes proposal questions, implementation-compliance questions, and implementation-results questions. Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## C1: Single Responsibility & Cohesion

**What it evaluates**: Whether each component has one reason to change. Use cases represent business intentions, repositories manage data coordination, services provide capabilities. No component should mix concerns across these categories.

### Proposal questions
- Does the design clearly assign each responsibility to a specific component type?
- Are components scoped to single business intentions or capabilities?
- Is there a clear decomposition of the problem into cohesive units?

### Implementation-compliance questions
- Does each class/module serve a single, well-defined purpose?
- Are there components that mix data access with business logic or UI formatting?
- Can you describe each component's responsibility in one sentence without using "and"?

### Implementation-results questions
- When a business rule changes, how many components need modification?
- Do code reviews reveal components doing multiple unrelated things?
- Are components small enough to be understood in isolation?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every component has a single, clear responsibility expressible in one sentence. Changes to a business rule affect exactly one use case. Data access changes affect exactly one repository. Component sizes are consistent and reviewable |
| 4 | Components are well-focused. Most have a single responsibility. A few utility components serve two closely related purposes. Changes are generally contained to 1-2 components |
| 3 | Most components have a primary responsibility but some accumulate secondary concerns. Some repositories contain business logic. Some use cases handle formatting. Changes sometimes cascade to 3-4 components |
| 2 | Many components mix concerns. Repositories validate business rules, use cases format data, services handle multiple unrelated capabilities. Hard to predict which components a change will affect |
| 1 | No meaningful responsibility separation. "God classes" that handle everything. A single component may do data access, business logic, formatting, and error handling. Touching anything risks breaking everything |

---

## C2: Repository vs Service Clarity

**What it evaluates**: Whether data-oriented operations are in repositories and capability-oriented operations are in services, with no ambiguous components ("Manager", "Helper", "Handler", "Utils") that obscure responsibility.

### Proposal questions
- Does the design distinguish between data coordination (repositories) and capability wrapping (services)?
- Are component names specific enough to communicate their responsibility?
- Are "manager", "helper", or "utils" classes avoided in favor of specific names?

### Implementation-compliance questions
- Do repositories focus on data operations (CRUD, caching, query aggregation)?
- Do services focus on capabilities (auth, payments, notifications, third-party APIs)?
- Are there ambiguous classes whose responsibility is unclear from their name?

### Implementation-results questions
- When a new data source is needed, is it clear whether to create a repository or service?
- Are there components that do both data coordination and capability wrapping?
- Do team members agree on where new functionality should be placed?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Clear and consistent distinction between repositories (data) and services (capabilities). No ambiguous component names. New team members can correctly place functionality based on naming conventions alone. Decision guide documented |
| 4 | Good separation with consistent naming. One or two edge cases where a component could be either, but the choice is reasonable and documented. No "Manager" or "Helper" classes |
| 3 | Separation mostly clear but some "Manager" or "Helper" classes exist. A few components straddle the line between data and capability concerns. Most developers agree on placement for common cases |
| 2 | Unclear distinction. Several "Manager", "Helper", or "Utils" classes with mixed responsibilities. Different team members would place the same functionality in different component types. Naming is inconsistent |
| 1 | No distinction between repositories and services. Functionality is organized arbitrarily. Component names reveal nothing about their responsibility ("DataManager", "ServiceHelper", "AppUtils"). No placement guidance exists |

---

## C3: Use Case Design & Composition

**What it evaluates**: Whether use cases represent standalone business intentions with shallow, acyclic composition and no shared implementation details.

### Proposal questions
- Does each use case represent a complete business intention (not a fragment)?
- Is use case composition planned as shallow (1-2 levels) and acyclic?
- Are shared behaviors extracted as separate use cases only when they represent standalone intentions?

### Implementation-compliance questions
- Does each use case class/function represent one business intention?
- Are there use cases that only exist to be called by other use cases (shared implementation detail)?
- Is composition depth ≤ 2 levels with no cycles?
- Do use cases avoid sharing implementation details through inheritance or shared base classes?

### Implementation-results questions
- Can each use case be understood and tested without reading the code of composed use cases?
- When modifying a use case, do other use cases break unexpectedly due to shared implementation?
- Are there use cases that are actually formatting helpers, DTO transformers, or validation utilities in disguise?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every use case is a standalone business intention. Composition is shallow (≤ 2 levels), acyclic, and each composed use case is independently meaningful. No shared implementation details between use cases. Invalid use cases (formatters, transformers) do not exist |
| 4 | Use cases represent clear intentions. Composition is shallow and acyclic. One or two shared use cases exist but they represent genuine standalone operations (e.g., "EnsureAuthenticated"). No invalid use cases |
| 3 | Most use cases are well-designed. Some composition is deeper than ideal (3 levels). A few use cases exist primarily to be composed rather than as standalone intentions. One or two borderline "utility" use cases |
| 2 | Many use cases are fragments of larger operations. Composition is deep or cyclic. Shared base classes contain business logic used by multiple use cases. Several "helper" or "formatter" use cases exist |
| 1 | Use cases are arbitrary code groupings, not business intentions. Heavy inheritance hierarchies. Circular composition. Use cases contain formatting, DTO mapping, and infrastructure logic. No design intent behind use case boundaries |

---

## C4: Public API & Encapsulation

**What it evaluates**: Whether each feature module exposes a minimal public API, keeping internal components (repositories, services, DTOs, data sources) private. Other features interact only through the public surface.

### Proposal questions
- Does the design specify what each feature module exports publicly?
- Is there a strategy for keeping internal components private (barrel exports, module visibility)?
- Are cross-feature dependencies routed through public APIs?

### Implementation-compliance questions
- Does each feature module have an explicit public API (barrel file, module exports)?
- Are internal components (repos, services, data sources, DTOs) excluded from public exports?
- Do other features import only from the public API, never from internal paths?
- Are there interfaces with methods that some consumers never call (ISP violation)?
- Do different consumers of the same module need different subsets of its API?

### Implementation-results questions
- Can a feature's internal structure be refactored without affecting other features?
- When adding a new feature, is the public API surface explicitly decided and reviewed?
- Are there accidental public exports that other features depend on?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every feature has an explicit public API file/module. Internal components are provably private (language-level enforcement or lint rules). Cross-feature imports verified by automated checks. Internal refactoring never breaks other features |
| 4 | Public APIs defined and used consistently. Internal components are private by convention and mostly enforced. One or two internal exports exist for practical reasons (e.g., shared domain model). Refactoring rarely breaks other features |
| 3 | Public APIs exist but are not consistently used. Some features import directly from other features' internal paths. Internal components are private by convention only. Refactoring sometimes requires changes in consuming features |
| 2 | No explicit public API boundary. Features import from each other's internal paths freely. "Everything is public" by default. Refactoring a feature's internals commonly breaks other features |
| 1 | No concept of public vs private API for feature modules. All files are accessible from anywhere. Tight coupling between feature internals. Any change anywhere can cascade everywhere |

---

## C5: Domain Model Purity

**What it evaluates**: Whether domain models are framework-agnostic value objects or entities with no infrastructure dependencies. Domain models should be the innermost, most stable components — pure representations of business concepts.

### Proposal questions
- Does the design specify that domain models will have no infrastructure dependencies?
- Are domain models designed as pure value objects or entities?
- Is serialization/deserialization handled outside domain models (in data source implementations)?

### Implementation-compliance questions
- Do domain model files import any framework, ORM, or serialization packages?
- Are domain models instantiable with no infrastructure setup?
- Is serialization logic (JSON, Protobuf, XML) outside domain models?

### Implementation-results questions
- Can domain models be used in unit tests with zero setup?
- When switching serialization formats, do domain model files change?
- Are domain models shared across features without pulling in framework dependencies?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Domain models are pure value objects/entities with zero framework imports. Testable with no setup. Serialization handled entirely in data source layer. Domain models are the most stable, least-changing files in the codebase |
| 4 | Domain models are largely pure. Minimal framework presence (e.g., an equality/hashcode annotation) that does not affect behavior. No serialization logic. Testable with trivial setup |
| 3 | Domain models are mostly pure but carry some framework annotations (`@Entity`, `@JsonSerializable`) that create compile-time coupling. Removing the framework would require touching domain files but not changing business logic |
| 2 | Domain models extend framework base classes or implement framework interfaces. Serialization logic mixed into domain models. Switching frameworks requires rewriting domain models |
| 1 | Domain models are framework objects — ORM entities, serialization DTOs, or UI models used as domain objects. No distinction between domain and infrastructure representations. Cannot use domain models without the framework |
