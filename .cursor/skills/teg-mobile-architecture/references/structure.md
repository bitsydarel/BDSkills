# Project Structure

## Feature Modules

Each top-level feature (e.g., `authentication`, `settings`) is treated as a module boundary. Dependencies between
features must form a Directed Acyclic Graph (DAG).

### Public API

Each feature must have an entry file (e.g., `authentication.dart`) at the feature root.

* **Exports**: Routes, Use Cases, Business Types.
* **Registers**: Dependency Injection (DI) bindings.
* **Rule**: External features must import *only* this file, never internal folders.

## Folder Layout

Within a feature, use these responsibilities. Valid for Flutter, iOS, and Android (naming conventions may vary slightly, but boundaries must match):

```text
/feature_name
  ├── feature_name.dart (Public API entry file)
  ├── /ui
  ├── /cubits (or /view_models)
  ├── /use_cases
  ├── /business_objects
  ├── /exceptions
  ├── /repositories
  ├── /services
  ├── /data_sources
      ├── /contracts
      ├── /impl
      └── /impl/dtos (Optional: Keep DTOs private here)

```

## Root Layouts by Platform

Flutter (Dart)

```text
/lib
  /common
  /authentication
  /settings

```

Android (Kotlin)

Use Gradle modules or distinct packages to represent feature boundaries.

```text
/app
/common
/authentication
/settings

```

iOS (Swift)

Use Swift Packages (preferred) or Xcode targets to represent feature boundaries.

```text
/App
/Common
/Authentication
/Settings

```
