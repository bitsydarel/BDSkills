# Calibration guide

What good PO rigor looks like — reference examples for each evaluation area.

## Good vs weak acceptance criteria

### Weak AC

- "Search should work well"
- "User can track orders"
- "Reviews feature works correctly"
- "Notifications are sent"

These are untestable. No boundary conditions, no negative cases, no pass/fail criteria. Anyone reading them will have a different interpretation of "well" and "correctly."

### Strong AC

- Given a customer who purchased a product, when they submit a review, then the review is saved and visible within 5 seconds
- Given a customer who did not purchase the product, when they attempt to submit a review, then the system rejects it with "Only verified purchasers can leave reviews"
- Given a review text exceeding 2000 characters, when the customer submits, then the system truncates at 2000 and shows a warning
- Given an order with status "Delivered," when the customer attempts to cancel, then the system displays "Delivered orders cannot be cancelled"
- Given the user's device has GPS enabled, when they enter the address field, then the system auto-populates with the detected address (non-functional: usability)

Strong AC cover business rules, boundary conditions, negative cases (what users *cannot* do), and non-functional attributes across Operations, Information, Performance, and Non-functional (usability, security, scalability, reliability).

### AC vs DoD distinction

**AC example** (specific to this PBI): "Customer can only cancel orders with status Open or In Progress."

**DoD example** (overarching quality standard): "Unit tested, 80% of code peer-reviewed, architecture standards met, API documentation updated, release notes written, stakeholder sign-off obtained."

AC answers "what does this story do?" DoD answers "what quality bar does all our work meet?"

## Definition of Ready: what good looks like

### Weak DoR

- "Story is written"
- "PO approves it"
- "It has a title and description"

### Strong DoR

- [ ] User story follows "As a [who], I want [what], so that [why]" format
- [ ] Acceptance criteria written in Given/When/Then, covering happy path + boundaries + negative cases
- [ ] Story sized by the development team (not the PO alone)
- [ ] Dependencies identified and confirmed (APIs, data, other teams)
- [ ] Three Amigos conducted: PO, Dev, and QA each raised at least one question
- [ ] UX designs attached if the story has a user-facing component
- [ ] No blockers — everything needed to start is available

## Definition of Done: what good looks like

- [ ] All acceptance criteria pass
- [ ] Code peer-reviewed (80%+ coverage)
- [ ] Unit tests written and passing
- [ ] Integration tests passing where applicable
- [ ] Architecture standards met (no circular dependencies, correct layer placement)
- [ ] API documentation updated
- [ ] Release notes drafted
- [ ] Deployed to staging and verified
- [ ] Stakeholder sign-off obtained at sprint review
- [ ] No known severity-1 defects

## INVEST criteria applied

| Criterion | Violation | Correction |
|-----------|-----------|------------|
| **Independent** | "This story requires Story #42 to be done first" | Split so each delivers independently testable value. If a dependency exists, make it explicit and order them. |
| **Negotiable** | "Build exactly this wireframe, pixel-perfect" | AC define the *what*, not the *how*. The team negotiates implementation. |
| **Valuable** | "Refactor the database schema" (no user value stated) | "Refactor schema so that order queries return in under 200ms" (ties to user-facing outcome). |
| **Estimable** | "Integrate with the partner API" (team has never seen it) | Run a spike first. The story is not estimable until unknowns are resolved. |
| **Small** | 13-point story spanning multiple features | Split by workflow step, business rule, or data variation until each piece is 1-5 points. |
| **Testable** | "The system should be fast" | "Page loads in under 2 seconds on 3G connection." Specific, measurable, pass/fail. |

## Value ordering and ROI rigor

### Weak ordering

- Items built in the order they were requested (FIFO)
- Gut-feel prioritization: "this feels important"
- Arbitrary value scores: "I give it a 7 out of 10" with no criteria
- Effort estimated by the PO alone, dev-only time, no docs/training/marketing/maintenance
- No risk discount for uncertain items

### Strong ordering

ROI = Value / Effort, with:
- **Value** scored on a ratio scale (a 10 is genuinely 10x more valuable than a 1, not "slightly more")
- **Effort** cross-functional: dev + QA + docs + training + marketing + ongoing maintenance
- **Confidence multiplier** for uncertainty: high confidence = 1.0, medium = 0.7, low = 0.4
- Result is rank-ordered, not grouped into tiers

Expanded ROI Scorecard: ((Customer Needs + Business Objectives) / Effort) x Confidence = Priority

