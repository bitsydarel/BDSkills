# CBAM (Cost Benefit Analysis Method)

An extension of ATAM that adds economic analysis to architecture decisions. CBAM quantifies the ROI of architectural strategies. For ATAM methodology (scenario-based architecture evaluation), see [frameworks-atam.md](frameworks-atam.md).

## When to use CBAM
- Multiple architectural approaches are viable and the team needs to choose
- Budget constraints require prioritizing architectural improvements
- Stakeholders need business justification for architecture investments

## CBAM process

**Step 1: Collate scenarios from ATAM**
- Use the prioritized scenarios from ATAM (or Lightweight ATAM)
- Add cost estimates for implementing each architectural strategy

**Step 2: Assess quality attribute benefits**
- For each scenario, estimate the benefit of each architectural strategy using a utility scale
- Benefit = expected improvement in quality attribute response

**Step 3: Quantify costs**
- Estimate implementation cost for each strategy (developer-days, infrastructure cost, opportunity cost)
- Include ongoing maintenance cost

**Step 4: Calculate ROI**
```
ROI = (Total Benefit × Weight) / Total Cost
```
- Weight reflects the scenario's business priority (from ATAM utility tree)
- Rank strategies by ROI — highest ROI strategies are recommended first

**Step 5: Select strategies within budget**
- Given a budget constraint, select the combination of strategies that maximizes total benefit
- Document the rationale: which strategies were selected, which deferred, and why

## CBAM integration with evaluation lenses

CBAM findings inform several criteria:
- **S3 (ADRs)**: CBAM provides structured rationale for architecture decisions — document as ADRs
- **Q3 (Scalability)**: Cost-benefit analysis of scaling strategies (horizontal vs vertical, caching layers)
- **S4 (Evolutionary Readiness)**: CBAM can evaluate the cost of future extensibility vs. current simplicity

## Integration with the evaluation framework

### Using ATAM and CBAM concepts during lens evaluation

You do not need to run a formal ATAM or CBAM to benefit from their concepts. Apply these questions during any architecture review:

**When scoring D2 (Abstraction at Boundaries)**:
- "If we changed the database, which components would be affected?" (sensitivity analysis)
- "Is there a tradeoff between abstraction overhead and performance here?" (tradeoff identification)

**When scoring Q2 (Modifiability)**:
- "What is the blast radius of changing this component?" (sensitivity analysis)
- "Adding this abstraction improves modifiability but adds indirection — is the tradeoff documented?" (tradeoff documentation)

**When scoring Q3 (Scalability)**:
- Build a mini utility tree for performance scenarios
- Trace each scenario through the architecture to identify bottlenecks

**When scoring S3 (ADRs)**:
- Are tradeoff points documented? A good ADR captures what was traded, not just what was chosen.
- Do ADRs reference the quality attributes affected?

### Quality attribute utility tree template

When reviewing, construct a lightweight utility tree focused on the lenses:

```
Quality Attributes
├── Testability (Q1)
│   └── "Can a new use case be tested without database/network?"
├── Modifiability (Q2)
│   └── "Can the data source be replaced by changing one module?"
├── Scalability (Q3)
│   └── "Can the system handle 10x current load with infrastructure changes only?"
├── Observability (Q4)
│   └── "Can a production error be traced from symptom to root cause?"
└── Evolvability (S4)
    └── "Can a new feature be added by extending, not modifying, existing modules?"
```

Rate each scenario (Importance, Difficulty), then trace through the architecture to assess whether the structure supports it.
