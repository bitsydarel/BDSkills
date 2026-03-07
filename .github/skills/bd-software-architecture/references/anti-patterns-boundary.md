# Anti-patterns: Data Flow & Boundaries (Lens 3)

Architecture failure modes related to data transformation, error translation, cross-feature coupling, and boundary enforcement. Each pattern includes Signs, Impact, Fix, and Detection guidance.

---

## Deep Imports [Major]

Importing directly from another feature's internal directories instead of through its public API. Breaks encapsulation and couples features at the implementation level — any internal refactoring in the imported feature breaks the importing feature.

**Signs**:
- Import paths reach into another feature's internal directories: `import 'features/user/data_sources/impl/user_api_data_source.dart'`
- Importing a DTO, data source, repository, or service from another feature's internals
- IDE autocompletion suggests internal files from other features
- Changes to one feature's internal file structure require updating imports in other features
- Build/test of one feature loads most of the codebase

**Impact**:
- Features are coupled at the implementation level, not the interface level
- Internal refactoring of any feature risks breaking its consumers
- Cannot evolve features independently — changes cascade across feature boundaries
- Feature isolation is an illusion — the module boundary exists only in the folder name

**Fix**:
- Create a public API file (barrel export) for each feature that exports only what other features need
- Route all cross-feature imports through the public API file
- Add lint rules that forbid imports from other features' internal directories
- If a feature needs something from another feature's internals, add it to the public API or extract a shared module

**Detection**:
- Review import statements for paths that include another feature's internal directories (`/data_sources/`, `/repositories/`, `/services/`, `/use_cases/`)
- Run a lint rule: "imports from `/features/X/` must resolve to `features/X/X.dart` (barrel file), not internal paths"
- Attempt to refactor a feature's internal structure — if imports in other features break, deep imports exist

---

## Leaking DTOs [Major]

DTOs (Data Transfer Objects) from the data source layer escaping their boundary and appearing in repositories, use cases, or presentation. Couples all layers to the external system's data format — a backend API change cascades through the entire stack.

**Signs**:
- Repository methods return DTOs instead of domain models (e.g., `Future<UserDto>` instead of `Future<User>`)
- Use cases reference DTO types in their signatures or implementations
- Presentation layer formats DTO fields directly
- The same DTO class is imported in data source, repository, use case, and presentation files
- A backend API response format change requires modifying files across multiple layers

**Impact**:
- Every layer is coupled to the external system's data format
- Backend API changes ripple through repository → use case → presentation
- Cannot swap data sources without modifying consumers — the DTO is the contract
- Domain model purity is compromised — the system models the API, not the business
- Different data sources for the same entity cannot coexist because each has different DTOs

**Fix**:
- Map DTOs to domain models inside the data source implementation, before returning
- Repository and use case methods should accept and return domain models exclusively
- DTOs should be private to the data source implementation directory
- Create mapper functions: `UserDto.toDomain() → User` and `User.toDto() → UserDto` inside the data source layer

**Detection**:
- Search for DTO types imported outside the data source directory
- Review repository method signatures — do they return domain types or DTOs?
- Check if changing a backend API response format would require changes beyond the data source implementation
- Look for classes with "Dto", "Response", "Request" suffixes outside the data source layer

---

## Missing Error Translation [Major]

Vendor-specific exceptions (HTTP status codes, database errors, file system exceptions) propagating beyond the data source layer. Use cases and presentation handle raw vendor errors instead of domain exceptions — coupling business logic to infrastructure.

**Signs**:
- Use cases contain `catch (HttpException)`, `catch (SQLException)`, `catch (SocketException)`
- Presentation layer formats HTTP status codes or database error messages directly
- Error handling logic in use cases references vendor-specific error codes (`if (e.statusCode == 404)`)
- Switching a data source (REST → GraphQL) requires rewriting error handling in use cases
- Log messages in upper layers contain vendor-specific error details

