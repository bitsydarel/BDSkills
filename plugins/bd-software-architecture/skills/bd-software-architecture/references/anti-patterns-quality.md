# Anti-patterns: Quality Attributes (Lens 4)

Architecture failure modes related to testability, modifiability, performance design, and observability. Each pattern includes Signs, Impact, Fix, and Detection guidance.

---

## Untestable Architecture [Critical]

The architecture makes it impossible or impractical to test components in isolation. Business logic cannot be verified without running databases, networks, or frameworks. Tests are slow, flaky, and rarely run.

**Signs**:
- No unit tests exist — only integration or end-to-end tests
- Tests require database setup, HTTP servers, or framework boot to verify business logic
- Test suite takes minutes (or longer) to run
- Developers skip tests because setup is too complex or execution is too slow
- Test failures are intermittent (flaky) due to infrastructure dependencies
- Components instantiate their own dependencies — no dependency injection
- Mocking is impossible because dependencies are concrete classes, not interfaces

**Impact**:
- Business logic is unverified — bugs reach production without detection
- Feedback loop is slow — developers wait minutes for test results
- Confidence in changes is low — developers avoid refactoring because they cannot verify correctness
- Test coverage metrics are misleading — integration tests may cover code paths without verifying business logic
- Regression detection is unreliable

**Fix**:
- Introduce dependency injection at all cross-layer boundaries
- Define interfaces/contracts for all data sources and external dependencies
- Write unit tests that use mock/fake implementations — no infrastructure required
- Separate integration tests (verify wiring) from unit tests (verify logic)
- Target: business logic testable with fast, isolated unit tests that run in seconds

**Detection**:
- Measure: can each use case be tested without any infrastructure setup?
- Check test run time: if the full suite takes >30 seconds, investigate infrastructure dependencies in unit tests
- Count the ratio of unit tests to integration tests — if all tests are integration tests, the architecture is untestable
- Attempt to instantiate a use case in a test with only mock dependencies — if it fails, DI is missing

---

## Observability Blind Spots [Major]

Parts of the system operate without logging, tracing, or monitoring. When failures occur in these areas, debugging requires reading source code and reproducing the issue rather than analyzing telemetry.

**Signs**:
- Some layers or components have no logging at all
- Error-prone areas (external API calls, database operations, authentication flows) have no monitoring
- When a production issue occurs, the team cannot determine which component failed without code inspection
- No correlation IDs or trace IDs — request flow cannot be followed across components
- Alerting is based only on uptime, not on business or architectural health metrics
- "It works on my machine" — issues only reproducible in production due to missing observability

**Impact**:
- Mean time to detection (MTTD) is long — failures discovered by users, not monitoring
- Mean time to resolution (MTTR) is long — root cause analysis requires code reading and reproduction
- Silent failures accumulate — partial data loss or degraded service goes undetected
- Performance degradation is invisible until users complain
- Post-incident analysis is guesswork without telemetry

**Fix**:
- Add structured logging at all boundary crossings (API entry/exit, data source calls, external service interactions)
- Implement correlation IDs that propagate through all layers
- Define key health metrics per layer: error rates, latency percentiles, throughput
- Set up alerting on architectural health indicators (not just uptime)
- Use the GQM (Goal-Question-Metric) approach: for each business goal, define questions, then define metrics that answer them

**Detection**:
- Simulate a failure in each layer — can the team diagnose it from logs/metrics alone?
- Review logging coverage: are all data source calls, external service calls, and error paths logged?
- Check for correlation ID propagation — does a request ID appear in logs from entry to exit?
- Ask: "If this external service starts returning errors, how quickly would we know?"

---

## Premature Optimization [Minor]

Architecture designed around performance assumptions before measuring actual bottlenecks. Adds complexity (caching layers, async processing, micro-optimizations) without evidence of need. Optimization decisions are not data-driven.

**Signs**:
- Complex caching infrastructure added before any performance measurement
- Asynchronous processing patterns used everywhere, even for simple synchronous operations
- Architecture documents discuss performance optimization without load testing results or performance budgets
- Code comments reference performance concerns with no supporting data ("this is faster because...")
- Custom data structures or algorithms used where standard library alternatives would suffice
- Microservices decomposition driven by speculative performance concerns rather than domain boundaries

