---
name: bd-software-architecture
description: Architectural enforcement for software design. Use this skill when, Designing the folder structure of a new feature, Deciding where specific business logic belongs (e.g., Repository vs Service), Refactoring legacy code or breaking monoliths, Reviewing PRs for dependency violations or circular references. Applies to Mobile, Web, Backend, AI/ML, CLI, and Desktop.
---

# Software Architecture Guide

This skill guides the internal structuring of software features to ensure loose coupling and testability.

## Architecture Workflow

When assisting with software design or refactoring, follow this process:

### 1. Identify Components & Layers

Determine the nature of the code being written. Map requirements to the correct layer.

- **Consult**: [references/layers.md](references/layers.md) for layer definitions and the Dependency Matrix.
- **Guidance**: Design from the inside out (Domain → Use Cases → Outer Layers).

### 2. Structure the Feature

Organize files to physically enforce dependency rules.

- **Consult**: [references/structure.md](references/structure.md) for the standard feature folder structure, public API guidelines, and data flow patterns.

### 3. Make Component Decisions

If unsure whether logic belongs in a Repository, Service, or Use Case:

- **Consult**: [references/decisions.md](references/decisions.md) for heuristics and composition rules.

### 4. Validate Compliance

Ensure the design meets strict architectural policies.

- **Consult**: [references/rules.md](references/rules.md) for non-negotiable rules and anti-patterns to avoid.

## Core Philosophy

> "The goal of software architecture is to minimize the human resources required to maintain the system."

Dependencies must always flow **inward** toward high-level policies. The UI and Database are details/plugins to the business logic.
