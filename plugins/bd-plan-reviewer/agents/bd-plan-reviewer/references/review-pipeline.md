# Review Pipeline — Per-Reviewer Context Adaptation

This document provides context adaptation guidance for each of the 10 review stages. Each reviewer uses the Context Block to determine which of their evaluation dimensions apply to the plan under review.

---

## Context Adaptation Principles

1. **Every reviewer executes** — the question is "which dimensions apply?" not "should this run?"
2. **N/A is not a failure** — marking dimensions as N/A means the reviewer correctly identified they don't apply to this plan context
3. **Partial applicability is normal** — a reviewer with 2/10 applicable dimensions provides a perfectly valid review of those 2 dimensions
4. **Context informs, it does not override** — if a reviewer notices a concern outside their typical scope for this plan type, they should still flag it (as a note, not as a plan addition)
5. **Ratings reflect applicable dimensions only** — PASS/CONDITIONAL PASS/NEEDS WORK/FAIL are based solely on how the plan performs on its applicable dimensions

---

## Stage 1: Product Leadership Review

**Skill:** `bd-product-leadership-review`

**Dimensions:**
1. Value risk — Will customers/users buy/use this?
2. Usability risk — Can users figure it out?
3. Feasibility risk — Can engineers build this within constraints?
4. Business viability risk — Does this work for the business?
5. Outcome definition — Are success metrics outcome-based?
6. Discovery evidence — Is there real evidence backing the decision?

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

---

## Stage 2: Product Manager Review

**Skill:** `bd-product-manager-review`

**Dimensions:**
1. Problem validation — Is the problem clearly stated and backed by evidence?
2. Four risks assessment — Value, usability, feasibility, viability
3. Strategic alignment — Does this connect to company/team OKRs?
4. Success metrics — Are they specific, measurable, time-bound?
5. MVP strategy — Is scope appropriately minimized for learning?
6. Prioritization rationale — Why this over alternatives?
7. Ethical responsibility — Privacy, bias, unintended consequences

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 7 dimensions | Full PM assessment |
| new-feature | All 7; MVP scoping critical | Prioritization vs. alternatives important |
| improvement | 5-6 dims; MVP may be N/A | Problem is usually well-understood |
| bug-fix | 3-4 dims: problem validation, success metrics, prioritization | MVP/ethics often N/A |
| refactor | 3-4 dims: problem validation, feasibility, success metrics | Why refactor now? Prioritization matters |
| architecture-change | 4-5 dims: problem, risks, metrics, prioritization | Ethics N/A unless data handling changes |
| infrastructure-change | 3-4 dims: problem, feasibility, metrics | Strategic alignment if major investment |
| ui-enhancement | 5-6 dims: problem, usability risk, metrics, MVP | Ethics if accessibility affected |
| deprecation | 5-6 dims: problem (why deprecate), risks, metrics, prioritization | Ethical: impact on existing users |
| devops-tooling | 3-4 dims: problem, feasibility, metrics | MVP scoping if phased rollout |

**How to update the plan:**
- Add a problem statement if missing or vague
- Add success metrics with targets and timeframes
- Add MVP scope boundaries (what's in v1, what's deferred) — only for applicable plan types
- Add prioritization justification
- Tighten strategic alignment references

---

## Stage 3: Product Marketing Review

**Skill:** `bd-product-marketing-review`

**Dimensions:**
1. Market understanding and buyer personas
2. Positioning and messaging clarity
3. Competitive differentiation
4. Go-to-market strategy
5. Sales enablement and cross-functional readiness
6. Launch planning
7. Market performance measurement
8. Pricing and packaging strategy
9. Channel strategy
10. Customer evidence and proof points

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

---

## Stage 4: Business Analyst Review

**Skill:** `bd-business-analyst-review`

**Dimensions:**
1. Requirements completeness (functional and non-functional)
2. Stakeholder coverage
3. Process modeling (current vs. future state)
4. Business rule specification
5. Data integrity and data model considerations
6. Traceability (requirement to implementation to test)
7. Gap analysis
8. Feasibility assessment
9. Impact analysis
10. Acceptance criteria verifiability

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

---

## Stage 5: Product Designer Review

**Skill:** `bd-product-designer-review`

**Dimensions:**
1. Human-centered problem framing
2. Usability and interaction quality
3. Information architecture
4. Visual design and brand expression
5. User research rigor
6. Accessibility and inclusivity (WCAG)
7. Service blueprint and end-to-end journey mapping
8. Co-creation and stakeholder facilitation
9. Prototyping and design validation
10. Design system coherence and feasibility

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

