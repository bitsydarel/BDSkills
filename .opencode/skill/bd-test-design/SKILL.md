---
name: bd-test-design
description: Comprehensive guide for designing and implementing software tests. Use when the user asks to write new tests, refactor existing tests, design test strategies, or improve code coverage for Unit, Integration, E2E, or UI automation across Web, Mobile, Backend, or AI platforms.
---

# Test Design

This skill guides the design and implementation of comprehensive tests.

## Core Thinking

Before generating code, establish:
1. **Purpose**: Verify behavior, not implementation.
2. **Scope**: Unit, Integration, or E2E?
3. **Inputs/Outputs**: Define strict expectations.

## Design Criteria

Use these techniques to select inputs:

### Equivalence Partitioning (EP)
Divide inputs into classes where all values are treated the same. Test one value from each valid and invalid class.
*Example*: For `age` (0-12 child, 13-19 teen), test values: `-1`, `5`, `15`.

### Boundary Value Analysis (BVA)
Bugs hide at edges. Test exact boundaries and one step before/after.
*Example*: For range 0-12, test: `-1`, `0`, `12`, `13`.

### Advanced Heuristics
For complex validation logic (CORRECT, Right-BICEP, Zero-One-Many), see [references/heuristics.md](references/heuristics.md).

## Test Structure

### Arrange-Act-Assert (AAA)
Ensure all tests follow this pattern:
1. **Arrange**: Set up independent state/fixtures.
2. **Act**: Execute the behavior.
3. **Assert**: Verify outcome.

### Isolation & Naming
- **Isolation**: No shared mutable state. Mocks/stubs for external deps.
- **Naming**: `should_[outcome]_when_[scenario]` or `test_[scenario]_[expected_outcome]`.

## Domain & Strategy Guides

Select the specific guide based on the user's context:

- **Property-Based Testing**: For invariants, algorithms, and round-trip data. See [references/property-testing.md](references/property-testing.md).
- **Edge Cases**: For checklists of required edge cases (Happy/Sad/Ugly). See [references/edge-cases.md](references/edge-cases.md).
- **Platform Specifics**: Tooling and patterns for **Mobile, Web, Backend, and AI**. See [references/platforms.md](references/platforms.md).

## Anti-Patterns
- **Interdependence**: Tests relying on execution order.
- **Shared Mutable State**: State bleeding between tests.
- **Implementation Coupling**: Tests breaking on internal refactors.
- **Flaky Tests**: Non-deterministic results.