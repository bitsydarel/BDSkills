# Evaluation: Data Flow & Boundaries (Lens 3)

Scoring rubric for criteria B1-B4. Each criterion includes proposal questions, implementation-compliance questions, and implementation-results questions. Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## B1: Data Flow Traceability

**What it evaluates**: Whether the path from external input to persistence and back is traceable through clearly defined layers. The system's declared data flow pattern should be followed consistently, making it possible to trace any data operation from origin to destination. In Clean Architecture this is Presentation → Use Case → Repository → Data Source. For other styles, see the matching `frameworks-mapping-*.md` file.

### Proposal questions
- Does the design describe the data flow for primary operations?
- Are the layers that data passes through explicitly mapped?
- Is it clear which component transforms data at each stage?

### Implementation-compliance questions
- Can you trace a request from the entry point (UI action, API call) through each layer to the external system and back?
- Does data follow the declared flow without skipping declared steps (e.g., Presentation calling Data Source directly)?
- Are there operations that bypass the use case layer?

### Implementation-results questions
- When debugging a data issue, can a developer trace the path from symptom to root cause without reading unrelated code?
- Are there operations that take shortcuts (Presentation → Repository, Use Case → Data Source implementation)?
- Is the data flow consistent across features, or does each feature invent its own patterns?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every data operation follows a consistent, documented flow through all declared steps. No shortcuts. A developer can trace any operation from entry to exit by following the declared pattern. Flow is the same across all features. Debugging is systematic |
| 4 | Data flow is consistent and traceable for all main operations. One or two minor shortcuts exist for pragmatic reasons (e.g., a presentation-layer cache for purely cosmetic data). Flow is documented or self-evident |
| 3 | Most operations follow the declared flow. Some operations skip declared steps (e.g., a use case accessing a data source implementation directly). Flow is mostly traceable but requires some familiarity with each feature's variations |
| 2 | Data flow is inconsistent. Some features follow the declared flow, others bypass declared steps freely. Debugging requires reading multiple unrelated files to trace data paths. Patterns vary by feature or developer |
| 1 | No consistent data flow pattern. Data moves between components arbitrarily. Presentation directly accesses databases, use cases call UI code, services bypass repositories. Tracing a data path requires reading the entire codebase |

---

## B2: Boundary-Appropriate Data Transformation

**What it evaluates**: Whether data transforms at the architectural boundary that owns the transformation. DTOs stay within data source implementations. Domain models travel between use cases and repositories. View models stay within presentation. Each boundary owns its data format conversion.

### Proposal questions
- Does the design specify where data transformations occur?
- Are DTOs planned as private to data source implementations?
- Is there a clear strategy for mapping between DTOs, domain models, and view models?

### Implementation-compliance questions
- Are DTOs confined to data source implementations, never appearing in repositories, use cases, or presentation?
- Do repositories receive and return domain models (not DTOs, not raw database objects)?
- Are view models created in the presentation layer (not in use cases)?
- Are mapping functions located at the boundary that owns the transformation?

### Implementation-results questions
- When an API response format changes, does the change stay within the data source implementation?
- When a UI layout changes, does the change stay within presentation?
- Are there DTOs that appear in method signatures of repositories, use cases, or presentation components?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | DTOs strictly confined to data source implementations. Domain models used between layers. View models created at the presentation boundary. Mapping functions located at the correct boundaries. Format changes never cascade beyond the owning layer |
| 4 | Data transformation mostly boundary-appropriate. DTOs contained in data source layer. One or two cases where a domain model carries a convenience field for presentation that does not violate purity. Mapping is clean |
| 3 | Most transformations at correct boundaries but some DTOs leak into repositories. Repositories occasionally return partially-mapped objects. View model logic sometimes creeps into use cases. Mapping exists but is inconsistent |
| 2 | DTOs used as domain models — passed from data source through repository into use case. Or domain models carry serialization annotations. Boundary ownership unclear. Changing an API response format ripples through multiple layers |
| 1 | No data transformation boundaries. DTOs, domain models, and view models are the same objects. Or raw framework objects (JSON maps, database rows) passed through all layers. Any external format change cascades everywhere |