### Acceptable approximation

When precise scoring is not feasible, a 3x3 grid works:

| | Low Effort | Medium Effort | High Effort |
|---|-----------|--------------|-------------|
| **High Value** | Do first | Do second | Evaluate carefully |
| **Medium Value** | Do second | Evaluate | Probably not now |
| **Low Value** | Maybe | Probably not | Do not do |

Deliberate imprecision is fine. Simple 1-3 or 0-2 scales prevent precision paralysis while still highlighting leverage. The goal is relative ordering, not absolute accuracy.

### Usability ROI

For UX features, translate behavioral metrics to dollars:
- **Internal**: time saved x salary, reduced errors, reduced training, reduced support calls
- **External**: increased conversion rate, reduced support costs, reduced churn

## Three Amigos: what a good session looks like

### Weak session

- PO reads the story aloud, others nod
- Held retroactively (after dev started) or skipped entirely
- AC are abstract and vague, written by PO alone
- No edge cases discussed
- Dev and QA discover gaps during implementation
- 5-10 minutes, feels like a formality

### Strong session

- All 3 perspectives present and active:
  - **PO**: "What problem does this solve? What is the expected behavior? What does the user care about?"
  - **Dev**: "How do we build it? What are the technical constraints? What dependencies exist?"
  - **QA**: "What could go wrong? What are the edge cases? What happens with bad input?"
- Held before sprint entry, during refinement
- AC produced collaboratively from concrete examples ("Imagine a user who just placed an order and...")
- Edge cases and failure scenarios identified and documented
- Shared understanding confirmed: each person can explain the story in their own words
- Output is stable, accurate requirements that rarely change during the sprint
- 20-40 minutes for complex items

## Sprint review as feedback loop

### Weak review

- One-way demo: PO shows slides, stakeholders watch
- "Any questions?" gets silence
- No feedback captured
- Team moves to next sprint with no new information
- Overcrowded room where junior members stay silent

### Strong review

- Hands-on: stakeholders interact with the increment directly
- PO asks directed questions: "Does this solve the problem you described last month?"
- Written feedback collected before open discussion (prevents groupthink)
- Feedback mapped to specific backlog items or new items created
- Attendance limited to relevant stakeholders
- Captured insights feed directly into next sprint planning

## Stakeholder conflict resolution techniques

These are the six core techniques a PO uses to resolve conflicting stakeholder demands.

**Prerequisite**: Stakeholder Map (Influence/Interest matrix) or RACI completed. Without knowing who has power and who has interest, the PO reacts to whoever is loudest.

### 1. Shuttle diplomacy

Meet stakeholders 1-on-1 before group sessions. Use GROW framework: Goals (what do you want?), Reality (what is the current situation?), Options (what are the alternatives?), Way forward (what will you do?). Cross-pollinate ideas between stakeholders. Remove office politics from the conversation.

### 2. Shift outputs to outcomes

When a stakeholder says "build me X," ask "why is that important?" Trace the request to the underlying customer or business need. Two stakeholders asking for different features might share the same underlying outcome.

### 3. Objective prioritization frameworks

Use ROI Scorecard, Kano Model (must-haves before delighters), Vision vs Survival matrix, or Desirability-Feasibility-Viability to make priority decisions visible and auditable. Frameworks do not decide — they make the decision process transparent.

### 4. Data over opinions

Run a quick prototype, A/B test, or feature stub to gauge actual demand. Let customer data act as the "outside arbitrator." This neutralizes the HiPPO effect and emotional attachments. Move from subjective (opinions) to objective (evidence).

### 5. Show your work and co-create

Use visual artifacts — Opportunity Solution Tree, Story Map, Kanban board — so stakeholders evaluate the *thinking*, not just the *conclusions*. Gather independent input first (written feedback, dot-voting), then run co-creation workshops. Stakeholders who participate in the process are less likely to fight the outcome.

### 6. Defer to expertise, not consensus

Tech lead decides architecture. Designer decides UX patterns. PO decides value priority. This is not autocracy — it is competence-based decision-making. Provide transparent rationale. Commit to the decision even without full agreement. Collaboration means gathering input from many; decision means one accountable person chooses.

## Outcome measurement: what good looks like

### Weak measurement

- Only tracks "stories shipped" or "velocity"
- Single metric: "reduce support tickets"
- No leading indicators (only lagging: revenue, retention)
- No guardrail pairs: optimizing one metric at the expense of others
- Ad-hoc metric selection, no framework

### Strong measurement