**Impact**:
- Business logic is coupled to the current infrastructure vendor
- Switching a data source requires modifying error handling across all layers
- Error semantics are unclear — developers must know the infrastructure to understand what went wrong
- Error handling is inconsistent — different parts of the codebase handle the same vendor error differently
- Tests must mock vendor-specific exceptions instead of domain exceptions

**Fix**:
- Catch all vendor exceptions inside data source implementations
- Translate to domain exceptions with business meaning: `HttpException(404)` → `UserNotFoundException`, `SocketException` → `NetworkFailureException`
- Define domain exception types for each meaningful error case
- Use cases should only catch domain exception types
- Presentation maps domain exceptions to user-facing messages or HTTP status codes

**Detection**:
- Search use case files for catches of vendor-specific exception types
- Review data source implementations: do they translate errors before returning, or do they let vendor exceptions propagate?
- Check domain exception definitions: are there domain-specific exception types, or does the system rely on generic `Exception`?
- Ask: "If we switched from REST to GraphQL, which files would need error handling changes?" If the answer includes use cases, translation is missing

---

## Feature Coupling [Critical]

Two or more features share internal implementation details — they access each other's repositories, services, data sources, or use cases directly rather than through public APIs. The features cannot evolve independently.

**Signs**:
- Feature A directly calls Feature B's repository or service (not through B's public API)
- Shared domain models between features, created by importing from one feature's internal domain directory
- Feature A's use case depends on Feature B's use case through an implementation detail (shared base class, direct instantiation)
- Modifying Feature A's data model requires changes in Feature B
- Features cannot be tested independently — Feature A's tests require Feature B's infrastructure

**Impact**:
- Features cannot be developed, tested, or deployed independently
- Changes in one feature's internals break other features
- Team ownership boundaries are meaningless — Feature A's team must coordinate with Feature B's team for internal changes
- Adding a new feature is slow because it must navigate existing coupling
- Effectively a monolith organized into feature-named folders

**Fix**:
- Define public APIs for each feature — only expose what other features genuinely need
- Extract shared domain concepts into explicit shared modules (not feature-internal)
- Use events or messaging for cross-feature communication where appropriate
- If two features are inseparably coupled, consider merging them into one feature or extracting the shared concern into a third module

**Detection**:
- Review cross-feature imports: do they go through public APIs or internal paths?
- Attempt to test one feature without the other loaded — if it fails, feature coupling exists
- Draw a dependency graph between features — look for bidirectional arrows (mutual coupling)
- Ask: "Can Team A work on Feature A for a sprint without coordinating with Team B about Feature B?" If not, features are coupled

---

## Shared Database Anti-Pattern [Critical]

Multiple features (or services in a distributed system) read and write to the same database tables directly, creating implicit coupling through the data layer. Changes to the schema or query patterns affect all consumers, and there is no clear owner of the data.

**Signs**:
- Multiple features have data sources that query the same database tables
- Schema migrations require coordination across multiple features or teams
- Features share ORM models or database entity classes
- No clear ownership of database tables — multiple features can modify the same rows
- Read and write conflicts between features on shared tables
- Data integrity constraints span feature boundaries

**Impact**:
- Schema changes require synchronized deployments across all consuming features
- No single owner of data integrity — conflicts arise from competing writes
- Performance optimization for one feature's queries may degrade another feature's performance
- Cannot split features into separate services without major data migration
- Testing requires setting up the full shared database state for every feature

**Fix**:
- Assign clear ownership: each database table is owned by exactly one feature/service
- Non-owning features access data through the owning feature's public API (never direct database access)
- For read-heavy cross-feature data needs, consider read replicas, materialized views, or CQRS
- In distributed systems, each service owns its database — no shared access
- Extract shared data concepts into explicit shared modules with defined APIs

**Detection**:
- Map which features/services have write access to which database tables — any table with multiple writers is a shared database
- Review data source implementations across features for references to the same tables
- Check schema migration ownership — if migrations require cross-team coordination, the database is shared
- Ask: "Can Feature A change its database schema without affecting Feature B?" If not, the database is shared
