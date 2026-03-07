# Evaluation: Quality Attributes (Lens 4)

Scoring rubric for criteria Q1-Q4. Maps to ISO 25010 quality characteristics (Maintainability, Reliability, Performance Efficiency, Flexibility) and integrates ATAM quality attribute utility tree concepts, AWS/Azure Well-Architected reliability and performance pillars, and Netflix resilience patterns. Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## Q1: Testability

**What it evaluates**: Whether every component can be tested in isolation through architectural decoupling (dependency injection, module boundaries, factory functions, or equivalent mechanism for the technology context). No test should require running a database, network, or framework to verify business logic. Testability is a direct consequence of proper dependency inversion — if the architecture is clean, components are testable by design.

*Maps to ISO 25010: Maintainability (Testability sub-characteristic)*

### Proposal questions
- Does the design specify how components will be tested in isolation?
- Is there a decoupling strategy for all cross-boundary interactions?
- Are there components that will require full framework boot to test?
- Does the design identify which components need integration vs unit testing?

### Implementation-compliance questions
- Can each use case be tested with mock/fake implementations of its dependencies?
- Do unit tests require database, network, or framework setup?
- Are test doubles (mocks, fakes, stubs) created from interfaces, not concrete classes?
- Is there a composition point (DI container, module wiring, factory setup) that assembles concrete implementations?

### Implementation-results questions
- What percentage of business logic is covered by fast, isolated unit tests?
- How long does the unit test suite take to run (excluding integration tests)?
- When a test fails, does it pinpoint the failing component or require investigation across multiple components?
- Can new features be tested before their infrastructure layer is implemented?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every component testable in isolation via the chosen decoupling mechanism. Unit tests require zero infrastructure. Test doubles created from contracts/interfaces. Test suite runs in seconds. New features testable before infrastructure exists. Test failure pinpoints the exact component |
| 4 | Most components testable in isolation. Unit tests run without infrastructure for business logic. One or two components require light framework setup (e.g., DI container initialization). Test suite runs quickly |
| 3 | Business logic mostly testable but some components require partial infrastructure (e.g., in-memory database, HTTP test server). Some tests are slow due to framework boot. Most test failures are diagnosable |
| 2 | Testing requires significant infrastructure setup. Many tests need database, network mocks, or full framework boot. Test suite is slow. Test failures often indicate problems in infrastructure rather than business logic |
| 1 | Components cannot be tested in isolation. All tests are integration tests requiring full system running. Test suite takes minutes or is not run regularly. Developers skip testing because setup is too complex |

---

## Q2: Modifiability & Change Isolation

**What it evaluates**: Whether changes to a data source, UI framework, or external API are contained within one module. The blast radius of a change should be predictable — a developer should know which files will change before making the modification.

*Maps to ISO 25010: Maintainability (Modifiability sub-characteristic), Flexibility*

### Proposal questions
- Does the design identify the expected blast radius for common change types?
- Are likely areas of change (volatile components) isolated behind stable interfaces?
- Can the UI framework, database, or API client be swapped without affecting business logic?

### Implementation-compliance questions
- When changing a data source implementation, do files outside the data source layer need modification?
- When changing the UI framework, do use cases or domain models need modification?
- Are configuration changes (endpoints, connection strings) isolated to configuration files?
- Is the module dependency structure such that low-coupling is maintained between features?

### Implementation-results questions
- In the last 5 significant changes, how many files were modified per change?
- Have there been cases where a "simple" change cascaded across multiple layers or features?
- Can you predict which files will change for a given requirement modification?
- How does the team assess blast radius before making changes?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Changes are highly contained. Swapping a database, API client, or UI framework affects only adapter layers. Blast radius is predictable and documented. Average change touches 1-3 files within a single layer. Teams estimate change scope accurately |
| 4 | Changes mostly contained within one layer or feature. Swapping major components would affect only the adapter layer plus DI configuration. Average change touches 2-5 files. Occasional minor cascade to adjacent layers |
| 3 | Changes are reasonably contained for common modifications but some changes cascade across layers. Swapping a major component would require changes in 2-3 layers. Average change touches 3-8 files. Blast radius is sometimes surprising |
| 2 | Changes regularly cascade across layers and features. Swapping any component requires widespread modifications. Average change touches many files across multiple layers. Teams cannot reliably predict change scope |
| 1 | Every change cascades everywhere. No isolation between components. A database schema change requires UI modifications. Modifying one feature breaks unrelated features. Change scope is unpredictable. Every modification feels like a rewrite |

---

## Q3: Scalability & Performance Design

