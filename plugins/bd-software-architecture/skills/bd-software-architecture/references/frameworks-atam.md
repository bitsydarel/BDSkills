# Architecture Tradeoff Analysis Method (ATAM)

Scenario-based architecture evaluation methodology developed by the Software Engineering Institute (SEI) at Carnegie Mellon University. ATAM systematically identifies tradeoff points and risks in architecture decisions. Load this file when performing in-depth quality attribute analysis or when evaluating architectural tradeoffs.

## Overview

ATAM evaluates architecture by:
1. Understanding the business drivers and quality attribute requirements
2. Analyzing the architecture's response to specific scenarios
3. Identifying sensitivity points (where a small change affects one quality attribute)
4. Identifying tradeoff points (where a decision affects multiple quality attributes in opposing ways)
5. Classifying risks and non-risks based on analysis

**Key value**: ATAM does not produce a single score — it surfaces the *tradeoffs* inherent in the architecture. Every architecture decision trades off one quality for another. ATAM makes these tradeoffs explicit.

## Full ATAM process (9 steps)

### Phase 1: Presentation

**Step 1: Present ATAM**
- Explain the method to stakeholders
- Set expectations: ATAM evaluates the architecture, not the implementation or the team

**Step 2: Present business drivers**
- System context, business goals, quality attribute requirements
- Who are the primary stakeholders? What does success look like?
- Key output: **business driver document** listing prioritized goals

**Step 3: Present architecture**
- The architect presents the current or proposed architecture
- Focus on how the architecture addresses the business drivers
- Include: component diagram, deployment view, data flow, key technology choices

### Phase 2: Investigation and analysis

**Step 4: Identify architectural approaches**
- Catalog the architectural patterns and tactics used
- Examples: layered architecture, event-driven messaging, caching strategy, authentication approach
- Map each approach to the quality attributes it intends to address

**Step 5: Generate quality attribute utility tree**

The utility tree is ATAM's central artifact. It breaks "quality" into specific, testable scenarios.

```
Quality Attributes
├── Performance
│   ├── Latency
│   │   ├── (H,H) Search returns results in <200ms under normal load
│   │   └── (M,H) Report generation completes in <5s for datasets up to 1M rows
│   └── Throughput
│       └── (H,M) System handles 10,000 concurrent API requests
├── Modifiability
│   ├── New Feature
│   │   ├── (H,H) Adding a new payment provider takes <2 developer-days
│   │   └── (M,M) Adding a new report type takes <1 developer-day
│   └── Technology Change
│       └── (H,H) Replacing the database engine requires changes in <5 files
├── Availability
│   ├── Fault Tolerance
│   │   ├── (H,H) System remains operational when one service instance fails
│   │   └── (M,L) System degrades gracefully when external payment API is down
│   └── Recovery
│       └── (H,M) System recovers from database failover in <30 seconds
└── Security
    └── (Handled by bd-security-review skill)
```

Each scenario is rated (Importance, Difficulty): H=High, M=Medium, L=Low. High-importance, high-difficulty scenarios are analyzed first — these are the most architecturally significant.

**Step 6: Analyze architectural approaches**

For each high-priority scenario from the utility tree:
1. Trace the scenario through the architecture
2. Identify which architectural decisions affect the response
3. Classify the decision as:
   - **Risk**: A decision that may not achieve the quality attribute goal
   - **Non-risk**: A decision that is well-supported by the architecture
   - **Sensitivity point**: A parameter where small changes significantly affect a quality attribute
   - **Tradeoff point**: A decision that affects two or more quality attributes in opposing directions

**Example sensitivity point**: Cache TTL. Setting it to 5 seconds improves data freshness but increases database load. Setting it to 5 minutes reduces load but serves stale data. The TTL is a sensitivity point for both performance and data consistency.

**Example tradeoff point**: Adding an event queue between services improves availability (messages survive service restarts) and loose coupling (services don't need to be up simultaneously), but trades off consistency (events are eventually consistent) and debuggability (async flows are harder to trace).

### Phase 3: Testing and reporting

**Step 7: Brainstorm and prioritize scenarios**
- Stakeholders generate additional scenarios beyond the utility tree
- Vote to prioritize — compare with utility tree priorities
- New high-priority scenarios that were not in the utility tree indicate a gap in the architecture presentation

**Step 8: Analyze architectural approaches (continued)**
- Apply Step 6 analysis to the newly prioritized scenarios

**Step 9: Present results**
- Catalog of risks, non-risks, sensitivity points, and tradeoff points
- Mapping of architectural approaches to quality attributes
- Prioritized list of architecturally significant decisions

## Lightweight ATAM

A condensed version for agile and iterative contexts. Takes a half-day peer review instead of the full multi-day stakeholder process.

### When to use Lightweight ATAM
- Agile teams evaluating architecture at sprint boundaries
- Architecture reviews within a single team (no external stakeholders)
- Feature-level architecture decisions (not system-wide)
- Time-constrained reviews where full ATAM is impractical

### Lightweight ATAM process (4 steps)

**Step 1: Identify key quality attributes (30 min)**
- Select 3-5 quality attributes most relevant to the feature/change
- Write 2-3 concrete scenarios per attribute using the (Importance, Difficulty) format

**Step 2: Present architecture decisions (30 min)**
- Architect presents key decisions and their rationale
- Focus on decisions that affect the selected quality attributes

**Step 3: Analyze tradeoffs (60-90 min)**
- Trace each high-priority scenario through the architecture
- Identify sensitivity points and tradeoff points
- Classify as risk or non-risk

**Step 4: Document findings (30 min)**
- Record risks, tradeoff points, and recommended mitigations
- Output: Lightweight ATAM findings document or ADR addendum

### Lightweight ATAM integration with evaluation lenses

| Lightweight ATAM Output | Maps To |
|------------------------|---------|
| Sensitivity points identified | Q2 (Modifiability) — which changes have outsized impact? |
| Tradeoff points documented | S3 (ADRs) — are tradeoffs documented with rationale? |
| Risks classified | Q3 (Scalability/Performance) — are performance risks acknowledged? |
| Quality attribute scenarios | Q1-Q4 — does the architecture address its stated quality goals? |

For economic analysis of architecture decisions (CBAM), integration with evaluation lenses, and quality attribute utility tree templates, see [frameworks-cbam.md](frameworks-cbam.md).
