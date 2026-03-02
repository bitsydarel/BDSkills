---
name: bd-business-analyst-review
description: "Reviews task plans, features, product proposals, and existing implementations through a Business Analyst lens — evaluating requirements completeness, stakeholder coverage, process modeling, business rule specification, data integrity, traceability, gap analysis, feasibility assessment, impact analysis, and acceptance criteria verifiability. Use when assessing a feature proposal, requirements specification, process change, system enhancement, or reviewing an existing implementation for Business Analyst rigor."
---

# Business Analyst review

This skill evaluates proposals and shipped features from the perspective of a Business Analyst. The BA enables change by defining needs and recommending solutions that deliver value. They act as an internal consultant and translator — bridging business and technology stakeholders, investigating expressed desires to uncover actual underlying needs, and ensuring the right problem is understood before building. Unlike the PM (who looks outward at market and customers), the BA looks inward at operations, processes, and organizational needs, suggesting improvements that can be realized through technology.

## Core BA principles

These eight principles frame the BA mindset. They are not a checklist. They are the lens through which every evaluation dimension operates.

1. **Completeness over assumptions** — Every unstated requirement is a defect waiting to happen. Make the implicit explicit.
2. **Elicit, do not assume** — Requirements are discovered through structured elicitation (interviews, observation, workshops, document analysis, prototyping), not assumed from past projects.
3. **Translate, do not transcribe** — The BA investigates and clarifies expressed desires to uncover actual underlying needs. Stakeholders describe solutions they know; the BA separates the underlying need from the proposed solution.
4. **Model the process before specifying the system** — Understand the as-is before designing the to-be. A solution built on a misunderstood process automates the wrong workflow.
5. **Business rules are first-class artifacts** — Business rules govern how the organization operates. They must be documented, validated, and versioned independently of the solution.
6. **Verify structure, validate value** — Verification checks that requirements are cohesive, complete, consistent, feasible, unambiguous, and testable. Validation confirms they actually solve the right business problem.
7. **Facilitate shared understanding** — The BA builds consensus across stakeholders, manages conflicts, and ensures everyone has a shared understanding of the requirements and vision. Not consensus-driven design, but informed alignment.
8. **Impact before implementation** — Every change affects people, processes, and systems beyond the immediate scope. Map downstream effects before the team commits.

## Review modes

- **Proposal review**: Evaluating plans, requirements, or specifications *before* building — verifying quality and completeness, validating against business need.
- **Implementation review**: Evaluating features that are *already built and live*. This is a **superset** of Proposal Review covering three layers:
  1. **Compliance check**: Did the implementation satisfy everything a BA should have required at proposal stage?
  2. **Solution evaluation**: Does the implemented solution actually deliver value? Are there limitations preventing it from meeting business needs? If outputs are ineffective, what is the root cause?
  3. **Iteration assessment**: Are requirements gaps discovered post-implementation being captured? Are change requests being impact-analyzed?

For proposals, questions are forward-looking. For implementations, apply ALL proposal-stage criteria first, then evaluate real-world results and iteration behavior.

## Evaluation dimensions

Ten dimensions, each scored 1-5. Maximum score: 50. For detailed scoring criteria, see [references/evaluation-framework.md](references/evaluation-framework.md).

1. **Requirements completeness** — Functional and non-functional requirements identified, documented, free of gaps, at the right level of detail.
2. **Stakeholder coverage** — All affected parties identified via stakeholder analysis, consulted through appropriate elicitation, conflicts surfaced and resolved.
3. **Process clarity** — As-is understood and documented, to-be modeled, decision points, exception paths, and handoffs explicit, gap between states analyzed.
4. **Business rule specification** — Rules documented as discrete testable statements, separated from process and UI, covering calculations, constraints, authorization, timing, and inference.
5. **Data and information integrity** — Entities, attributes, relationships, and flows identified; data model consistent with business rules; quality rules and source-of-truth defined.
6. **Traceability and requirements lifecycle** — Each requirement traces upstream to a business objective and downstream to test cases and acceptance criteria. Orphan and gold-plated requirements identified. Requirements are prioritized, versioned, and change-controlled.
7. **Goal definition and outcome measurement** — Clearly stated goals with measurable success criteria and KPIs. Sufficient evidence to validate the business need before building. Leading and lagging indicators defined. Measurement plan to confirm the feature achieved its intended outcome post-launch.
8. **Feasibility and constraint analysis** — Technical, operational, economic, and schedule feasibility assessed. Constraints documented, assumptions flagged, dependencies confirmed. Cost-benefit and risk analysis conducted.
9. **Impact analysis** — Downstream effects on people, processes, systems, and compliance mapped. Blast radius understood. Gap analysis between current and desired state articulated with categorized gaps linked to closing requirements.
10. **Acceptance criteria verifiability** — Criteria are specific, measurable, and testable. Cover happy path, boundaries, errors, and business rules. Traceable to requirements. A tester can construct test cases directly without additional clarification.

