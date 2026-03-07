# Calibration: Instrumentation & Guardrails

Weak, adequate, and strong examples for scoring Instrumentation & Guardrails (I1-I4).

## Strong (Score 5)

- Comprehensive telemetry covering all key user actions with context (which flow, which segment)
- Funnel analytics with per-step drop-off visibility
- Custom dashboards showing all KR metrics with trend lines, updated at least daily
- Guardrail thresholds defined with automated alerts
- Data reviewed weekly in team standups or dedicated review sessions

**Example signal:** "Every workflow step fires an event with user segment and session context. Our KR dashboard shows onboarding completion rate by cohort with daily updates. Guardrail alert fires if activation quality drops below 70%."

## Adequate (Score 3)

- Some tracking exists but gaps prevent measuring key outcomes
- Page views tracked but user actions within pages are not
- Events fire but lack context (which button? which flow? which user segment?)
- Data collected but no dashboards — requires an analyst to query
- Guardrails informally understood but not automated

**Example signal:** "We track page views and some button clicks. To check our KR, the data analyst runs a SQL query each Monday."

## Weak (Score 1-2)

- No telemetry; outcomes cannot be confirmed with data
- "We'll add analytics later" appears in the plan
- Metrics available but reviewed monthly instead of weekly (or not at all)
- No guardrails; single-metric optimization without side-effect monitoring
- Feature is live but no usage data is collected

**Example signal:** "The feature shipped last month. We don't have analytics set up yet but plan to add them next sprint."

## Telemetry Coverage Checklist

- [ ] **Core user actions**: Every key workflow step fires an event with context
- [ ] **Funnel tracking**: Multi-step flows have start/step/complete/abandon events
- [ ] **Error tracking**: Errors captured with stack trace, user context, and session replay
- [ ] **Performance**: Latency, throughput, and availability at endpoint and page level
- [ ] **Cohort segmentation**: Events tagged with user attributes for segment analysis
- [ ] **Real-time dashboards**: KR metrics visible with trend lines, updated at least daily
- [ ] **Alerting**: Guardrail breaches trigger automated alerts

## What Bad Instrumentation Looks Like

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
