# Feedback template

Structured output format for Business Analyst reviews.

## Severity levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Requirement gap or value not delivered | Must resolve before proceeding |
| **Major** | Significant gap in analysis or specification | Should resolve for quality |
| **Minor** | Small gap or improvement opportunity | Consider addressing |
| **Suggestion** | Enhancement idea | Optional |

## Full review template

```markdown
## Business Analyst review

**Input**: [What was reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Business Analyst
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### BA evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Requirements Completeness | /5 | |
| 2 | Stakeholder Coverage | /5 | |
| 3 | Process Clarity | /5 | |
| 4 | Business Rule Specification | /5 | |
| 5 | Data & Information Integrity | /5 | |
| 6 | Traceability & Requirements Lifecycle | /5 | |
| 7 | Goal Definition & Outcome Measurement | /5 | |
| 8 | Feasibility & Constraint Analysis | /5 | |
| 9 | Impact Analysis | /5 | |
| 10 | Acceptance Criteria Verifiability | /5 | |
| | **Overall Score** | **/50** | |

### BA compliance checklist (implementation reviews only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Structured elicitation conducted (interviews, observation, workshops) | [Yes/No] | |
| Stakeholder analysis completed (stakeholder map, RACI) | [Yes/No] | |
| As-is process documented before to-be designed | [Yes/No] | |
| Gap analysis between as-is and to-be conducted | [Yes/No] | |
| Business rules cataloged with IDs, owners, and validation status | [Yes/No] | |
| Data model created (ERD or equivalent) | [Yes/No] | |
| Traceability matrix maintained (objective → requirement → AC → test) | [Yes/No] | |
| Impact analysis conducted across people, processes, systems, compliance | [Yes/No] | |
| Feasibility assessed (technical, operational, economic, schedule) | [Yes/No] | |
| Acceptance criteria written as testable Given/When/Then statements | [Yes/No] | |
| Non-functional requirements specified with measurable thresholds | [Yes/No] | |
| Requirements validated via walkthrough with stakeholders (not sign-off only) | [Yes/No] | |
| Solution performance measured against requirements and KPIs | [Yes/No] | |
| Root cause analysis performed for solution limitations | [Yes/No] | |
| Post-implementation requirements gaps captured and change-controlled | [Yes/No] | |

### Critical issues
- [ ] [Issue] — [Dimension] — [Required action]

### Major issues
- [ ] [Issue] — [Dimension] — [Recommended action]

### Minor issues
- [ ] [Issue] — [Dimension] — [Suggestion]

### Strengths
- [What is well-done from a BA perspective]

### Top recommendation
[One highest-priority action the plan owner should take]

### Key question for the team
[The single most important question the BA would ask]
```

## Filled example 1: Proposal review

