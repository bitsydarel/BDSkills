---
name: bd-product-manager-review
description: "Reviews task plans, features, product proposals, and existing implementations through a Product Manager lens — evaluating problem validation, the four critical product risks (value, usability, feasibility, business viability), strategic alignment, success metrics, MVP strategy, prioritization, and ethical responsibility. Use when assessing a feature proposal, product spec, task plan, roadmap item, or reviewing an existing feature for PM-quality rigor."
---

# Product Manager Review

This skill evaluates proposals and existing features through the lens of a Product Manager — the role at the intersection of business, UX, and technology. The PM is responsible for the *why* and *what* (outcomes), not just the *when* (output). They are not a "mini-CEO" — they lead through influence, evidence, and intense collaboration with design and engineering.

## Core PM Principles

These seven principles frame the PM mindset. They are not a checklist — they are the philosophical lens through which every evaluation dimension operates.

1. **Outcomes Over Outputs** — Minimize output while maximizing outcome and impact. Shipping a feature is meaningless if it does not solve a real problem.
2. **Fall in Love with the Problem** — Operate in the problem space before jumping to the solution space. Never be an "order taker." Ask "why" to uncover the underlying pain.
3. **Tackle Risks Before Building** — Validate value, usability, feasibility, and viability during discovery, not after launch. Building the "Wrong It" after months of work is catastrophic.
4. **Lead Through Influence, Not Authority** — PMs have no direct authority. The best solutions come from intense collaboration with design and engineering, not from dictating requirements.
5. **Data Beats Opinions** — When discussions devolve into HiPPO (Highest Paid Person's Opinion), the PM loses. Run experiments and collect evidence. Move from subjective to objective.
6. **Customers Cannot Tell You What to Build** — Observe behavior and constraints. Customers do not know what is technically possible. The PM acts as an intelligent filter to innovate on their behalf.
7. **Prioritize Ruthlessly, Build Less** — Strategy means deciding what NOT to do. Trying to please everyone pleases nobody. Say "no" to distractions that do not serve the core vision.

## Review Modes

- **Proposal Review**: Evaluating plans, specs, or roadmap items *before* building — "Is this worth building? Are risks addressed?"
- **Implementation Review**: Evaluating features that are *already built and live* — a **superset** of Proposal Review covering three layers:
  1. **Compliance Check**: Did the implementation satisfy everything a PM should have required at proposal stage? Were all four risks addressed? Was there a clear problem statement? Was discovery conducted?
  2. **Outcome Confirmation**: Are the intended outcomes actually being achieved? What does production data show? Are guardrails holding? Is the feature delivering value or just consuming resources?
  3. **Iteration Assessment**: Is post-launch data being collected and acted on? Are learnings feeding the next iteration cycle?

For proposals, questions are forward-looking ("will customers use this?"). For existing features, apply ALL proposal-stage criteria first (what should have been in place), then additionally evaluate real-world results and iteration behavior.

## Evaluation Dimensions

Ten dimensions, each scored 1-5. Maximum score: 50. For detailed scoring criteria, see [references/evaluation-framework.md](references/evaluation-framework.md).

1. **Problem Validation** — Is the problem real and validated? What is the job to be done? Are we in the problem space or already in the solution space? Customers cannot tell you what to build — observe behavior instead of taking feature requests.
2. **Value Risk** — Will customers buy or use this? Is there demand evidence? Is this a must-have or a nice-to-have? What happens if we do not build it?
3. **Usability Risk** — Can users figure it out? Has it been tested with real users? What is the learning curve? Is the UX validated or assumed?
4. **Feasibility Risk** — Can engineering build this? Was a spike conducted? Are dependencies confirmed? Were estimates engineer-validated? Is tech debt accounted for?
5. **Business Viability Risk** — Is it legal? Do unit economics work? Can sales and support operationalize it? Does it create sustainable advantage?
6. **Strategic Alignment** — Does it serve the product vision? Current OKRs? North Star metric? Strategy means focus over features — what are we choosing NOT to do?
7. **Success Metrics & Evidence** — Are KPIs outcome-based? Spock (quantitative) + Oprah (qualitative) evidence? Data over HiPPO? Leading vs lagging indicators defined?
8. **MVP & Experimentation** — What is the smallest testable version? Is this a one-way or two-way door? What is the cheapest way to validate the riskiest assumption?
9. **Prioritization & Trade-offs** — Why this over that? ROI considered? Cost of Delay? Iron Triangle trade-offs? Compare-and-contrast framing (not "whether or not")?
10. **Ethics & Responsibility** — What is the potential harm if misused? Bias considered? Accessibility addressed? Environmental or social consequences evaluated?

## PM Knowledge Signals

When scoring dimensions, check whether the plan demonstrates deep knowledge across four areas. These are quality signals within existing evaluations, not additional scored dimensions:

- **Customer Knowledge** → signals in Problem Validation and Value Risk (deep empathy, behavioral understanding, real pain points)
- **Data Knowledge** → signals in Success Metrics & Evidence (quantitative + qualitative data, A/B testing, analytics)
- **Business Knowledge** → signals in Business Viability Risk (finance, sales, marketing, legal, support constraints)
- **Market Knowledge** → signals in Strategic Alignment (competitive landscape, industry trends, technology ecosystem)

## Review Workflow

### 1. Ingest Input

Identify review mode (proposal or implementation), artifact type, and stated goal.

### 2. Validate Problem

Assess the problem space vs solution space. What is the job to be done? Is the team observing behavior or taking feature requests at face value? Check for the Build Trap.

### 3. Assess Risks

Score the four risks (value, usability, feasibility, viability) 1-5 each. Tackle risks before building — validate during discovery, not after launch. For detailed scoring, see [references/evaluation-framework.md](references/evaluation-framework.md).

### 4. Evaluate Strategy & Metrics

Assess strategic alignment, success metrics, and evidence quality. Is the vision customer-centric? Are OKRs outcome-based? Does data beat opinions in this plan?

### 5. Evaluate MVP & Prioritization

Assess experimentation strategy, decision sizing (one-way vs two-way door), prioritization rigor, trade-offs, and ethical responsibility. Is the team prioritizing ruthlessly and building less?

### 6. Produce Structured Output

Write the review using [references/feedback-template.md](references/feedback-template.md). Include the 10-dimension scorecard, issues by severity, strengths, top recommendation, and key question.

## Anti-Patterns

Common failure modes to detect during review. For detailed descriptions with Signs, Impact, and Fix, see [references/anti-patterns.md](references/anti-patterns.md).

**Critical**:
- **Build Trap** — Jumping to solutions without validating the problem
- **Opinion-Driven Planning** — No customer evidence; HiPPO decides
- **Flying Blind** — No instrumentation to measure outcomes

**Major**:
- **Invisible Customer** — Target user is "everyone" or undefined
- **Order Taker** — PM fulfills feature requests instead of investigating underlying problems
- **Feasibility Handwave** — Timeline set without engineering input
- **Gold Plating** — Full feature built when MVP would validate the hypothesis
- **Strategy Drift** — Feature does not serve vision or OKRs but gets built anyway
- **Peanut-Butter Strategy** — Spreading effort thin; impactful nowhere
- **Ship and Forget** — No post-launch review; success never confirmed
- **FIFO Backlog** — No prioritization framework; items built in request order

## Calibration

For examples of what excellent looks like — good vs weak evidence, outcome vs output comparisons, leading vs lagging indicators, problem statement templates, and the complete PM toolkit — see [references/calibration.md](references/calibration.md).
