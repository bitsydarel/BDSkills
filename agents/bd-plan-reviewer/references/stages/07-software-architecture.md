# Stage 7: Software Architecture Review

Invoke skill `bd-software-architecture` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full architecture assessment |
| new-feature | 7-10 dims | Depends on feature scope |
| improvement | 5-8 dims | Focus on integration with existing architecture |
| bug-fix | 3-5 dims: error handling, data flow, technical debt | Does the fix introduce debt? |
| refactor | All 10 dimensions | This IS the architect's core domain |
| architecture-change | All 10 dimensions | Full assessment — this is literally an architecture change |
| infrastructure-change | 6-8 dims: scalability, security, integration, data flow | Layer separation may be N/A |
| ui-enhancement | 3-5 dims: layer separation, state management, data flow | If UI-only, limited scope |
| deprecation | 4-6 dims: coupling, integration, technical debt | What depends on the deprecated component? |
| devops-tooling | 4-6 dims: integration, security, scalability | Pipeline architecture matters |

**How to update the plan:**
- Add architectural diagrams or layer descriptions if missing
- Add dependency direction rules
- Flag circular dependencies or layer violations
- Add API contract definitions for new endpoints
- Add data migration strategy if schema changes involved
- Add infrastructure requirements (caching, queuing, storage)
- Flag scalability concerns with specific thresholds