## BA knowledge signals

When scoring dimensions, check whether the work demonstrates knowledge across four areas. These are quality signals within existing evaluations, not additional scored dimensions:

- **Elicitation & collaboration knowledge** (BABOK KA2) — signals in Stakeholder Coverage and Requirements Completeness (interviews, workshops, observation, document analysis, prototyping; stakeholder maps, RACI, empathy maps, journey maps)
- **Requirements & design knowledge** (BABOK KA5) — signals in Business Rules, Process Clarity, and Data Integrity (business rules analysis, process modelling/BPMN, data modelling/ERDs, use cases, user stories, functional decomposition, state modelling)
- **Strategy & planning knowledge** (BABOK KA1+KA4) — signals in Gap Analysis and Feasibility (business capability analysis, Business Model Canvas, SWOT, risk analysis, decision analysis, estimation; BACCM core concepts)
- **Solution evaluation knowledge** (BABOK KA6) — signals in Impact Analysis and Acceptance Criteria (acceptance and evaluation criteria, metrics and KPIs, root cause analysis, lessons learned; measure performance, assess limitations, recommend actions)

## Review workflow

### 1. Ingest input

Identify review mode (proposal or implementation), artifact type (requirements spec, user stories, process documentation, business case, change request, shipped feature), and stated goal.

### 2. Verify quality and completeness

Evaluate requirements against quality characteristics: cohesive, complete, consistent, feasible, unambiguous, testable. Check conformance to organizational standards, templates, and modeling notations. Assess stakeholder coverage and elicitation quality.

### 3. Validate against business need and outcome data

Confirm the requirements solve the right problem. Identify underlying assumptions and risks. Check that goals and outcomes are clearly stated with measurable success criteria. Verify there is sufficient evidence to validate the business need. Ensure KPIs and evaluation criteria are defined before building. Validate business rules and data model against stated needs.

### 4. Assess impact and change

Evaluate alignment with change strategy. Assess effects on value, timeline, budget, and resources. Identify conflicts with other systems. Document constraints and opportunities. Map blast radius across people, processes, and systems.

### 5. Evaluate solution (implementation reviews)

Measure solution performance against requirements and KPIs. Analyze performance measures to determine if value is being realized. Assess solution limitations preventing full value delivery. Assess enterprise limitations. If outputs are ineffective, perform root cause analysis. Recommend actions to increase solution value. Check whether requirements gaps are being captured post-launch.

### 6. Produce structured output

Write the review using [references/feedback-template.md](references/feedback-template.md). Include the 10-dimension scorecard, issues by severity, strengths, top recommendation, and key question.

## Anti-patterns

Common failure modes to detect during review. For detailed descriptions with Signs, Impact, and Fix, see [references/anti-patterns.md](references/anti-patterns.md).

**Critical**:
- **Assumed requirements** — Requirements carried over from past projects or assumed without elicitation; no stakeholder validation
- **Missing traceability** — Requirements exist in isolation with no link upstream to objectives or downstream to test cases
- **Invisible business rules** — Business rules buried in process narratives, UI mockups, or tribal knowledge; not documented as discrete artifacts

**Major**:
- **Stakeholder blindspot** — Key affected parties not identified or consulted; stakeholder analysis skipped
- **Solution contamination** — Requirements written as implementation instructions rather than business needs
- **Process blindness** — No as-is process documented; to-be designed on assumptions about current state
- **Ambiguous acceptance criteria** — Criteria that two testers would interpret differently; not pass/fail testable
- **Scope fog** — Boundaries of the change undefined; no context diagram or scope model
- **Data model neglect** — Entities and relationships not modeled; data quality rules absent
- **Impact blindness** — Downstream effects on people, processes, and systems not mapped
- **Requirements by committee** — Every stakeholder's wish included without prioritization or conflict resolution
- **Gold-plated specification** — Requirements far exceed the stated business need; over-engineering before validation
- **Validation theater** — Sign-off obtained but no actual walkthrough conducted with stakeholders
- **Late feasibility check** — Technical and operational feasibility assessed after requirements are finalized
- **Skipped core team review** — Requirements sent to stakeholders without internal team review first

## Calibration

For examples of what good looks like — strong vs weak requirements, elicitation quality spectrum, business rule specification, process modeling quality, verification vs validation, solution evaluation, evidence quality at scale, traceability matrices, impact analysis, the complete BA toolkit, and tech company BA practices — see [references/calibration.md](references/calibration.md).
