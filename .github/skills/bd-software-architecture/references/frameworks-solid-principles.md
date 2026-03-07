# SOLID principles at the architecture level

SOLID principles applied to modules, features, and layer boundaries — not just classes. These architecture-level interpretations inform how the evaluation lenses assess structural quality.

## Single Responsibility Principle (SRP)

**Class level**: A class should have one reason to change.
**Architecture level**: A module/feature should change only when its business domain changes — not when a framework, shared utility, or sibling feature changes.

**Architecture-level violation**:
```
features/orders/
  order_use_case.py       # Business logic
  order_email_template.py # Email formatting — changes when marketing changes
  order_pdf_generator.py  # PDF layout — changes when legal changes
  order_analytics.py      # Analytics tracking — changes when data team changes
```

The order feature has four different reasons to change: business rules, marketing, legal, and analytics. Each of these change drivers should be in its own module or delegated to a separate service.

**Architecture-level fix**: The order feature delegates to a notification service (email), a document service (PDF), and an analytics service (tracking). The order feature changes only when order business rules change.

**Maps to**: C1 (Single Responsibility & Cohesion), Q2 (Modifiability & Change Isolation).

## Open-Closed Principle (OCP)

**Class level**: Open for extension, closed for modification.
**Architecture level**: The system should accommodate new features, integrations, and capabilities by adding new modules — not by modifying existing ones. Extension points, plugin boundaries, and event systems enable this.

**Architecture-level violation**: Adding a new payment provider (Apple Pay) requires modifying the existing `PaymentService`, `OrderUseCase`, and `CheckoutView`. Every new provider touches existing code.

**Architecture-level fix**: `PaymentService` accepts any `PaymentProvider` implementation through an interface. Adding Apple Pay means creating a new `ApplePayProvider` and registering it in DI — zero changes to existing code.

**Extension point patterns**:
- Interface-based: new implementations of existing contracts
- Plugin-based: new modules that register capabilities at startup
- Event-based: new subscribers for existing events
- Configuration-based: new entries in routing/mapping configuration

**Maps to**: S4 (Evolutionary Architecture Readiness), D2 (Abstraction at Boundaries).

## Liskov Substitution Principle (LSP)

**Class level**: Subtypes must be substitutable for their base types.
**Architecture level**: Any implementation of a contract can replace any other implementation without breaking consumers. A `PostgresUserDataSource` and a `MongoUserDataSource` must both satisfy the `UserDataSource` contract identically — same inputs produce semantically equivalent outputs, same errors for same failure conditions.

**Architecture-level violation**: `CachedUserRepository` extends `UserRepository` but throws `CacheExpiredException` that `UserRepository` never defined. Consumers that handle `UserRepository` do not expect this exception — substitution breaks.

**Architecture-level fix**: Contracts define all possible outcomes, including error conditions. Implementations must honor the full contract — no additional exceptions, no missing behaviors, no weaker postconditions.

**Contract design rules for substitution**:
- All implementations return the same domain types for the same operations
- Error types are defined in the contract, not invented by implementations
- Performance characteristics may differ but functional behavior must be identical
- If a cached implementation cannot serve a request, it falls back to the source — it does not fail differently

**Maps to**: D2 (Abstraction at Boundaries), D5 (External Dependency Management).

## Interface Segregation Principle (ISP)

**Class level**: Clients should not depend on interfaces they do not use.
**Architecture level**: Feature public APIs expose only what consumers need, not everything the module can do. Fat interfaces force consumers to depend on capabilities they never use, creating unnecessary coupling.

**Architecture-level violation**:
```python
# features/user/__init__.py — fat public API
from .domain.user import User
from .domain.admin_user import AdminUser
from .repositories.user_repository import UserRepository
from .repositories.user_stats_repository import UserStatsRepository
from .services.user_avatar_service import UserAvatarService
from .use_cases.get_user import GetUserUseCase
from .use_cases.admin_operations import AdminBulkDeleteUseCase
# ... 20 more exports
```

Every feature that imports `from features.user import User` also gets compile-time exposure to `AdminBulkDeleteUseCase`, `UserStatsRepository`, etc.

**Architecture-level fix**: Export minimal public API. If different consumers need different subsets, consider splitting the module or providing role-specific interfaces:
```python
# features/user/__init__.py — minimal public API
from .domain.user import User
from .domain.exceptions import UserNotFoundException
from .di import register_user_feature
```

**Maps to**: C4 (Public API & Encapsulation), B4 (Feature Module Isolation).

## Dependency Inversion Principle (DIP)

**Class level**: Depend on abstractions, not concretions.
**Architecture level**: High-level modules (domain, use cases) define the interfaces they need. Low-level modules (data sources, frameworks) implement those interfaces. The interface is owned by the consumer, not the provider.

This is the foundation of the Dependency Rule in Clean Architecture and the most critical SOLID principle at the architecture level.

**Architecture-level violation**:
```
Use Case → imports → PostgresUserDataSource (concrete)
```
The use case (high-level policy) depends on the data source (low-level detail). Changing the database requires changing business logic.

**Architecture-level fix**:
```
Use Case → imports → UserDataSource (interface, defined in use case layer)
PostgresUserDataSource → implements → UserDataSource (interface)
```
The interface is owned by the use case layer. The data source layer implements it. Dependencies flow inward (toward the interface owner).

**Key insight**: DIP is not just "use interfaces." It is about **ownership of the interface**. The interface must be defined in the consuming layer, not the providing layer. If the interface is defined next to its implementation, the consumer still depends on the provider's module — DIP is not achieved.

**Maps to**: D1 (Layer Separation & Dependency Direction), D2 (Abstraction at Boundaries), D3 (Framework Independence).

## SOLID at architecture level — summary

| Principle | Architecture Manifestation | Primary Evaluation Criteria |
|-----------|--------------------------|---------------------------|
| SRP | Modules change for one business reason | C1, Q2 |
| OCP | New features by extension, not modification | S4, D2 |
| LSP | Implementations interchangeable through contracts | D2, D5 |
| ISP | Minimal public APIs, role-specific interfaces | C4, B4 |
| DIP | Interface owned by consumer, not provider | D1, D2, D3 |
