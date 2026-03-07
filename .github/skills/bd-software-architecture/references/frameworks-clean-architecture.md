# Clean Architecture

Reference for the Clean Architecture model (Robert C. Martin), one of several architecture styles applicable to the evaluation lenses in this skill. Load this file when the system under review follows or claims to follow Clean Architecture, layered architecture, or similar dependency-inversion patterns. For other architecture styles, see [frameworks-architecture-styles.md](frameworks-architecture-styles.md).

## Core idea

The architecture is organized in concentric layers where **dependencies point inward** — from low-level details (UI, databases, frameworks) toward high-level policies (domain models, business rules). Inner layers know nothing about outer layers. Business logic is independent of delivery mechanisms, databases, and frameworks.

## Layer definitions

Six layers ordered from outermost (most volatile) to innermost (most stable):

### Presentation

**Responsibility**: How data is shown to and received from the user or external caller.
**Contains**: Views, screens, pages, CLI handlers, API controllers, state management (stores, reducers, view models), route definitions, UI formatters.
**Depends on**: Use Cases, Domain Models.
**Never depends on**: Repositories, Services, Data Sources.
**Key rule**: Presentation orchestrates UI flow but delegates all business decisions to Use Cases.

### Use Cases

**Responsibility**: What the application does — business operations that represent standalone intentions.
**Contains**: Application services, command/query handlers, business operation orchestrators. Each use case represents one user or system intention (e.g., "Login", "ProcessPayment", "EnsureAuthenticated").
**Depends on**: Repository contracts, Service contracts, Domain Models.
**Never depends on**: Presentation, Data Source implementations.

**Composition rules**:
- Only compose when the called use case represents a **standalone business intention**
- Keep composition shallow (1-2 levels maximum) and acyclic
- Use cases must never share implementation details — only compose through public interfaces

**Valid use cases**: Business intentions ("Login", "ProcessPayment"), reusable guards ("EnsureAuthenticated"), domain-driven queries ("GetDashboardMetrics").
**Invalid use cases**: Formatting helpers, DTO transformations, shared implementation details, CRUD wrappers with no business logic.

### Repositories

**Responsibility**: How data is coordinated — abstracting data access patterns.
**Contains**: Cache coordination, query aggregation, data source selection logic, optimistic update strategies.
**Depends on**: Data Source contracts, Domain Models.
**Never depends on**: Presentation, Use Cases, Data Source implementations.
**Key rule**: Repositories consume and return Domain Models exclusively. If it acts like a collection of data → Repository.

### Services

**Responsibility**: How capabilities work — wrapping external capabilities behind domain-friendly interfaces.
**Contains**: Authentication, payment processing, notification delivery, analytics, third-party API wrappers.
**Depends on**: Data Source contracts.
**Never depends on**: Presentation, Use Cases.
**Key rule**: Services provide capabilities, not data. If it performs an action → Service.

### Data Sources

**Responsibility**: Where and how data lives — the implementation details of storage and retrieval.

Split into contracts and implementations:
- **Contracts (Interfaces)**: Define *what* data operations are available. Framework-agnostic.
- **Implementations**: Define *how* operations work. Contain all framework-specific code (HTTP clients, database drivers, file I/O). Map DTOs ↔ Domain Models at this boundary.

**Key rules**:
- DTOs are private to Data Source implementations — they never escape this layer
- All vendor-specific errors (HTTP codes, database exceptions, file system errors) are translated into domain exceptions before returning

### Domain Models

**Responsibility**: What data is — pure representation of business concepts.
**Contains**: Entities, value objects, enums, domain events, domain exceptions.
**Depends on**: Nothing. Domain Models are the innermost layer.
**Key rule**: Domain Models are pure — no framework imports, no infrastructure annotations, no serialization logic. Expressible and testable with the language's standard library alone.

## Dependency matrix

| From ↓ / To → | Presentation | Use Cases | Repos/Services | DS Contracts | DS Impls | Domain Models |
|----------------|:---:|:---:|:---:|:---:|:---:|:---:|
| **Presentation** | ✅ | ✅ | — | — | — | ✅ |
| **Use Cases** | — | ✅ | ✅ (contracts) | — | — | ✅ |
| **Repos/Services** | — | — | ✅ | ✅ | — | ✅ |
| **DS Contracts** | — | — | — | ✅ | — | ✅ |
| **DS Implementations** | — | — | — | ✅ (impl) | ✅ | ✅ |
| **Domain Models** | — | — | — | — | — | ✅ |

