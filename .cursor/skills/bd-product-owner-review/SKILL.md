---
name: bd-product-owner-review
description: "Reviews task plans, features, product proposals, and existing implementations through a Product Owner lens, evaluating backlog readiness, acceptance criteria quality, value maximization, stakeholder conflict resolution, scope control, outcome measurement, and iterative learning. Use when assessing a feature proposal, product backlog item, sprint plan, user story, backlog health, or reviewing an existing feature for Product Owner rigor."
---

# Product Owner review

This skill evaluates proposals and shipped features from the perspective of a Product Owner. The PO owns the Product Backlog, decides what to build and in what order, and is the link between business, customer, and development team. They are not the team's manager or a project coordinator. They are the single voice for prioritization.

## Core PO principles

These eight principles frame the PO mindset. They are not a checklist. They are the lens through which every evaluation dimension operates.

1. **Value maximization over throughput** — The goal is not to ship more items. It is to deliver the highest possible value per sprint. Velocity is a planning tool, not a success metric.
2. **Single voice for prioritization** — One person decides backlog order. Shared ownership of priority is no ownership at all. The PO can delegate research, but the ordering decision is theirs.
3. **Customer empathy through observation** — Talk to users. Watch them struggle. Do not confuse feature requests with needs. Customers describe solutions in terms of what they already know.
4. **Ready before pulling** — Items that enter a sprint must meet the Definition of Ready. Pulling unready work into a sprint wastes capacity and creates mid-sprint chaos.
5. **Done means validated** — "Done" is not "code merged." It means acceptance criteria are met, the Definition of Done is satisfied, and the increment is potentially releasable.
6. **Learn from every increment** — Sprint reviews are feedback loops, not demos. Capture what stakeholders and users actually think, and feed that into the next iteration.
7. **Shield the team, serve the stakeholders** — The PO absorbs conflicting stakeholder demands through shuttle diplomacy before they reach the team. The team gets clarity, not politics.
8. **Defer to expertise, not consensus** — Collaboration is not consensus. Defer to the tech lead for architecture, the designer for UX, and the PO for business value. A watered-down compromise built by committee rarely wins.

## Review modes

- **Proposal review**: Evaluating plans, PBIs, or sprint goals *before* building. "Is this ready? Is it the right thing to build next?"
- **Implementation review**: Evaluating features that are *already built and live*. This is a **superset** of Proposal Review covering three layers:
  1. **Compliance check**: Did the implementation satisfy everything a PO should have required at proposal stage? Were AC defined? Was DoR met? Was priority justified?
  2. **Outcome confirmation**: Are intended outcomes being achieved? What does production data show? Are metrics moving?
  3. **Iteration assessment**: Is sprint review feedback captured? Is it feeding the next cycle? Is the PO learning from delivery data?

For proposals, questions are forward-looking. For implementations, apply ALL proposal-stage criteria first, then evaluate real-world results and iteration behavior.

## Evaluation dimensions

Ten dimensions, each scored 1-5. Maximum score: 50. For detailed scoring criteria, see [references/evaluation-framework.md](references/evaluation-framework.md).

1. **Strategic alignment** — Does the work trace to the product vision and business objectives?
2. **Value maximization** — Is the team delivering the highest-value items first? Is there a prioritization rationale?
3. **Customer empathy and advocacy** — Is the work grounded in observed user pain, not feature requests?
4. **Backlog quality and readiness** — Are items clearly expressed, properly sized, ordered, and meeting Definition of Ready?
5. **Acceptance criteria and done** — Are AC specific, testable, and collaboratively produced? Is Definition of Done met?
6. **Stakeholder management and conflict resolution** — Is the PO resolving conflicting demands before they reach the team?
7. **Feasibility-viability-desirability balance** — Has the Product Triad assessed all three lenses? Were spikes or prototypes used for unknowns?
8. **Scope control and prioritization** — Is scope bounded? Can the PO say "no"? Is an objective framework used?
9. **Outcome measurement** — Are success metrics defined across engagement, satisfaction, business, and operational categories? Are leading and lagging indicators paired?
10. **Iterative learning and feedback** — Is sprint review feedback captured and feeding the next iteration? Is the PO learning from delivery data?

