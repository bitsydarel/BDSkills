# Stage 10: QA Engineer Review

Invoke skill `bd-quality-assurance` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full QA assessment |
| new-feature | All 10 dimensions | Feature flags especially relevant |
| improvement | 8-10 dims | Nearly full assessment |
| bug-fix | 6-8 dims: standards, release, rollback, monitoring | Feature flags may be N/A for hotfix |
| refactor | 7-9 dims: standards, pipeline, code review critical | Rollback if high risk |
| architecture-change | 8-10 dims | Nearly full — deployment risk is high |
| infrastructure-change | 7-9 dims: pipeline, monitoring, rollback critical | Code standards may be lighter |
| ui-enhancement | 7-9 dims | Feature flags for gradual rollout |
| deprecation | 6-8 dims: release checklist, monitoring, deployment | Remove deprecated code safely |
| devops-tooling | 8-10 dims | This IS the QA domain for pipeline changes |

**How to update the plan:**
- Add quality gates for each phase (code review, testing, staging, prod)
- Add deployment checklist
- Add rollback plan if something goes wrong
- Add monitoring requirements (metrics, alerts, dashboards)
- Add feature flag strategy for gradual rollout where applicable
- Flag missing CI/CD pipeline steps
