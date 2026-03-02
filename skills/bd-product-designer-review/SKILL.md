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

**Platform-specific interpretation**: When the target platform is known (CLI, Web, Mobile, IDE Plugin, Desktop, API), interpret each dimension through that platform's lens and apply platform-specific weighting. See [references/platform-overview.md](references/platform-overview.md) for per-platform dimension interpretation tables, complexity checklists, and anti-patterns.

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

**Identify the target platform**: CLI / Web / Mobile / IDE Plugin / Desktop / API / Multi-platform. If not stated, infer from context or review generically. For identified platforms, load the corresponding platform file from [references/platform-overview.md](references/platform-overview.md) — note platform complexity (e.g., "Mobile" → which screen sizes? Foldables? OEM targets? Tablet support?). For ambiguous cases, use the Platform Classification Guide. For multi-platform products, identify the primary platform and flag secondary platform gaps.

### 2. The Empathy Lens — Problem Framing & Research (Dims 1, 5, 6)

Is this meaningfully solving the user's problem, or is it an "elegant solution looking for a problem"? Evaluate persona/scenario alignment, assumption checking, empathy artifacts, research rigor, accessibility foundations. Check: Does the design account for the user's actual context (noisy room, mobile while walking, skill level)?

**Platform**: For CLI, is the user's terminal environment considered (width, color support, CI vs interactive)? For Mobile, are diverse device contexts evaluated (foldables, small phones, tablets, one-handed use)? For API, is the developer's integration context understood (language, framework, existing toolchain)?

### 3. The Friction Lens — Interaction & IA Quality (Dims 2, 3)

Intuitiveness: Can the user understand the feature without a manual? Inelegant/arbitrary solutions: Is the workflow more awkward than it needs to be? Inconsistencies: Was a similar interaction handled differently elsewhere? Cognitive load: Does the visual hierarchy guide naturally, or is there clutter?

**Platform**: For CLI, evaluate command ergonomics, composability, and discoverability via `--help`. For Mobile, touch targets (44pt/48dp), thumb zones, and gesture conventions. For Web, responsive behavior across breakpoints and Core Web Vitals. For IDE Plugin, Command Palette discoverability and non-disruptive interaction.

### 4. The Aesthetic & Brand Lens — Visual Design & Service Journey (Dims 4, 7)

How does this make the user feel? Does it reflect the brand's experience attributes? Is the visual language communicative and consistent? Is the full service journey mapped (frontstage/backstage, touchpoints, moments of truth)?

**Platform**: For CLI, terminal output formatting and NO_COLOR support. For IDE Plugin, host theme integration (dark/light/high contrast). For Desktop, OS-native visual language (Fluent Design on Windows, HIG on macOS). For Mobile, platform-specific visual conventions (HIG vs Material 3) and dark mode support.

### 5. The Feasibility & Viability Lens — Accessibility, Systems & Handoff (Dims 6, 10)

Does a proposed design choice make implementation unnecessarily difficult without proportional user value? Ethical check: Are there dark patterns that serve business metrics at the expense of user trust? WCAG compliance? Design system alignment? Engineering handoff quality?

**Platform**: For Mobile, OEM fragmentation and OS version support scope. For Web, cross-browser compatibility (Blink/WebKit/Gecko). For Desktop, native vs cross-platform framework tradeoffs (Electron vs Tauri vs native). For API, SDK language coverage and backward compatibility.

### 6. The Collaborative Critique & Testing Lens — Co-Creation & Prototyping (Dims 8, 9)

Were design crits facilitated (green round: what works / red round: concerns + suggestions)? Were prototypes tested with real users to settle debates with behavioral evidence? Fidelity progression appropriate? Is the team using evidence, not opinions?

**Platform**: For API/DX, developer community feedback and time-to-first-call testing with real developers. For CLI, shell completion testing and observation in real terminal workflows (interactive + scripted). For Mobile, on-device prototype testing (not desktop emulators) across diverse devices.

### 7. Produce Structured Output

Write review using [references/feedback-template.md](references/feedback-template.md). Include the 10-dimension scorecard, issues by severity, strengths, top recommendation, and key question.

## Anti-Patterns

Watch for these recurring failure modes. Full details in [references/anti-patterns.md](references/anti-patterns.md). Platform-specific anti-patterns (30 total across 6 platforms) are indexed in the anti-patterns reference and detailed in [references/platform-overview.md](references/platform-overview.md).

**Critical:**

- **Pixel-Perfect Blindness** — Obsessing over visual polish while fundamental usability issues persist
- **Research Theater** — Conducting user research but ignoring findings that contradict design decisions
- **Siloed Touchpoint Design** — Designing individual screens without mapping the end-to-end service journey

**Major** (15 total — Aesthetic Usability Trap, Accessibility Afterthought, Stakeholder-Driven Design, and 12 more): See [references/anti-patterns.md](references/anti-patterns.md) for full list with descriptions.

## Calibration

Use [references/calibration-frameworks.md](references/calibration-frameworks.md) for scoring anchors, framework quick references, usability heuristic checklists, and design maturity spectrums. For UX metrics and measurement benchmarks, see [references/calibration-metrics.md](references/calibration-metrics.md). For platform-specific calibration anchors (levels 5/3/1 for top-weighted dimensions per platform) and quantitative standards (Mobile touch targets, CLI exit codes), see [references/platform-calibration.md](references/platform-calibration.md).
