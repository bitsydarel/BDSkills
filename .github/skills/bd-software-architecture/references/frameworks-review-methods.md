# Architecture review methods

Foundational guidance for conducting effective architecture reviews: the critical role of "why," root cause analysis techniques, and reviewer best practices. For specific review methodologies (SARM, ARID, SARB, tactics-based questionnaires, performance/fault modeling), see [frameworks-review-specialized-methods.md](frameworks-review-specialized-methods.md).

## The power of "Why"

### The Second Law of Software Architecture

> "Why is more important than how."

Code reveals *how* a system is structured. The reviewer's job is to uncover and evaluate *why*. Without "why":
- Teams re-debate settled decisions (the Groundhog Day anti-pattern)
- Constraints are forgotten and violated
- Architecture evolves without direction
- New team members guess at intent and guess wrong

### The Five Whys technique

Adapted from the Toyota Production System for root cause analysis. When an architectural issue is found, ask "why" repeatedly to reach the root cause.

**Example**:
```
Finding: Tests take 8 minutes to run.
Why? → Tests require database setup and teardown.
Why? → Use cases instantiate database connections directly.
Why? → No repository interfaces exist — use cases call ORM models.
Why? → The original team followed the framework's tutorial pattern.
Why? → No architecture decision was made about dependency direction.

Root cause: Missing architectural decision about dependency direction (S3 → D1 → Q1).
```

Without Five Whys, the team might "fix" slow tests by parallelizing test execution — treating the symptom, not the cause. The architectural fix is introducing repository interfaces (D2), which makes tests fast (Q1) and makes the system modifiable (Q2).

### Uncovering true business intent

Requirements often encode *how* instead of *why*. The reviewer must dig deeper.

**Classic example (adapted from SEI literature)**:
- Stated requirement: "The system must respond in under 100ms."
- Five Whys reveals: The real need is that traders make decisions in real-time. The 100ms target is an assumption, not a measured need. The actual constraint is "faster than the trader's decision cycle" — which might be 500ms.

This matters architecturally: designing for 100ms might require in-memory caching and denormalized storage (trading consistency for speed). Designing for 500ms allows a simpler architecture with fewer tradeoffs.

**Reviewer practice**: When a non-functional requirement drives an architectural decision, ask: "What happens if this constraint is relaxed by 2x? By 10x?" The answer reveals whether the architecture is over-constrained.

### GQM (Goal-Question-Metric) for observability

When evaluating Q4 (Observability), apply the GQM approach:

**Goal**: What do you need to know about the system's behavior?
- Example: "We need to know when order processing slows down."

**Question**: What questions would answer whether the goal is met?
- "What is the 95th percentile latency for order processing?"
- "Which step in the pipeline is the bottleneck?"

**Metric**: What measurements answer those questions?
- Timer on each pipeline step
- Histogram of end-to-end processing time
- Alert when p95 exceeds threshold

If the architecture does not support collecting these metrics (no instrumentation points at boundaries, no structured logging), then Q4 scores low regardless of intent.

## Reviewer best practices

### The architect as friendly interrogator

The reviewer's role is not to approve or reject — it is to **surface hidden risks, make tradeoffs explicit, and ensure decisions are intentional**. The most valuable review question is always "why."

### Best practices checklist

1. **Always ask "why"** — For every architectural decision, ask why this approach was chosen over alternatives. If the answer is "because the framework does it this way" or "because we always do it this way," probe deeper.

2. **Request ADRs** — If significant decisions are not documented, ask for ADRs before completing the review. Undocumented decisions will be re-debated (Groundhog Day anti-pattern).

3. **Ensure stakeholder representation** — Architecture reviews without product, operations, and security perspectives miss critical quality attributes. At minimum, ask: "Has this been reviewed by ops?" and "Has security seen this?"

4. **Validate tradeoffs against business priorities** — Every tradeoff should align with business priorities. A startup optimizing for reliability over speed-to-market may be making the wrong tradeoff. A healthcare system optimizing for speed over reliability definitely is.

5. **Uncover true requirements vs assumed constraints** — Use Five Whys on non-functional requirements. Many "hard requirements" are actually assumptions that can be relaxed.

6. **Look for missing alternatives** — A good decision considers at least 2 alternatives. If only one approach was considered, the decision may be premature. Ask: "What other approaches did you consider?"

7. **Check for reversibility** — Distinguish between one-way door decisions (hard to reverse: database choice, service decomposition) and two-way door decisions (easy to reverse: naming conventions, configuration). Apply more scrutiny to one-way doors.

8. **Evaluate for the current stage** — A startup's architecture has different needs than an enterprise system. Score within the appropriate system complexity classification (see [evaluation-scoring.md](evaluation-scoring.md)).

## Method selection guide

| Context | Recommended Method | Time Investment |
|---------|-------------------|:---:|
| System-wide architecture evaluation | Full ATAM | 2-3 days |
| Feature-level architecture review | Lightweight ATAM | Half day |
| Comparing multiple solutions | SARM + CBAM | 1-2 days |
| Validating a partial design | ARID | 2-4 hours |
| Organization-wide governance | SARB | Ongoing |
| Rapid quality attribute check | Tactics-based questionnaire | 1-2 hours |
| Pre-implementation performance assessment | Performance/fault modeling | Half day |
| Any review | Five Whys + GQM | Integrated into review |
