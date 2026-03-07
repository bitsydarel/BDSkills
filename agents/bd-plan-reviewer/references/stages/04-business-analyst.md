# Stage 4: Business Analyst Review

Invoke skill `bd-business-analyst-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full BA assessment |
| new-feature | All 10 dimensions | Requirements completeness critical |
| improvement | 7-9 dims; process modeling may be lighter | Gap analysis vs. current state |
| bug-fix | 4-6 dims: requirements (what's broken), impact, acceptance criteria | Process modeling/stakeholder may be N/A |
| refactor | 4-6 dims: requirements, traceability, impact, acceptance | Business rules may be N/A |
| architecture-change | 6-8 dims: requirements, data integrity, impact, feasibility | Business rules may be N/A |
| infrastructure-change | 5-7 dims: requirements, data, feasibility, impact, acceptance | Process modeling may be N/A |
| ui-enhancement | 6-8 dims: requirements, process, acceptance, gap analysis | Data model may be N/A |
| deprecation | 6-8 dims: impact analysis critical, stakeholder coverage | What breaks? Who's affected? |
| devops-tooling | 4-6 dims: requirements, feasibility, acceptance, impact | Business rules typically N/A |

**How to update the plan:**
- Add missing functional requirements discovered through gap analysis
- Add non-functional requirements (performance, security, scalability) — scope to plan context
- Add or refine business rules where applicable
- Create traceability links between requirements and plan sections
- Add data model considerations if the plan involves data changes
- Flag ambiguous requirements and replace with specific, testable statements
