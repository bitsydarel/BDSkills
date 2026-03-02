# Evaluation framework

Detailed scoring criteria for the 10 BA review dimensions.

## Scoring scale

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Excellent | Exceeds standards; evidence-rich, no gaps |
| 4 | Good | Meets standards with minor gaps |
| 3 | Adequate | Partially addressed; notable gaps |
| 2 | Weak | Significant gaps; requires rework |
| 1 | Missing | Not addressed or fundamentally flawed |

## Dimension 1: Requirements completeness

**Proposal-Verification questions**: Are all functional and non-functional requirements documented? Are they cohesive, complete, consistent, feasible, unambiguous, and testable? Is the level of detail appropriate for the phase? Are there gaps — requirements that should exist but do not?

**Proposal-Validation questions**: Do these requirements actually address the stated business need? Are there requirements that serve no business objective (gold-plating)?

**Implementation-Compliance questions**: Were requirements documented before building? Were gaps discovered during development that should have been caught during elicitation?

**Implementation-Solution Evaluation questions**: Are all implemented features traceable to documented requirements? Are there undocumented behaviors in the solution?

**Scoring**: 5 = comprehensive functional and NFR coverage, quality characteristics met, no gaps identified during review; 3 = most requirements present but notable gaps in NFRs or edge cases; 1 = requirements absent, vague, or fundamentally incomplete.

## Dimension 2: Stakeholder coverage

**Proposal-Verification questions**: Has a stakeholder analysis been conducted (stakeholder list, map, RACI)? Are all affected parties identified — including indirect stakeholders, downstream systems, and compliance bodies? Were appropriate elicitation techniques used for each stakeholder group?

**Proposal-Validation questions**: Do stakeholders confirm the requirements reflect their actual needs? Are conflicts between stakeholder groups surfaced and resolved?

**Implementation-Compliance questions**: Were stakeholders consulted during requirements gathering? Were any affected parties discovered post-launch that should have been identified earlier?

**Implementation-Solution Evaluation questions**: Are stakeholders satisfied with the solution? Are there unmet needs from groups that were under-represented?

**Scoring**: 5 = stakeholder map complete, RACI defined, multiple elicitation techniques used, conflicts resolved with rationale; 3 = key stakeholders identified but some groups missing, limited elicitation; 1 = no stakeholder analysis, single-source requirements.

## Dimension 3: Process clarity

**Proposal-Verification questions**: Is the as-is process documented with actors, decision points, exception paths, and handoffs? Is the to-be process modeled? Are SLAs and performance expectations stated? Is the gap between as-is and to-be analyzed with categorized gaps?

**Proposal-Validation questions**: Does the to-be process actually improve the identified pain points? Have process owners validated the models?

**Implementation-Compliance questions**: Was as-is documented before building? Were process changes designed intentionally or discovered accidentally?

**Implementation-Solution Evaluation questions**: Does the implemented process match the to-be model? Are there workarounds indicating the process model was wrong?

**Scoring**: 5 = as-is and to-be modeled (BPMN or equivalent), gap analysis complete, exception paths explicit, SLAs defined; 3 = some process documentation but gaps in exception paths or handoffs; 1 = no process modeling, requirements written without understanding current workflow.

## Dimension 4: Business rule specification

**Proposal-Verification questions**: Are business rules documented as discrete, testable statements with unique IDs? Are they separated from process and UI descriptions? Do they cover calculations, constraints, authorization, timing, and inference rules? Are owners, validation status, and effective dates tracked?

**Proposal-Validation questions**: Are rules validated by business rule owners? Do rules align with regulatory and policy requirements?

**Implementation-Compliance questions**: Were business rules cataloged before building? Were rules discovered during development that should have been explicit?

**Implementation-Solution Evaluation questions**: Are all implemented rules consistent with the business rule catalog? Are there hard-coded rules that bypass the catalog?

**Scoring**: 5 = business rules catalog with IDs, owners, validation status, comprehensive coverage; 3 = some rules documented but mixed into process narratives, incomplete coverage; 1 = no explicit business rules, rules buried in code or tribal knowledge.

## Dimension 5: Data and information integrity

**Proposal-Verification questions**: Are entities, attributes, relationships, and data flows identified? Is there a data model (ERD or equivalent)? Are data quality rules defined? Is the source-of-truth for each entity identified? Are data migration and transformation needs addressed?

**Proposal-Validation questions**: Is the data model consistent with business rules and process models? Are data ownership and stewardship defined?

**Implementation-Compliance questions**: Was a data model created before building? Were data issues discovered during development?

**Implementation-Solution Evaluation questions**: Is data integrity maintained in production? Are there data quality issues, orphaned records, or inconsistencies?

**Scoring**: 5 = data model complete, quality rules defined, source-of-truth identified, consistent with business rules; 3 = partial data model, some quality rules but gaps in relationships or constraints; 1 = no data modeling, data structure emerged from code.

## Dimension 6: Traceability and requirements lifecycle

**Proposal-Verification questions**: Does each requirement trace upstream to a business objective and downstream to acceptance criteria and test cases? Are orphan requirements identified? Are gold-plated requirements flagged? Are requirements prioritized, versioned, and change-controlled?

**Proposal-Validation questions**: Is the traceability chain complete from objective to test case? Are all business objectives covered by at least one requirement?

**Implementation-Compliance questions**: Was a traceability matrix maintained? Were changes to requirements impact-analyzed and version-controlled?

**Implementation-Solution Evaluation questions**: Can every implemented behavior be traced to a documented requirement? Are there features with no traceability (gold-plating)?