**Coverage across 4 categories**:
1. Engagement/Traction — Feature Usage Rate, DAU/MAU, Task Completion Rate
2. Satisfaction/Sentiment — NPS, CSAT, CES
3. Business/Strategic — Retention, Conversion, ARPU
4. Operational Quality — Escaped Defects, Latency, Uptime

**Framework applied**: HEART (Happiness, Engagement, Adoption, Retention, Task Success) or AARRR (Acquisition, Activation, Retention, Revenue, Referral) to structure measurement, not ad-hoc selection.

**Leading + lagging paired**: Leading indicators are team-controlled and measurable quickly (first-week engagement, activation rate, task completion). Lagging indicators are cross-department and take months (retention, revenue, LTV). Both are tracked together, with an explicit causal hypothesis: "We believe first-week engagement predicts 90-day retention because users who complete onboarding within 48 hours form habits."

**Guardrail pairs**: Mutually destructive metric pairs prevent gaming. If you optimize conversion, guard retention. If you optimize speed, guard defect rate. If you optimize feature count, guard user satisfaction.

### Outcome vs output at sprint level

| Output (Weak) | Outcome (Strong) |
|---------------|-----------------|
| "Ship order tracking dashboard" | "Reduce order-related support tickets from 37% to under 15%" |
| "Build preference settings page" | "30% of users customize at least one preference within 30 days" |
| "Complete search improvements" | "Reduce zero-result searches from 40% to under 10%" |
| "Launch notification system" | "Increase 7-day re-engagement from 12% to 25%" |

## Feasibility assessment: what good looks like

### Weak assessment

- PO estimates feasibility alone
- Engineering sees the item for the first time at sprint planning
- "How hard can it be?" is the feasibility analysis
- No spikes for uncertain components
- Architecture concerns surface mid-sprint

### Strong assessment

- Product Triad (PO + Designer + Tech Lead) collaborates from discovery
- Engineers are in discovery sessions hearing customer pain directly
- Feasibility prototypes or spikes run for uncertain solutions (throwaway code, time-boxed, with AC)
- Tech Lead assesses skills, time, architecture, scalability, and performance
- Desirability vs Feasibility matrix used for scoring features
- High-desirability / low-feasibility features are chunked into atomic MVP components
- Feature chunking: break ambitious items into must-haves + one differentiator

## Scope control: saying no constructively

| Response | When to Use |
|----------|-------------|
| **"Not now"** | The request has value but other items are higher priority. Place it in the backlog with a clear ordering rationale. |
| **"Not ever"** | The request contradicts the product vision or strategy. Explain why, reference the vision, close the item. |
| **"Let me investigate the underlying need"** | The request is a solution, not a problem. Ask "why is this important?" to uncover the root need. The solution may be different from what was asked. |

The PO's ability to say "no" (or "not yet") is the single most important scope control mechanism. A PO who cannot say no is an order taker.

## Complete PO toolkit

All techniques a PO reviewer checks for, organized by scope.

**Tactical (sprint/story level)**:
- Acceptance criteria in Given/When/Then format
- Three Amigos sessions (PO + Dev + QA)
- Definition of Ready as a sprint entry gate
- Definition of Done as a quality bar
- Story splitting patterns (by workflow, rule, data, interface)
- INVEST criteria for story quality
- Spikes for estimation blockers
- Prototypes for customer validation

**Operational (backlog/quarter level)**:
- Named prioritization framework (WSJF, RICE, ROI Scorecard, Kano, MoSCoW)
- Cost of Delay estimation
- MVP scoping with narrow target audience (MVS)
- Backlog grooming cadence (weekly)
- Sprint review as feedback loop (not demo)
- Post-launch reviews at 30/60/90 days
- Metric coverage: engagement, satisfaction, business, operational
- Leading/lagging indicator pairs with causal hypothesis
- Guardrail metric pairs

**Strategic (product/annual level)**:
- Stakeholder mapping (Influence/Interest, RACI)
- Shuttle diplomacy with GROW framework
- Outcome-shifting ("why is that important?")
- Visual artifacts (Opportunity Solution Tree, Story Map, Kanban)
- Co-creation workshops after independent input
- Defer-to-expertise pattern (tech lead, designer, PO)
- Innovation portfolio balance (70/20/10 sustaining/adjacent/disruptive)
- Vision vs Survival matrix for conflict resolution
- Product Triad collaboration (PO + Designer + Tech Lead)
- DFV three-lens test (Desirability, Feasibility, Viability)
