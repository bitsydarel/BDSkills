# Feedback template

Structured output format for Product Owner reviews.

## Severity levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Risk unaddressed or outcome broken | Must resolve before proceeding |
| **Major** | Significant gap in evidence or process | Should resolve for quality |
| **Minor** | Small gap or improvement opportunity | Consider addressing |
| **Suggestion** | Enhancement idea | Optional |

## Full review template

```markdown
## Product Owner review

**Input**: [What was reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Product Owner
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### PO evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Strategic Alignment | /5 | |
| 2 | Value Maximization | /5 | |
| 3 | Customer Empathy & Advocacy | /5 | |
| 4 | Backlog Quality & Readiness | /5 | |
| 5 | Acceptance Criteria & Done | /5 | |
| 6 | Stakeholder Mgmt & Conflict Resolution | /5 | |
| 7 | Feasibility-Viability-Desirability Balance | /5 | |
| 8 | Scope Control & Prioritization | /5 | |
| 9 | Outcome Measurement | /5 | |
| 10 | Iterative Learning & Feedback | /5 | |
| | **Overall Score** | **/50** | |

### PO compliance checklist (implementation reviews only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Three Amigos conducted with all 3 perspectives before sprint entry | [Yes/No] | |
| Definition of Ready met before sprint entry | [Yes/No] | |
| AC collaboratively produced from concrete examples | [Yes/No] | |
| AC cover business rules + boundaries + negative cases | [Yes/No] | |
| Clear AC vs DoD distinction maintained | [Yes/No] | |
| Prioritization framework applied with documented rationale | [Yes/No] | |
| Stakeholder mapping done before engagement | [Yes/No] | |
| Conflicting demands resolved before reaching team | [Yes/No] | |
| Product Triad collaborated from discovery | [Yes/No] | |
| Spikes/prototypes used for high-uncertainty items | [Yes/No] | |
| Metrics cover engagement, satisfaction, business, and operational categories | [Yes/No] | |
| Leading and lagging indicators paired with causal hypothesis | [Yes/No] | |
| Guardrail metric pairs defined to prevent gaming | [Yes/No] | |
| Sprint review feedback captured and mapped to backlog items | [Yes/No] | |
| Post-launch data driving iterations | [Yes/No] | |

### Critical issues
- [ ] [Issue] — [Dimension] — [Required action]

### Major issues
- [ ] [Issue] — [Dimension] — [Recommended action]

### Minor issues
- [ ] [Issue] — [Dimension] — [Suggestion]

### Strengths
- [What is well-done from a PO perspective]

### Top recommendation
[One highest-priority action the plan owner should take]

### Key question for the team
[The single most important question the PO would ask]
```

## Filled example 1: Proposal review

