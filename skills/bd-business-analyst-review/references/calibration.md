# Calibration guide

What good BA rigor looks like — reference examples for each evaluation area.

## Good vs weak requirements

| Weak (ambiguous) | Strong (verifiable) | Test |
|---|---|---|
| "System should be fast" | "Page loads in under 2 seconds on 3G" | Two devs would implement "fast" differently |
| "Handle data correctly" | "Given duplicate applicant records, when merge is triggered, then the record with the most recent update timestamp is retained" | "Correctly" is subjective |
| "User-friendly interface" | "New users complete onboarding in under 3 minutes without assistance (measured via usability testing with 5 participants)" | "User-friendly" has no pass/fail |
| "Support high volume" | "System processes 10,000 concurrent loan applications with p95 response time under 500ms" | "High volume" is undefined |

**The test**: If two developers would implement it differently, it is ambiguous.

## Elicitation quality spectrum

| Level | Method | Quality |
|-------|--------|---------|
| 1. Assumption | "Users probably want this" | No validation — anti-pattern |
| 2. Anecdotal | Stakeholder says "customers ask for X" | No data, secondhand |
| 3. Qualitative | User interviews, journey mapping, observation | Directional evidence |
| 4. Prototyped | Wireframes/demos tested with users | Validated concept |
| 5. Quantitative | Analytics, A/B test, production data | Statistically validated |
| 6. Working Backwards | Customer-facing value statement before building | Outcome-first validation |

**Minimum bar**: Level 3+ for functional requirements. Level 4+ for process changes. Never ship based on Level 1-2 alone. Best practice: combine multiple levels.

## Business rule specification quality

**Weak**: "Premium customers get a discount" (embedded in process narrative, no ID, no owner, no test).

**Strong**:
- **BR-042**: Premium customers (tier = Gold or Platinum) receive a 15% discount on orders over $100 before tax
- **Owner**: Revenue Operations
- **Validation**: Confirmed by CFO, 2024-01-15
- **Effective date**: 2024-02-01
- **Test**: Given a Gold customer with a $120 order, when discount is applied, then order total = $102 (120 × 0.85)

## Process modeling quality

**Weak**: "The customer submits an application, then it gets reviewed and approved."

**Strong**: As-is and to-be BPMN models with: actors/swim lanes, decision points (diamond gateways), exception paths (what happens when documents are incomplete?), handoffs between departments, SLAs per step ("underwriter review completes within 4 business hours"), gap analysis table showing: current state → desired state → gap category → closing requirement.

## Verification vs validation

| Verification | Validation |
|---|---|
| "Are requirements cohesive, complete, consistent, feasible, unambiguous, testable?" | "Do these requirements solve the right problem?" |
| Checks the structure of the specification | Checks the purpose of the specification |
| Can be done by a BA reviewing the document | Requires stakeholder participation |
| Catches: ambiguity, contradictions, gaps, infeasibility | Catches: wrong problem, missed need, misaligned solution |

Both are required. Verification without validation produces a perfect specification for the wrong problem. Validation without verification produces the right intent with an ambiguous specification.

## Solution evaluation quality

**Weak**: "The system is working" (no measurement, no comparison to requirements, no value assessment).

**Strong**: Measures solution performance against documented KPIs. Analyzes whether value is being realized. Identifies limitations (solution cannot handle volume spikes over 5,000 concurrent users — requirement was 10,000). Assesses enterprise limitations (compliance team lacks bandwidth to review all flagged applications). Performs root cause analysis when outcomes fall short. Recommends specific actions to increase value delivery. Tracks requirements gaps discovered post-launch and feeds them into change control.

## Evidence quality at scale

How top tech companies validate needs before building:

| Level | Approach | Example |
|-------|----------|---------|
| Assumed | "Users probably want this" | No validation — anti-pattern |
| Anecdotal | Stakeholder says "customers ask for X" | No data to support |
| Qualitative | Interviews, journey mapping, observation | Directional evidence |
| Prototyped | Wireframes/demos tested with users (Apple demo-driven, BABOK Prototyping) | Validated concept |
| Quantitative | Analytics, A/B tests, production data (Netflix experimentation, Google data-DNA) | Statistically validated |
| Working Backwards | Customer-facing value statement written first (Amazon PR/FAQ) | Outcome-first validation |

## Traceability matrix example

