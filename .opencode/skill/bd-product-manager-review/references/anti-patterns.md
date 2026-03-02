# PM Anti-Patterns

Named failure modes that PM reviews must detect. Each pattern includes signs to look for, its impact, and a concrete fix.

## Critical Anti-Patterns

### 1. Build Trap

**Signs**: Team discusses solutions (features, screens, APIs) without articulating the underlying problem. No problem statement. No "job to be done." Discovery phase is skipped because "we already know what to build." Backlog is a feature list, not a problem list.

**Impact**: Organization ships features that do not solve real problems. Resources are consumed without creating value. The team becomes a feature factory measuring velocity instead of outcomes.

**Fix**: Require a validated problem statement before any solution work begins. Use the template: "[Target customer] struggles with [problem] when [context], causing [impact]." Validate with behavioral observation, not opinion surveys.

---

### 2. Opinion-Driven Planning

**Signs**: Proposals cite no customer interviews, experiments, or usage data. Justification is "stakeholder X requested this" or "competitor Y has it." Team cannot name a specific customer who has the stated problem. HiPPO (Highest Paid Person's Opinion) determines priority.

**Impact**: Resources allocated to solutions that do not address validated needs. Low adoption and wasted effort. PM credibility erodes when features fail.

**Fix**: Require at minimum 5 customer interviews or prototype tests before any proposal advances. Reframe HiPPO discussions by proposing experiments: "Let me validate that hypothesis with data before we commit resources."

---

### 3. Flying Blind

**Signs**: Outcome-based KRs proposed but no instrumentation exists to measure them. Team cannot produce a dashboard showing baseline metrics. "We will add analytics later" appears in the plan. Feature is live but no usage data is collected.

**Impact**: Team cannot confirm whether outcomes are achieved. Decisions revert to gut feel. Failed features persist because no data exists to challenge them.

**Fix**: Require an instrumentation plan alongside every feature spec. Establish baselines before launch. No metric without a measurement mechanism.

---

## Major Anti-Patterns

### 4. Invisible Customer

**Signs**: Target user is "everyone" or undefined. No segmentation. Problem statement uses "users" generically. No evidence of direct customer contact.

**Impact**: Feature designed for an abstract user solves nobody's problem well. Diffuse value proposition fails in market.

**Fix**: Name the target persona with demographic, behavioral, and need-based attributes. Validate with representatives of that segment.

---

### 5. Order Taker

**Signs**: PM acts as a "waiter" — receives feature requests from stakeholders and passes them directly to engineering. No pushback, no "why," no investigation of underlying problems. Backlog is a queue of stakeholder requests. PM measures success by request fulfillment speed.

**Impact**: Product becomes incoherent — a patchwork of disconnected features driven by the loudest voices. Real user problems go unsolved. PM loses strategic influence and becomes a project coordinator.

**Fix**: For every request, ask "What problem does this solve?" and "How would we know it worked?" Investigate the underlying need before committing to any specific solution. Present options, not just orders.

---

### 6. Untested Usability

**Signs**: No prototype tested with real users. UX designed by engineers without design review. "We will iterate after launch" is the usability plan. No task completion criteria.

**Impact**: Feature built but users cannot figure out how to use it. Low adoption, high support burden, eventual abandonment.

**Fix**: Conduct usability tests with at least 5 representative users before committing to build. Define task completion criteria.

---

### 7. Feasibility Handwave

**Signs**: Timeline set by stakeholders without engineering input. No spike for technically uncertain components. Dependencies on external teams not validated. Tech lead not involved in architectural decisions.

**Impact**: Project runs over timeline. Quality suffers under deadline pressure. Technical debt accumulates from shortcuts.

**Fix**: Require engineer-validated estimates. Conduct spikes for uncertain components. Involve the tech lead in discovery. Budget 10-30% for tech debt.

---

### 8. Viability Blindspot

**Signs**: No unit economics analysis. Legal and compliance not evaluated. No GTM plan. Sales and marketing not consulted. "We will monetize later" mindset.

**Impact**: Feature launches but is unsustainable — too expensive to support, legally risky, or impossible to sell.

**Fix**: Include viability assessment in every proposal. Consult legal for regulated domains. Validate GTM with sales and marketing before building.

---

### 9. Stakeholder-Driven Roadmap

**Signs**: Roadmap items trace to executive requests, not customer discovery. HiPPO determines priority. Product team acts as feature-request fulfillment. Discovery skipped because "leadership already decided."

**Impact**: Product strategy disconnected from customer reality. Team loses agency. Features serve internal politics, not customer needs.

**Fix**: Require customer evidence for every roadmap item regardless of source. Use Shuttle Diplomacy — present data to stakeholders showing the gap between their assumptions and customer reality.

---

### 10. Gold Plating

**Signs**: Full feature built when an MVP would validate the hypothesis. Months of development before any user feedback. All edge cases handled before core value is confirmed. "While we are at it" scope additions.

**Impact**: Massive investment before validation. If assumptions are wrong, entire effort is wasted. High cost of learning.

**Fix**: Define the MVP as the smallest version that tests the riskiest assumption. Use decision sizing — two-way doors get lighter builds. Ship to learn, not to impress.

---

### 11. Under-Engineered MVP

**Signs**: MVP is so broken, slow, or ugly that users cannot experience the core value proposition. "Minimum" interpreted as "barely functional." No quality bar for the test.

**Impact**: Invalid experiment — negative results could mean "wrong idea" or "terrible execution." Cannot distinguish between the two.

**Fix**: MVP must be minimum but viable. Users must be able to experience the core value proposition clearly. Quality bar for the experiment must be defined upfront.

---

### 12. Strategy Drift

**Signs**: Feature does not connect to product vision or current OKRs but gets built anyway. Justification is "it is a quick win" or "a customer asked for it." No one can articulate how it serves the North Star metric.

**Impact**: Product becomes unfocused. Resources diverted from strategic priorities. Roadmap becomes a grab bag of disconnected features.

**Fix**: Every feature must trace to a strategic objective. If it does not, it does not get built — regardless of how easy it is. Quick wins that drift from strategy are slow losses.

---

### 13. Peanut-Butter Strategy

**Signs**: Effort spread thinly across too many initiatives. Team works on 8+ projects simultaneously. No clear #1 priority. Everything is "important." Resources split so thin that nothing ships with impact.

**Impact**: Organization is busy everywhere and impactful nowhere. Competitors with focused strategies outperform on every dimension.

**Fix**: Ruthlessly cut to 2-3 top priorities per quarter. Strategy means deciding what NOT to do. Saying no to distractions is the PM's primary job.

---

### 14. Metric Theater

**Signs**: Metrics defined but never reviewed or acted upon. Dashboards exist but nobody checks them. Success declared without verifying numbers. Team cannot state current values for their KRs.

**Impact**: Appearance of data-driven culture without substance. Bad outcomes persist because metrics are performative.

**Fix**: Institute weekly metric reviews. Require data citations in every status update. If a metric is not reviewed regularly, remove it — it is noise.

---

### 15. FIFO Backlog

**Signs**: No prioritization framework. Items built in the order they were requested. No ROI, RICE, or Cost of Delay analysis. Backlog is a chronological queue. Framing is "whether or not to build this" instead of "which of these is most important now."

**Impact**: High-value items wait behind low-value items. Opportunity cost accumulates silently. Team optimizes for throughput, not impact.

**Fix**: Apply a structured prioritization framework (ROI, RICE, Cost of Delay, Kano). Use compare-and-contrast framing. Re-prioritize regularly as new information arrives.

---

### 16. Ship and Forget

**Signs**: Feature launched but no post-launch review conducted. Success criteria exist but were never checked. Team moved to next project immediately. No iteration based on learnings. "We shipped it" treated as the end state.

**Impact**: Organization never learns whether products work. Failed features consume resources indefinitely. Success stories cannot be replicated.

**Fix**: Require post-launch reviews at 30, 60, 90 days. Compare actual metrics to predictions. Feed learnings into the next iteration cycle.

---

### 17. Late Engineer Involvement

**Signs**: Engineers brought in after discovery is complete. Handed requirements to build. No engineering voice in problem framing or solution exploration. "Dual-track" means PM decides, then engineers execute.

**Impact**: Missed technical insights that could shape better solutions. Lower engineering ownership and motivation. Feasibility surprises late in the process.

**Fix**: Include engineers in discovery from day one. Best solutions come from intense collaboration between PM, design, and engineering — not from handoffs.

---

### 18. Swoop and Poop

**Signs**: Stakeholders see the product only after it is fully built. No mid-process reviews or demos during discovery. Feedback arrives after investment is locked in. Major direction changes triggered at the last minute.

**Impact**: Late-stage rework. Wasted effort. Stakeholder trust erodes because they feel excluded, even though early involvement would have caught issues cheaply.

**Fix**: Show work early and often. Use iteration reviews during discovery. Shuttle Diplomacy — keep stakeholders informed incrementally so there are no surprises.

---

### 19. Fluffy Validation

**Signs**: Accepting "I would use that" or "that sounds great" as validation. No concrete commitment demanded. Surveys with leading questions. Confusing enthusiasm with willingness to pay or change behavior.

**Impact**: False confidence in demand. Product launches to indifference because verbal enthusiasm does not predict real behavior.

**Fix**: Demand concrete signals: sign-ups, letters of intent, deposits, time commitment. Observe behavior, not stated preferences. Run Riskiest Assumption Tests (RATs) before scaling.

---

### 20. Analysis Paralysis

**Signs**: Endless research without building prototypes or running experiments. Waiting for "perfect data" before deciding. Discovery phase that never transitions to delivery. Over-planning two-way door decisions.

**Impact**: Missed market windows. Competitors ship while the team researches. Team loses momentum and confidence.

**Fix**: Set time-boxes for discovery phases. Use decision sizing — two-way doors get quick decisions. "Good enough" data for reversible decisions; deep analysis only for one-way doors.

---

### 21. Ethics Blindspot

**Signs**: No consideration of harm, bias, or accessibility. No one asks "what happens if this is misused?" Accessibility treated as a nice-to-have. No diverse perspective in design reviews.

**Impact**: Product causes harm at scale. Legal liability. Brand damage. Exclusion of user populations. Regulatory consequences.

**Fix**: Add ethics questions to every review: "Who could be harmed? What biases exist? Is this accessible? What are the unintended consequences at scale?"

---

## Anti-Pattern Summary

| Pattern | Severity | Primary Dimension | Applies To |
|---------|----------|-------------------|------------|
| Build Trap | Critical | Problem Validation | Both |
| Opinion-Driven Planning | Critical | Success Metrics | Both |
| Flying Blind | Critical | Success Metrics | Both |
| Invisible Customer | Major | Value Risk | Both |
| Order Taker | Major | Problem Validation | Both |
| Untested Usability | Major | Usability Risk | Both |
| Feasibility Handwave | Major | Feasibility Risk | Proposal |
| Viability Blindspot | Major | Business Viability | Both |
| Stakeholder-Driven Roadmap | Major | Strategic Alignment | Both |
| Gold Plating | Major | MVP & Experimentation | Proposal |
| Under-Engineered MVP | Major | MVP & Experimentation | Both |
| Strategy Drift | Major | Strategic Alignment | Both |
| Peanut-Butter Strategy | Major | Strategic Alignment | Both |
| Metric Theater | Major | Success Metrics | Both |
| FIFO Backlog | Major | Prioritization | Both |
| Ship and Forget | Major | Success Metrics | Implementation |
| Late Engineer Involvement | Major | Feasibility Risk | Both |
| Swoop and Poop | Major | Prioritization | Both |
| Fluffy Validation | Major | Value Risk | Proposal |
| Analysis Paralysis | Major | MVP & Experimentation | Proposal |
| Ethics Blindspot | Major | Ethics | Both |