---

## Stage 6: Product Owner Review

**Skill:** `bd-product-owner-review`

**Dimensions:**
1. Backlog readiness (items well-defined and estimated)
2. Acceptance criteria quality (specific, testable, complete)
3. Value maximization (highest value items prioritized)
4. Stakeholder conflict resolution
5. Scope control (no scope creep, clear boundaries)
6. Outcome measurement (how will we know this succeeded?)
7. Iterative learning (feedback loops, iteration plans)

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

---

## Stage 7: Software Architecture Review

**Skill:** `bd-software-architecture`

**Dimensions:**
1. Layer separation (UI, domain, data, infrastructure)
2. Dependency rules (inner layers don't depend on outer)
3. Module boundaries and coupling
4. API design and contracts
5. Data flow and state management
6. Scalability considerations
7. Technical debt implications
8. Security architecture
9. Error handling strategy
10. Integration patterns

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

---

## Stage 8: Test Design Review

**Skill:** `bd-test-design`

**Dimensions:**
1. Test strategy completeness (unit, integration, E2E, UI)
2. Test coverage targets
3. Test data management
4. Test environment requirements
5. Edge case identification
6. Performance test plan
7. Security test plan
8. Regression strategy
9. Test automation approach
10. Platform-specific testing (web, mobile, backend, AI)

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full test design assessment |
| new-feature | All 10 dimensions | Test strategy must cover new functionality |
| improvement | 7-9 dims | Regression strategy especially important |
| bug-fix | 6-8 dims: regression critical, edge cases, coverage | Performance/security may be N/A |
| refactor | 7-9 dims: regression critical, coverage must not drop | Refactor must not break existing tests |
| architecture-change | 8-10 dims | Nearly full — architecture changes need thorough testing |
| infrastructure-change | 6-8 dims: environment, performance, security | UI testing may be N/A |
| ui-enhancement | 7-9 dims: UI testing, E2E, edge cases, accessibility | Security testing may be lighter |
| deprecation | 5-7 dims: regression, coverage (remove deprecated tests?), edge cases | What tests need updating? |
| devops-tooling | 4-6 dims: automation, environment, integration | UI/E2E testing may be N/A |

**How to update the plan:**
- Add a test strategy section if missing
- Add specific test cases for critical paths
- Add coverage targets per component/layer
- Add edge cases and boundary conditions
- Add performance benchmarks and load test plans where applicable
- Add security test scenarios where applicable
- Add test environment setup requirements

---

## Stage 9: QA Engineer Review

**Skill:** `bd-quality-assurance`

**Dimensions:**
1. Code standards compliance
2. Release readiness checklist
3. Pre-commit check configuration
4. Build pipeline validation
5. Code review requirements
6. Documentation completeness
7. Monitoring and alerting
8. Rollback strategy
9. Feature flag strategy
10. Deployment verification

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full QA assessment |
| new-feature | All 10 dimensions | Feature flags especially relevant |
| improvement | 8-10 dims | Nearly full assessment |
| bug-fix | 6-8 dims: standards, release, rollback, monitoring | Feature flags may be N/A for hotfix |
| refactor | 7-9 dims: standards, pipeline, code review critical | Rollback if high risk |
| architecture-change | 8-10 dims | Nearly full — deployment risk is high |
| infrastructure-change | 7-9 dims: pipeline, monitoring, rollback critical | Code standards may be lighter |
| ui-enhancement | 7-9 dims | Feature flags for gradual rollout |
| deprecation | 6-8 dims: release checklist, monitoring, deployment | Remove deprecated code safely |
| devops-tooling | 8-10 dims | This IS the QA domain for pipeline changes |

**How to update the plan:**
- Add quality gates for each phase (code review, testing, staging, prod)
- Add deployment checklist
- Add rollback plan if something goes wrong
- Add monitoring requirements (metrics, alerts, dashboards)
- Add feature flag strategy for gradual rollout where applicable
- Flag missing CI/CD pipeline steps

---

## Stage 10: Clean Code Review

**Skill:** `bd-clean-code-writing`

**Dimensions:**
1. SOLID principle adherence
2. Separation of concerns
3. Type safety
4. Naming conventions
5. Function/class size and complexity
6. Code duplication
7. Error handling patterns
8. Dependency injection
9. Interface segregation
10. Code readability and self-documentation

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
