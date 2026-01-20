---
name: bd-project-conventions
description: Standards for project structure, environment configuration, and code organization. Use when scaffolding new projects, refactoring code, setting up environments, or troubleshooting import/build issues across Mobile, Web, and Backend platforms.
---

# Project Conventions

This skill provides standards for modular project structure and consistent environment setup.

## Core Principles

### Feature-Based Organization
Organize code **by feature**, not by file type. Ensure related code (logic, views, tests) lives together to maintain modularity.
- **Goal**: Consistency, Separation of Concerns, Reproducibility.
- **Rule**: If a module is feature-specific, it belongs in that feature's directory, not in a shared folder.

### The Common Module
Limit the `Common` (or `Shared`) module to true foundations used broadly across the app.
- **Include**: Design tokens, core utilities, platform adapters, cross-cutting concerns (logging).
- **Exclude**: Feature-specific logic.

### Anti-Patterns (NEVER Use)
- **Sys.path hacks**: Never modify import paths programmatically.
- **Hardcoded paths**: Use relative paths or configuration.
- **Secrets in code**: Always use environment variables.
- **Missing lock files**: Always commit lock files (`yarn.lock`, `go.sum`, etc.).
- **Mixing test/prod**: Keep test utilities out of production code.

## Platform specifics

### Directory Structure
For specific directory trees (Flutter, Android, iOS, Python, Node, Go, React), see [structure-patterns.md](references/structure-patterns.md).

### Setup, Config & Troubleshooting
For environment variable patterns, lock file commands, and build error troubleshooting, see [setup-patterns.md](references/setup-patterns.md).

## Import Conventions

### General Rules
- **Relative Imports**: Use within the same package/module (cleaner, refactor-friendly).
- **Absolute Imports**: Use in tests (tests import the package, not siblings).
- **No Path Manipulation**: Never modify `sys.path` or similar runtime paths.
- **Barrel Exports**: Use `index.ts` or `__init__.py` to define clean public APIs.

### Import Order
Group imports in this order:
1. Standard library / built-ins
2. Third-party packages
3. Local application imports (Absolute)
4. Local application imports (Relative)
