# Feedback Template

Structured output format for Product Manager reviews.

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Risk unaddressed or outcome broken | Must resolve before proceeding |
| **Major** | Significant gap in evidence or process | Should resolve for quality |
| **Minor** | Small gap or improvement opportunity | Consider addressing |
| **Suggestion** | Enhancement idea | Optional |

## Full Review Template

```markdown
## Product Manager Review

**Input**: [What was reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Product Manager
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### PM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Problem Validation | /5 | |
| 2 | Value Risk | /5 | |
| 3 | Usability Risk | /5 | |
| 4 | Feasibility Risk | /5 | |
| 5 | Business Viability Risk | /5 | |
| 6 | Strategic Alignment | /5 | |
| 7 | Success Metrics & Evidence | /5 | |
| 8 | MVP & Experimentation | /5 | |
| 9 | Prioritization & Trade-offs | /5 | |
| 10 | Ethics & Responsibility | /5 | |
| | **Overall Score** | **/50** | |

### PM Compliance Checklist (Implementation Reviews Only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Clear problem statement | [Yes/No] | |
| Target customer defined | [Yes/No] | |
| Pre-build discovery conducted | [Yes/No] | |
| Value risk validated (demand evidence) | [Yes/No] | |
| Usability tested with real users | [Yes/No] | |
| Engineer validated feasibility | [Yes/No] | |
| Tech lead involved in architecture | [Yes/No] | |
| Business constraints assessed | [Yes/No] | |
| Success metric is outcome-based | [Yes/No] | |
| MVP scoped before full build | [Yes/No] | |
| Prioritization framework applied | [Yes/No] | |
| Ethics review conducted | [Yes/No] | |
| Post-launch data being collected | [Yes/No] | |
| Post-launch data driving iterations | [Yes/No] | |

### Critical Issues
- [ ] [Issue] — [Dimension] — [Required action]

### Major Issues
- [ ] [Issue] — [Dimension] — [Recommended action]

### Minor Issues
- [ ] [Issue] — [Dimension] — [Suggestion]

### Strengths
- [What is well-done from a PM perspective]

### Top Recommendation
[One highest-priority action the plan owner should take]

### Key Question for the Team
[The single most important question the PM would ask]
```

## Filled Example 1: Proposal Review

```markdown
## Product Manager Review

**Input**: Mobile Push Notification Preferences Feature Proposal
**Review Mode**: Proposal Review
**Perspective**: Product Manager
**Verdict**: Proceed with Conditions

### PM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Problem Validation | 4/5 | Clear JTBD: "users want control over notification frequency." 8 interviews + support ticket analysis. Problem is real. |
| 2 | Value Risk | 3/5 | Qualitative demand but no quantitative signal. 23% of churn-exit surveys mention "too many notifications" but sample is small. |
| 3 | Usability Risk | 2/5 | No prototype tested. Notification preference UIs are notoriously complex — high risk of confusing users. |
| 4 | Feasibility Risk | 4/5 | Engineering validated. Push infrastructure exists. Estimated 3 sprints. Tech lead reviewed architecture. |
| 5 | Business Viability Risk | 4/5 | Supports retention OKR. No legal risk. Low incremental cost. |
| 6 | Strategic Alignment | 5/5 | Directly serves North Star (monthly active retention). Aligns with Q1 OKR "reduce voluntary churn by 15%." |
| 7 | Success Metrics & Evidence | 3/5 | KR is outcome-based ("reduce notification-related churn by 30%") but no leading indicators defined. No instrumentation plan yet. |
| 8 | MVP & Experimentation | 3/5 | Proposal includes "simple toggle" MVP but does not identify riskiest assumption to test first. Two-way door — appropriate scope. |
| 9 | Prioritization & Trade-offs | 4/5 | RICE score documented. Compared against 3 alternatives. Cost of Delay estimated at $12K/week in churn revenue. |
| 10 | Ethics & Responsibility | 4/5 | Accessibility reviewed. Dark pattern risk acknowledged (making "off" hard to find). |
| | **Overall Score** | **36/50** | |

### Critical Issues
- [ ] No usability testing — Usability Risk — Prototype the preference UI and test with 5 users before building. Notification preference UIs are a known usability challenge.

### Major Issues
- [ ] No leading indicators — Success Metrics — Define leading metrics (preference screen visit rate, toggle usage, notification opt-out rate) alongside the lagging churn metric.
- [ ] Riskiest assumption untested — MVP & Experimentation — State the riskiest assumption explicitly. Is it "users will find and use preferences" or "reduced notifications will reduce churn"? Design MVP to test that assumption first.

### Minor Issues
- [ ] Small exit-survey sample — Value Risk — Expand quantitative validation. Consider in-app survey targeting users who disabled notifications.

### Strengths
- Strong strategic alignment with retention OKR and North Star metric
- Engineering feasibility well-validated with tech lead involvement
- RICE prioritization with cost-of-delay analysis against alternatives
- Ethics consideration for dark patterns proactively addressed

### Top Recommendation
Prototype the preference UI and test with 5 users. Notification preference UIs are notoriously complex — usability risk is the biggest gap in an otherwise well-prepared proposal.

### Key Question for the Team
What is the riskiest assumption — that users will find the preference controls, or that controlling frequency will actually reduce churn?
```

