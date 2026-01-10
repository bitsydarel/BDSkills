---
name: bd-software-architecture
description: Implement clean architecture, adhere to layer responsibilities, and structure features correctly. Use when designing new features or refactoring modules.
---

# Software Architecture

This skill guides the internal structuring of software features, enforcing separation of concerns, strict dependency rules, and clean data flow. Apply these principles to ensure features remain loosely coupled, testable, and maintainable.

The user needs help with designing a feature, understanding where code belongs (Repository vs Service), or fixing dependency violations.

---

## Architecture Thinking

Before creating files or folders, map the feature's requirements to the architecture layers:

- **Boundaries**: Is this a self-contained feature (e.g., `authentication`) or a shared foundation (e.g., `common`)?
- **Data Flow**: Where does data come from (Network, DB, Cache)? How does it reach the UI?
- **Contracts**: What interface does the Domain layer need? (Define this *before* implementation).
- **Dependencies**: Are high-level policies depending on low-level details? (They shouldn't).

**CRITICAL**: Design from the **inside out** (Domain & Use Cases first), not outside in (Database or UI first). The UI is just a plugin to the business logic.

### When This Applies

Use this skill when:
- Designing the structure of a new feature
- Refactoring a "God Class" or monolithic module
- Deciding where to put new logic (Repository vs. Service?)
- Fixing circular dependencies
- Implementing data caching or offline support
- Reviewing PRs for architectural violations

---

## Feature Folder Structure

**Applies to**: Each feature module/package across all platforms

Structure features to enforce the dependency rule physically. The goal is consistent layering, even if naming conventions vary slightly by platform.

### Conceptual Layout

```
/feature_name
  /ui                     # Presentation (Views, Controllers)
                          # DEPENDS ON: Use Cases, Business Objects
  
  /cubits                 # State Management (ViewModels, Stores)
                          # DEPENDS ON: Use Cases, Business Objects

  /use_cases              # Application Business Rules (Orchestrators)
                          # DEPENDS ON: Repositories, Services, Business Objects

  /business_objects       # Enterprise Business Rules (Entities)
                          # DEPENDS ON: Nothing (Pure)

  /repositories           # Interface Adapters (Data Coordination)
                          # DEPENDS ON: Data Source Contracts, Business Objects

  /services               # Interface Adapters (Capabilities)
                          # DEPENDS ON: Data Source Contracts

  /data_sources           # Frameworks & Drivers (IO, DB, API)
    /contracts            # Interfaces (Define location + behavior)
    /impl                 # Implementations (The dirty details)
      /dtos               # Data Transfer Objects (Private to impl)

  feature_name.dart       # Public API (Barrel export)
```

### Platform Mapping

Use this guide to translate the conceptual layers to platform-specific conventions while maintaining the architecture.

| Concept | Flutter | iOS (Swift) | Android (Kotlin) | Backend (Python/Node) |
|---------|---------|-------------|------------------|-----------------------|
| **UI** | `/ui` | `/Views` | `/ui` | `/handlers` or `/controllers` |
| **State** | `/cubits` | `/ViewModels` | `/viewmodels` | `/handlers` |
| **Use Cases** | `/use_cases` | `/UseCases` | `/usecases` | `/use_cases` |
| **Domain** | `/business_objects` | `/Models` | `/domain` | `/domain` or `/models` |
| **Repository** | `/repositories` | `/Repositories` | `/repositories` | `/repositories` |
| **Service** | `/services` | `/Services` | `/services` | `/services` |
| **Data Source** | `/data_sources` | `/DataSources` | `/datasources` | `/data_sources` or `/adapters` |

---

## Layer Responsibilities

| Layer | Responsibility | Contains |
|-------|---------------|----------|
| **Business Objects** | **What** data is (Pure) | Entities, Value Objects, Enums |
| **Use Cases** | **What** the app does | Single-purpose classes (`LoginUseCase`) |
| **Repositories** | **How** data is coordinated | `UserRepository` (decides Cache vs API) |
| **Services** | **How** capabilities work | `AuthService`, `AnalyticsService` |
| **Data Sources** | **Where** data lives | `RemoteUserDataSource`, `LocalUserDataSource` |
| **UI / State** | **How** data is shown | Widgets, ViewModels, Presenters |

---

## Component Decision Guide

### Repository vs. Service

Use this guide to decide where logic belongs:

| Component | Focus | Example Responsibilities |
|-----------|-------|--------------------------|
| **Repository** | **Data** | CRUD operations, Caching strategies, Fetching, Saving |
| **Service** | **Capabilities** | 3rd Party APIs (Stripe), Device features (Camera), System events |

**Rule of Thumb**: If it acts like a collection of data, it's a Repository. If it performs an action, it's a Service.

### Data Source Architecture

Data Sources are the boundary between your clean code and the outside world.

1.  **Contract (Interface)**: Defines *what* is needed. Lives in the Data Source layer but is imported by Repositories.
2.  **Implementation**: Defines *how* it works. Injected via Dependency Injection.

```
                  Dependency Direction
Repository ─────────────────────────────────> Data Source Contract
                                                      ^
                                                      │ (implements)
                                                      │
                                              Data Source Impl
```

---

## Dependency Rules

**CRITICAL**: Dependencies must point **inwards** towards high-level policies.

1.  **UI** depends on **Use Cases** (or ViewModels).
2.  **Use Cases** depend on **Repositories/Services** (Interfaces).
3.  **Repositories** depend on **Data Source Contracts**.
4.  **Data Source Impls** depend on **External Libs** & **DTOs**.
5.  **Business Objects** depend on **Nothing**.

**Forbidden Imports**:
- UI importing Data Sources directly.
- Use Cases importing DTOs (Domain pollution).
- Business Objects importing *anything* framework-specific (e.g., JSON parsers, HTTP clients).

---

## Feature Public API

**Applies to**: Encapsulation

Each feature must act like a separate library. Expose **only** what other features need.

**Expose**:
- UI Pages/Screens (for navigation)
- Business Objects (shared models)
- Main Use Cases (rarely, usually via specific inter-feature contracts)

**Hide (Private)**:
- Repositories
- Data Sources
- DTOs
- Internal helper functions

---

## Architecture Anti-Patterns (NEVER use)

- **Deep Imports**: Importing `feature/src/internal/repo.ts`. **Fix**: Use the barrel file.
- **Leaking DTOs**: Returning `UserDTO` from a Repository. **Fix**: Map to `User` entity inside the Data Source or Repository.
- **Logic in UI**: Making API calls or complex decisions in the View. **Fix**: Move to Use Case or Cubit.
- **God Repositories**: A `GeneralRepository` doing everything. **Fix**: Split by domain entity (`UserRepository`, `OrderRepository`).
- **Hard Dependencies**: `new PostgresDataSource()`. **Fix**: Use Dependency Injection.

---

## Core Philosophy

> "The software architecture of a system is the set of structures needed to reason about the system, which comprises software elements, relations among them, and properties of both." — Len Bass

Good architecture is about **deferring decisions**. By strictly separating layers, you allow the database, UI framework, or external APIs to change without breaking your business logic.