| Business Objective | Requirement | Acceptance Criteria | Test Case |
|---|---|---|---|
| Reduce loan processing from 5 to 2 days | REQ-101: Auto-validate applicant identity via credit bureau API | Given valid SSN, when identity check runs, then result returns within 3 seconds | TC-201: Submit valid SSN, verify < 3s response |
| Reduce loan processing from 5 to 2 days | REQ-102: Auto-calculate risk score | Given complete application, when scoring runs, then risk score between 0-1000 returned | TC-202: Submit complete application, verify score range |
| Improve compliance audit pass rate to 99% | REQ-103: Log all approval decisions with timestamp, approver, and rationale | Given approval decision, when logged, then audit trail includes all three fields | TC-203: Approve loan, verify audit trail fields |

## Impact analysis template

| Category | Current State | Impact of Change | Mitigation |
|---|---|---|---|
| **People** | Loan officers review manually | Role changes to exception handling | Training program, 2-week transition |
| **Process** | 5-day manual review cycle | Same-day automated with exceptions | Exception path design, SLA definition |
| **Systems** | Legacy CRM, email-based workflow | New system integrates CRM + credit bureau | API integration, data migration plan |
| **Compliance** | Manual audit trail | Automated logging required | Audit trail requirements, compliance review |
| **Data** | Applicant data in CRM only | Data flows to scoring engine + audit log | Data quality rules, source-of-truth definition |

## BABOK techniques by review purpose

**Elicitation** (assessing how requirements were gathered): Interviews, Focus Groups, Workshops, Observation, Surveys/Questionnaires, Document Analysis, Brainstorming, Collaborative Games, Mind Mapping, Prototyping

**Modeling & Specification** (assessing specification quality): Process Modelling, Data Modelling, Data Flow Diagrams, Data Dictionary, Business Rules Analysis, Use Cases & Scenarios, User Stories, State Modelling, Sequence Diagrams, Functional Decomposition, Interface Analysis, Scope Modelling

**Analysis & Decision** (assessing analytical rigor): Decision Analysis, Root Cause Analysis, SWOT Analysis, Risk Analysis, Financial Analysis, Estimation, Business Capability Analysis, Business Model Canvas, Non-Functional Requirements Analysis, Vendor Assessment

**Management & Tracking** (assessing governance): Acceptance & Evaluation Criteria, Backlog Management, Item Tracking, Prioritization, RACI Matrix, Stakeholder List/Map/Personas, Lessons Learned, Reviews

**Measurement** (assessing solution evaluation): Metrics & KPIs, Balanced Scorecard, Data Mining

## BA frameworks reference

**Strategic**: BACCM, Business Model Canvas, SWOT, Balanced Scorecard, Cynefin, PEST/STEEP, Porter's 5 Forces, CATWOE

**Prioritization**: MoSCoW, Kano Model, Purpose Alignment Model, RACI matrix, CRUD matrix

**Customer/User**: AARRR (Pirate Metrics), HEART framework, Value Proposition Canvas, Customer Journey Maps, Empathy Maps, Personas

## Complete BA toolkit

**Tactical (Story/Sprint)**: AC in Given/When/Then, business rule catalog entries, data dictionary, use case descriptions, user stories, requirements walkthroughs, wireframes/prototypes, CRUD matrices, item tracking

**Operational (Feature/Release)**: Traceability matrix, BPMN process models, gap analysis (as-is/to-be), context diagrams, ERDs, stakeholder register (RACI), impact analysis, NFR spec, solution evaluation reports, customer journey maps, story maps, MoSCoW/Kano prioritization, reviews, scope models

**Strategic (Program/Portfolio)**: Business case (Business Model Canvas), feasibility analysis (SWOT, PEST), business capability analysis, enterprise data model alignment, regulatory compliance mapping, cross-project dependency analysis, change management readiness (Balanced Scorecard), benefits realization tracking, Cynefin complexity assessment, benchmarking, vendor assessment

## Tech company BA practices

**Amazon**: PR/FAQ narrative — write the press release first, then work backwards to requirements. 6-pager silent reading + discussion. Forces problem clarity and customer value articulation before any building begins.

**Netflix**: Experimentation platform — thousands of A/B tests per year. Every product change validated with data. Scientific method applied to all ideas. Data trumps seniority.

**Spotify**: Risk-based discovery — evaluates 4 risks (Value, Usability, Feasibility, Viability). Squads iterate with data until value confirmed. Dogfooding → limited rollout → full rollout. Clear metrics: reach, depth, retention.

**Apple**: Demo-driven development — demo becomes the spec. Weekly executive review. "Andon cord" to halt projects early. Rules of the Road document evaluates process and milestones. Clarity of purpose and customer problem comes first.

**Google**: Data-DNA culture — all decisions based on data, analytics, experimentation. Evaluative research: usability studies, surveys, shadowing, log analysis. Customer feedback via multiple channels.
