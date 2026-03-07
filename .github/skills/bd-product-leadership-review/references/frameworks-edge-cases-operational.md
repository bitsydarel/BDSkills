# Operational Edge Cases

Operational edge cases product leaders face, each with scenario, real-world example, decision framework, and common mistakes.

---

### 10. Conflicting Stakeholders

**Scenario:** Sales wants Feature A, engineering wants technical debt paydown, CEO has a pet project.

**Decision framework:**
- Use DACI framework: Driver (one person), Approver (one person), Contributors (informed), Informed (updated)
- Anchor in shared goal — find the metric everyone agrees matters, then evaluate each request against it
- Don't let the loudest voice win — data and customer evidence outrank organizational authority
- Make tradeoffs explicit and visible — "Building Feature A means NOT doing B. Here's the impact of each."
- Escalation protocol: if stakeholders can't align, the DRI (Directly Responsible Individual) decides

**Common mistakes:** Building everything (spreading too thin); building for the most senior stakeholder; avoiding the conflict (it doesn't resolve itself); making promises to multiple stakeholders that conflict.

---

### 11. Resource Constraints

**Scenario:** Three critical initiatives, capacity for 1.5.

**Real-world example:** 62% of organizations report lacking visibility into actual team capacity and utilization.

**Decision framework:**
- Say no explicitly — refusing to start what you can't finish is a leadership act, not a failure
- Reserve 15-20% buffer for unplanned work (bugs, incidents, urgent requests)
- Evaluate each initiative on impact-per-engineer-week, not total impact
- Sequence rather than parallelize — one completed initiative > three half-done initiatives
- If all three are genuinely critical, escalate the resource constraint as a business problem

**Common mistakes:** Starting all three at reduced pace; not accounting for context-switching costs (each additional project adds 20-40% overhead); treating "critical" as permanent (re-evaluate monthly).

---

### 12. Post-Acquisition Integration

**Scenario:** Two overlapping products from acquirer and acquired company.

**Real-world example:** 30% of acquisitions fail to deliver expected value, often due to product integration failures. Culture clash compounds technical challenges.

**Decision framework:**
- Define target architecture early — within 90 days, decide: keep both, merge to one, or build new
- Communicate transparently — users and teams of both products need clarity on the plan
- Don't treat acquired product as inferior — it was acquired for a reason; respect its strengths
- Set integration milestones with clear ownership and accountability
- Preserve key talent from acquired team — they built what you bought

**Common mistakes:** Indefinite "we'll run both" without convergence plan; forcing acquired product into acquirer's architecture without evaluation; losing acquired team's domain expertise.

---

### 13. Technical Debt vs. Features

**Scenario:** Engineering needs refactoring; sales needs features for pipeline deals.

**Decision framework:**
- 10-15% fixed allocation per sprint for tech debt — non-negotiable baseline
- Reframe debt as business risk: "Without this refactoring, feature velocity drops 30% in 6 months"
- Quantify in business terms: "This tech debt causes 3 incidents/month costing $X in engineering time"
- Tie debt reduction to upcoming features: "Paying down X enables features Y and Z faster"
- Make debt visible — dashboard showing debt impact on velocity, incidents, developer satisfaction

**Common mistakes:** Treating debt as engineering's problem; no fixed allocation (debt always loses to features); over-investing in debt (diminishing returns past a point); refactoring without business justification.

---

### 14. Dual-Track Discovery

**Scenario:** Continuous discovery is squeezed out by delivery demands.

**Real-world example:** Marty Cagan's dual-track agile: discovery and delivery run simultaneously, not sequentially. But most teams let delivery consume all bandwidth.

**Decision framework:**
- Plan discovery work explicitly in sprint/cycle planning — not as "spare time" activity
- Subset of team dedicated to discovery (typically PM + Designer + 1 engineer)
- Make discovery outputs visible: opportunity trees, experiment results, interview summaries
- Discovery feeds delivery, not competes with it — discovery de-risks the next quarter's delivery
- Minimum: 2 customer conversations per week, regardless of delivery pressure

**Common mistakes:** Discovery only during "innovation sprints" (quarterly at best); discovery done only by PM without engineering involvement; no artifact creation (learning evaporates); treating discovery as a phase rather than continuous activity.
