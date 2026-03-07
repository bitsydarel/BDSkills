# Stage 6: Product Owner Review

Invoke skill `bd-product-owner-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 7 dimensions | Full PO assessment |
| new-feature | All 7 dimensions | Acceptance criteria critical |
| improvement | 5-7 dims | Iterative learning may be lighter |
| bug-fix | 4-5 dims: acceptance criteria, scope control, outcome | Value maximization = severity/frequency |
| refactor | 4-5 dims: acceptance criteria, scope, outcome | Stakeholder conflict if team disagrees on approach |
| architecture-change | 5-6 dims: scope control critical, outcome measurement | Clear boundaries prevent scope creep |
| infrastructure-change | 4-5 dims: acceptance criteria, scope, outcome | Backlog readiness for phased rollout |
| ui-enhancement | 6-7 dims | Nearly full assessment |
| deprecation | 5-6 dims: scope, stakeholder, outcome, acceptance | What counts as "done" for deprecation? |
| devops-tooling | 4-5 dims: acceptance criteria, scope, outcome | Iterative learning if phased adoption |

**How to update the plan:**
- Add acceptance criteria for each deliverable if missing
- Break down large items into smaller, deliverable increments
- Add definition of done
- Add scope boundaries (explicit "not included" list)
- Add iteration/feedback milestones where applicable
- Ensure acceptance criteria are testable (Given/When/Then or equivalent)