**What it evaluates**: Whether the architecture supports horizontal scaling where needed, performance-critical paths are identified, and bottlenecks can be addressed without restructuring the entire system. This is about architectural readiness for performance, not premature optimization.

*Maps to ISO 25010: Performance Efficiency. Integrates AWS Well-Architected Performance Efficiency pillar and Netflix resilience patterns (Circuit Breaker, Bulkhead, Fallback, Timeout).*

### Proposal questions
- Does the design identify performance-critical paths and expected load patterns?
- Are stateful components identified and their scaling strategy documented?
- Does the architecture allow horizontal scaling of bottleneck components?
- Are caching, connection pooling, or async processing strategies specified where needed?

### Implementation-compliance questions
- Are performance-critical paths optimized (efficient queries, appropriate caching, connection pooling)?
- Are stateless components separated from stateful ones to enable independent scaling?
- Are there architectural bottlenecks (shared singleton, synchronous chains) that would prevent scaling?
- Are resilience patterns (circuit breakers, timeouts, fallbacks) implemented for external dependencies?

### Implementation-results questions
- Can the system handle expected peak load without architectural changes?
- Are there performance budgets or SLOs for critical paths?
- Have bottlenecks been identified through profiling or load testing?
- When adding load, does performance degrade gracefully or catastrophically?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Performance-critical paths identified, budgeted, and measured. Architecture supports horizontal scaling. Resilience patterns (circuit breakers, timeouts, fallbacks) implemented for external dependencies. Load testing validates architecture under expected peak. Bottlenecks addressable without restructuring |
| 4 | Key performance paths identified. Architecture supports scaling for known bottlenecks. Caching and async processing used appropriately. No architectural impediments to scaling. Some load testing performed |
| 3 | Basic scalability considered. Some caching and async processing. Architecture mostly supports scaling but one or two architectural bottlenecks exist (e.g., synchronous call chain, shared state). No systematic performance testing |
| 2 | Scalability not systematically addressed. Architectural bottlenecks exist (single database, synchronous everything, monolithic deployment). Performance problems would require architectural changes to resolve |
| 1 | Architecture prevents scaling. Everything is synchronous, stateful, and monolithic. No caching strategy. External dependencies called without timeouts or fallbacks. Performance problems require rewrite, not refactoring |

---

## Q4: Observability & Debuggability

**What it evaluates**: Whether the architecture supports logging, tracing, and monitoring at boundary crossings. Errors should be traceable from symptom (user-facing error) to root cause (infrastructure failure) across layers without reading unrelated code.

*Maps to ISO 25010: Maintainability (Analysability sub-characteristic). Integrates GQM (Goal-Question-Metric) approach for structured observability.*

### Proposal questions
- Does the design specify logging, tracing, or monitoring strategies at layer boundaries?
- Are correlation IDs or request tracing planned for cross-layer debugging?
- Does the design identify which metrics and events need to be observable?
- Is there a strategy for structured logging that captures context at each boundary?

### Implementation-compliance questions
- Is logging implemented at key boundary crossings (API entry, data source calls, external service interactions)?
- Are correlation IDs or trace IDs propagated across layers?
- Do logs include enough context to trace a request from entry to exit?
- Are errors logged with sufficient context for root cause analysis?

### Implementation-results questions
- When a user reports an error, can the team trace it to the root cause using logs/traces alone?
- Are there "black box" layers where data enters but events are not observable?
- How quickly can the team identify whether a failure is in presentation, business logic, or infrastructure?
- Are alerting and monitoring in place for architectural health metrics (error rates, latency by layer, dependency failures)?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Comprehensive observability. Structured logging at all boundary crossings. Distributed tracing with correlation IDs. Errors traceable from symptom to root cause. Metrics dashboards show per-layer health. Alerting on architectural degradation (increasing cross-layer errors, latency spikes). GQM-informed metric selection |
| 4 | Good observability. Logging at key boundaries. Trace IDs for request correlation. Most errors traceable within minutes. Monitoring covers primary health metrics. Some gaps in non-critical paths |
| 3 | Basic observability. Logging present but inconsistent across layers. Some correlation capability but not systematic. Errors usually traceable but sometimes require code reading to diagnose. Limited monitoring |
| 2 | Minimal observability. Logging scattered and unstructured. No correlation IDs. Diagnosing errors requires reading code and reproducing issues. No monitoring beyond basic uptime checks |
| 1 | No observability. No structured logging. No tracing. Errors produce stack traces with no business context. Debugging requires stepping through code with a debugger. No monitoring. Teams discover failures when users complain |
