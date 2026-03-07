# Specialized architecture review methods

Detailed guidance for specific review methodologies: SARM, ARID, SARB, tactics-based questionnaires, and performance/fault modeling. For foundational review guidance (Five Whys, GQM, reviewer best practices), see [frameworks-review-methods.md](frameworks-review-methods.md).

## SARM (Solution Architecture Review Method)

A method focused on mapping candidate solutions to stakeholder interests through risk-impact analysis.

### When to use
- Comparing two or more architectural approaches
- Early-stage design where multiple solutions are viable
- Reviews where different stakeholders have conflicting priorities

### Process

**Step 1: Identify stakeholders and their interests**
```
| Stakeholder | Primary Interest | Key Concern |
|-------------|-----------------|-------------|
| Product Owner | Time to market | Will this slow down feature delivery? |
| Operations | Reliability | Can we monitor and recover from failures? |
| Security | Data protection | Does this introduce new attack surfaces? |
| Development | Maintainability | Can we understand and modify this? |
```

**Step 2: Map solutions to interests**
For each candidate solution, assess impact on each stakeholder interest:
```
| Interest          | Solution A (Monolith) | Solution B (Microservices) |
|-------------------|-----------------------|---------------------------|
| Time to market    | High (simpler deploy) | Low (infra setup needed)  |
| Reliability       | Medium (single point) | High (isolated failures)  |
| Data protection   | Medium (single perimeter) | Low (many surfaces)  |
| Maintainability   | Medium (growing codebase) | High (small codebases)|
```

**Step 3: Risk-impact classification**
- Identify risks for each solution
- Map risk to stakeholder impact
- Prioritize risks by stakeholder weight

### Integration with evaluation lenses
- SARM stakeholder mapping informs lens weighting — if reliability is the top stakeholder concern, Q3 and Q4 carry more weight
- Risk-impact matrix entries map directly to findings in the review output

## ARID (Active Reviews for Intermediate Designs)

A method for validating partial designs through engineer scenario solving. Unlike ATAM (which reviews complete architectures), ARID evaluates designs that are still in progress.

### When to use
- Mid-sprint architecture decisions that need quick validation
- API design reviews before implementation begins
- Module interface design before feature development
- Design spikes that need team validation

### Process

**Step 1: Present the intermediate design**
- Show the partial design (API contract, module interface, data model)
- State what is decided and what is still open

**Step 2: Engineers solve scenarios using the design**
- Give engineers concrete scenarios to solve using only the presented design
- Example: "Using this API, show me how you would implement the 'cancel order' workflow."
- Example: "Using these module interfaces, show me how you would add a new notification channel."

**Step 3: Identify design gaps**
- Where engineers struggle or make incorrect assumptions → the design is ambiguous
- Where engineers cannot solve the scenario → the design is incomplete
- Where engineers solve it differently → the design allows unintended interpretations

**Key value**: ARID tests the design's *usability for developers* — not just its theoretical correctness. A design that engineers cannot use correctly is a design that will be violated.

### Integration with evaluation lenses
- ARID findings inform C4 (Public API) — if engineers misuse the public API during ARID, the API is poorly designed
- ARID findings inform Q2 (Modifiability) — if adding a feature using the design is painful, the architecture resists change
- ARID findings inform S4 (Evolutionary Readiness) — if the design cannot accommodate the test scenarios, it is not extensible

## SARB (Software Architecture Review Board)

A structured review leveraging domain experts for governance of architecture decisions.

### When to use
- Organization-wide architecture standards need enforcement
- Cross-team architecture decisions (shared services, platform changes)
- Architecture decisions with long-term strategic impact
- Compliance-driven environments (finance, healthcare, government)

### Structure

**Board composition**:
- Lead architect (facilitator)
- Domain experts relevant to the decision
- Representatives from affected teams
- Optional: operations, security, product stakeholders

