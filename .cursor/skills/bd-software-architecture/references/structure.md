# Feature Structure & Data Flow

## Feature Folder Structure

Structure features to enforce the dependency rule physically.

```text
/feature_name
  /ui                     # Presentation (Views, Controllers) - DEPENDS ON: Use Cases, Domain
  /state                  # State Management (Stores, Reducers) - DEPENDS ON: Use Cases, Domain
  /use_cases              # Application Business Rules - DEPENDS ON: Repos, Services, Domain
  /domain                 # Enterprise Business Rules (Pure) - DEPENDS ON: Nothing
  /repositories           # Data Coordination - DEPENDS ON: DS Contracts, Domain
  /services               # Capabilities - DEPENDS ON: DS Contracts
  /data_sources           # Frameworks & Drivers
    /contracts            # Interfaces
    /impl                 # Implementations (Dirty details)
      /dtos               # Private Data Transfer Objects
  feature_name.dart       # Public API (Barrel export)

```

## Feature Public API

Each feature must act like a separate library.

**Export (Public):**

* Public screens/views/handlers (navigation entry points)
* Domain models needed by other features
* DI registration functions

**Keep Private:**

* Repositories, Services, Data Sources, DTOs

## Data Flow Patterns

**Standard Flow:**
Presentation → State/Handler → Use Case → Repository/Service → Data Source (contract) → Data Source (impl) → External System

**Error Translation:**

* Translate vendor errors (HTTP, DB) inside Data Source implementations.
* Convert to Domain Exceptions before returning.
* Use Cases catch domain exceptions, not vendor errors.
