# BA anti-patterns

Named failure modes that BA reviews must detect. Each pattern includes signs to look for, its impact, and a concrete fix.

## Critical anti-patterns

### 1. Assumed requirements

**Signs**: Requirements carried over from a previous project without validation. Phrases like "same as last time" or "we always do it this way." No elicitation sessions conducted. No stakeholder sign-off on current requirements. Business context has changed but requirements have not.

**Impact**: The solution solves yesterday's problem. Unstated assumptions become defects discovered in testing or production. Rework is expensive because the foundation is wrong.

**Fix**: Conduct structured elicitation for every project. Interview stakeholders, observe processes, analyze documents. Validate every carried-over requirement against the current business context. If it cannot be confirmed, it is an assumption — flag it.

---

### 2. Missing traceability

**Signs**: Requirements exist in a flat list with no link to business objectives above or test cases below. No traceability matrix. When asked "why does this requirement exist?", the answer is unclear. Changes are made to requirements without assessing upstream or downstream impact. Orphan requirements persist.

**Impact**: No way to confirm all business objectives are covered. No way to confirm all requirements are tested. Gold-plated requirements waste effort. Impact analysis is impossible because relationships are invisible.

**Fix**: Build a traceability matrix linking business objectives to requirements to acceptance criteria to test cases. Every requirement must answer "which objective does this serve?" and "how will this be verified?" Review for orphans and gold-plating regularly.

---

### 3. Invisible business rules

**Signs**: Business rules are embedded in process narratives ("when the customer is premium, the discount applies"). Rules live in someone's head or in legacy code comments. No business rules catalog. Rules contradict each other across documents. Developers discover rules during implementation by asking SMEs.

**Impact**: Inconsistent implementation across the solution. Rules cannot be validated, versioned, or audited. Regulatory compliance becomes difficult to demonstrate. Changes to rules require code archaeology.

**Fix**: Extract all business rules into a catalog with unique IDs, owners, validation status, and effective dates. Rules must be discrete, testable statements separated from process descriptions and UI specifications. Validate with business rule owners before development.

---

## Major anti-patterns

### 4. Stakeholder blindspot

**Signs**: Only the requesting department was consulted. No stakeholder analysis conducted. Downstream teams, compliance, operations, or end-users were not identified. Affected parties surface post-launch with unmet needs or objections.

**Impact**: Requirements are incomplete because perspectives are missing. Post-launch rework to address overlooked stakeholder needs. Organizational resistance to the change.

**Fix**: Conduct stakeholder analysis early. Use a stakeholder map (influence/interest matrix) and RACI. Identify direct users, indirect users, affected departments, compliance bodies, and system owners. Elicit from each group using appropriate techniques.

---

### 5. Solution contamination

**Signs**: Requirements are written as implementation instructions: "add a dropdown with values X, Y, Z" instead of "user must select a category." Technology choices embedded in requirements. UI layouts specified as requirements. The "what" and "how" are conflated.

**Impact**: The development team is constrained to a specific implementation that may not be optimal. Innovation is stifled. Requirements become obsolete when technology changes.

**Fix**: Separate the need from the solution. Write requirements as business capabilities or user needs. Let the development team determine the implementation. If a specific technology is a genuine constraint, document it as a constraint, not a requirement.

---

### 6. Process blindness

**Signs**: No as-is process documented. The to-be is designed based on assumptions about current state. Process owners were not interviewed. Handoffs, decision points, and exception paths are unknown. The team automates a process nobody fully understands.

**Impact**: The solution automates the wrong workflow. Exception paths cause system failures. Handoffs break because they were not modeled. The gap between as-is and to-be is unknown, so the change effort is miscalculated.

**Fix**: Document the as-is process through observation and interviews before designing the to-be. Model both using BPMN or equivalent notation. Conduct gap analysis. Validate with process owners and participants.

---

### 7. Ambiguous acceptance criteria

**Signs**: Criteria use subjective language: "system should be fast," "data is handled correctly," "user-friendly interface." Two testers reading the same AC would write different test cases. No Given/When/Then structure. Business rules not reflected in AC.

**Impact**: "Done" is subjective. Testing is inconsistent. Defects are disputed because criteria are open to interpretation. Rework due to misaligned expectations.

**Fix**: Write AC as specific, measurable, pass/fail statements in Given/When/Then format. Test: if two developers would implement it differently, it is ambiguous. Every business rule should have a corresponding AC.

---

### 8. Scope fog

**Signs**: No context diagram or scope model. Boundaries of the change are undefined. "In scope" and "out of scope" are not documented. Stakeholders have different understandings of what the project covers. Scope expands continuously without formal change control.

**Impact**: Effort estimates are unreliable because scope is unbounded. Stakeholder expectations diverge. The team builds beyond what was intended or misses essential components.

**Fix**: Create a context diagram showing system boundaries and external interactions. Document in-scope and out-of-scope items explicitly. Use a scope model. Apply change control for scope modifications.

---

### 9. Data model neglect

