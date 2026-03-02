# Risk Evaluation Framework

Dual-mode evaluation for proposals (before building) and implementations (after building). Implementation mode is a superset — it evaluates compliance with proposal-stage requirements AND actual results.

## Scoring Scale

| Score | Meaning |
|-------|---------|
| 5 | Strong evidence this risk is mitigated |
| 4 | Good evidence with minor gaps |
| 3 | Some evidence but significant gaps |
| 2 | Weak evidence, mostly assumptions |
| 1 | No evidence, risk unaddressed |

## Risk 1: Value Risk — Are we solving a real problem customers care about?

**Proposal:** (1) What specific problem does this solve? (2) Evidence of demand? (3) Must-have or nice-to-have? (4) Target segment and size? (5) Current alternatives and switching motivation?

**Implementation — Compliance:** (1) Was a clear problem defined? (2) Was demand validated with customers? (3) Was target segment documented?

**Implementation — Results:** (1) Did customers adopt it? (2) Retention/engagement metrics? (3) Did it solve the stated problem? (4) Would customers miss it if removed?

**Benchmarks:** 5 = Multiple interviews confirm problem + quantitative demand + clear segment. 3 = Anecdotal evidence; assumed from observation. 1 = No customer contact; solution looking for a problem.

## Risk 2: Usability Risk — Can users figure it out and get value?

**Proposal:** (1) Prototype tested with real users? (2) Expected learning curve? (3) Fit with existing workflows? (4) Accessibility requirements?

**Implementation — Compliance:** (1) Was usability tested before building? (2) Design review conducted? (3) Target personas defined?

**Implementation — Results:** (1) Task completion rates? (2) Drop-off points in funnel? (3) Support ticket patterns? (4) Can new users succeed without training?

**Benchmarks:** 5 = Prototype tested with 5+ users; iterated on feedback. 3 = Design review but no user testing. 1 = No usability consideration.

## Risk 3: Feasibility Risk — Can we build this with acceptable effort and quality?

**Proposal:** (1) Team has required skills? (2) Known unknowns and technical risks? (3) Engineer-validated estimate? (4) External dependencies confirmed? (5) Spike done for risky components?

**Implementation — Compliance:** (1) Was an engineer involved in estimation? (2) Technical risks identified upfront? (3) Spike done for high-uncertainty parts?

**Implementation — Results:** (1) Built within estimate? (2) Technical debt incurred? (3) Maintainable by other engineers? (4) Performance under load?

**Benchmarks:** 5 = Engineer-validated estimate; spike completed; relevant experience. 3 = Rough estimate without spike. 1 = No engineering input; timeline dictated by stakeholders.

## Risk 4: Business Viability Risk — Does this work for the business?

**Proposal:** (1) Business model alignment? (2) Legal/compliance concerns? (3) Unit economics? (4) Can sales/marketing/support operationalize? (5) Sustainable competitive advantage?

**Implementation — Compliance:** (1) Business constraints evaluated? (2) Legal consulted? (3) GTM plan defined?

**Implementation — Results:** (1) Profitable/sustainable at current scale? (2) Legal issues surfaced? (3) Sales able to position it? (4) Unit economics holding?

**Benchmarks:** 5 = Unit economics validated; legal complete; GTM in place. 3 = Business case sketched but not validated. 1 = No business analysis; viability assumed.

## Discovery Evidence — Is this grounded in data or opinions?

**Proposal:** (1) Discovery activities conducted? (2) How many customers involved? (3) Artifacts exist (notes, test results, survey data)? (4) Evidence recency?

**Implementation — Compliance:** (1) Discovery done before building? (2) Artifacts produced? (3) Direct customer contact or proxies?

**Implementation — Results:** (1) Post-launch data collected systematically? (2) Learnings feeding iteration? (3) Regular outcome reviews? (4) Post-launch interviews conducted?

**Benchmarks:** 5 = 10+ interviews; prototype tested; quantitative validation. 3 = Few conversations; limited artifacts. 1 = No customer contact; stakeholder opinion or gut feel.

## Risk Weighting Guide

Not all risks matter equally for every input. Weight accordingly:

| Input Type | Primary Risks | Secondary Risks |
|------------|---------------|-----------------|
| New product | Value, Feasibility | Viability, Usability |
| Feature addition | Value, Usability | Feasibility, Viability |
| Technical initiative | Feasibility | Viability, Value |
| Growth experiment | Value, Viability | Usability, Feasibility |
| UX redesign | Usability, Value | Feasibility, Viability |

For **implementation reviews**, also weight by how much production data is available — a feature live for 2 weeks has less outcome signal than one live for 6 months.

## Verdict Thresholds

Total score across 7 dimensions (4 risks + Product Outcomes + Discovery Evidence + Instrumentation & Guardrails), each scored 1-5. Maximum: 35.

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

<RiskSummary>
  <Dimensions count="7">
    <Dimension name="Value Risk" maxScore="5" />
    <Dimension name="Usability Risk" maxScore="5" />
    <Dimension name="Feasibility Risk" maxScore="5" />
    <Dimension name="Business Viability Risk" maxScore="5" />
    <Dimension name="Product Outcomes" maxScore="5" />
    <Dimension name="Discovery Evidence" maxScore="5" />
    <Dimension name="Instrumentation and Guardrails" maxScore="5" />
  </Dimensions>
  <VerdictScale max="35" />
  <ProposalVerdicts top="Proceed" mid="Proceed with Conditions" low="Rework Required" />
  <ImplementationVerdicts top="Meets Standards" mid="Needs Improvement" low="Critical Gaps" />
</RiskSummary>
