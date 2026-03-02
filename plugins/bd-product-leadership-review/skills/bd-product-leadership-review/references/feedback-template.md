# Feedback Template

Structured output format for product leadership reviews.

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Risk unaddressed or outcome broken | Must resolve before proceeding |
| **Major** | Significant gap in evidence or outcomes | Should resolve for quality |
| **Minor** | Small gap or improvement opportunity | Consider addressing |
| **Suggestion** | Enhancement idea | Optional |

## Full Review Template

```markdown
## Product Leadership Review

**Input**: [What was reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Product Leadership (CPO / VP Product / Director of Product)
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### Risk & Outcome Scorecard

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Value Risk | /5 | |
| Usability Risk | /5 | |
| Feasibility Risk | /5 | |
| Business Viability Risk | /5 | |
| Product Outcomes | /5 | |
| Discovery Evidence | /5 | |
| Instrumentation & Guardrails | /5 | |
**Overall Score**: /35

### Outcome Confirmation Status

| Element | Status | Notes |
|---------|--------|-------|
| Outcome-Based OKRs | [Present/Partial/Missing] | |
| Leading Product Outcomes | [Present/Partial/Missing] | |
| Product Instrumentation | [Present/Partial/Missing] | |
| Guardrail Metrics | [Present/Partial/Missing] | |
| Two-Way Negotiation | [Present/Partial/Missing] | |

### Leadership Compliance (Implementation Reviews Only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Clear problem statement | [Yes/No] | |
| Target customer/persona defined | [Yes/No] | |
| Pre-build discovery conducted | [Yes/No] | |
| Usability validated before build | [Yes/No] | |
| Engineer validated feasibility | [Yes/No] | |
| Business constraints assessed | [Yes/No] | |
| Success metric is outcome-based | [Yes/No] | |
| Post-launch data being collected | [Yes/No] | |

### Critical Issues
- [ ] [Issue] — [Area] — [Required action]
### Major Issues
- [ ] [Issue] — [Area] — [Recommended action]
### Minor Issues
- [ ] [Issue] — [Area] — [Suggestion]

### Strengths
- [What is well-done from a product leadership perspective]

### Top Recommendation
[One highest-priority action the plan owner should take]

### Key Question for the Team
[The single most important question leadership would ask]
```

## Filled Example 1: Proposal Review

```markdown
## Product Leadership Review

**Input**: In-App Notifications Feature Proposal
**Review Mode**: Proposal Review
**Perspective**: Product Leadership
**Verdict**: Proceed with Conditions

### Risk & Outcome Scorecard
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Value Risk | 3/5 | 3 interviews mention email fatigue; no quantitative demand |
| Usability Risk | 2/5 | No prototype tested; notification UX is complex |
| Feasibility Risk | 4/5 | Engineering validated; real-time infra exists |
| Business Viability Risk | 4/5 | Aligns with retention strategy |
| Product Outcomes | 2/5 | KR is output-based ("launch notifications") |
| Discovery Evidence | 3/5 | 3 interviews but small sample |
| Instrumentation & Guardrails | 2/5 | No analytics plan; no fatigue guardrail |
**Overall Score**: 20/35

### Outcome Confirmation Status
| Element | Status | Notes |
|---------|--------|-------|
| Outcome-Based OKRs | Partial | Good objective but KR is output-based |
| Leading Product Outcomes | Missing | Only lagging churn metric |
| Product Instrumentation | Missing | No tracking planned |
| Guardrail Metrics | Missing | No fatigue protection |
| Two-Way Negotiation | Present | Team-initiated |

### Critical Issues
- [ ] Output-based KR — Outcomes — Redefine as "Increase 7-day re-engagement from 12% to 25%"
- [ ] No instrumentation — Instrumentation — Define analytics before building
### Major Issues
- [ ] Small discovery sample — Discovery — Expand to 8+ interviews
- [ ] No usability testing — Usability — Prototype and test with 5 users
### Strengths
- Team-initiated from real support ticket patterns
- Engineering feasibility well-validated

### Top Recommendation
Redefine KR to outcome metric and add instrumentation plan.
### Key Question for the Team
How will you know if notifications help re-engagement vs. drive uninstalls?
```

## Filled Example 2: Implementation Review

```markdown
## Product Leadership Review

**Input**: Onboarding Flow (launched 60 days ago)
**Review Mode**: Implementation Review
**Reviewer Perspective**: Product Leadership (CPO / VP Product / Director of Product)
**Verdict**: Needs Improvement

### Risk & Outcome Scorecard

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Value Risk | 4/5 | 68% new-user churn before setup; validated with 12 interviews |
| Usability Risk | 3/5 | Design review but no user test; 45% drop-off at step 3 |
| Feasibility Risk | 5/5 | Built on time; clean implementation; no tech debt |
| Business Viability Risk | 4/5 | Supports activation-retention-revenue pipeline |
| Product Outcomes | 3/5 | Outcome-based KR but target not collaboratively set |
| Discovery Evidence | 4/5 | Strong pre-build discovery; post-launch data collected but not acted on |
| Instrumentation & Guardrails | 3/5 | Funnel tracked but no activation quality guardrail |

**Overall Score**: 26/35

### Outcome Confirmation Status

| Element | Status | Notes |
|---------|--------|-------|
| Outcome-Based OKRs | Present | "Increase onboarding completion from 32% to 60%" |
| Leading Product Outcomes | Partial | No "quality of activation" metric |
| Product Instrumentation | Present | Full funnel with per-step drop-off |
| Guardrail Metrics | Missing | No check that completers actually activate |
| Two-Way Negotiation | Partial | VP set target; team adjusted timeline only |

### Leadership Compliance

| Requirement | Met? | Gap |
|-------------|------|-----|
| Clear problem statement | Yes | |
| Target customer defined | Yes | New users in first 24 hours |
| Pre-build discovery | Yes | 12 interviews + churn analysis |
| Usability validated | No | Design review only |
| Engineer validated feasibility | Yes | |
| Business constraints assessed | Yes | |
| Outcome-based success metric | Yes | |
| Post-launch data collected | Yes | Not yet driving iteration |

### Major Issues
- [ ] No guardrail — Outcomes — Add "activation within 48h" guardrail
- [ ] Data not driving iteration — Discovery — Investigate step 3 drop-off (45%)
- [ ] Pre-build usability skipped — Usability — Conduct usability audit now

### Strengths
- 12 customer interviews and quantitative churn analysis pre-build
- Outcome-based KR framed around completion, not delivery
- Full funnel instrumentation in place

### Top Recommendation
Add activation quality guardrail and investigate 45% step 3 drop-off immediately.

### Key Question for the Team
Are completers becoming active users, or completing steps without real engagement?
```

## Quick Review Template

```markdown
## Product Leadership Review (Quick)

**Input**: [What was reviewed] | **Mode**: [Proposal / Implementation] | **Verdict**: [Verdict] | **Score**: /35

**Key Risks**: [1-2 highest concerns]
**Strengths**: [1-2 positive signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```
