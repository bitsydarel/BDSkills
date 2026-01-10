---
name: bd-software-architecture
description: Implement clean architecture, adhere to layer responsibilities, and structure features correctly. Use when designing new features or refactoring modules.
---

# Software Architecture

This skill guides the internal structuring of software features, enforcing separation of concerns, strict dependency rules, and clean data flow.

The user needs help with designing a feature, understanding where code belongs (Repository vs Service), or fixing dependency violations.

---

## Feature Folder Structure

**Applies to**: Each feature module/package across all platforms

Within a feature, use the same layer responsibilities. Names may differ slightly by platform, but **boundaries must match**.

```
/authentication
  /ui                     # Views, widgets, screens, controllers
  /cubits (or /view_models or /state)  # State management

  /use_cases              # Business logic orchestration
  /business_objects       # Domain models
  /exceptions             # Feature-specific errors

  /repositories           # Data coordination and access
  /services               # Functionality/capability providers

  /data_sources
    /contracts            # Interfaces specifying location + functionality
    /impl                 # Implementations for each location type
      /dtos               # Data transfer objects (private to impl)

  authentication.dart     # Feature public API (barrel export)
  (or index.ts, __init__.py, etc.)
```

---

## Layer Responsibilities

| Layer | Responsibility | Contains |
|-------|---------------|----------|
| **UI** | Presentation | Views, widgets, screens, controllers, CLI handlers |
| **State** | State management | Cubits, ViewModels, Reducers, Stores |
| **Use Cases** | Business orchestration | Single-purpose business operations |
| **Business Objects** | Domain models | Pure domain entities, value objects |
| **Repositories** | Data coordination | Handles data access, caching, aggregation |
| **Services** | Functionality providers | Provides capabilities/operations (not data) |
| **Data Source Contracts** | Interface definition | Specifies location type + functionality |
| **Data Source Impl** | Location-specific logic | Implements contract for specific location |
| **DTOs** | Transfer objects | API response/request models, DB row models |

---

## Repositories vs Services

| Component | Purpose | Examples |
|-----------|---------|----------|
| **Repository** | Handles **data** | UserRepository, OrderRepository, CacheRepository |
| **Service** | Provides **functionality** | AuthService, NotificationService, AnalyticsService |

Both use Data Source contracts and receive implementations via dependency injection.

---

## Data Source Architecture

**Applies to**: All data access and external functionality

Data Sources have two parts:

1. **Contract (Interface)**: Defines the location type (local/external) AND the functionality
2. **Implementation**: Provides the actual logic for that specific location

```
┌─────────────────────────────────────────────────────────────┐
│                  Repository / Service                        │
│  Uses: Data Source Contract (interface)                      │
│  Receives: Implementation via dependency injection           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Data Source Contract (Interface)                │
│  Specifies: Location type (local/external) + functionality   │
│  Example: CacheUserDataSource, RemoteUserDataSource          │
└─────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Memory Impl     │ │ File Impl       │ │ Cloud Impl      │
│ (in-memory)     │ │ (local file)    │ │ (remote API)    │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

**Example: Cache User Data Source**

```
Contract: CacheUserDataSource
  - getUser(id) -> User?
  - saveUser(user) -> void
  - clearCache() -> void

Implementations:
  - MemoryCacheUserDataSource  (stores in memory)
  - FileCacheUserDataSource    (stores in local file)
  - CloudCacheUserDataSource   (stores in cloud/Redis)
```

**Guidance**:
- Contracts define WHAT the data source does and WHERE it operates (local/external)
- Implementations define HOW for a specific storage mechanism
- Developer chooses which implementation to inject at runtime/composition root
- This allows swapping implementations without changing business logic

---

## Platform-Specific Layer Names

| Layer | Flutter | iOS | Android | Backend |
|-------|---------|-----|---------|---------|
| UI | /ui | /Views | /ui | /handlers or /controllers |
| State | /cubits | /ViewModels | /viewmodels | /handlers |
| Use Cases | /use_cases | /UseCases | /usecases | /use_cases |
| Domain | /business_objects | /Models | /domain | /domain or /models |
| Repository | /repositories | /Repositories | /repositories | /repositories |
| Service | /services | /Services | /services | /services |
| Data Source | /data_sources | /DataSources | /datasources | /data_sources or /adapters |

---

## Dependency Rules

**CRITICAL**: These import rules enforce clean architecture boundaries across ALL platforms.

```
┌─────────────────────────────────────────────────────────────┐
│                     UI / Handlers Layer                      │
│  Imports: Use Cases, Business Objects (for rendering)        │
│  NEVER imports: Repositories, Services, Data Sources         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Use Cases Layer                        │
│  Imports: Repositories, Services, Business Objects           │
│  NEVER imports: Data Sources, DTOs, UI                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Repositories/Services Layer                │
│  Imports: Data Source Contracts, Business Objects            │
│  Receives: Data Source Implementations via DI                │
│  NEVER imports: UI, State, Use Cases                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Data Sources Layer                       │
│  Contracts: Define location type + functionality             │
│  Implementations: Provide logic for specific location        │
│  Imports: External libraries, internal DTOs                  │
│  Returns: Business Objects (maps DTOs → Domain)              │
│  DTOs are PRIVATE to implementations                         │
└─────────────────────────────────────────────────────────────┘
```

### Import Rules Summary

| Layer | Can Import | Cannot Import |
|-------|------------|---------------|
| UI / Handlers & State | Use Cases, Business Objects | Repositories, Services, Data Sources |
| Use Cases | Repositories, Services, Business Objects | Data Sources, DTOs, UI |
| Repositories/Services | Data Source Contracts, Business Objects | UI, Use Cases, Data Source Impls directly |
| Data Source Impl | External libs, DTOs | UI, Use Cases, Repositories |

---

## Feature Public API

**Applies to**: Feature barrel exports (all platforms)

Each feature exposes a minimal public API via a barrel file:

**Flutter** (`authentication.dart`):
```dart
export 'ui/login_screen.dart';
export 'business_objects/user.dart';
```

**Python** (`authentication/__init__.py`):
```python
from .use_cases import LoginUseCase, LogoutUseCase
from .business_objects import User
```

**TypeScript** (`authentication/index.ts`):
```typescript
export { LoginUseCase } from './use-cases';
export { User } from './business-objects';
```

**Go** (package exports via capitalization):
```go
// Only exported (capitalized) symbols form the public API
type User struct { ... }
func NewLoginUseCase(...) *LoginUseCase { ... }
```

**CRITICAL**: Internal implementation details (repositories, services, data sources, DTOs) are NOT exported.

---

## Architecture Anti-Patterns (NEVER use)

- **Deep imports into features**: Use barrel exports, not internal paths (e.g., `import X from 'feat/internal/repo'`)
- **UI importing data sources**: Respect layer boundaries; UI only calls Use Cases (or Repos if simple, but never Data Sources directly)
- **DTOs leaking outside data sources**: Map DTOs to Business Objects immediately in the Data Source or Repository.
- **Mixing repository and service concerns**: Repositories for data; Services for capability.
- **Hardcoding data source implementations**: Use Dependency Injection.
- **Circular dependencies**: Often a sign of poor separation.
- **God packages**: Split large packages by concern.
