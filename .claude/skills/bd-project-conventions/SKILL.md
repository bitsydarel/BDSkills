---
name: bd-project-conventions
description: Follow project structure conventions and setup procedures. Use when onboarding, setting up environments, or troubleshooting import/build issues.
---

# Project Conventions

This skill guides project structure, environment setup, and development conventions. Apply these standards when starting new projects, onboarding to existing codebases, or troubleshooting setup issues.

The user needs help with project setup, environment configuration, import issues, or understanding project structure. They may be starting fresh or debugging existing configuration.

---

## Project Thinking

Before setting up or modifying project structure, understand the goals:

- **Consistency**: Does this follow platform conventions others will recognize?
- **Separation**: Are concerns properly separated (source, tests, config)?
- **Reproducibility**: Can another developer set up identically?
- **Security**: Are secrets and credentials properly handled?

**CRITICAL**: Follow platform conventions. Custom structures create friction for every new team member.

### When This Applies

Use this skill when:
- Creating a new project
- Setting up a development environment
- Troubleshooting import/module errors
- Configuring environment variables
- Understanding project structure
- Onboarding to a new codebase

---

## Feature-by-Folder Architecture

**Applies to**: All software — Mobile, Web, Backend, Desktop, CLI, Libraries

At the root of the application, code is organized **by feature**. This ensures related code lives together and features remain modular and independently maintainable. The exact folder/module shape differs per platform, but the same feature boundaries apply.

### Root-Level Structure by Platform

#### Flutter (Dart)

```
/lib
  /common              # Shared foundations
  /authentication      # Feature
  /settings            # Feature
  /orders              # Feature
  ...
```

#### Android (Kotlin)

**Guidance**: Use Gradle modules or folders to represent feature boundaries.

```
/ (repo root)
  /app                 # Android application
  /common              # Shared foundations
  /authentication      # Feature module
  /settings            # Feature module
  ...
```

#### iOS (Swift)

**Guidance**: Represent feature boundaries using Swift packages (preferred) or Xcode modules/targets.

```
/ (repo root)
  /App                 # iOS application target
  /Common              # Shared foundations
  /Authentication      # Feature package/target
  /Settings            # Feature package/target
  ...
```

#### Python Backend

**Guidance**: Use packages/modules for feature boundaries.

```
/src
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature
  /payments            # Feature
  ...
/tests
  /authentication
  /orders
  ...
```

#### Node.js/TypeScript Backend

**Guidance**: Use folders or npm workspaces for feature boundaries.

```
/src
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature
  /payments            # Feature
  ...
```

#### Go Backend

**Guidance**: Use packages within internal/ for feature boundaries.

```
/cmd
  /server              # Entry point
/internal
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature
  /payments            # Feature
  ...
```

#### React/Vue/Angular Web

**Guidance**: Use feature folders within src.

```
/src
  /common              # Shared foundations
  /authentication      # Feature
  /dashboard           # Feature
  /settings            # Feature
  ...
```

### The Common Module

**Applies to**: All platforms and software types

`Common` contains shared foundations used broadly across the app:
- Design tokens and theming (UI apps)
- Core utilities and helpers
- Shared platform adapters
- Shared business types/models
- Cross-cutting concerns (logging, error handling)

**CRITICAL**: Keep Common small and stable. If something is feature-specific, it belongs in that feature.

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

### Layer Responsibilities

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

### Repositories vs Services

| Component | Purpose | Examples |
|-----------|---------|----------|
| **Repository** | Handles **data** | UserRepository, OrderRepository, CacheRepository |
| **Service** | Provides **functionality** | AuthService, NotificationService, AnalyticsService |

Both use Data Source contracts and receive implementations via dependency injection.

### Data Source Architecture

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

### Platform-Specific Layer Names

| Layer | Flutter | iOS | Android | Backend |
|-------|---------|-----|---------|---------|
| UI | /ui | /Views | /ui | /handlers or /controllers |
| State | /cubits | /ViewModels | /viewmodels | /handlers |
| Use Cases | /use_cases | /UseCases | /usecases | /use_cases |
| Domain | /business_objects | /Models | /domain | /domain or /models |
| Repository | /repositories | /Repositories | /repositories | /repositories |
| Service | /services | /Services | /services | /services |
| Data Source | /data_sources | /DataSources | /datasources | /data_sources or /adapters |

