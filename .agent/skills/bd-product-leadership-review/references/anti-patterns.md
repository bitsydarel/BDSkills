# Product Leadership Anti-Patterns

Named failure modes that product leadership reviews must detect. Each pattern has signs to look for, its impact, and a concrete fix.

## Critical Anti-Patterns

### 1. Feature Factory

**Signs:**
- Success defined as "shipped on time" rather than "problem solved"
- Roadmap is a list of features with dates, not problems with outcomes
- Team celebrates releases, never measures impact
- OKRs (if they exist) are output-based: "Launch X by Q2"

**Impact:** Organization builds features that nobody uses while real customer problems go unsolved.

**Fix:** Reframe every roadmap item as a problem to solve with an outcome-based KR. Require a post-launch impact review within 30 days.

---

### 2. Opinion-Driven Planning

**Signs:**
- Proposals cite no customer interviews, experiments, or usage data
- Justification is "stakeholder X requested this" or "competitor Y has it"
- Team cannot name a specific customer who has the stated problem
- Discovery section is empty or filled with assumptions

**Impact:** Resources are allocated to solutions that do not address validated customer needs, leading to low adoption and wasted effort.

**Fix:** Require at minimum 5 customer interviews or prototype tests before any proposal advances past discovery. Document evidence artifacts.

---

### 3. Flying Blind

**Signs:**
- Outcome-based KRs are proposed but no instrumentation exists to measure them
- Team cannot produce a dashboard showing current baseline metrics
- Feature is live in production but no usage data is being collected
- "We'll add analytics later" appears in the plan

**Impact:** Team cannot confirm whether outcomes are being achieved. Decisions revert to gut feel, and failed features persist because no one has data to challenge them.

**Fix:** For proposals: require an instrumentation plan alongside the feature spec. For existing features: add telemetry retroactively and establish baselines before claiming success.

---

## Major Anti-Patterns

### 4. Invisible Customer

**Signs:**
- Target customer/persona is not defined or is "everyone"
- No segmentation of who benefits most
- Problem statement uses "users" generically without specificity
- No evidence of direct customer contact

**Impact:** Feature solves nobody's problem well because it was designed for an abstract, non-existent user.

**Fix:** Name the target persona with demographic, behavioral, and need-based attributes. Validate the problem with representatives of that segment.

---

### 5. Untested Usability

**Signs:**
- No prototype or mockup was tested with real users
- UX is designed by engineers without design review
- "We'll iterate after launch" is the usability plan
- No task completion rates or success criteria for the user experience

**Impact:** Feature is built but users cannot figure out how to use it, leading to low adoption, high support burden, and eventual abandonment.

**Fix:** Conduct usability tests with at least 5 representative users before committing to build. Define task completion criteria.

---

### 6. Feasibility Handwave

**Signs:**
- Timeline set by stakeholders without engineering input
- No spike or prototype for technically uncertain components
- "How hard can it be?" justification for estimates
- Dependencies on external teams not validated

**Impact:** Project runs over timeline, quality suffers under deadline pressure, and technical debt accumulates from shortcuts.

**Fix:** Require engineer-validated estimates. Conduct spikes for any component with technical uncertainty. Document assumptions and dependencies.

---

### 7. Viability Blindspot

**Signs:**
- No analysis of unit economics, margins, or cost to serve
- Legal and compliance implications not evaluated
- Go-to-market plan absent — sales and marketing not consulted
- "We'll monetize later" mindset

**Impact:** Feature launches successfully from a product perspective but is unsustainable — too expensive to support, legally risky, or impossible to sell.

**Fix:** Include viability assessment in every proposal. Consult legal for regulated domains. Validate GTM with sales and marketing before building.

---

### 8. Stakeholder-Driven Roadmap

**Signs:**
- Roadmap items trace back to executive requests, not customer discovery
- HiPPO (Highest Paid Person's Opinion) determines priority
- Product team acts as a feature-request fulfillment service
- Discovery is skipped because "leadership already decided"

**Impact:** Product strategy is disconnected from customer reality. Team loses agency and motivation. Features serve internal politics, not customer needs.

**Fix:** Require customer evidence for every roadmap item regardless of source. Product leadership should set problems to solve, not solutions to build.

---

### 9. Metric Theater

**Signs:**
- Metrics are defined but never reviewed or acted upon
- Dashboards exist but nobody looks at them
- Success is declared without checking the actual numbers
- Team cannot state current values for their KRs

**Impact:** The appearance of data-driven decision-making without the substance. Bad outcomes persist because metrics are performative, not operational.

**Fix:** Institute weekly metric reviews where the team examines KR progress. Require data citations in every status update. If a metric isn't reviewed regularly, remove it — it is noise.

---

### 10. Missing Guardrails

**Signs:**
- Single metric is optimized with no side-effect monitoring
- Team cannot answer "what could go wrong if we succeed at this metric?"
- No OEC or trade-off documentation
- Previous optimization caused unintended harm that was discovered late

**Impact:** Optimizing one dimension degrades another — e.g., engagement increases but churn spikes, or conversion improves but support costs double.

**Fix:** Define at least one guardrail metric per primary KR. Document acceptable trade-offs explicitly. Monitor guardrails with the same rigor as primary metrics.

---

### 11. Ship and Forget

**Signs:**
- Feature was launched but no post-launch review was conducted
- Original success criteria exist but were never checked against actual results
- Team moved to the next project immediately after release
- No iteration based on post-launch learnings
- "We shipped it" is treated as the end state

**Impact:** Organization never learns whether its products actually work. Failed features consume resources indefinitely. Success stories cannot be replicated because outcomes were never confirmed.

**Fix:** Require post-launch review at defined intervals (30, 60, 90 days). Compare actual metrics to predicted outcomes. Feed learnings into the next iteration cycle.

---

## Anti-Pattern Summary

<AntiPatternSummary>
  <Pattern name="Feature Factory" severity="Critical" area="Outcomes" appliesTo="Both" />
  <Pattern name="Opinion-Driven Planning" severity="Critical" area="Discovery Evidence" appliesTo="Proposal" />
  <Pattern name="Flying Blind" severity="Critical" area="Instrumentation" appliesTo="Both" />
  <Pattern name="Invisible Customer" severity="Major" area="Value Risk" appliesTo="Both" />
  <Pattern name="Untested Usability" severity="Major" area="Usability Risk" appliesTo="Both" />
  <Pattern name="Feasibility Handwave" severity="Major" area="Feasibility Risk" appliesTo="Proposal" />
  <Pattern name="Viability Blindspot" severity="Major" area="Business Viability" appliesTo="Both" />
  <Pattern name="Stakeholder-Driven Roadmap" severity="Major" area="Discovery Evidence" appliesTo="Both" />
  <Pattern name="Metric Theater" severity="Major" area="Outcomes" appliesTo="Both" />
  <Pattern name="Missing Guardrails" severity="Major" area="Outcome Confirmation" appliesTo="Both" />
  <Pattern name="Ship and Forget" severity="Major" area="Implementation Review" appliesTo="Implementation" />
</AntiPatternSummary>
