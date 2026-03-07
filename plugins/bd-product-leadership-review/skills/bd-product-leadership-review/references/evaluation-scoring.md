# Scoring Framework

Scoring scale, verdict thresholds, weighting guide, and critical rules for product leadership reviews.

## Scoring Scale

| Score | Meaning | Decision Aid |
|-------|---------|--------------|
| 5 | Strong evidence this dimension is addressed | Multiple validated signals; no material gaps |
| 4 | Good evidence with minor gaps | Core evidence present; 1-2 areas could be stronger |
| 3 | Some evidence but significant gaps | Partial validation; key questions remain unanswered |
| 2 | Weak evidence, mostly assumptions | Little direct evidence; relying on proxies or opinion |
| 1 | No evidence, dimension unaddressed | Complete absence of validation or consideration |

## Score Boundary Decision Aid

When uncertain between adjacent scores, ask:

| Boundary | Ask yourself |
|----------|-------------|
| 5 vs 4 | Are there ANY gaps in evidence, even minor? If yes → 4. |
| 4 vs 3 | Is the core evidence validated with customers/data, or mostly inferred? If inferred → 3. |
| 3 vs 2 | Is there at least one concrete artifact (interview notes, test results, data)? If no → 2. |
| 2 vs 1 | Was this dimension even considered? If not mentioned → 1. |

**Tie-breaker rule:** When evidence is ambiguous, assign the lower score. It is better to flag a gap than to miss one.

## Dimension Weighting Guide

Not all dimensions matter equally for every input. Weight accordingly:

| Input Type | Primary Dimensions | Secondary Dimensions |
|------------|-------------------|---------------------|
| New product | Value, Feasibility | Viability, Usability |
| Feature addition | Value, Usability | Feasibility, Viability |
| Technical initiative | Feasibility | Viability, Value |
| Growth experiment | Value, Viability | Usability, Feasibility |
| UX redesign | Usability, Value | Feasibility, Viability |

For **implementation reviews**, also weight by data availability — a feature live for 2 weeks has less outcome signal than one live for 6 months.

## Verdict Thresholds

Total score across 7 dimensions (Value Risk, Usability Risk, Feasibility Risk, Business Viability Risk, Product Outcomes, Discovery Evidence, Instrumentation & Guardrails), each scored 1-5. Maximum: 35.

### Proposal Verdicts

| Score Range | Verdict | Meaning |
|-------------|---------|---------|
| 29-35 | Proceed | Strong evidence across all dimensions |
| 19-28 | Proceed with Conditions | Gaps exist but are addressable; specify conditions |
| 0-18 | Rework Required | Fundamental gaps; not ready to build |

### Implementation Verdicts

| Score Range | Verdict | Meaning |
|-------------|---------|---------|
| 29-35 | Meets Standards | Implemented with leadership-quality rigor |
| 19-28 | Needs Improvement | Gaps in process or outcomes; specify remediation |
| 0-18 | Critical Gaps | Major failures in process and/or outcomes |

## Critical Rules

1. **Any dimension scoring 1 prevents "Proceed" or "Meets Standards"** — a single unaddressed dimension is a blocking gap regardless of total score.
2. **Weakest-link rule** — if two or more primary dimensions (per weighting guide) score 2 or below, the verdict cannot exceed "Proceed with Conditions" / "Needs Improvement."
3. **Discovery floor** — Discovery Evidence scoring 2 or below caps the Value Risk score at 3, because value claims without evidence are assumptions.

<RiskSummary>
  <Dimensions count="7">
    <Dimension name="Value Risk" id="V" maxScore="5" />
    <Dimension name="Usability Risk" id="U" maxScore="5" />
    <Dimension name="Feasibility Risk" id="F" maxScore="5" />
    <Dimension name="Business Viability Risk" id="B" maxScore="5" />
    <Dimension name="Product Outcomes" id="P" maxScore="5" />
    <Dimension name="Discovery Evidence" id="D" maxScore="5" />
    <Dimension name="Instrumentation & Guardrails" id="I" maxScore="5" />
  </Dimensions>
  <VerdictScale max="35" />
  <ProposalVerdicts top="Proceed" mid="Proceed with Conditions" low="Rework Required" />
  <ImplementationVerdicts top="Meets Standards" mid="Needs Improvement" low="Critical Gaps" />
</RiskSummary>

---

## Cross-Dimensional Risk-Return Tradeoff

Not all gap combinations are equally dangerous. Use this guide for nuanced verdict reasoning:

| Pattern | Risk Level | Guidance |
|---------|-----------|----------|
| High Value + Low Feasibility | Moderate | Strong problem-solution fit but execution risk. Investable if team can spike. |
| High Feasibility + Low Value | Dangerous | Easy to build ≠ should build. Often leads to Feature Factory behavior. |
| High Value + Low Discovery | Speculative | Promising but unvalidated. Require discovery before committing resources. |
| High Viability + Low Usability | Misleading | Business case works on paper but users won't adopt. Common in B2B enterprise. |
| Low Instrumentation + High everything else | Hidden risk | The proposal looks good but you won't know if it succeeds. Require instrumentation plan. |

**Principle:** A proposal's weakest dimension matters more than its strongest. Address the lowest-scoring dimension first.

## Stage-Appropriate Scoring Thresholds

Score expectations should be calibrated to the company's stage. See [frameworks-company-stages.md](frameworks-company-stages.md) for detailed guidance.

| Stage | Minimum for "Proceed" | Key Dimension Emphasis |
|-------|----------------------|----------------------|
| Pre-PMF | 18/35 with Value ≥ 3 | Value Risk, Discovery Evidence |
| Growth | 24/35 with no dimension < 3 | All four risks equally, Instrumentation |
| Scale | 28/35 with Viability ≥ 4, Instrumentation ≥ 4 | Viability, Operational Readiness |
| Mature | 30/35 with no dimension < 4 | Compliance, Integration, Strategic Alignment |

These are guidelines, not rigid rules. Use judgment and document reasoning when deviating.
