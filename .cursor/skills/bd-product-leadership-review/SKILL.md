---
name: bd-product-leadership-review
description: "Reviews task plans, features, product proposals, and existing implementations through a Product Leadership lens — evaluating value risk, usability risk, feasibility risk, business viability risk, outcome definition, and discovery evidence. Use when assessing a feature proposal, roadmap item, product spec, task plan, or reviewing an existing feature for compliance with product leadership standards."
---

# Product Leadership Review

This skill evaluates proposals and existing features through the lens of product leadership — the four critical risks, outcome confirmation, and discovery evidence quality.

## Review Modes

- **Proposal Review**: Evaluating plans, specs, or roadmap items before building — "Is this worth building?"
- **Implementation Review**: Evaluating existing features after delivery — a **superset** that covers two layers:
  1. **Compliance Check**: Does the implementation satisfy everything product leadership would have required at proposal stage? (Were all four risks addressed? Was there a clear problem statement? Were OKRs outcome-based?)
  2. **Outcome Confirmation**: Are the intended outcomes actually being achieved? What does the production data show? Are guardrails holding?

For proposals, questions are forward-looking. For implementations, apply ALL proposal-stage criteria first (what should have been in place), then additionally evaluate real-world results.

## Risk Evaluation Framework

1. **Value Risk** — Proposal: Will customers buy/use this? Implementation: Did customers adopt it? What does usage data show?
2. **Usability Risk** — Proposal: Can users figure it out? Implementation: Can they actually use it? What do usability metrics show?
3. **Feasibility Risk** — Proposal: Can engineers build this? Implementation: Was it built sustainably? Technical debt incurred?
4. **Business Viability Risk** — Proposal: Does this work for the business? Implementation: Is it actually viable in production?

For detailed scoring and evaluation questions, see [references/review-framework.md](references/review-framework.md).

## Product Outcome Confirmation

Verify the five critical elements for confirming product outcomes:
- **Outcome-Based OKRs** — Success measured by business results or user behavior, not task completion
- **Leading Product Outcomes** — Team-controlled metrics that predict lagging business indicators
- **Product Instrumentation** — Telemetry and analytics to track actual customer usage
- **Guardrail Metrics** — Protections against negative side effects of optimizing a single metric
- **Two-Way Negotiation** — Collaborative goal-setting between leadership and team, not top-down mandates

For detailed evaluation criteria, see [references/outcome-confirmation.md](references/outcome-confirmation.md).

## Discovery Evidence

Is the work grounded in data from user tests, experiments, and customer interactions — or in opinions and stakeholder dictates? For implementations: is post-launch data being collected and acted on?

For evidence quality spectrum and examples, see [references/strategic-context.md](references/strategic-context.md).

## Review Workflow

1. **Ingest Input** — Identify review mode (proposal or implementation), artifact type, and stated goal
2. **Evaluate Each Risk** — Score 1-5 with rationale; see [references/review-framework.md](references/review-framework.md)
   - For implementations: first assess whether each risk was properly addressed (compliance), then assess actual results
3. **Confirm Product Outcomes** — Verify OKRs, instrumentation, guardrails; see [references/outcome-confirmation.md](references/outcome-confirmation.md)
   - For implementations: verify outcomes are defined AND confirm they are being achieved with production data
4. **Assess Discovery Evidence** — Verify evidence quality; see [references/strategic-context.md](references/strategic-context.md)
   - For implementations: verify pre-build discovery was done AND post-launch data is being collected and acted on
5. **Identify Anti-Patterns** — Flag leadership failure modes; see [references/anti-patterns.md](references/anti-patterns.md)
6. **Produce Structured Output** — Write review using [references/feedback-template.md](references/feedback-template.md)

## Anti-Patterns in Reviews

- **Output Bias**: Evaluating delivery velocity instead of problem-solving quality
- **Skipping Risks**: Reviewing only feasibility while ignoring value or viability
- **Advice Without Evidence**: Raising concerns without citing specific signals from the input
- **Opinion Laundering**: Accepting claims about user needs that lack discovery evidence
- **Guardrail Blindness**: Approving focused metrics without checking for negative side effects
