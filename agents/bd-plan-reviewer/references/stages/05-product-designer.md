# Stage 5: Product Designer Review

Invoke skill `bd-product-designer-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full design assessment |
| new-feature | 8-10 dims | Nearly full; brand expression may be lighter |
| improvement | 6-8 dims: usability, IA, accessibility, design system | Research lighter if well-understood |
| bug-fix | 2-3 dims: usability (is the fix intuitive?), accessibility | 7/10 dimensions typically N/A |
| refactor | 1-2 dims: usability if UI touched, design system coherence | Nearly all N/A if backend-only |
| architecture-change | 0-2 dims | N/A unless user-facing (e.g., loading states change) |
| infrastructure-change | 0-1 dims | Nearly all N/A |
| ui-enhancement | All 10 dimensions | Full design assessment — this is the designer's core domain |
| deprecation | 2-4 dims: journey mapping (what changes), usability of alternatives | If user-facing |
| devops-tooling | 1-2 dims: usability if developer-facing UI | CLI UX counts |

**How to update the plan:**
- Add user journey or flow description if missing and applicable
- Add accessibility requirements (WCAG level, assistive tech) for user-facing changes
- Add interaction specs for key workflows
- Flag UX risks (complex flows, cognitive overload, poor affordances)
- Add design validation steps (usability testing, prototype review) for new/major UX
- Address edge cases in user flows (error states, empty states, loading states)
- **Do NOT add:** full service blueprints for bug fixes, visual design specs for backend refactors
