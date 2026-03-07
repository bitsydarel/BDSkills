# Technology context: Mobile

Platform-specific architecture patterns for mobile platforms and how the 5 evaluation lenses adapt. Load this file when the system under review targets a mobile platform. For backend, frontend, CLI, and cross-platform lens weighting, see [frameworks-technology-context.md](frameworks-technology-context.md).

## Flutter (Clean Architecture)

**Typical structure** (TEG convention):
```
/lib
  /feature_name
    feature_name.dart          # Public API entry file (exports, DI bindings)
    /ui                        # Screens, widgets
    /cubits                    # State management (Cubits)
    /use_cases                 # Business intentions
    /business_objects          # Domain models (plain Dart classes)
    /exceptions                # Domain exceptions
    /repositories              # Data access boundary
    /services                  # Capability wrappers
    /data_sources
      /contracts               # Interfaces for external systems
      /impl                    # Concrete implementations
      /impl/dtos               # DTOs (private to data source impl)
  /common                     # Shared utilities, theme, routing
```

**Layer rules**:
- UI & Cubits call Use Cases only — never Repositories, Services, or Data Sources directly
- Use Cases are the only entry point for business intentions
- Repositories/Services return Business Objects, never DTOs
- DTOs are private to Data Source implementations — they must not cross boundaries
- Dependencies flow one-way: UI → Use Cases → Repositories → Data Source Contracts

**Platform-specific considerations**:
- **D3**: Domain must not import `package:flutter`. Business Objects and Use Cases must be framework-agnostic. Cubits should contain no widget references.
- **C5**: Business Objects must be plain Dart classes. Freezed/json_serializable annotations are infrastructure — belong in data layer DTOs, not Business Objects.
- **B2**: Data Sources return DTOs internally. Data Source implementations map DTOs to Business Objects. Cubits receive Business Objects or view-specific models.
- **Q1**: Use Cases testable with mock repositories. Cubits testable with `blocTest`. No `WidgetTester` needed for business logic.
- **C4**: Each feature has a public API entry file (`feature_name.dart`). External features import only this file, never internal folders.

**Common anti-patterns**:
- Cubit directly calling API clients (skipping repository/use case layers)
- Business Objects with `toJson`/`fromJson` methods (infrastructure in domain)
- Feature-to-feature navigation importing internal widgets instead of route contracts
- DTOs leaking beyond Data Source implementations into Use Cases or Cubits

## iOS (VIPER / TCA / Clean Swift)

**VIPER structure**:
```
Feature/
  View/          # UIViewController, SwiftUI View
  Interactor/    # Business logic (use case equivalent)
  Presenter/     # Formats data for view
  Entity/        # Domain models
  Router/        # Navigation logic
```

**The Composable Architecture (TCA)**:
```
Feature/
  Feature.swift       # Reducer, State, Action, Environment
  FeatureView.swift   # SwiftUI view observing store
```

**Platform-specific considerations**:
- **D1**: In VIPER, Presenter depends on Interactor protocol, not concrete class. Router depends on module factory protocols.
- **D3**: Interactors must not import UIKit/SwiftUI. Entities must be plain structs.
- **C3**: In TCA, Reducers compose through `.scope()` — composition is explicit and acyclic by design.
- **Q1**: Interactors testable by injecting mock data sources. TCA reducers testable through `TestStore`.

## Android (MVVM + Clean Architecture)

**Typical structure**:
```
feature/
  auth/
    presentation/   # Activity/Fragment/Compose, ViewModel
    domain/          # Entities, use cases, repository interfaces
    data/            # Repository implementations, Retrofit services, Room DAOs
```

**Platform-specific considerations**:
- **D3**: ViewModels must not import `android.*` UI classes. Domain layer must not reference Room, Retrofit, or Hilt annotations.
- **B2**: Room entities (`@Entity`) are data layer DTOs — domain models are separate plain Kotlin classes.
- **C2**: Repositories fetch from data sources (Room DAO, Retrofit API). Do not confuse with Android's legacy `Repository` pattern that mixed caching logic with data fetching.
- **Q1**: Use cases testable with JUnit + mock repositories. ViewModels testable with `Turbine` for Flow testing.

**Common anti-patterns**:
- Domain entities annotated with `@Entity` (Room) or `@SerializedName` (Gson)
- ViewModel directly calling Retrofit services (skipping repository/use case)
- Hilt `@Inject` in domain layer classes