**Signs**: No entity-relationship diagram. Data structures emerge from code rather than design. Data quality rules not defined. Source-of-truth for key entities unknown. Data migration needs not addressed. Relationships between entities discovered during development.

**Impact**: Data integrity issues in production. Inconsistent data across systems. Migration failures. Reporting becomes unreliable because the data model was an afterthought.

**Fix**: Model entities, attributes, relationships, and data flows during analysis. Define data quality rules and source-of-truth. Create a data dictionary. Address migration and transformation needs before development.

---

### 10. Impact blindness

**Signs**: Only the immediate system is considered. Effects on downstream processes, other systems, compliance requirements, and people are not mapped. Training needs not assessed. No change management plan. Post-launch surprises from affected parties.

**Impact**: Organizational disruption. Compliance violations. System integration failures. User resistance because they were not prepared for the change.

**Fix**: Conduct impact analysis across people, processes, systems, and compliance. Map the blast radius. Assess training needs. Align with change management. Create a gap analysis with closing requirements.

---

### 11. Requirements by committee

**Signs**: Every stakeholder's wish is included without prioritization. Conflicting requirements coexist. No conflict resolution process. The specification is a union of all inputs with no synthesis. The BA acts as a scribe rather than an analyst.

**Impact**: The solution tries to please everyone and satisfies nobody. Contradictory requirements cause implementation deadlocks. Bloated scope. The BA loses credibility as an analyst.

**Fix**: The BA synthesizes, not transcribes. Use prioritization frameworks (MoSCoW, Kano). Surface and resolve conflicts through facilitated sessions. Document the rationale for inclusion and exclusion decisions.

---

### 12. Gold-plated specification

**Signs**: Requirements far exceed the stated business need. Edge cases documented for scenarios that will never occur. Non-functional requirements set to levels the business does not need. The specification is exhaustive but the project is time-constrained.

**Impact**: Analysis paralysis. Development effort inflated for low-value requirements. Time-to-market delayed. The team builds to a specification that exceeds the actual need.

**Fix**: Align specification depth with business value and risk. Apply "good enough" analysis — requirements should be as detailed as necessary, not as detailed as possible. Prioritize and time-box analysis effort.

---

### 13. Validation theater

**Signs**: Stakeholders sign off on requirements documents they have not read. Walkthroughs are scheduled but nobody attends or engages. Sign-off is a checkbox, not a confirmation of understanding. Requirements are approved via email without discussion.

**Impact**: False confidence that requirements are validated. Defects surface in UAT or production. Stakeholders claim "that is not what I asked for" after delivery.

**Fix**: Replace document sign-off with interactive walkthroughs. Use prototypes, scenarios, and examples to confirm understanding. Validate with process participants, not just managers. Record decisions and confirmations.

---

### 14. Late feasibility check

**Signs**: Requirements are fully specified before technical and operational feasibility is assessed. Engineering sees the requirements for the first time at handoff. Constraints surface that invalidate requirements. Cost estimates arrive after scope is committed.

**Impact**: Expensive rework of finalized requirements. Scope reduction under time pressure with poor trade-off analysis. Loss of trust between business and technology teams.

**Fix**: Include technical and operational representatives in requirements analysis from the start. Assess feasibility iteratively as requirements emerge. Conduct spikes for uncertain components early.

---

### 15. Skipped core team review

**Signs**: Requirements sent directly to stakeholders or steering committee without internal team review. Developers, testers, and architects see the requirements for the first time alongside business stakeholders. Basic issues (ambiguity, infeasibility, missing edge cases) are found in formal reviews.

**Impact**: Stakeholder trust erodes. Review sessions are spent on basic quality issues instead of strategic concerns. The team appears unprepared.

**Fix**: Always conduct an internal team review before external stakeholder sessions. Dev, QA, and architecture catch 80% of issues at a fraction of the cost. External reviews should focus on business fit, not specification quality.

---

## Anti-pattern summary

| Pattern | Severity | Primary Dimension | Applies To |
|---------|----------|-------------------|------------|
| Assumed Requirements | Critical | Requirements Completeness | Both |
| Missing Traceability | Critical | Traceability & Lifecycle | Both |
| Invisible Business Rules | Critical | Business Rule Specification | Both |
| Stakeholder Blindspot | Major | Stakeholder Coverage | Both |
| Solution Contamination | Major | Requirements Completeness | Proposal |
| Process Blindness | Major | Process Clarity | Both |
| Ambiguous Acceptance Criteria | Major | Acceptance Criteria | Both |
| Scope Fog | Major | Impact Analysis | Both |
| Data Model Neglect | Major | Data & Information Integrity | Both |
| Impact Blindness | Major | Impact Analysis | Both |
| Requirements by Committee | Major | Stakeholder Coverage | Both |
| Gold-Plated Specification | Major | Requirements Completeness | Proposal |
| Validation Theater | Major | Stakeholder Coverage | Both |
| Late Feasibility Check | Major | Feasibility & Constraints | Proposal |
| Skipped Core Team Review | Major | Acceptance Criteria | Both |
