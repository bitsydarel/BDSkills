# Calibration: Product Outcomes

Weak, adequate, and strong examples for scoring Product Outcomes (P1-P5).

## Strong (Score 5)

- OKRs are outcome-based with baselines, targets, and timeframes
- Team owns leading indicators and can articulate the hypothesis linking them to lagging metrics
- Comprehensive instrumentation covering all KRs with dashboards reviewed weekly
- Guardrails defined for each primary KR with automated alerts
- Goals collaboratively set with documented rationale

**Example signal:** "KR: Increase onboarding completion from 32% to 60% by Q3. Leading indicator: time-to-first-value (predicts 90-day retention). Guardrail: activation quality stays above 70%. Dashboard reviewed weekly in team standup."

## Adequate (Score 3)

- OKRs exist but some KRs are output-based ("launch X") rather than outcome-based
- Some metrics defined but no clear leading/lagging distinction
- Partial tracking — some events instrumented but gaps prevent full measurement
- Guardrails informally understood but not formalized with thresholds
- Goals set with some team input but primarily top-down

**Example signal:** "We have a KR to ship notifications by Q2 and improve retention, but we haven't defined the target retention number or set up tracking yet."

## Weak (Score 1-2)

- No OKRs or only output-based deliverables ("ship feature X")
- Only lagging business metrics; team cannot influence what they're measured on
- No instrumentation; "we'll add analytics later"
- No guardrails; single-metric focus without side-effect awareness
- Pure top-down mandate; team handed metrics without context or negotiation

**Example signal:** "VP said we need to increase revenue by 20%. We're building three features that should help."

## Outcomes vs Outputs Reference

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
