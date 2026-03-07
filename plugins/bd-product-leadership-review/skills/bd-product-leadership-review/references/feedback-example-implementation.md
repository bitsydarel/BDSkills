# Example: Implementation Review

A scored product leadership review of an existing implementation, demonstrating the full review template with compliance and results assessment.

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
- [ ] No guardrail — Product Outcomes — Add "activation within 48h" guardrail
- [ ] Data not driving iteration — Discovery Evidence — Investigate step 3 drop-off (45%)
- [ ] Pre-build usability skipped — Usability Risk — Conduct usability audit now

### Strengths
- 12 customer interviews and quantitative churn analysis pre-build
- Outcome-based KR framed around completion, not delivery
- Full funnel instrumentation in place

### Top Recommendation
Add activation quality guardrail and investigate 45% step 3 drop-off immediately.

### Key Question for the Team
Are completers becoming active users, or completing steps without real engagement?
```