## Filled Example 2: Implementation Review

```markdown
## Product Manager Review

**Input**: Search Autocomplete Feature (launched 45 days ago)
**Review Mode**: Implementation Review
**Perspective**: Product Manager
**Verdict**: Needs Improvement

### PM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Problem Validation | 4/5 | Problem well-validated: 40% of searches returned 0 results due to typos. Behavioral data from search logs. |
| 2 | Value Risk | 4/5 | Strong pre-launch demand signal from search log analysis. Post-launch: 62% of searches now use autocomplete. |
| 3 | Usability Risk | 3/5 | Design review conducted but no user testing. Post-launch: users struggle with suggestion selection on mobile (tap target too small). |
| 4 | Feasibility Risk | 5/5 | Built on time, within budget. Clean implementation. Elasticsearch integration well-architected. |
| 5 | Business Viability Risk | 4/5 | Low cost to operate. Supports core product value. Indexing cost manageable. |
| 6 | Strategic Alignment | 4/5 | Serves "reduce friction" strategic pillar. Connected to search conversion OKR. |
| 7 | Success Metrics & Evidence | 2/5 | Outcome-based KR defined ("increase search-to-purchase conversion by 20%") but only raw search counts are instrumented. Conversion funnel not tracked end-to-end. Team cannot confirm KR progress. |
| 8 | MVP & Experimentation | 3/5 | Launched as A/B test (good). But A/B test ran for only 5 days with insufficient sample size before full rollout. |
| 9 | Prioritization & Trade-offs | 4/5 | Well-prioritized using opportunity scoring (high importance × low satisfaction). Compared against 4 alternatives. |
| 10 | Ethics & Responsibility | 4/5 | Autocomplete suggestions reviewed for bias. Offensive term filtering in place. Accessible via keyboard navigation. |
| | **Overall Score** | **37/50** | |

### PM Compliance Checklist

| Requirement | Met? | Gap |
|-------------|------|-----|
| Clear problem statement | Yes | |
| Target customer defined | Yes | All users who search (80% of DAU) |
| Pre-build discovery conducted | Yes | Search log analysis + 6 user observations |
| Value risk validated | Yes | Search log data showed 40% zero-result rate |
| Usability tested with real users | No | Design review only; no user testing |
| Engineer validated feasibility | Yes | |
| Tech lead involved in architecture | Yes | Elasticsearch integration designed collaboratively |
| Business constraints assessed | Yes | Indexing cost analyzed |
| Success metric is outcome-based | Yes | But not fully instrumented |
| MVP scoped before full build | Partial | A/B test used but insufficient duration |
| Prioritization framework applied | Yes | Opportunity scoring |
| Ethics review conducted | Yes | Bias and accessibility addressed |
| Post-launch data being collected | Partial | Search counts only; conversion not tracked |
| Post-launch data driving iterations | No | Mobile usability issue known but not scheduled |

### Critical Issues
- [ ] Incomplete instrumentation — Success Metrics — Search-to-purchase conversion funnel is the KR but is not being tracked end-to-end. Team cannot confirm whether the feature achieves its stated outcome. Add conversion tracking immediately.

### Major Issues
- [ ] Insufficient A/B test — MVP & Experimentation — 5-day test with small sample size is not statistically valid. Results may be misleading. Document minimum sample size and duration for future experiments.
- [ ] Mobile usability gap — Usability Risk — Tap targets too small on mobile. Known issue but not scheduled for fix. Users are struggling — this undermines the value proposition for 55% of traffic.
- [ ] Post-launch data not driving action — Success Metrics — Mobile usability issue identified in data but no iteration scheduled. Data collection without action is Metric Theater.

### Strengths
- Excellent problem validation using behavioral search log data (not just opinions)
- Strong feasibility execution with collaborative engineering involvement
- Good prioritization discipline with opportunity scoring framework
- Proactive ethics review including bias filtering and accessibility

### Top Recommendation
Instrument the full search-to-purchase conversion funnel immediately. Without it, the team cannot confirm whether the feature achieves its KR — and the current "success" claim is unsupported.

### Key Question for the Team
If 62% of users are using autocomplete but you cannot measure conversion impact, how do you know this feature is working rather than just being clicked?
```

## Quick Review Template

```markdown
## Product Manager Review (Quick)

**Input**: [What was reviewed] | **Mode**: [Proposal / Implementation] | **Verdict**: [Verdict] | **Score**: /50

**Top Risks**: [1-2 highest concerns with dimension names]
**Strengths**: [1-2 positive signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```