```markdown
## Business Analyst review

**Input**: Loan Application Processing System — Requirements Specification
**Review Mode**: Proposal Review
**Perspective**: Business Analyst
**Verdict**: Proceed with Conditions

### BA evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Requirements Completeness | 4/5 | Functional requirements well-documented. NFRs present but missing performance thresholds for batch processing. |
| 2 | Stakeholder Coverage | 3/5 | Loan officers and underwriters consulted. Compliance team mentioned but not interviewed. Collections department not identified as affected. |
| 3 | Process Clarity | 4/5 | As-is process mapped in BPMN. To-be modeled. Gap analysis present. Exception path for incomplete applications missing. |
| 4 | Business Rule Specification | 2/5 | Rules embedded in process narratives. No business rules catalog. Eligibility criteria stated but not as discrete testable rules. Approval thresholds mentioned informally. |
| 5 | Data & Information Integrity | 4/5 | ERD present with core entities. Data dictionary started. Source-of-truth for applicant data not defined (CRM vs application form). |
| 6 | Traceability & Requirements Lifecycle | 3/5 | Requirements numbered but no traceability to business objectives or test cases. Change control process not established. |
| 7 | Goal Definition & Outcome Measurement | 3/5 | Goal: "reduce loan processing time from 5 days to 2 days." KPI stated but no measurement plan. No leading indicators. Evidence for need based on management observation, not process data. |
| 8 | Feasibility & Constraint Analysis | 4/5 | Technical feasibility assessed with architecture team. Integration with credit bureau API spiked. Economic feasibility via CBA. Schedule constraint documented. |
| 9 | Impact Analysis | 3/5 | Impact on loan officers documented. Effects on downstream collections and reporting not assessed. No training needs analysis. |
| 10 | Acceptance Criteria Verifiability | 4/5 | Most AC in Given/When/Then. Cover happy path well. Missing boundary cases for loan amounts at threshold values. |
| | **Overall Score** | **34/50** | |

### Critical issues
- [ ] Business rules not cataloged — Business Rule Specification — Extract all eligibility, approval threshold, and calculation rules into a catalog with unique IDs. Rules like "loans over $50K require senior underwriter approval" must be discrete, testable, and owned. Currently buried in section 3.2 narrative.

### Major issues
- [ ] Compliance team not interviewed — Stakeholder Coverage — Regulatory requirements for loan processing are critical. Interview the compliance team to validate KYC, AML, and fair lending requirements are reflected in the specification.
- [ ] No traceability matrix — Traceability & Lifecycle — Create a traceability matrix linking business objectives to requirements to AC to test cases. Currently no way to confirm all objectives are covered or identify gold-plated requirements.
- [ ] Downstream impact not assessed — Impact Analysis — Collections and reporting are affected by process changes but not analyzed. Map effects on these departments and include closing requirements.

### Minor issues
- [ ] NFR batch processing thresholds missing — Requirements Completeness — Specify expected volume and performance thresholds for end-of-day batch processing.
- [ ] Source-of-truth for applicant data undefined — Data Integrity — Define whether CRM or application form is authoritative when data conflicts.

### Strengths
- As-is and to-be process models in BPMN with gap analysis
- Feasibility assessment thorough with architecture involvement and CBA
- Acceptance criteria mostly in Given/When/Then format with good happy-path coverage
- Credit bureau API integration de-risked via early spike

### Top recommendation
Build the business rules catalog immediately. Eligibility, approval thresholds, and calculation rules are the core logic of a loan processing system — leaving them embedded in narratives guarantees inconsistent implementation and makes compliance auditing nearly impossible.

### Key question for the team
What happens when a loan application hits the $50K threshold exactly — which approval path applies, and can you point to the business rule that governs this?
```

## Filled example 2: Implementation review

