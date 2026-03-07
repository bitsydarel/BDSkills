# Calibration: Feasibility Risk

Weak, adequate, and strong examples for scoring Feasibility Risk (F1-F5).

## Strong (Score 5)

- Technical spike results documenting approach, risks, and estimated effort
- Architecture review with senior engineer sign-off
- Dependency map showing external team commitments confirmed in writing
- Performance benchmarks from prototype under realistic load
- Build-vs-buy analysis for major components

**Example signal:** "Engineer completed a 3-day spike; core algorithm works at 10x expected load; integration with payment API tested; estimated 3 sprints with 1-sprint buffer for unknowns."

## Adequate (Score 3)

- Rough engineering estimate provided but without a spike or proof-of-concept
- Team believes they have the skills but no relevant prior experience documented
- Dependencies identified but not yet confirmed with external teams
- Timeline assumed to be reasonable based on past projects of similar size

**Example signal:** "Senior engineer estimates 4-6 weeks based on similar work last quarter. We haven't tested the new API integration yet but it should be straightforward."

## Weak (Score 1-2)

- Timeline set by stakeholders without engineering input
- No spike or prototype for technically uncertain components
- "How hard can it be?" justification for estimates
- Dependencies on external teams not validated or even identified
- No technical risk assessment

**Example signal:** "The VP said we need this by end of quarter. The team thinks they can make it work."

## Worked Example

**Scenario:** Team proposes a real-time collaboration feature.

| Criterion | Evidence Presented | Score |
|-----------|-------------------|-------|
| F1: Team Capability | Team built chat feature last year; WebSocket experience | 4 — Relevant but not identical |
| F2: Technical Risks | Identified: conflict resolution, offline sync, mobile parity | 5 — Risks catalogued proactively |
| F3: Estimation Quality | 2-day spike completed; estimate is 5 sprints ± 1 sprint | 5 — Spike-validated estimate |
| F4: Dependencies | Needs infra team for WebSocket scaling — verbal commitment | 3 — Not confirmed in writing |
| F5: Uncertainty Reduction | Spike built working prototype of conflict resolution | 5 — Highest-risk component tested |

**Dimension Score:** 4/5 — Strong overall but dependency (F4) not formally confirmed.