### Dependency Rules

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

### Feature Public API

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

## Environment Configuration

**Applies to**: All projects with environment-specific settings

### Environment File Pattern

**Guidance**:

1. **Create template**: `.env.example` (committed to git)
   ```
   # Database
   DATABASE_URL=postgres://user:pass@localhost:5432/db

   # API Keys (get from team lead)
   API_KEY=your-api-key-here

   # Feature Flags
   FEATURE_NEW_UI=false
   ```

2. **Create local config**: `.env` (never committed)
   ```bash
   cp .env.example .env
   # Edit .env with real values
   ```

3. **Add to .gitignore**:
   ```
   .env
   .env.local
   .env.*.local
   ```

### What Belongs in Environment Files

| Include | Exclude |
|---------|---------|
| Database URLs | Hardcoded in source |
| API keys | Committed to git |
| Feature flags | Production secrets in dev files |
| Service endpoints | Anything that doesn't vary |
| Debug flags | |

### Loading Environment Variables

| Platform | Method |
|----------|--------|
| Python | `python-dotenv` or `environs` |
| Node.js | `dotenv` package |
| Flutter | `flutter_dotenv` or `envied` |
| Go | `godotenv` or `viper` |

---

## Dependency Management

**Applies to**: All projects

### Lock Files

**Guidance**: Always commit lock files for reproducible builds.

| Platform | Lock File | Command to Update |
|----------|-----------|-------------------|
| Python | `requirements.lock` or `poetry.lock` | `pip-compile` or `poetry lock` |
| Node.js | `package-lock.json` | `npm install` |
| Flutter | `pubspec.lock` | `flutter pub get` |
| Go | `go.sum` | `go mod tidy` |
| Swift | `Package.resolved` | `swift package resolve` |
| Rust | `Cargo.lock` | `cargo update` |

### Dependency Organization

| Category | Description |
|----------|-------------|
| Production | Required at runtime |
| Development | Testing, linting, building |
| Optional | Feature-specific extras |

---

## Import Conventions

**Applies to**: All projects with modules

### General Rules

| Rule | Rationale |
|------|-----------|
| Relative within package | Cleaner, refactor-friendly |
| Absolute in tests | Tests import the package, not siblings |
| No path manipulation | Never modify sys.path, import path, etc. |
| Barrel exports | Clean public API (index.ts, __init__.py) |

### Import Order

**Guidance**: Group imports in this order:

```
1. Standard library / built-ins
2. Third-party packages
3. Local application imports
   - Absolute imports
   - Relative imports
```

---

## Common Setup Issues

**Applies to**: Troubleshooting

### Import/Module Errors

| Error | Likely Cause | Solution |
|-------|--------------|----------|
| Module not found | Package not installed in editable mode | `pip install -e .` |
| Cannot resolve | Missing __init__.py | Add empty __init__.py files |
| Circular import | Modules importing each other | Restructure or use lazy imports |
| No module named X | Wrong environment | Activate correct venv/node_modules |

### Build Errors

| Error | Likely Cause | Solution |
|-------|--------------|----------|
| Version mismatch | Lock file out of sync | Delete lock, reinstall |
| Missing dependency | Not in requirements | Add and reinstall |
| Platform-specific | OS-specific package | Use conditional dependencies |

---

## Anti-Patterns (NEVER use)

- **sys.path hacks**: Never modify import paths programmatically
- **Hardcoded paths**: Use relative paths or configuration
- **Secrets in code**: Use environment variables
- **Missing lock files**: Always commit lock files
- **Circular dependencies**: Restructure to eliminate
- **God packages**: Split large packages by concern
- **Mixing test/prod**: Keep test utilities out of production code
- **Custom project layouts**: Follow platform conventions
- **Deep imports into features**: Use barrel exports, not internal paths
- **UI importing data sources**: Respect layer boundaries
- **DTOs leaking outside data sources**: Map to business objects
- **Mixing repository and service concerns**: Data vs functionality
- **Hardcoding data source implementations**: Use DI, not direct instantiation

---

## Core Philosophy

> "Convention over configuration." — Rails philosophy

Standard project structures reduce onboarding time and cognitive load. Feature-by-folder keeps related code together. Layer boundaries ensure clean architecture is enforced through imports—regardless of platform.