```markdown
## Product Owner review

**Input**: "User Profile Preferences" PBI
**Review Mode**: Proposal Review
**Perspective**: Product Owner
**Verdict**: Proceed with Conditions

### PO evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Strategic Alignment | 4/5 | Traces to Q2 OKR "improve user personalization." Connection to product vision is stated but broad. |
| 2 | Value Maximization | 3/5 | RICE score documented. However, no cost-of-delay analysis and the value component is a gut estimate, not grounded in usage data. |
| 3 | Customer Empathy & Advocacy | 3/5 | 5 user interviews reference "wanting more control." But these are stated preferences, not observed behavior. No session recordings or behavioral data. |
| 4 | Backlog Quality & Readiness | 4/5 | INVEST-compliant. Story is sized at 5 points by the team. Dependencies on the settings API are confirmed. Three Amigos conducted. |
| 5 | Acceptance Criteria & Done | 2/5 | AC exist but are vague: "User can update preferences" and "Changes are saved." No boundary conditions. No negative cases. No Given/When/Then format. |
| 6 | Stakeholder Mgmt & Conflict Resolution | 4/5 | PO resolved a conflict between marketing (who wanted mandatory preferences) and UX (who wanted optional). Used Kano analysis to justify optional as a must-have baseline. |
| 7 | Feasibility-Viability-Desirability Balance | 3/5 | Tech lead reviewed. No spike despite settings API being new. Designer created wireframes but no user testing. |
| 8 | Scope Control & Prioritization | 4/5 | Scope is bounded: 6 preference categories, no custom fields in v1. PO documented what is out of scope. |
| 9 | Outcome Measurement | 3/5 | Success metric defined ("30% of users update at least one preference within 30 days"). But this is a single engagement metric — no satisfaction, business, or operational metrics. No guardrail pairs. |
| 10 | Iterative Learning & Feedback | 4/5 | PO plans to review adoption data at sprint review and adjust the second batch of preferences based on which categories are most used. |
| | **Overall Score** | **34/50** | |

### Critical issues
- [ ] Acceptance criteria are vague and untestable — AC & Done — Rewrite AC in Given/When/Then format. Add boundary conditions (max character limits, invalid input handling), negative cases (what happens with conflicting preferences), and non-functional requirements (save latency under 500ms). Run Three Amigos again with rewritten AC.

### Major issues
- [ ] Single-category metrics — Outcome Measurement — Add at least one metric from each category: satisfaction (CSAT on settings page), business (correlation with retention), operational (error rate on preference saves). Define a guardrail pair (e.g., adoption rate + page load time).
- [ ] No behavioral evidence for customer empathy — Customer Empathy — Supplement interviews with session recordings or analytics showing users currently struggle with defaults. Stated preferences ("I want more control") are not reliable indicators of actual behavior.
- [ ] No spike for new settings API — FVD Balance — The settings API is new and untested. Run a time-boxed spike (1-2 days) to confirm the API handles the required data model before committing to the full story.

### Minor issues
- [ ] Value estimate is subjective — Value Maximization — Consider pairing the RICE score with a brief cost-of-delay analysis to strengthen the ordering rationale.

### Strengths
- Scope is well-bounded with explicit out-of-scope documentation
- Three Amigos conducted with all three perspectives present
- Stakeholder conflict resolved proactively using Kano analysis
- Iteration plan tied to sprint review data

### Top recommendation
Rewrite acceptance criteria before sprint entry. The current AC ("user can update preferences," "changes are saved") are untestable. Without specific, boundary-covering AC, the team will build something, but nobody will agree on whether it is done.

### Key question for the team
What happens when a user sets conflicting preferences (e.g., "notify me about everything" and "minimize notifications") — and do our acceptance criteria cover that?
```

## Filled example 2: Implementation review

