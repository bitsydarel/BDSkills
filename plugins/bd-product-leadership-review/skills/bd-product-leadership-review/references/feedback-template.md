# Feedback Template

Structured output format for product leadership reviews. For scored examples, see [feedback-example-proposal.md](feedback-example-proposal.md) and [feedback-example-implementation.md](feedback-example-implementation.md).

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
- [ ] [Issue] — [Dimension] — [Required action]
### Major Issues
- [ ] [Issue] — [Dimension] — [Recommended action]
### Minor Issues
- [ ] [Issue] — [Dimension] — [Suggestion]

### Strengths
- [What is well-done from a product leadership perspective]

### Top Recommendation
[One highest-priority action the plan owner should take]

### Key Question for the Team
[The single most important question leadership would ask]
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
