---
name: teg-mobile-architecture
description: Enforce Transport Exchange Group (TEG) mobile architecture standards. Use this skill when designing new mobile features, structuring project folders, implementing architectural layers (UI, Use Case, Repository, Data Source), or reviewing PRs for compliance across Flutter, iOS, and Android.
---

# TEG Mobile Architecture

This skill defines the architectural standard for TEG mobile apps.

## Core Principle: One-Way Dependencies
Dependencies flow strictly in one direction:
**UI & State** → **Use Cases** → **Repositories** → **Data Source Contracts**.

## Quick Start
When building a feature, implement layers in this specific order:
1.  **Business Types** (Objects + Exceptions)
2.  **Use Cases** (Business Intentions)
3.  **Repositories** (Data Boundaries)
4.  **Data Sources** (Contracts & Implementations)
5.  **UI & State** (Screens & Cubits/ViewModels)

## Reference Documentation
Load the specific reference file needed for the current task.

### 1. Architectural Rules & Policy
For "Non-negotiable" rules, dependency matrices, and strict layer boundaries:
* See [references/policies.md](references/policies.md)

### 2. Project Structure
For folder layout, module boundaries, and file placement:
* See [references/structure.md](references/structure.md)

### 3. Implementation Patterns
For code templates and platform-specific syntax:
* **Flutter (Dart)**: [references/implementation_flutter.md](references/implementation_flutter.md)
* **iOS (Swift)**: [references/implementation_ios.md](references/implementation_ios.md)
* **Android (Kotlin)**: [references/implementation_android.md](references/implementation_android.md)