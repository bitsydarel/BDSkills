# Stage 9: Test Design Review

Invoke skill `bd-test-design` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | All 10 dimensions | Full test design assessment |
| new-feature | All 10 dimensions | Test strategy must cover new functionality |
| improvement | 7-9 dims | Regression strategy especially important |
| bug-fix | 6-8 dims: regression critical, edge cases, coverage | Performance/security may be N/A |
| refactor | 7-9 dims: regression critical, coverage must not drop | Refactor must not break existing tests |
| architecture-change | 8-10 dims | Nearly full — architecture changes need thorough testing |
| infrastructure-change | 6-8 dims: environment, performance, security | UI testing may be N/A |
| ui-enhancement | 7-9 dims: UI testing, E2E, edge cases, accessibility | Security testing may be lighter |
| deprecation | 5-7 dims: regression, coverage (remove deprecated tests?), edge cases | What tests need updating? |
| devops-tooling | 4-6 dims: automation, environment, integration | UI/E2E testing may be N/A |

**How to update the plan:**
- Add a test strategy section if missing
- Add specific test cases for critical paths
- Add coverage targets per component/layer
- Add edge cases and boundary conditions
- Add performance benchmarks and load test plans where applicable
- Add security test scenarios where applicable
- Add test environment setup requirements
