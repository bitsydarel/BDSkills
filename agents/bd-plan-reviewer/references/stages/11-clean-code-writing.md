# Stage 11: Clean Code Review

Invoke skill `bd-clean-code-writing` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full clean code assessment |
| new-feature | All 10 dimensions | Clean code from the start |
| improvement | 7-10 dims | Focus on not degrading existing quality |
| bug-fix | 5-7 dims: error handling, naming, complexity, duplication | SOLID/DI may be N/A for small fix |
| refactor | All 10 dimensions | This IS the clean code domain |
| architecture-change | 7-10 dims | Especially interface segregation, DI |
| infrastructure-change | 4-6 dims: error handling, naming, separation of concerns | SOLID may be partially N/A |
| ui-enhancement | 6-8 dims: separation of concerns, naming, readability | DI may be lighter for UI |
| deprecation | 3-5 dims: duplication (removing dead code), naming | Less to add, more to remove |
| devops-tooling | 4-6 dims: readability, naming, error handling | Scripts need clean code too |

**How to update the plan:**
- Add coding standards or conventions to follow
- Flag areas where SOLID violations are likely (e.g., god classes, feature envy)
- Add refactoring notes for complex areas
- Add type safety requirements
- Add naming convention guidelines for new entities
- Ensure the plan's technical approach avoids known anti-patterns
