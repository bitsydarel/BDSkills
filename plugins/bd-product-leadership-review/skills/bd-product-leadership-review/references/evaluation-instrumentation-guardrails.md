# Dimension 7: Instrumentation & Guardrails

Can the team actually measure outcomes and protect against negative side effects?

This dimension evaluates whether the infrastructure exists to confirm that outcomes are being achieved (instrumentation) and that optimizing one metric is not degrading another (guardrails). It is distinct from the Product Outcomes dimension (P3/P4), which evaluates whether instrumentation and guardrails are *defined*. This dimension evaluates whether they *work*.

## Criteria

- **I1: Telemetry Coverage** — Are analytics and telemetry in place to track actual customer usage?
- **I2: KR Measurability** — Can the team produce current values for every Key Result they defined?
- **I3: Workflow Visibility** — Can drop-off points, friction, and user paths be identified from data?
- **I4: Guardrail Monitoring** — Are guardrails monitored with alerts and thresholds that trigger action?

## Proposal Questions

1. What analytics and telemetry are planned? Is there an instrumentation plan? (I1)
2. For each KR, can the team describe exactly how it will be measured? (I2)
3. Will the team have visibility into workflow steps and drop-off points? (I3)
4. Are guardrail thresholds defined with automated alerts? (I4)

## Implementation — Compliance Questions

1. Was an instrumentation plan defined alongside the feature spec? (I1)
2. Were dashboards set up before or at launch? (I2)
3. Were guardrail thresholds agreed upon before optimization began? (I4)

## Implementation — Results Questions

1. Does telemetry cover all key user actions with sufficient context? (I1)
2. Can the team produce a dashboard showing current KR values with trend lines? (I2)
3. Can the team identify where users drop off and why? (I3)
4. Have guardrail alerts fired? Were they acted upon? (I4)

## Scoring

| Score | Description |
|-------|-------------|
| 5 | Comprehensive telemetry; all KRs measurable via dashboards; funnel visibility with drop-off analysis; guardrails monitored with automated alerts |
| 4 | Good coverage with minor gaps (e.g., one KR requires manual query; guardrails defined but not automated) |
| 3 | Some tracking exists but gaps prevent measuring key outcomes; no guardrail monitoring |
| 2 | Minimal tracking; "we'll add analytics later"; no guardrails |
| 1 | No telemetry; outcomes cannot be confirmed with data; no guardrails considered |

## Quality Check

A score of 4+ requires at minimum: telemetry covering all KRs, a dashboard with current values and trends, and documented guardrail thresholds.

## Instrumentation Checklist

- [ ] **Event tracking**: Key user actions instrumented (clicks, page views, feature usage)
- [ ] **Funnel analytics**: Multi-step workflows tracked with drop-off visibility
- [ ] **Performance monitoring**: Latency, error rates, and availability tracked
- [ ] **Error tracking**: Errors captured with context for debugging
- [ ] **Cohort analysis**: Ability to segment users by behavior, signup date, or persona
- [ ] **Custom dashboards**: KR metrics visible in a single view with trend lines
- [ ] **Alerting**: Guardrail breaches trigger automated alerts

---

## Extended Criteria

### I5: Metric Validity

Are the chosen metrics actually measuring what they claim to measure?

- **Attribution complexity**: Can improvements be attributed to the feature, or are there confounding factors? Multi-touch attribution requires careful design.
- **Survivorship bias**: Are metrics only measuring engaged users while ignoring those who churned or never activated? Retention metrics must include the denominator.
- **Simpson's Paradox risk**: Could aggregate metrics hide opposing trends in subgroups? Segment metrics by key cohorts to detect this.
- **Metric gaming potential**: Could the team (or users) optimize the metric in ways that don't create real value? (e.g., counting pageviews when engagement depth matters)

**Scoring impact:** Invalid metrics produce false confidence. If I5 concerns are present, cap Instrumentation score at 3 until metric validity is addressed.

### I6: Learning Velocity

How quickly can the team go from data to decision to iteration?

- **Data-to-decision cadence**: How long from data collection to actionable insight? Days, weeks, or months?
- **Post-launch iteration speed**: Can the team ship changes based on learnings within one sprint/cycle?
- **Experiment throughput**: How many experiments can the team run per quarter? Higher throughput = faster learning.
- **Feedback loop closure**: Is there a systematic process for turning instrumentation data into product improvements?

**Scoring impact:** High learning velocity compensates for imperfect initial instrumentation — teams that iterate quickly can correct course. Low learning velocity means initial instrumentation must be more comprehensive.
