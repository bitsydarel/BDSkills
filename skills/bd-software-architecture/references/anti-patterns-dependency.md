# Anti-patterns: Dependency Architecture (Lens 1)

Architecture failure modes related to dependency direction, layer separation, framework coupling, and module graph structure. Each pattern includes Signs, Impact, Fix, and Detection guidance.

---

## Framework in Domain [Critical]

Domain models or use cases import framework packages (ORM, HTTP, UI, serialization libraries). Business logic becomes inseparable from infrastructure.

**Signs**:
- Domain model files contain `import` statements for framework packages (e.g., `import 'package:http/http.dart'`, `from django.db import models`, `import javax.persistence.*`)
- Domain models extend framework base classes (`Model`, `Entity`, `Document`)
- Use case files reference framework-specific types (`HttpResponse`, `DatabaseConnection`, `Context`)
- Domain models carry serialization annotations (`@JsonSerializable`, `@Serializable`, `@Entity`)
- Unit tests for domain logic require framework boot or mock framework components

**Impact**:
- Business logic cannot be tested without framework setup — tests are slow and fragile
- Framework upgrades break domain logic — the most stable code depends on the most volatile
- Porting to a different framework requires rewriting business rules
- Domain models cannot be shared across different deployment targets (web, mobile, CLI)
- The Dependency Rule is violated at the most fundamental level

**Fix**:
- Extract pure domain models with zero framework imports; move framework annotations to data source layer mappers
- Create mapping functions at the data source boundary: `DTO → Domain Model` and `Domain Model → DTO`
- Use case dependencies should be injected interfaces, not framework classes
- Serialization belongs in the data source implementation, not the domain

**Detection**:
- Search domain/use case directories for framework-specific imports
- Run a lint rule or ArchUnit test: "files in `/domain/` and `/use_cases/` must not import from [framework packages]"
- Review test files: if domain tests require `@SpringBootTest`, `setUp()` with framework, or `TestBed`, the domain depends on the framework

---

## Cyclic Dependencies [Critical]

Modules depend on each other in a cycle (A → B → C → A). Makes independent compilation, testing, and reasoning impossible. Often indicates a missing abstraction or a boundary drawn in the wrong place.

**Signs**:
- Circular import warnings from the compiler or static analyzer
- Feature A imports from Feature B which imports from Feature A
- Layer A calls Layer B which calls back into Layer A (e.g., use case calls repository which calls back into use case)
- Cannot compile or test a module without loading most of the codebase
- Adding a feature in module A requires changes in module B

**Impact**:
- Modules cannot be built, tested, or deployed independently
- Changes in any module in the cycle can break all other modules
- Compile times increase as the build system must process all cycled modules together
- Cognitive load increases — understanding one module requires understanding all modules in the cycle
- Refactoring is high-risk because the blast radius spans the entire cycle

**Fix**:
- Identify the shared concept causing the cycle and extract it into a separate module
- Apply the Dependency Inversion Principle: introduce an interface in the depended-upon module and implement it in the depending module
- Use events or callbacks to break direct dependency chains
- Re-evaluate feature boundaries — the cycle may indicate that two features should be merged or that a third shared module is needed

**Detection**:
- Run dependency analysis tools (madge for JS, deptry for Python, dart_dependency_analyzer, JDepend)
- Build system warnings about circular imports
- Attempt to compile each module independently — failures indicate hidden cycles
- Draw the module dependency graph — visual inspection often reveals cycles faster than tooling

---

## Rigid Coupling [Major]

Components are tightly bound to their concrete dependencies with no mechanism for substitution. Makes testing and swapping implementations impossible without modifying the consumer. This is a DIP violation regardless of architecture style.

**Signs**:
- Constructors or methods contain `new ConcreteDataSource()`, `ConcreteService()`, or factory calls to concrete classes
- No mechanism for substituting implementations — the component creates or hard-references everything it needs internally
- Test files contain comments like "cannot mock because it's created internally"
- Switching an implementation requires modifying the consumer class
- No composition point in the application (DI container, module wiring, factory setup, or equivalent)

**Impact**:
- Components cannot be tested with mock/fake implementations — must use the real dependency
- Swapping an implementation (e.g., REST → GraphQL data source) requires modifying every consumer
- The system is tightly coupled at the implementation level, even if interfaces exist
- Integration testing becomes the only testing option for rigidly coupled components

**Fix**:
- Accept dependencies through constructor parameters (constructor injection — primary recommendation)
- Use factory functions that return abstractions, not concrete types
- Use module-level overrides or protocol conformance for languages where DI is not idiomatic
- Depend on the interface/contract, not the concrete implementation
- Create a composition point (DI container, module wiring, factory setup) that assembles concrete implementations

**Detection**:
- Search for `new` / direct instantiation of classes that implement interfaces
- Review constructors: do they accept abstract types or create concrete types?
- Check if tests use the real implementation because mocking is not possible
- Look for components that cannot be instantiated without their full dependency chain

---

## Distributed Monolith [Critical]

A system deployed as multiple services but with the coupling characteristics of a monolith — services share databases, require synchronized deployments, or communicate through tightly coupled interfaces. Has the operational complexity of microservices with none of the benefits.

**Signs**:
- Multiple services read/write to the same database tables directly
- Deploying Service A requires simultaneously deploying Service B
- Services share internal data types (DTOs, domain models) through a common library that changes frequently
- Removing or modifying one service breaks other services at runtime
- Services call each other synchronously in deep chains (A → B → C → D)
- No service can be developed, tested, or deployed independently
- "Microservices" that are really a monolith split by layer instead of by business domain

**Impact**:
- All the complexity of distributed systems (network failures, eventual consistency, deployment orchestration) with none of the benefits (independent scaling, independent deployment, team autonomy)
- Coordination cost between teams is as high as with a monolith, plus network overhead
- Debugging is harder — a single operation spans multiple services with no single view
- A failure in any service cascades to all dependent services through synchronous chains

**Fix**:
- Evaluate whether the system should be a modular monolith instead — it may be simpler and more appropriate
- If services are warranted, establish clear domain boundaries following DOMA or DDD bounded contexts
- Each service owns its database — no shared database access
- Communication between services uses well-defined APIs with versioning, not shared internal types
- Replace synchronous chains with async events or aggregation layers where appropriate
- Define each service's contract independently — no shared DTO libraries that change in lockstep

**Detection**:
- Check database access: do multiple services have write access to the same tables?
- Review deployment pipeline: can each service be deployed independently?
- Examine shared libraries: is there a "common" or "shared" library that all services depend on and that changes frequently?
- Trace a single user operation: how many services does it pass through synchronously?
- Ask: "Can Team A deploy without coordinating with Team B?" If no, it is a distributed monolith
