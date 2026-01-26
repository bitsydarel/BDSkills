---
name: bd-clean-code-writing
description: Workflow for generating, refactoring, and reviewing code with strict adherence to SOLID principles, separation of concerns, and type safety. Use when Writing new components, Refactoring legacy code, Splitting large classes, or Reviewing architecture.
---

# Clean Code Writing

## Workflow

### 1. Design Analysis
Before generating code, define the **Clean Design Direction**. If you cannot describe the purpose in one sentence without "and", the scope is too broad.

1.  **Purpose**: Identify the single responsibility.
2.  **Boundaries**: Define fit within architecture and dependencies.
3.  **Abstraction**: Determine layer (Presentation, Domain, or Data).
4.  **Consumers**: Define the required interface.

### 2. Implementation Guidelines
Apply the following standards based on the task type:

* **Architecture & Layers**: For service layers, repositories, or module boundaries, strictly follow strict dependency injection and layer separation.
    * See [architecture.md](references/architecture.md)
* **Class & Logic Design**: For logical structure, inheritance, and extensibility, apply SOLID patterns.
    * See [principles.md](references/principles.md)
* **Syntax & Style**: For function writing, naming conventions, and language-specific type safety (Swift, Kotlin, TS, etc.).
    * See [standards.md](references/standards.md)

### 3. Verification Checklist
Verify the output against these critical constraints:
* [ ] **Cognitive Complexity**: Functions under 15 complexity.
* [ ] **Nesting**: Max 3 levels.
* [ ] **Type Safety**: No `Any` or `dynamic` types; explicit nullability.
* [ ] **Magic Values**: All strings/numbers extracted to constants/enums.

## Common Pitfalls
Avoid these issues by reviewing [architecture.md](references/architecture.md) for detailed anti-patterns.

## Examples
### Design Analysis Example
**Bad (too broad)**: "Create a user management system for authentication and profiles."  
**Good (single responsibility)**: "Implement user authentication with login/logout."

### Implementation Example
**Before (violates SOLID)**: Large class with multiple responsibilities.  
**After**: Split into `UserService` (interface), `AuthService` (implementation), `ProfileRepository` (data access).