```markdown
## Business Analyst review

**Input**: Customer Onboarding Workflow (launched 60 days ago)
**Review Mode**: Implementation Review
**Perspective**: Business Analyst
**Verdict**: Needs Improvement

### BA evaluation scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Requirements Completeness | 3/5 | Core functional requirements implemented. Three NFRs (response time, concurrent users, accessibility) not specified at proposal stage — discovered as issues post-launch. |
| 2 | Stakeholder Coverage | 3/5 | Sales and customer success consulted. Legal (privacy/consent) discovered at launch. Support team not consulted — onboarding generates 40% of support tickets. |
| 3 | Process Clarity | 4/5 | As-is documented. To-be modeled. Gap analysis conducted. One exception path (international customers with non-standard documents) was missed and required post-launch hotfix. |
| 4 | Business Rule Specification | 3/5 | Key rules documented but not in a catalog. Document verification rules hard-coded by developers from verbal descriptions. Three rules conflict between the spec and implementation. |
| 5 | Data & Information Integrity | 4/5 | Data model sound. Integration with CRM working. Data quality issue: duplicate customer records created when onboarding is restarted. |
| 6 | Traceability & Requirements Lifecycle | 2/5 | No traceability matrix. Post-launch change requests not linked to original requirements. Two features implemented that trace to no documented requirement. |
| 7 | Goal Definition & Outcome Measurement | 3/5 | Goal: "reduce onboarding time from 3 days to same-day." Partially achieved (avg 1.2 days). No measurement plan for customer satisfaction or drop-off rate. No leading indicators tracked. |
| 8 | Feasibility & Constraint Analysis | 4/5 | Technical feasibility well-assessed. Document OCR integration tested early. Budget constraint documented. |
| 9 | Impact Analysis | 3/5 | Impact on sales process mapped. Effects on support team, billing, and compliance not assessed pre-launch. Support ticket volume increased 15% due to onboarding confusion. |
| 10 | Acceptance Criteria Verifiability | 4/5 | AC testable and mostly met. Missing criteria for the document re-upload scenario — users upload incorrect documents and the retry path was not specified. |
| | **Overall Score** | **33/50** | |

### BA compliance checklist

| Requirement | Met? | Gap |
|-------------|------|-----|
| Structured elicitation conducted | Yes | Interviews and workshops conducted |
| Stakeholder analysis completed | Partial | Legal and support team missed |
| As-is process documented before to-be designed | Yes | |
| Gap analysis between as-is and to-be conducted | Yes | One exception path missed |
| Business rules cataloged with IDs, owners, and validation status | No | Rules not in catalog format |
| Data model created | Yes | |
| Traceability matrix maintained | No | No matrix exists |
| Impact analysis conducted across people, processes, systems, compliance | Partial | Support and compliance gaps |
| Feasibility assessed | Yes | |
| Acceptance criteria written as testable statements | Yes | Missing re-upload scenario |
| Non-functional requirements specified with measurable thresholds | No | NFRs discovered post-launch |
| Requirements validated via walkthrough with stakeholders | Partial | Sign-off only, no walkthrough |
| Solution performance measured against requirements and KPIs | Partial | Only time-to-complete tracked |
| Root cause analysis performed for solution limitations | No | |
| Post-implementation requirements gaps captured and change-controlled | No | Ad-hoc fixes without tracing |

### Critical issues
- [ ] No traceability matrix exists — Traceability & Lifecycle — Two implemented features have no documented requirement (gold-plating). Post-launch changes are unlinked. Build a traceability matrix now and trace all existing features to requirements and business objectives.

### Major issues
- [ ] Business rules not cataloged — Business Rule Specification — Document verification rules were verbally communicated to developers. Three rules conflict between spec and code. Extract all rules into a versioned catalog with owners and validate against implementation.
- [ ] Support team not consulted — Stakeholder Coverage — Support handles 40% of onboarding tickets. Their input would have identified the document re-upload and international customer gaps. Conduct retrospective elicitation and feed findings into the next iteration.
- [ ] No root cause analysis for limitations — Goal Definition — Onboarding averages 1.2 days vs the 0-day target. No analysis of why. Is it document verification delays? User drop-off? System bottleneck? Perform root cause analysis before iterating.

### Minor issues
- [ ] Duplicate customer records on restart — Data Integrity — Data quality rule needed: detect and merge duplicates when onboarding is restarted. Define the source-of-truth for customer identity.
- [ ] NFRs discovered post-launch — Requirements Completeness — Response time, concurrency, and accessibility should be specified during requirements analysis. Add NFR elicitation to the standard requirements checklist.

### Strengths
- As-is and to-be process models with gap analysis conducted
- Technical feasibility well-assessed with early OCR integration testing
- Core functional requirements complete and implemented correctly
- Data model sound with working CRM integration

### Top recommendation
Build the traceability matrix and business rules catalog immediately. Without traceability, post-launch changes are uncontrolled — you cannot confirm what was intended, what was built, and what was tested. Without a rules catalog, the three rule conflicts between spec and code will compound.

### Key question for the team
Of the support tickets generated by onboarding (40% of volume), what are the top three categories — and do any of them trace to requirements gaps that were identified but not addressed?
```

## Quick review template

```markdown
## Business Analyst review (quick)

**Input**: [What was reviewed] | **Mode**: [Proposal / Implementation] | **Verdict**: [Verdict] | **Score**: /50

**Top Risks**: [1-2 highest concerns with dimension names]
**Strengths**: [1-2 positive signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```

## Guidance note

Prioritize the top 5-10 critical and major issues in the review output. Avoid overwhelming the reader with exhaustive lists of every minor violation. Leave minor nits for offline discussion or follow-up refinement sessions. The goal is actionable feedback that the team can act on this iteration, not a comprehensive audit of everything that could be better.
