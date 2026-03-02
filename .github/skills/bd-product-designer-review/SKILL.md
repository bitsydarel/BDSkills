---
name: bd-product-designer-review
description: "Reviews task plans, features, product proposals, and existing implementations through a Product Designer lens — evaluating human-centered problem framing, usability and interaction quality, information architecture, visual design and brand expression, user research rigor, accessibility and inclusivity, service blueprint and end-to-end journey mapping, co-creation and stakeholder facilitation, prototyping and design validation, and design system coherence and feasibility. Use when assessing a feature proposal, design spec, UX strategy, service blueprint, prototype plan, or reviewing an existing feature for product design rigor."
---

# Product Designer Review

The Product Designer is a first-class member of the cross-functional product trio (alongside PM and Tech Lead). They are responsible for product discovery, own usability risk, and design the holistic customer experience — from interaction models and visual brand expression to service ecosystem fit. Unlike an internal agency model, the empowered Product Designer is measured by product success in the market, not creative output. This skill unifies the perspectives of UX Design, Interaction Design, User Research, and Service Design into one holistic lens, evaluating through five review lenses: Empathy, Friction, Aesthetic & Brand, Feasibility & Viability, and Collaborative Critique.

## Core Product Designer Principles

1. **Own Usability Risk in the Product Trio** — The PM owns value and viability, engineering owns feasibility, the designer owns usability. This is explicit accountability, not shared vaguely. (Cagan: Empowered Product Teams)
2. **Drive Discovery, Don't Receive Requirements** — Product Designers work from inception alongside PM and Tech Lead, rapidly experimenting to separate good ideas from bad before production code. (Continuous Discovery, Product Trio)
3. **Evidence Over Aesthetics** — Beautiful design that doesn't test well is decoration, not design. Put prototypes in front of real users weekly — a dozen prototypes to test different approaches is normal. (Spool, Nielsen, Lean UX)
4. **Design the Whole Journey** — A product is one touchpoint in a broader service ecosystem. Evaluate the customer's complete context, not isolated screens. (Stickdorn, Service Design Thinking)
5. **Include, Don't Exclude** — Accessibility is not a feature; it is a foundation. Design for diverse abilities, contexts, and environments (noisy rooms, mobile while walking). (WCAG, Universal Design)
6. **Co-Create, Don't Prescribe** — The best solutions emerge from collaborative design with users and stakeholders. Facilitate, don't dictate. Use design crits with green/red rounds. (Participatory Design, Vargo & Lusch SDL)
7. **Prototype to Learn, Not to Prove** — Prototypes test hypotheses; they should not confirm biases. If disagreements arise, settle with behavioral evidence, not internal opinions. (Double Diamond, Lean UX)
8. **Coherent Systems, Not Isolated Screens** — Design at the system level; components, patterns, tokens. Share accountability for product success — the design must work for both the customer and the business. (Atomic Design, Design Tokens)

## Review Modes

- **Proposal Review** — Pressure-testing a plan through the 5 designer lenses: Is the design grounded in user evidence (Empathy)? Are interactions intuitive and frictionless (Friction)? Does it evoke the right feelings and express the brand (Aesthetic & Brand)? Is implementation proportional to user value with no dark patterns (Feasibility & Viability)? Has the team tested with real users, not just internal opinions (Collaborative Critique)?
- **Implementation Review** — Superset of proposal review plus three additional layers:
  1. **Compliance Check** — Were empathy maps created? Was usability testing conducted? Was WCAG audited? Were service blueprints mapped? Was the design reviewed via design crits? Were prototypes tested at appropriate fidelity?
  2. **Outcome Confirmation** — Do performance metrics (task success rate, time on task, error rate, efficiency/lostness, learnability) confirm usability? Do self-reported metrics (SUS, NPS, CES, post-task SEQ/ASQ, Product Reaction Cards) confirm satisfaction? **Critical: Distinguish satisfaction from loyalty** — 60-80% of defectors rated themselves "satisfied" before leaving (the Satisfaction Trap). Go beyond CSAT/OSAT to measure true loyalty: Retention Rate, NPS (Promoters vs Passives vs Detractors), Stickiness (DAU/MAU), Earned Growth Rate (EGR). Are HEART framework dimensions healthy (Happiness, Engagement, Adoption, Retention, Task Success)? Is the retention curve stable? Are conversion/drop-off bottlenecks identified?
  3. **Iteration Assessment** — Is post-launch user feedback driving design iteration? Are usability testing insights being acted on? Is the design crit cycle (green/red rounds) operational? Is the SUM (Single Usability Metric) being tracked over releases?

## Evaluation Dimensions

Score each 1-5 per [references/evaluation-framework.md](references/evaluation-framework.md). Total /50.

1. **Human-Centered Problem Framing** — Is the design grounded in real human needs? Empathy maps, persona validation, problem-space exploration before solution-space. (Norman HCD, IDEO Design Thinking)
2. **Usability & Interaction Quality** — Is the interface learnable, efficient, error-preventing? Goal-directed design, cognitive load management, heuristic compliance. (Nielsen 10 Heuristics, Cooper Goal-Directed, Krug)
3. **Information Architecture & Navigation** — Are content structures intuitive? Findability, labeling, mental models, wayfinding. (Garrett 5 Planes of UX, Card Sorting)
4. **Visual Design & Brand Expression** — Is the visual language communicative, consistent, and on-brand? Typography, color, layout, hierarchy, Gestalt principles. (Brand Systems, Visual Communication)
5. **User Research & Evidence Rigor** — Quality of qualitative/quantitative research, prototype testing, triangulation, insight synthesis. (Spool, Goodwin, Mixed Methods)
6. **Accessibility & Inclusivity** — Does the design work for diverse abilities, contexts, and cultures? WCAG compliance, Universal Design principles. (WCAG 2.1/2.2, Inclusive Design)
7. **Service Blueprint & End-to-End Journey** — Is the full service ecosystem mapped? Frontstage/backstage, touchpoints, pain points, moments of truth. (Stickdorn, Polaine, Penin, Vargo & Lusch SDL)
8. **Co-Creation & Stakeholder Facilitation** — Are users and stakeholders actively involved in the design process? Participatory methods, workshop facilitation, design sprints. (Participatory Design, SDL, Design Sprints)
9. **Prototyping & Design Validation** — Fidelity progression, testability, iteration cycles, convergent/divergent evidence. (Double Diamond, Lean UX)
10. **Design System Coherence & Feasibility** — Componentization, engineering handoff quality, token architecture, scalability. For hardware: DFM, materials, cost-effectiveness. (Atomic Design, Design Tokens)

