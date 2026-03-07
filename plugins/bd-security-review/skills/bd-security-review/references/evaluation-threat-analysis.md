# Lens 1: Threat Analysis (/20)

Scoring criteria for the 4 Threat Analysis dimensions. For scoring scale and verdict thresholds, see [evaluation-scoring.md](evaluation-scoring.md).

---

## T1: Attack Surface & Entry Point Mapping

**Proposal questions**: Are all external interfaces (APIs, UI, file uploads, webhooks, message queues) identified? Is each entry point documented with its data format, authentication requirement, and exposure level? Are internal service-to-service boundaries mapped?

**Implementation-Compliance questions**: Were all entry points identified at design time actually implemented with controls? Are there undocumented endpoints or debug interfaces exposed?

**Implementation-Results questions**: Has penetration testing or attack surface scanning confirmed the mapping? Are new entry points from post-launch changes captured?

**Scoring**:
- **5 (Excellent)**: Complete attack surface inventory with exposure ratings for every entry point. Automated scanning confirms the mapping. Internal service-to-service boundaries included. New entry points from post-launch changes are tracked.
- **4 (Good)**: Major external and internal entry points mapped with data formats and auth requirements. Minor gaps in secondary interfaces or exposure ratings. No automated scanning yet.
- **3 (Adequate)**: External-facing entry points identified but internal boundaries or secondary interfaces missing. No exposure ratings. Mapping exists but incomplete.
- **2 (Weak)**: Partial surface mapping covering only obvious endpoints. No systematic approach. Internal services and secondary interfaces not considered.
- **1 (Missing)**: No systematic identification of attack surface.

**Quality check**: Each entry point should specify: data format, auth requirement, and exposure level. Internal service-to-service boundaries must be mapped, not just external interfaces.

---

## T2: Threat Modeling (STRIDE Analysis)

**Proposal questions**: Has STRIDE been applied to each major component? Are threat trees or misuse cases documented? Does the model cover all six STRIDE categories for each entry point?

**Implementation-Compliance questions**: Were identified threats mitigated as designed? Are mitigations tested?

**Implementation-Results questions**: Have new threats emerged since the initial model? Is the threat model updated with each significant change?

**Scoring**:
- **5 (Excellent)**: STRIDE applied per component with documented mitigations and test coverage for each. Threat trees trace from entry point to impact. Model updated with each significant architectural change.
- **4 (Good)**: STRIDE applied per component. Most mitigations documented and tested. Minor gaps in coverage of one or two STRIDE categories for lower-risk components.
- **3 (Adequate)**: STRIDE applied at system level but not per component. Some categories (e.g., Repudiation, Information Disclosure) treated superficially. Mitigations listed but not all tested.
- **2 (Weak)**: Threat model exists but only covers Spoofing and Tampering. No structured methodology. Mitigations vague or unverified.
- **1 (Missing)**: No threat modeling performed.

**Quality check**: Confirm all 6 STRIDE categories are addressed per major entry point. Verify that identified threats have corresponding mitigations with test evidence.

---

## T3: Trust Boundaries & Data Flow Security

**Proposal questions**: Are trust boundaries explicitly marked in architecture diagrams? Is data validated at every trust transition? Are DFDs (Data Flow Diagrams) used to trace sensitive data?

**Implementation-Compliance questions**: Do actual data flows match the designed DFDs? Are trust boundaries enforced with network segmentation, API gateways, or service mesh policies?

**Implementation-Results questions**: Has runtime monitoring confirmed data stays within expected flow paths? Are anomalous cross-boundary flows detected?

**Scoring**:
- **5 (Excellent)**: DFDs with annotated trust boundaries. Data validated at every crossing. Runtime enforcement verified through network segmentation, API gateways, or service mesh. Anomalous flows detected.
- **4 (Good)**: Trust boundaries identified and mostly enforced. DFDs exist with sensitive data paths traced. Minor gaps in validation at internal boundaries.
- **3 (Adequate)**: Trust boundaries identified but inconsistent validation at crossings. DFDs exist for external flows but not internal. Network segmentation present but incomplete.
- **2 (Weak)**: Trust boundaries mentioned informally. No DFDs. Data validation only at the outermost boundary. Internal services communicate without validation.
- **1 (Missing)**: No trust boundary analysis. Data flows untraced.

**Quality check**: Verify DFDs trace sensitive data end-to-end. Confirm validation occurs at every boundary crossing, not just the perimeter.

---

## T4: Adversary & Risk Assessment

**Proposal questions**: Are threat actors profiled (nation-state, criminal, insider, opportunistic)? Is risk quantified using DREAD or equivalent? Are risks prioritized by likelihood and business impact?

**Implementation-Compliance questions**: Were high-priority risks from the assessment addressed first? Are residual risks documented with acceptance rationale?

**Implementation-Results questions**: Has actual incident data validated risk assumptions? Are risk ratings updated based on threat intelligence?

**Scoring**:
- **5 (Excellent)**: Threat actor profiles with DREAD scoring. Risk register with acceptance rationale and quarterly review. Incident data validates assumptions. Threat intelligence feeds inform updates.
- **4 (Good)**: Threat actors profiled and risks quantified. Risk register maintained with residual risks documented. Reviews occur but not on a fixed cadence.
- **3 (Adequate)**: Risk assessment exists but without quantification or structured prioritization. Threat actors mentioned generically. No formal risk register.
- **2 (Weak)**: Risks acknowledged informally. No threat actor profiling. No quantification method. Priorities based on gut feel.
- **1 (Missing)**: No adversary or risk analysis.

**Quality check**: Verify threat actors are profiled beyond "hackers." Confirm risks have both likelihood and impact ratings, not just severity labels.