**Impact**:
- Unnecessary complexity increases maintenance cost and cognitive load
- Code is harder to understand, debug, and modify
- Actual performance bottlenecks may be elsewhere — optimization effort is wasted
- Premature caching can introduce consistency bugs that are harder to find than the performance problem they prevent
- Over-engineered solutions resist change when requirements evolve

**Fix**:
- Establish performance budgets based on requirements and user expectations
- Measure before optimizing — profile production workloads to identify actual bottlenecks
- Optimize the bottleneck identified by measurement, not the one imagined
- Document performance decisions in ADRs with supporting data
- Keep the simple solution until measurement proves it insufficient

**Detection**:
- Review architecture for optimization patterns (caching, async, custom data structures) — is there measurement data supporting each one?
- Check ADRs: do performance decisions reference profiling data or assumptions?
- Ask: "What measurement showed this was a bottleneck?" If the answer is "it seemed like it might be," it is premature optimization

---

## Missing Performance Budget [Major]

No defined performance targets or SLOs for critical paths. The architecture cannot be evaluated for performance fitness because there is no baseline. Performance problems are discovered by users, not by measurement.

**Signs**:
- No response time targets for critical user operations
- No load testing or performance benchmarks
- Performance is evaluated subjectively ("it feels fast enough")
- Performance regressions discovered by users, not by CI/CD or monitoring
- No latency tracking at architectural boundaries
- Architecture decisions reference "fast" or "performant" without quantified targets

**Impact**:
- Performance regressions slip through undetected until users complain
- Architecture tradeoffs cannot be evaluated objectively — no baseline to compare against
- Scaling decisions are reactive (after problems) rather than proactive (before growth)
- SLA commitments are risky because internal SLOs do not exist
- Performance optimization has no success criteria — when is it "fast enough"?

**Fix**:
- Define performance budgets for critical paths: target response time at p50, p95, p99
- Implement performance tracking at architectural boundaries (API entry, data source calls)
- Add performance assertions to CI/CD (e.g., build time budget, critical path latency budget)
- Establish SLOs for key operations and track compliance
- Use architecture fitness functions for performance: automated checks that fail when budgets are exceeded

**Detection**:
- Ask: "What is the acceptable response time for the most critical user operation?" If there is no answer, there is no performance budget
- Check CI/CD: are there performance-related checks or benchmarks?
- Review monitoring: are latency percentiles tracked for critical paths?
- Look for performance targets in requirements or ADRs

---

## Tight Coupling to Test Doubles [Minor]

Tests are written against specific mock/stub implementations rather than against the component's contract. Tests break when the implementation changes even though behavior is correct. Tests verify interactions instead of outcomes.

**Signs**:
- Tests verify the order or number of method calls on mocks (`verify(mock.method(), times: 3)`)
- Changing the implementation of a component breaks its tests even though behavior is unchanged
- Tests contain extensive mock setup that mirrors the implementation step by step
- Tests fail when refactoring internal implementation details
- Test names describe implementation steps rather than business outcomes ("should call repository then service then mapper")

**Impact**:
- Tests resist refactoring — developers avoid improving code because tests will break
- Tests are brittle — any implementation change requires updating test setup
- Tests verify the *how* (implementation) rather than the *what* (behavior/outcome)
- False confidence — tests pass because they mirror the implementation, not because they verify correctness
- Maintenance cost of tests is disproportionately high

**Fix**:
- Test behavior/outcomes rather than interactions: assert on return values, state changes, and side effects
- Use fakes (simple in-memory implementations) over mocks where practical
- Avoid verifying method call counts or order unless the order is a business requirement
- Test names should describe business outcomes: "should return authenticated user when credentials are valid"
- When a test breaks after refactoring, ask: "Did the behavior change?" If not, the test was coupled to implementation

**Detection**:
- Search tests for `verify(`, `times:`, `inOrder` — excessive interaction verification indicates coupling
- Count test breakages during refactoring: if behavior-preserving refactoring breaks many tests, coupling is high
- Review test names: do they describe business outcomes or implementation steps?