✅ = allowed dependency. — = forbidden. `(contracts)` = abstract contract only. `(impl)` = implements the interface.

## Feature folder structure

One way to physically enforce the dependency rule — each feature is a self-contained module:

```
/feature_name/
  /ui/                    # Presentation
  /use_cases/             # Application Business Rules
  /domain/                # Enterprise Business Rules (pure)
  /repositories/          # Data Coordination
  /services/              # Capabilities
  /data_sources/
    /contracts/           # Interfaces (framework-agnostic)
    /impl/                # Implementations (framework-specific)
      /dtos/              # Private Data Transfer Objects
  feature_name.dart       # Public API (barrel export)
```

This structure makes the dependency rule physical: `domain/` files import nothing from sibling directories; `ui/` files only import from `use_cases/` and `domain/`. Where the language supports it, use module visibility or lint rules for build-time enforcement. See [frameworks-fitness-functions.md](frameworks-fitness-functions.md).

## Feature public API

Each feature acts like a separate library with a minimal public surface:

**Export (Public)**: Public screens/views/handlers, domain models needed by other features, DI registration functions.
**Keep Private**: Repositories, Services, Data Sources, DTOs, internal use cases.
**Cross-feature rule**: Feature A may only import from Feature B's public API file. Deep imports into internal directories are forbidden.

## Inside-out design methodology

Design from the domain outward:

1. **Domain Models** — Define business entities, value objects, domain exceptions. No imports.
2. **Use Cases** — Express application behavior using domain models and contracts only.
3. **Data Source Contracts** — Define interfaces for needed data operations. Still no framework code.
4. **Data Source Implementations** — Bring in the framework: HTTP clients, DB drivers, file I/O. Map DTOs ↔ domain models.
5. **Repositories/Services** — Coordinate data sources, implement caching, orchestrate capabilities.
6. **Presentation** — Wire up UI/CLI/API that calls use cases and displays domain models.
7. **Dependency Injection** — Compose at the application root. The DI container is the only place that knows all concrete implementations.

## Data flow patterns

### Standard flow

```
User Action → Presentation → Use Case → Repository/Service → DS Contract → DS Impl → External System
                                                                              ↕ DTO ↔ Domain Model mapping
```

### Error translation

| Boundary | Translates From | Translates To |
|----------|----------------|---------------|
| DS Impl → Repository | Vendor errors (`HttpException`, `SQLException`, `SocketException`) | Domain exceptions (`UserNotFoundException`, `NetworkFailureException`) |
| Use Case → Presentation | Domain exceptions | User-facing messages or HTTP status codes |

**Key rule**: Use Cases catch domain exceptions, never vendor exceptions. A `catch (HttpException)` in a Use Case means the Data Source layer failed to translate.

## Repository vs Service decision guide

| Question | Repository | Service |
|----------|-----------|---------|
| Manages a collection of domain entities? | ✅ | — |
| Performs CRUD operations? | ✅ | — |
| Coordinates caching strategies? | ✅ | — |
| Wraps a third-party capability? | — | ✅ |
| Performs an action (send, process, validate externally)? | — | ✅ |
| Integrates device features (camera, GPS, biometrics)? | — | ✅ |
| Aggregates queries from multiple sources? | ✅ | — |
| Manages authentication/authorization flows? | — | ✅ |

## Data Source contract/implementation pattern

```
Repository ──────────────> Data Source Contract (Interface)
                                    ^
                                    │ (implements)
                            Data Source Implementation
                                    │ (uses)
                                  DTOs (private)
                                    │
                                    ↓
                            External System (API, DB, etc.)
```

The contract is owned by the consuming layer. The implementation fulfills the contract and contains all framework-specific code. DTOs are private to the implementation.

## Mapping to other architecture styles

Clean Architecture is compatible with and maps to other styles. See [frameworks-architecture-styles.md](frameworks-architecture-styles.md) for detail:

| Clean Architecture | Hexagonal (Ports & Adapters) | Onion Architecture | DOMA (Uber) |
|-------------------|------------------------------|-------------------|-------------|
| DS Contracts | Ports (driven) | Infrastructure interfaces | Gateway interfaces |
| DS Implementations | Adapters (driven) | Infrastructure | Domain implementations |
| Use Cases | Application Services | Application Services | Product/Business layer |
| Domain Models | Domain Model | Domain Model | Business entities |
| Presentation | Adapters (driving) | UI/API layer | Presentation/Edge layer |
| Feature modules | — | — | Domains |
