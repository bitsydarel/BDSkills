# Stage 1: Product Leadership Review

Invoke skill `bd-product-leadership-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 6 dimensions | Full leadership assessment |
| new-feature | All 6; lighter on discovery if incremental | Existing product reduces value risk uncertainty |
| improvement | 3-5 dims; focus on outcome definition, feasibility | Viability usually established |
| bug-fix | 2-3 dims: feasibility, outcome definition | Value/usability/viability typically N/A |
| refactor | 2-3 dims: feasibility, business viability | Focus on risk vs. reward of refactoring |
| architecture-change | 3-4 dims: feasibility, viability, outcome | Value risk reframed as "does this enable future value?" |
| infrastructure-change | 2-3 dims: feasibility, viability | Outcome = reliability/performance metrics |
| ui-enhancement | 4-5 dims: value, usability, outcome, discovery | Business viability may be N/A for cosmetic changes |
| deprecation | 3-4 dims: value risk (of removing), viability, outcome | Discovery = usage data on deprecated feature |
| devops-tooling | 2-3 dims: feasibility, viability | Outcome = developer productivity metrics |

**How to update the plan:**
- Add or sharpen OKRs if they are output-based ("ship feature X") rather than outcome-based ("increase metric Y by Z%")
- Add a risk assessment section if missing (only for applicable risk types)
- Flag missing discovery evidence (user research, data analysis, competitive intel) — but only if the plan type warrants it
- Add guardrail metrics if only success metrics exist
- For pre-launch plans with no users: note "define instrumentation for baseline measurement"