**Review agenda**:
1. Architect presents the decision, context, and alternatives considered
2. Board asks clarifying questions (focus on "why")
3. Board evaluates against architecture principles and standards
4. Board provides verdict: Approve, Approve with Conditions, Defer, Reject
5. Decision and rationale documented as ADR

**Key governance question**: "How does this decision align with our architecture principles?"

### Integration with evaluation lenses
- SARB decisions should produce ADRs → S3 (Architecture Decision Records)
- SARB standards inform S1 (Physical Enforcement) — board-mandated rules should be automated
- SARB governance prevents architectural drift → S4 (Evolutionary Readiness)

## Tactics-based questionnaires

Pre-defined checklists that translate architectural tactics into review questions. Useful for rapid assessment without full scenario analysis.

### What are architectural tactics?

Tactics are design decisions that influence the response of a quality attribute. They are more specific than architectural patterns but more general than design patterns.

### Example questionnaire: Modifiability tactics

| Tactic | Question | Lens Criterion |
|--------|----------|---------------|
| **Encapsulate** | Are implementation details hidden behind interfaces? | D2, C4 |
| **Use an intermediary** | Is there an abstraction layer between consumers and providers? | D2 |
| **Restrict dependencies** | Does each module depend only on what it needs? | D4, B4 |
| **Defer binding** | Can configuration change without code changes? | S4 |
| **Abstract common services** | Are shared capabilities behind stable interfaces? | C3, D5 |

### Example questionnaire: Testability tactics

| Tactic | Question | Lens Criterion |
|--------|----------|---------------|
| **Separate interface from implementation** | Can components be tested through interfaces with mock implementations? | Q1, D2 |
| **Limit complexity** | Are components small enough to test in isolation? | C1, Q1 |
| **Limit nondeterminism** | Can tests run without external dependencies (network, time, random)? | Q1, D3 |
| **Record/playback** | Can interactions be captured and replayed for debugging? | Q4 |

### Example questionnaire: Performance tactics

| Tactic | Question | Lens Criterion |
|--------|----------|---------------|
| **Manage resources** | Is the system right-sized? Are thread pools and connection pools configured? | Q3 |
| **Control frequency** | Are high-frequency operations batched or debounced? | Q3 |
| **Manage sampling rate** | Is monitoring configured to balance insight with overhead? | Q4 |
| **Prioritize events** | Are critical-path operations prioritized over background tasks? | Q3 |
| **Reduce overhead** | Is unnecessary computation avoided (lazy loading, caching)? | Q3 |

## Performance and fault modeling

Simulation-based methods for estimating system behavior before implementation.

### Performance modeling

**When to use**: Evaluating Q3 (Scalability) for systems where load testing is not yet feasible (pre-implementation or proposal review).

**Approach**:
1. Model the system as a queuing network (requests arrive → processed → respond)
2. Identify bottlenecks: which component has the lowest throughput?
3. Calculate theoretical maximum throughput: `min(component_throughput_i)`
4. Estimate response time under load using Little's Law: `L = λ × W` (items in system = arrival rate × wait time)

**Reviewer application**: When scoring Q3, ask:
- "Has the team modeled the expected throughput?"
- "Where is the theoretical bottleneck?"
- "What happens when arrival rate exceeds processing rate?"

### Fault modeling

**When to use**: Evaluating Q3 resilience and B3 error handling.

**Approach**:
1. List all external dependencies (databases, APIs, message queues, caches)
2. For each dependency, identify failure modes: unavailable, slow, returning errors, returning corrupt data
3. Trace each failure mode through the architecture: what happens to the user?
4. Identify cascading failure paths: does one failure trigger others?

**Reviewer application**: When scoring B3 and Q3, ask:
- "What happens when [external dependency] is unavailable for 5 minutes?"
- "Does the architecture have circuit breakers or fallback responses?"
- "Can a single dependency failure cascade to affect unrelated features?"