---

## B3: Error Translation & Propagation

**What it evaluates**: Whether vendor-specific errors (HTTP status codes, database exceptions, file system errors) are translated into domain exceptions at the data source boundary. Use cases should catch domain exceptions, never vendor exceptions. Errors should be meaningful within the business domain, not leak infrastructure details.

### Proposal questions
- Does the design specify an error translation strategy?
- Are domain exceptions defined for business-meaningful error cases?
- Is there a plan for how vendor errors map to domain exceptions?

### Implementation-compliance questions
- Are vendor errors (HttpException, SQLException, SocketException) caught and translated within data source implementations?
- Do use cases catch only domain exceptions, never vendor-specific exception types?
- Are domain exceptions descriptive of business meaning (UserNotFoundException, PaymentDeclinedException)?
- Does presentation map domain exceptions to user-facing messages or HTTP status codes?

### Implementation-results questions
- When a backend API changes error codes, does only the data source implementation change?
- Can a developer understand the error semantics from domain exceptions without knowing which vendor produced the error?
- Are there catch blocks in use cases that reference vendor-specific exception types?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | All vendor errors translated at the data source boundary into well-defined domain exceptions. Use cases handle domain exceptions exclusively. Error semantics are clear at every layer. Switching a vendor (e.g., REST to GraphQL) changes no error handling outside the adapter layer |
| 4 | Vendor error translation consistent for main error paths. Domain exceptions well-defined. One or two edge cases where a generic exception passes through untranslated. Use cases handle domain exceptions for all critical paths |
| 3 | Vendor errors translated for common cases but some vendor exceptions leak into repositories or use cases. Domain exceptions defined but incomplete — some use cases catch generic Exception types. Translation exists but is inconsistent |
| 2 | Limited error translation. Most vendor errors bubble up untranslated. Use cases contain catch blocks for HttpException, SQLException, or similar vendor types. Error handling mixes vendor and domain concepts |
| 1 | No error translation. Vendor exceptions propagate through all layers. Use cases, repositories, and presentation all handle raw vendor errors. A database error appears as a database error in the UI. Switching vendors requires rewriting error handling everywhere |

---

## B4: Feature Module Isolation

**What it evaluates**: Whether cross-feature imports go through public APIs only, with no deep imports into another feature's internal structure. Features should be independently developable, testable, and modifiable.

### Proposal questions
- Does the design define feature boundaries and their public interfaces?
- Are cross-feature dependencies explicitly identified and minimized?
- Is there a strategy for shared domain concepts that span features?

### Implementation-compliance questions
- Do cross-feature imports use only public API exports (barrel files, module exports)?
- Are there imports that reach into another feature's internal directories (e.g., `feature_b/data_sources/impl/some_dto`)?
- Are shared domain concepts extracted into a shared module rather than creating cross-feature dependencies?

### Implementation-results questions
- Can a feature be developed and tested without loading other features?
- When refactoring a feature's internals, do other features' tests break?
- Are there circular dependencies between features?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | All cross-feature imports use public APIs exclusively. Deep imports are blocked by lint rules or module visibility. Features are independently testable. Shared concepts live in explicit shared modules. Refactoring a feature's internals never breaks other features |
| 4 | Cross-feature imports mostly use public APIs. One or two deep imports exist for practical reasons and are documented as tech debt. Features are largely independent. Shared domain models extracted where needed |
| 3 | Public API concept exists but is not consistently enforced. Some features import from another feature's internal directories. Cross-feature coupling exists but is manageable. Most feature refactoring stays contained |
| 2 | No consistent public API discipline. Features regularly import from each other's internal paths. Shared data types create implicit coupling. Refactoring one feature frequently breaks another. Testing requires loading multiple features |
| 1 | No feature isolation. Features import freely from each other's internals — data sources, DTOs, use cases, repositories. Features are tangled together. Cannot test, develop, or modify any feature independently. Effectively a monolithic blob organized into feature-named folders |