## PO knowledge signals

When scoring dimensions, check whether the work demonstrates knowledge across four areas. These are quality signals within existing evaluations, not additional scored dimensions:

- **Customer knowledge** — signals in Customer Empathy and Value Maximization (behavioral understanding, real pain observed, not feature-request driven)
- **Backlog craft knowledge** — signals in Backlog Quality and AC (INVEST compliance, DoR rigor, Three Amigos sessions)
- **Stakeholder navigation** — signals in Stakeholder Management (shuttle diplomacy, co-creation, defer-to-expertise pattern)
- **Delivery feedback knowledge** — signals in Iterative Learning and Outcome Measurement (sprint review as feedback loop, data-driven iteration)

## Review workflow

### 1. Ingest input

Identify review mode (proposal or implementation), artifact type (PBI, sprint plan, user story, backlog, shipped feature), and stated goal.

### 2. Assess backlog readiness

Check Definition of Ready, acceptance criteria quality, and whether Three Amigos was conducted with all three perspectives (PO: "what problem?", Dev: "how to build?", QA: "what could go wrong?"). For detailed criteria, see [references/evaluation-framework.md](references/evaluation-framework.md).

### 3. Evaluate value and prioritization

Score value maximization, strategic alignment, and scope control. Is there a named prioritization framework? Can the PO justify the ordering?

### 4. Assess stakeholder and balance

Evaluate stakeholder management, conflict resolution approach, and the feasibility-viability-desirability balance. Was the Product Triad involved?

### 5. Evaluate outcomes and learning

Assess outcome measurement (four metric categories, leading/lagging pairs, guardrail metrics) and iterative learning (sprint review feedback loops, inspect-and-adapt cycles).

### 6. Produce structured output

Write the review using [references/feedback-template.md](references/feedback-template.md). Include the 10-dimension scorecard, issues by severity, strengths, top recommendation, and key question.

## Anti-patterns

Common failure modes to detect during review. For detailed descriptions with Signs, Impact, and Fix, see [references/anti-patterns.md](references/anti-patterns.md).

**Critical**:
- **Backlog swamp** — Hundreds of items with no ordering, stale entries, no grooming cadence
- **Missing acceptance criteria** — PBIs enter sprint with vague descriptions and no testable AC
- **Absent Product Owner** — PO is unavailable during sprint; team guesses at priority and scope

**Major**:
- **Order taker** — PO passes stakeholder requests straight to the team without investigating the underlying need
- **Scope creep enabler** — PO accepts mid-sprint additions without trade-offs
- **Gold-plated stories** — AC padded with nice-to-haves that inflate effort without proportional value
- **FIFO backlog** — Items built in request order; no prioritization framework applied
- **Phantom readiness** — Items declared "ready" but missing AC, sizing, or dependencies
- **Demo-only reviews** — Sprint review is a presentation, not a feedback session
- **Ship and forget** — Feature delivered but no post-launch review; success never confirmed
- **Design by committee** — Every stakeholder gets a vote; product becomes a compromise
- **HiPPO surrender** — Highest-paid person's opinion overrides evidence and frameworks
- **Late feasibility check** — Engineering sees the item for the first time at sprint planning
- **Skipped core team review** — Jumped to stakeholder review without internal team assessment first
- **Review theater** — Feedback is subjective and unconstructive; no reference to personas, scenarios, or metrics

## Calibration

For examples of what good looks like — strong vs weak acceptance criteria, Definition of Ready, Three Amigos sessions, value ordering, stakeholder conflict resolution techniques, outcome measurement, and the complete PO toolkit — see [references/calibration.md](references/calibration.md).
