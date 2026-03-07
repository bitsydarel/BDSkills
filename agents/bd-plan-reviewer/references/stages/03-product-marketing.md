# Stage 3: Product Marketing Review

Invoke skill `bd-product-marketing-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full PMM assessment |
| new-feature (external) | 7-8 dims; emphasis on positioning, launch | Pricing may be N/A if no pricing change |
| improvement | 3-5 dims: messaging, launch, measurement | Lighter positioning unless major UX change |
| bug-fix | 1 dim: customer impact assessment (#6 launch — support briefing) | 9/10 dimensions N/A |
| refactor | 0-1 dims | Nearly all N/A unless user-visible performance improvement |
| architecture-change | 0-1 dims | N/A unless user-visible (e.g., latency improvement) |
| infrastructure-change | 0-1 dims | N/A unless affects user-facing SLAs |
| ui-enhancement | 3-5 dims: positioning, messaging, launch, measurement | If external-facing |
| deprecation | 3-4 dims: customer impact, messaging, launch, channel | Communication plan critical |
| devops-tooling | 0-1 dims | Nearly all N/A |
| internal tool | 0-1 dims | Reframe "customer" as "internal stakeholder"; stakeholder readiness only |

**Key insight:** Customer Impact Assessment (dimension 6 — launch planning, support briefing) applies to nearly every plan type. Even bug fixes may need support team briefing if customer-facing. This is the one near-universally-applicable PMM dimension.

**How to update the plan:**
- For applicable contexts: add positioning statement, competitive context, launch checklist, messaging
- For bug-fix/refactor/infra: add customer impact note only if user-facing
- For internal tools: reframe as stakeholder readiness (who needs to know? training needed?)
- **Do NOT add:** buyer personas for internal tools, GTM strategy for bug fixes, pricing for architecture changes