**Scoring**: 5 = full traceability matrix, requirements versioned and change-controlled, no orphans or gold-plating; 3 = partial traceability, some requirements untraceable; 1 = no traceability, requirements exist in isolation.

## Dimension 7: Goal definition and outcome measurement

**Proposal-Verification questions**: Are goals clearly stated with measurable success criteria and KPIs? Are leading and lagging indicators defined? Is there a measurement plan for post-launch validation? Are evaluation criteria established per BABOK techniques?

**Proposal-Validation questions**: Is there sufficient evidence to validate the business need before building? What elicitation, observation, analytics, or experimentation supports the need? Is there an experimentation plan (A/B testing, hypothesis-driven development)?

**Implementation-Compliance questions**: Were goals and KPIs defined before building? Is there a measurement plan being executed?

**Implementation-Solution Evaluation questions**: Are KPIs being tracked? Is the solution delivering its intended outcome? Is there evidence of value realization?

**Scoring**: 5 = SMART goals, KPIs with leading/lagging indicators, evidence-based validation, measurement plan active; 3 = goals stated but vague metrics, limited evidence for need; 1 = no measurable goals, assumed need with no validation.

## Dimension 8: Feasibility and constraint analysis

**Proposal-Verification questions**: Are technical, operational, economic, and schedule feasibility assessed? Are constraints documented? Are assumptions flagged and validated? Are dependencies confirmed? Has cost-benefit analysis been conducted? Has risk analysis been performed?

**Proposal-Validation questions**: Are the feasibility conclusions realistic? Do constraints invalidate any proposed requirements?

**Implementation-Compliance questions**: Was feasibility assessed before committing? Were assumptions validated? Were any constraints violated during implementation?

**Implementation-Solution Evaluation questions**: Were feasibility predictions accurate? Did constraints hold? Were risks mitigated as planned?

**Scoring**: 5 = all feasibility dimensions assessed, CBA conducted, risks analyzed with mitigations, assumptions validated; 3 = partial feasibility assessment, some constraints documented; 1 = no feasibility analysis, constraints discovered during implementation.

## Dimension 9: Impact analysis

**Proposal-Verification questions**: Are downstream effects on people, processes, systems, and compliance mapped? Is the blast radius understood? Is a change strategy defined? Is the gap analysis between current and desired state articulated with categorized gaps linked to closing requirements?

**Proposal-Validation questions**: Is the impact assessment complete? Are affected parties aware of the change?

**Implementation-Compliance questions**: Was impact analysis conducted before building? Were unexpected impacts discovered post-launch?

**Implementation-Solution Evaluation questions**: Were predicted impacts accurate? Are there unanticipated effects on people, processes, or systems?

**Scoring**: 5 = comprehensive impact map across people/process/systems/compliance, gap analysis with closing requirements, change strategy aligned; 3 = partial impact analysis, some downstream effects missed; 1 = no impact analysis, blast radius unknown.

## Dimension 10: Acceptance criteria verifiability

**Proposal-Verification questions**: Are criteria specific, measurable, and testable? Do they cover happy path, boundaries, errors, and business rules? Are they traceable to requirements? Can a tester construct test cases directly without additional clarification?

**Proposal-Validation questions**: Do acceptance criteria reflect actual business expectations? Would stakeholders agree these criteria confirm the need is met?

**Implementation-Compliance questions**: Were testable AC defined before building? Did testers need clarification beyond what was documented?

**Implementation-Solution Evaluation questions**: Did all AC pass? Were AC sufficient to catch defects? Are there production issues that better AC would have prevented?

**Scoring**: 5 = AC in Given/When/Then, covering all paths and business rules, directly testable, traceable to requirements; 3 = AC exist but vague or missing boundary and error cases; 1 = no AC, or untestable statements like "system should handle data correctly."

## Dimension weighting guide

Default weighting is equal (all dimensions scored 1-5, summed to /50). Adjust emphasis by input type:

| Input Type | Higher Weight Dimensions | Lower Weight Dimensions |
|-----------|------------------------|------------------------|
| Requirements Spec | Requirements Completeness, Business Rules, Process Clarity | Impact Analysis (early stage) |
| Process Change | Process Clarity, Impact Analysis, Stakeholder Coverage | Data Integrity (unless data migration) |
| System Enhancement | Data Integrity, Feasibility, Acceptance Criteria | Process Clarity (unless process change) |
| Change Request | Impact Analysis, Traceability, Feasibility | Process Clarity (unless process affected) |
| Integration Project | Data Integrity, Feasibility, Stakeholder Coverage | Business Rules (unless cross-system rules) |

Weighting adjusts emphasis in the rationale, not the scoring scale. All dimensions still receive a 1-5 score.

## Verdict thresholds

### Proposal reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Proceed** | 42-50 | Strong across all dimensions; ready to build |
| **Proceed with Conditions** | 27-41 | Viable but gaps need addressing before or during build |
| **Rework Required** | 0-26 | Fundamental gaps; return to elicitation and analysis |

### Implementation reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Meets Standards** | 42-50 | Well-specified and delivering value |
| **Needs Improvement** | 27-41 | Functional but significant gaps to address |
| **Critical Gaps** | 0-26 | Fundamental issues; remediation plan needed |

### Critical dimension rules

Regardless of total score:
- Any dimension scoring 1 = cannot receive "Proceed" or "Meets Standards" verdict
- Requirements Completeness + Business Rules both scoring 2 or below = automatic "Rework Required" / "Critical Gaps"