## Product Designer Knowledge Signals

Knowledge signals cluster dimensions into interpretive themes, revealing where a proposal or implementation is strongest and weakest.

- **Empathy & Research Knowledge** → dims 1, 5, 6 — depth of user understanding, research rigor, accessibility awareness
- **Craft & Interaction Knowledge** → dims 2, 3, 4 — interface quality, information architecture, visual communication
- **Systems & Service Knowledge** → dims 7, 10 — end-to-end journey thinking, design system maturity
- **Facilitation & Process Knowledge** → dims 8, 9 — co-creation methods, prototyping discipline

## Review Workflow

### 1. Ingest Input

Identify mode (proposal/implementation), artifact type (design spec, wireframe, prototype, shipped feature, service blueprint), stated goal. Determine if this is a product trio collaboration or a designer-only deliverable.

### 2. The Empathy Lens — Problem Framing & Research (Dims 1, 5, 6)

Is this meaningfully solving the user's problem, or is it an "elegant solution looking for a problem"? Evaluate persona/scenario alignment, assumption checking, empathy artifacts, research rigor, accessibility foundations. Check: Does the design account for the user's actual context (noisy room, mobile while walking, skill level)?

### 3. The Friction Lens — Interaction & IA Quality (Dims 2, 3)

Intuitiveness: Can the user understand the feature without a manual? Inelegant/arbitrary solutions: Is the workflow more awkward than it needs to be? Inconsistencies: Was a similar interaction handled differently elsewhere? Cognitive load: Does the visual hierarchy guide naturally, or is there clutter?

### 4. The Aesthetic & Brand Lens — Visual Design & Service Journey (Dims 4, 7)

How does this make the user feel? Does it reflect the brand's experience attributes? Is the visual language communicative and consistent? Is the full service journey mapped (frontstage/backstage, touchpoints, moments of truth)?

### 5. The Feasibility & Viability Lens — Accessibility, Systems & Handoff (Dims 6, 10)

Does a proposed design choice make implementation unnecessarily difficult without proportional user value? Ethical check: Are there dark patterns that serve business metrics at the expense of user trust? WCAG compliance? Design system alignment? Engineering handoff quality?

### 6. The Collaborative Critique & Testing Lens — Co-Creation & Prototyping (Dims 8, 9)

Were design crits facilitated (green round: what works / red round: concerns + suggestions)? Were prototypes tested with real users to settle debates with behavioral evidence? Fidelity progression appropriate? Is the team using evidence, not opinions?

### 7. Produce Structured Output

Write review using [references/feedback-template.md](references/feedback-template.md). Include the 10-dimension scorecard, issues by severity, strengths, top recommendation, and key question.

## Anti-Patterns

Watch for these recurring failure modes. Full details in [references/anti-patterns.md](references/anti-patterns.md).

**Critical:**

- **Pixel-Perfect Blindness** — Obsessing over visual polish while fundamental usability issues persist
- **Research Theater** — Conducting user research but ignoring findings that contradict design decisions
- **Siloed Touchpoint Design** — Designing individual screens without mapping the end-to-end service journey

**Major:**

- **Aesthetic Usability Trap** — Assuming beautiful = good without usability validation
- **Accessibility Afterthought** — Treating WCAG as a post-design checklist instead of a foundation
- **Stakeholder-Driven Design** — Internal politics override user evidence (HiPPO variant)
- **Fidelity Escalation** — Jumping to high-fidelity before validating concepts at low fidelity
- **Designer Hero Complex** — Designing in isolation without co-creation or cross-functional input
- **Journey Gap** — Missing critical transition points between channels or touchpoints
- **Component Soup** — Creating bespoke UI elements instead of extending the design system
- **Empathy Deficit** — Personas exist on paper but were never validated with real users
- **Convergence Without Divergence** — Jumping to solutions without exploring the problem space (skipping Diamond 1)
- **Dark Pattern Drift** — Interaction patterns that serve business metrics at the expense of user trust
- **Handoff Chasm** — Design specifications that engineering cannot implement as intended
- **Requirements Receiver** — Designer receives requirements from PM instead of co-driving product discovery as a product trio member
- **Opinion Over Evidence** — Design debates settled by seniority or eloquence rather than putting prototypes in front of real users
- **Focus Group Fallacy** — Asking users "do you like this?" instead of task-based observation; collecting opinions when behavioral evidence is what matters
- **Satisfaction Score Complacency** — Celebrating high CSAT/OSAT scores while ignoring that 60-80% of defectors rated themselves "satisfied"; not tracking true loyalty metrics

## Calibration

Use [references/calibration.md](references/calibration.md) for scoring anchors, framework quick references, usability heuristic checklists, UX metrics benchmarks, and design maturity spectrums.
