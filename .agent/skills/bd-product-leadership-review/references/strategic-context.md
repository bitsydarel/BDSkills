# Strategic Context: What Excellent Looks Like

Reference examples for calibrating product leadership reviews. Use these to benchmark the quality of evidence, outcomes, and instrumentation in proposals and implementations.

## What Good Value Evidence Looks Like

- Direct customer interview quotes describing the pain point in their own words
- Support ticket volume and themes quantifying the problem's frequency
- Churn analysis showing the problem as a driver of customer loss
- Willingness-to-pay signals from pricing conversations or surveys
- Usage data showing workarounds customers have built (indicating unmet need)
- Competitive analysis showing customers leaving for solutions that address this problem

**Weak signal:** "Our sales team says customers want this."
**Strong signal:** "12 of 15 interviewed customers independently described this workflow as their top frustration; 3 have built spreadsheet workarounds."

## What Good Usability Evidence Looks Like

- Usability test summary with 5+ participants showing task completion rates
- Prototype feedback with specific friction points identified and resolved
- Heuristic evaluation by a UX professional against established principles
- Accessibility audit results for target platforms
- Comparative testing against current workflow (before/after measurements)

**Weak signal:** "The design looks clean."
**Strong signal:** "5 of 5 test users completed the core task in under 2 minutes; 3 of 5 struggled with the settings panel, which we redesigned before build."

## What Good Feasibility Evidence Looks Like

- Technical spike results documenting approach, risks, and estimated effort
- Architecture review with senior engineer sign-off
- Dependency map showing external team commitments confirmed
- Performance benchmarks from prototype under realistic load
- Build-vs-buy analysis for major components

**Weak signal:** "The team thinks we can do it in 2 sprints."
**Strong signal:** "Engineer completed a 3-day spike; core algorithm works at 10x expected load; integration with payment API tested; estimated 3 sprints with 1-sprint buffer for unknowns."

## What Good Viability Analysis Looks Like

- Unit economics model showing cost to build, cost to serve, and expected revenue
- Legal review sign-off for regulated domains (data privacy, financial, healthcare)
- Go-to-market alignment: sales can position it, marketing can message it, support can handle it
- Competitive moat analysis: how defensible is this advantage?
- Pricing strategy validated with customer willingness-to-pay data

**Weak signal:** "This should increase revenue."
**Strong signal:** "Unit economics show $2.40 cost to serve per user/month against $12 ARPU; legal cleared data processing for EU markets; sales team trained on positioning document."

## Outcomes vs Outputs

| Output (Bad) | Outcome (Good) | Why It Matters |
|-------------|----------------|----------------|
| Ship notifications feature | Increase 7-day re-engagement from 12% to 25% | Output says what you build; outcome says what changes for the customer |
| Launch mobile app v2 | Increase mobile task completion from 28% to 65% | Shipping an app means nothing if users still can't complete tasks |
| Complete 15 Jira tickets | Reduce average resolution time from 48h to 12h | Ticket velocity measures team busyness, not customer impact |
| Deploy new checkout flow | Increase checkout completion from 34% to 52% | A deployed flow that nobody completes is a waste of effort |
| Integrate 3 data sources | Reduce manual report creation time by 70% | Integrations are valuable only if they solve a workflow problem |

## Leading vs Lagging Indicator Pairs

| Domain | Leading (Team Controls) | Lagging (Business Cares About) |
|--------|------------------------|-------------------------------|
| Onboarding | Onboarding completion rate | 90-day retention |
| Engagement | Weekly active feature usage | Net revenue retention |
| Acquisition | Signup-to-activation rate | Monthly new paying customers |
| Support | Time to first response | Customer satisfaction (CSAT) |
| Performance | P95 page load time | User session length |
| Product quality | Error rate per session | NPS score |

**Why this matters:** Teams must own leading indicators they can directly influence within their iteration cycle. Lagging indicators confirm the strategy is working but are too slow for tactical decisions.

## Discovery Evidence Quality Spectrum

From weakest to strongest signal:

| Level | Source | Confidence |
|-------|--------|------------|
| 1 | Opinion or gut feel | Very Low |
| 2 | Stakeholder or executive request | Low |
| 3 | Market research or analyst report | Low-Medium |
| 4 | Customer interview (qualitative) | Medium |
| 5 | Prototype or usability test | Medium-High |
| 6 | Quantitative experiment (A/B test) | High |
| 7 | Production data at scale | Very High |

**Principle:** Move right on this spectrum before committing significant resources. A proposal at Level 1-2 should not proceed to build. Level 4+ is the minimum for responsible resource commitment.

## What a Well-Framed Problem Statement Looks Like

**Template:** [Target customer] struggles with [specific problem] when [context/trigger], which causes [measurable impact].

**Examples:**

- "Mid-market account managers spend 3+ hours weekly manually compiling client reports from 4 different tools, which delays client communication and contributes to 15% churn in this segment."
- "New users who don't complete onboarding within their first session have a 68% churn rate within 7 days, compared to 12% for those who complete it."
- "Enterprise customers in regulated industries cannot adopt our product because we lack SOC 2 compliance, costing us an estimated $2M ARR in lost deals."

**Red flags in problem statements:** "Users want...", "We need to...", "Competitors have...", "It would be nice if..."

## What Good Instrumentation Looks Like

### Telemetry Coverage Checklist

- [ ] **Core user actions**: Every key workflow step fires an event with context
- [ ] **Funnel tracking**: Multi-step flows have start/step/complete/abandon events
- [ ] **Error tracking**: Errors captured with stack trace, user context, and session replay
- [ ] **Performance**: Latency, throughput, and availability at endpoint and page level
- [ ] **Cohort segmentation**: Events tagged with user attributes for segment analysis
- [ ] **Real-time dashboards**: KR metrics visible with trend lines, updated at least daily
- [ ] **Alerting**: Guardrail breaches trigger automated alerts

### What Bad Instrumentation Looks Like

- Page views tracked but user actions within pages are not
- Events fire but lack context (which button? which flow? which user segment?)
- Data collected but no dashboards — requires an analyst to query
- Metrics available but reviewed monthly instead of weekly

## What Good Guardrails Look Like

| Primary Metric | Risk Without Guardrail | Guardrail | Threshold |
|---------------|----------------------|-----------|-----------|
| Signup conversion | Quality of signups drops | Activation rate within 7 days | >40% |
| Engagement (DAU) | Users feel spammed | Notification opt-out rate | <10% |
| Revenue per user | Free users churned out | Free tier retention | >70% at 30 days |
| Page load speed | Functionality sacrificed | Feature parity score | 100% of core features |
| Support ticket volume | Quality of resolution drops | First-contact resolution rate | >80% |

**Principle:** Every primary metric should have at least one guardrail that catches unintended negative side effects. If you cannot articulate what could go wrong, you have not thought deeply enough about trade-offs.