```markdown
## Product Owner review

**Input**: "Order Tracking Dashboard" (launched 30 days ago)
**Review Mode**: Implementation Review
**Perspective**: Product Owner
**Verdict**: Needs Improvement

### PO evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Strategic Alignment | 4/5 | Traces to "reduce support burden" strategic objective. Supports Q3 OKR "decrease order-related tickets by 40%." |
| 2 | Value Maximization | 3/5 | Was prioritized via MoSCoW. However, three lower-value features were built in the same sprint, diluting focus. No cost-of-delay analysis. |
| 3 | Customer Empathy & Advocacy | 4/5 | Grounded in support ticket analysis (37% of tickets are "where is my order?"). PO observed 8 customer calls. Real pain confirmed. |
| 4 | Backlog Quality & Readiness | 3/5 | Items met DoR formally, but Three Amigos was a 10-minute session. QA perspective was limited to "it should work." No edge cases surfaced until development. |
| 5 | Acceptance Criteria & Done | 3/5 | AC were written but PO-dictated. Format was bullet points, not Given/When/Then. Missing: what happens when tracking data is unavailable? What about multi-package orders? QA found these gaps mid-sprint. |
| 6 | Stakeholder Mgmt & Conflict Resolution | 4/5 | PO resolved a conflict between ops (wanted internal dashboard first) and product (wanted customer-facing). Used Vision vs Survival to justify customer-facing first. |
| 7 | Feasibility-Viability-Desirability Balance | 4/5 | Tech lead involved from refinement. Shipping carrier API integration was spiked one sprint ahead. Product Triad collaborated on the UX. |
| 8 | Scope Control & Prioritization | 3/5 | Initial scope held, but post-launch the PO accepted 3 enhancement requests without formal trade-offs. Scope is now creeping for v2 without re-prioritization. |
| 9 | Outcome Measurement | 2/5 | Success metric is "reduce order-related tickets by 40%." That is the only metric — no engagement, satisfaction, or operational metrics. Dashboard adoption rate is not tracked. No leading indicators defined. No guardrail pairs. |
| 10 | Iterative Learning & Feedback | 3/5 | Sprint review captured feedback (stakeholders want filtering by date range). But the feedback is a feature request, not validated against user behavior. No post-launch review scheduled. |
| | **Overall Score** | **33/50** | |

### PO compliance checklist

| Requirement | Met? | Gap |
|-------------|------|-----|
| Three Amigos conducted with all 3 perspectives before sprint entry | Partial | Session was perfunctory; QA perspective was minimal |
| Definition of Ready met before sprint entry | Yes | Formally met |
| AC collaboratively produced from concrete examples | No | PO-dictated, no collaborative session |
| AC cover business rules + boundaries + negative cases | No | Missing unavailable data, multi-package, error states |
| Clear AC vs DoD distinction maintained | Yes | |
| Prioritization framework applied with documented rationale | Yes | MoSCoW applied |
| Stakeholder mapping done before engagement | No | Not documented |
| Conflicting demands resolved before reaching team | Yes | Ops vs Product resolved |
| Product Triad collaborated from discovery | Yes | |
| Spikes/prototypes used for high-uncertainty items | Yes | Carrier API spiked |
| Metrics cover engagement, satisfaction, business, and operational categories | No | Only support ticket volume tracked |
| Leading and lagging indicators paired with causal hypothesis | No | Single lagging indicator only |
| Guardrail metric pairs defined to prevent gaming | No | |
| Sprint review feedback captured and mapped to backlog items | Partial | Captured but not validated |
| Post-launch data driving iterations | No | No post-launch review scheduled |

### Critical issues
- [ ] Single-metric measurement — Outcome Measurement — Only tracking support ticket reduction. Add: dashboard adoption rate (engagement), CSAT on tracking page (satisfaction), time-to-resolution for order inquiries (operational). Define a guardrail pair: ticket reduction + dashboard page load time. Without broader measurement, the PO cannot confirm the feature actually works or detect side effects.

### Major issues
- [ ] AC were not collaboratively produced — AC & Done — AC were dictated by the PO, not produced in Three Amigos. QA found gaps mid-sprint (unavailable tracking data, multi-package orders) that should have been caught in refinement. For future items, require collaborative AC writing with concrete examples.
- [ ] No post-launch review scheduled — Iterative Learning — Feature launched 30 days ago with no review planned. The 40% ticket reduction target has not been checked. Schedule 30/60/90 day reviews.
- [ ] Scope creeping on v2 without re-prioritization — Scope Control — Three enhancement requests accepted without trade-off analysis. Apply RICE or cost-of-delay to the v2 items and re-prioritize against the full backlog.

### Minor issues
- [ ] Three Amigos was perfunctory — Backlog Quality — 10-minute session with minimal QA input. For complex items (external API integrations), allocate 30+ minutes and require each perspective to voice at least one concern.
- [ ] Sprint review feedback not validated — Iterative Learning — "Add date range filtering" is a feature request, not a validated need. Check usage data: do users actually need to filter, or is the default view sufficient?

### Strengths
- Strong customer empathy grounded in support ticket analysis and direct call observation
- Carrier API integration spiked one sprint ahead, preventing feasibility surprises
- Product Triad collaboration from discovery through delivery
- Stakeholder conflict resolved proactively with a named framework

### Top recommendation
Expand outcome measurement immediately. A single metric (support ticket reduction) cannot confirm whether the dashboard is working, and it definitely cannot detect negative side effects. Add engagement, satisfaction, and operational metrics before the 60-day mark.

### Key question for the team
If 37% of support tickets were "where is my order?" before launch, what percentage are they now — and can anyone on the team answer that question today?
```

## Quick review template

```markdown
## Product Owner review (quick)

**Input**: [What was reviewed] | **Mode**: [Proposal / Implementation] | **Verdict**: [Verdict] | **Score**: /50

**Top Risks**: [1-2 highest concerns with dimension names]
**Strengths**: [1-2 positive signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```

## Guidance note

Prioritize the top 5-10 critical and major issues in the review output. Avoid overwhelming the reader with exhaustive lists of every minor violation. Leave minor nits for offline discussion or follow-up refinement sessions. The goal is actionable feedback that the PO can act on this sprint, not a comprehensive audit of everything that could be better.
