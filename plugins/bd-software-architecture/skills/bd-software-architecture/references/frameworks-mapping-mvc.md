# Architecture Style Mapping: MVC (Django, Rails, Laravel)

Maps evaluation criteria to MVC equivalents. Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D4, D5, S1-S4, B3, B4, Q2-Q4) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally. MVC conventions express these principles differently but must achieve the same outcomes. The bar is identical — only the vocabulary changes.

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule + SRP**: Route → Controller → Model → Database. Controllers handle HTTP concerns only (SRP). Models own business logic. Views/templates are pure presentation. Dependencies flow inward: Controllers depend on Models, never the reverse. Views depend on data passed by Controllers, never on Models directly.

**Violation**: Controller contains business logic or raw SQL (SRP violation). View queries the database (Dependency Rule violation). Model imports HTTP or request objects (Independence violation).

## D2: Abstraction at Boundaries

**DIP**: Cross-boundary communication should use abstractions that allow substitution. Django Managers/QuerySets and Rails scopes ARE the abstraction layer for data access. Service objects with defined method signatures provide cross-boundary abstraction. The test: can you substitute the implementation without changing the consumer?

**Violation**: Business logic scattered with raw `Model.objects.filter()` encoding database-specific patterns. No service layer — controllers directly compose complex ORM chains that cannot be substituted (DIP violation).

## D3: Framework Independence

**Independence**: Models inherently extend framework base classes — this is MVC's contract. Score on whether **business logic within the model** is separable from persistence. Pure domain methods (validation rules, state transitions, calculations) should be testable without the database.

- **Score 5**: Pure domain objects alongside ORM models, OR model business methods testable on unsaved instances. Business rules as methods that take values, return values — zero infrastructure.
- **Score 4**: Business logic in model methods testable via fixtures/factories. Logic identifiable and separable even on ORM-backed models.
- **Score 3**: Most business logic testable but some methods couple queries with decisions — database state required to test a business rule.
- **Score 2**: Business logic interleaved with ORM queries — cannot test a rule without a database.
- **Score 1**: All logic requires full framework boot. No separation between "what the rule is" and "how data is fetched."

## C1: Single Responsibility & Cohesion

**SRP**: Fat models, thin controllers. Each model = one domain concept. Service objects = cross-model orchestration. Form objects = validation. Serializers = API formatting. If a controller changes when business rules change AND when URL structure changes, it has two reasons to change — SRP violation.

## C2: Repository vs Service Clarity

**SRP + ISP**: Separate data-oriented operations (fetching/storing) from capability-oriented operations (business workflows). Model Managers/QuerySets = data operations. Service objects/functions = business capabilities. A model method that fetches data, applies rules, and saves results has three reasons to change — SRP violation.

## C5: Domain Model Purity

**Independence + SRP**: Domain behavior within models should be free of infrastructure concerns. `calculate_total()` using model attributes = pure. `sync_to_stripe()` inside a model = infrastructure in domain (Independence violation). External service calls belong in service objects or adapters.

## B1: Data Flow Traceability

**Separation of Concerns**: Request → Router → Controller → Model/Service → Database → Model/Service → Controller → Response. This flow should be consistent across all features. A developer should trace any operation by following the convention.

**Violation**: Some features go Controller → Model, others go Controller → raw SQL, others go Controller → another Controller. Inconsistent flow = separation of concerns breakdown.

## B2: Boundary-Appropriate Data Transformation

**Separation of Concerns**: Serializers/forms transform at the API boundary (Django REST Framework serializers, Rails strong parameters, Laravel form requests). Template contexts transform at the presentation boundary. Each boundary owns its transformation — data format changes should not cascade.

## Q1: Testability

**Consequence of all three principles + DIP**: The decoupling mechanism differs — factories, fixtures, unsaved model instances, service objects with injectable parameters — but the outcome is the same: business logic testable without infrastructure. Service objects accepting dependencies as parameters = same decoupling as constructor injection. Model tests on unsaved instances = same isolation as testing pure domain objects. The question is not "do you use DI?" but "can you test in isolation?"
