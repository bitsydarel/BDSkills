# Product Outcome Confirmation

The five critical elements for confirming that product outcomes are properly defined, measurable, and being achieved. Without these elements, teams ship features without knowing whether they solved the problem.

## Element 1: Outcome-Based OKRs

The Objective describes the business or customer problem being solved — not a feature to ship. Key Results are quantitative metrics measured by business results or user behavior changes.

**The cardinal rule:** Success is NEVER measured by task completion or feature shipment.

### Evaluation Questions

1. Does the plan define OKRs (or equivalent success metrics)?
2. Are Key Results based on business outcomes or user behavior, not deliverables?
3. Can the team articulate the customer problem the Objective addresses?
4. Is there a baseline measurement for each Key Result?
5. Is the target timeframe realistic given the baseline?

### Before/After Examples

| Bad KR (Output) | Good KR (Outcome) |
|------------------|-------------------|
| Launch notifications feature by Q2 | Increase 7-day retention from 42% to 55% by Q2 |
| Ship 3 integration partners | Reduce manual data entry time by 60% for mid-market accounts |
| Complete checkout redesign | Increase checkout completion rate from 34% to 52% |
| Deploy new onboarding flow | Achieve 70% onboarding completion within first session |
| Release mobile app v2.0 | Increase mobile task completion rate from 28% to 65% |

### Scoring Guide

- **Present**: OKRs exist with outcome-based KRs, baselines, and targets
- **Partial**: OKRs exist but KRs are output-based or lack baselines
- **Missing**: No defined success criteria, or criteria are purely delivery-based

## Element 2: Leading Product Outcomes

Distinguish between business outcomes (lagging indicators the company cares about) and product outcomes (leading indicators the team can directly influence).

**Business outcomes** (lagging): Revenue, 90-day retention, market share, customer lifetime value
**Product outcomes** (leading): Onboarding completion, time-to-value, feature adoption, perceived value score

Teams must own leading indicators they can directly influence. Lagging indicators confirm the strategy is working but take too long for iteration cycles.

### Evaluation Questions

1. Does the plan distinguish leading from lagging indicators?
2. Are product outcomes within the team's direct control and influence?
3. Do the leading indicators credibly predict the lagging business outcomes?
4. Is there a documented hypothesis linking product outcomes to business outcomes?
5. Are leading indicators measured frequently enough to enable iteration?

### Leading vs Lagging Pairs

| Leading (Team Controls) | Lagging (Business Cares About) |
|-------------------------|-------------------------------|
| Onboarding completion rate | 90-day retention |
| Time-to-first-value | Customer lifetime value |
| Feature adoption in first week | Net revenue retention |
| Support ticket resolution speed | NPS / CSAT |
| Activation rate (key action taken) | Monthly active users |

### Scoring Guide

- **Present**: Leading/lagging distinction is clear; team owns leading indicators; hypothesis documented
- **Partial**: Some metrics defined but no clear leading/lagging separation
- **Missing**: Only lagging business metrics; team has no leading indicators to iterate on

## Element 3: Product Instrumentation & Telemetry

Products must be heavily instrumented to track actual customer usage. Without telemetry, leadership cannot confirm whether an outcome was achieved — the team is flying blind.

### Evaluation Questions

1. What analytics and telemetry are in place or planned?
2. Can the team actually measure the Key Results they defined?
3. Is there visibility into specific workflow steps and drop-off points?
4. Are events granular enough to answer "why" questions, not just "what"?

### Instrumentation Checklist

- [ ] **Event tracking**: Key user actions instrumented (clicks, page views, feature usage)
- [ ] **Funnel analytics**: Multi-step workflows tracked with drop-off visibility
- [ ] **Performance monitoring**: Latency, error rates, and availability tracked
- [ ] **Error tracking**: Errors captured with context for debugging
- [ ] **Cohort analysis**: Ability to segment users by behavior, signup date, or persona
- [ ] **Custom dashboards**: KR metrics visible in a single view with trend lines

### Scoring Guide

- **Present**: Comprehensive instrumentation covering all KRs; dashboards in place; team reviews data regularly
- **Partial**: Some tracking exists but gaps prevent measuring key outcomes
- **Missing**: No telemetry; outcomes cannot be confirmed with data

## Element 4: Guardrail Metrics

Focusing on one metric can cause damage elsewhere. Guardrails protect overall business health while the team optimizes specific outcomes.

An Overall Evaluation Criterion (OEC) can encode acceptable trade-offs: "Increase activation rate while keeping 7-day retention above 60% and support tickets below 50/week."

### Evaluation Questions

1. What guardrail metrics are defined alongside primary KRs?
2. Could optimizing the primary metric harm another area? (e.g., engagement up, but quality down)
3. Are acceptable trade-offs explicitly documented?
4. Who monitors guardrails, and what happens when one is breached?

### Guardrail Examples

| Team Focus | Primary Metric | Guardrail |
|------------|---------------|-----------|
| Acquisition | New signups/week | Customer satisfaction score stays above 4.2 |
| Engagement | DAU/MAU ratio | Churn rate stays below 5% monthly |
| Monetization | ARPU | Free-to-paid conversion stays above 3% |
| Performance | Page load time | Error rate stays below 0.1% |
| Growth | Activation rate | 7-day retention stays above 60% |

### Scoring Guide

- **Present**: Guardrails defined for each primary KR; trade-offs documented; monitoring in place
- **Partial**: Some awareness of trade-offs but no formal guardrails
- **Missing**: Single-metric focus with no side-effect protection

## Element 5: Two-Way Negotiation

Goal-setting is collaborative, not top-down. Leadership provides strategic intent and business context. The team communicates what metric movement is realistic within the timeframe.

**Top-down mandates fail** because leadership lacks the ground-level insight to set achievable targets, and teams lack ownership of goals they didn't help define.

### Evaluation Questions

1. Was the goal collaboratively set between leadership and the product team?
2. Does the team believe the target is achievable given current resources and constraints?
3. Did the team have input on both the metric chosen and the target timeframe?
4. Is there a mechanism for renegotiation if assumptions change mid-cycle?
5. Does the team understand the strategic context behind the goal?

### Red Flags

- Target set by executive without team input
- Team cannot explain why the specific number was chosen
- No mechanism to adjust goals when context changes
- Team is measured on metrics they cannot influence

### Scoring Guide

- **Present**: Collaborative goal-setting with documented rationale; team has ownership and believes targets are achievable
- **Partial**: Some collaboration but targets feel imposed; limited team input
- **Missing**: Pure top-down mandate; team is handed metrics without context

<OutcomeConfirmationSummary>
  <Elements count="5">
    <Element name="Outcome-Based OKRs" status="Present/Partial/Missing" />
    <Element name="Leading Product Outcomes" status="Present/Partial/Missing" />
    <Element name="Product Instrumentation" status="Present/Partial/Missing" />
    <Element name="Guardrail Metrics" status="Present/Partial/Missing" />
    <Element name="Two-Way Negotiation" status="Present/Partial/Missing" />
  </Elements>
</OutcomeConfirmationSummary>
