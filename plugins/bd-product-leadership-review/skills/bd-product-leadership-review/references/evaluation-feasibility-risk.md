# Dimension 3: Feasibility Risk

Can we build this with acceptable effort and quality?

## Criteria

- **F1: Team Capability** — Does the team have the required skills and experience?
- **F2: Technical Risks** — Are known unknowns and technical risks identified?
- **F3: Estimation Quality** — Is there an engineer-validated estimate with assumptions documented?
- **F4: Dependencies** — Are external dependencies confirmed and committed?
- **F5: Uncertainty Reduction** — Has a spike been done for technically uncertain components?

## Proposal Questions

1. Does the team have the required skills and relevant experience? (F1)
2. What are the known unknowns and technical risks? (F2)
3. Is the estimate engineer-validated with assumptions documented? (F3)
4. Are external dependencies confirmed with committed timelines? (F4)
5. Has a spike or proof-of-concept been done for risky components? (F5)

## Implementation — Compliance Questions

1. Was an engineer involved in estimation? (F3)
2. Were technical risks identified upfront? (F2)
3. Was a spike done for high-uncertainty parts? (F5)

## Implementation — Results Questions

1. Was it built within the estimated timeline? (F3)
2. What technical debt was incurred? (F2)
3. Is it maintainable by other engineers? (F1)
4. How does it perform under realistic load? (F5)

## Scoring

| Score | Description |
|-------|-------------|
| 5 | Engineer-validated estimate; spike completed for uncertain parts; relevant team experience; dependencies confirmed |
| 4 | Good engineering input with minor gaps (e.g., one dependency not yet confirmed) |
| 3 | Rough estimate without spike; assumed the team can handle it |
| 2 | Timeline set without engineering input; risks not catalogued |
| 1 | No engineering input; timeline dictated by stakeholders |

## Quality Check

A score of 4+ requires at minimum: an engineer-validated estimate, documented technical risks, and confirmed external dependencies.

---

## Extended Criteria (Scale-Stage and Beyond)

These criteria become increasingly important as the organization moves from growth to scale stage. See [frameworks-company-stages.md](frameworks-company-stages.md) for stage-appropriate expectations.

### F6: Operational Readiness

Has the team planned for running the feature in production, not just building it?

- **On-call burden**: What is the expected incident rate? Who is on-call? Is the rotation sustainable?
- **Monitoring and alerting**: Are health checks, error rate alerts, and performance dashboards defined?
- **Deployment strategy**: Is there a plan for blue-green, canary, or rolling deployment? What is the rollback procedure?
- **Runbooks**: Are operational runbooks documented for common failure scenarios?

**Scoring impact:** At scale stage, F6 gaps can cap the Feasibility score at 3 even if F1-F5 are strong.

### F7: Infrastructure Validation

Has the technical foundation been verified for the proposed workload?

- **Database migration readiness**: Schema changes planned? Migration strategy (online vs. offline)? Rollback path?
- **Capacity under load**: Load testing completed or planned? Capacity headroom sufficient for projected growth?
- **Data pipeline integrity**: ETL/streaming pipelines validated for new data flows? Backfill strategy for historical data?

**Scoring impact:** At scale stage, missing infrastructure validation is a blocking gap for scores above 3.
