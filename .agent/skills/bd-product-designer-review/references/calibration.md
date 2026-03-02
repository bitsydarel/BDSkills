# Product Designer Review — Calibration Reference

Scoring anchors, framework quick references, and maturity spectrums for consistent evaluation.

## Usability Quality Spectrum

| Level | Description | Signal |
|-------|-------------|--------|
| 5 — Validated & Optimized | All 10 heuristics satisfied; task-based testing confirms; SUS > 80; continuous improvement | Industry-leading practice |
| 4 — Tested & Refined | Most heuristics met; usability testing conducted and acted on; SUS 68-80 | Solid practice |
| 3 — Heuristic-Aware | Basic heuristic compliance; limited testing; SUS 50-68 | Acceptable minimum |
| 2 — Ad Hoc Usability | Multiple violations; no systematic testing; SUS < 50 | Below standard |
| 1 — No Usability Practice | No heuristic awareness; no testing; fundamental interaction flaws | Unacceptable |

## Nielsen's 10 Usability Heuristics Quick Reference

| # | Heuristic | Strong Signal | Weak Signal |
|---|-----------|---------------|-------------|
| 1 | Visibility of System Status | User always knows what's happening; loading states, progress indicators, real-time feedback | Users unsure if action worked; no feedback on state changes |
| 2 | Match Between System and Real World | Uses familiar language and concepts; follows real-world conventions | Jargon, technical terminology; system-centric rather than user-centric language |
| 3 | User Control and Freedom | Easy undo/redo; clear exits; no trapped states | Irreversible actions; no way to go back; forced linear flows |
| 4 | Consistency and Standards | Platform conventions followed; similar actions behave similarly | Same action different behavior in different places; custom patterns without justification |
| 5 | Error Prevention | Constraints prevent invalid input; confirmation for destructive actions | Users frequently make errors; no guardrails; easy to accidentally delete/overwrite |
| 6 | Recognition Rather Than Recall | Visible options; contextual help; no memory burden | Users must remember codes, IDs, or previous screen info to proceed |
| 7 | Flexibility and Efficiency of Use | Shortcuts for experts; customizable; progressive complexity | One-size-fits-all; experts frustrated by mandatory steps; no accelerators |
| 8 | Aesthetic and Minimalist Design | Every element serves a purpose; visual hierarchy guides attention | Cluttered; decorative elements distract; information density too high or too low |
| 9 | Help Users Recognize, Diagnose, and Recover from Errors | Error messages explain the problem and suggest a solution; friendly tone | Cryptic error codes; blame the user; no recovery guidance |
| 10 | Help and Documentation | Contextual help where needed; searchable; task-oriented | No help; help is a PDF manual; help doesn't address actual user tasks |

## Garrett's 5 Planes of UX Quick Reference

| Plane | Focus | Strong Signal | Weak Signal |
|-------|-------|---------------|-------------|
| Strategy | User needs + business objectives | Clear alignment between user goals and business value; validated needs | No documented user needs; business objectives unstated or disconnected from users |
| Scope | Features + content requirements | Features map to validated needs; prioritized backlog; content requirements defined | Feature list driven by stakeholder wish-lists; no content strategy |
| Structure | IA + interaction design | Information architecture based on user mental models; consistent interaction patterns | Org-chart navigation; inconsistent interaction models |
| Skeleton | Navigation + interface + info design | Navigation validated through tree testing; interface elements follow conventions | Untested navigation; unconventional interface patterns without justification |
| Surface | Visual design | Visual language supports brand and guides attention; accessible color/typography | Visual design disconnected from brand; decorative without purpose |

## Cooper's Goal-Directed Design Quick Reference

| Element | Description | Strong Signal | Weak Signal |
|---------|-------------|---------------|-------------|
| Personas | Research-based user archetypes | Behavioral personas with goals, mental models, and validated context of use | Demographic profiles or marketing segments used as design personas |
| Goals | What users want to achieve | Design organized around user goals (life goals, experience goals, end goals) | Design organized around features or business requirements |
| Scenarios | Narratives of use | Context-rich task scenarios drive design decisions; edge cases explored | No scenarios; design based on feature list |

## Service Blueprint Quality Spectrum

| Level | Description | Signal |
|-------|-------------|--------|
| 5 — Fully Validated Cross-Channel Blueprint | All touchpoints mapped (frontstage + backstage); transitions designed; validated with users and operations teams; moments of truth measured | Comprehensive |
| 4 — Multi-Channel Blueprint | Frontstage and backstage mapped; key transitions designed; some operational validation | Strong practice |
| 3 — Frontstage Journey Map | Customer journey mapped but limited to frontstage; backstage implied not documented | Partial |
| 2 — Fragmented Journey Awareness | Some awareness of journey stages; no formal mapping; individual screens designed in isolation | Insufficient |
| 1 — No Journey Thinking | No journey map; no service awareness; screen-level design only | Absent |

## Stickdorn's 5 Service Design Principles

| Principle | Description | Strong Signal | Weak Signal |
|-----------|-------------|---------------|-------------|
| User-Centred | Design based on genuine understanding of users | Services designed from user perspective; validated through research | Service reflects org structure; users adapt to internal processes |
| Co-Creative | All stakeholders involved in design | Users, employees, and partners co-create the service | Design imposed top-down without stakeholder input |
| Sequencing | Visualized as sequences of interrelated actions | Service choreographed as a coherent sequence; pacing and rhythm considered | Random collection of touchpoints; no sense of flow |
| Evidencing | Intangible services made tangible through physical evidence | Service moments made tangible (confirmation emails, status updates, physical tokens) | Invisible service; users can't tell what happened or what will happen next |
| Holistic | Full context of the service considered | End-to-end service ecosystem designed including edge cases | Only the "happy path" designed; no consideration of failure modes |

## Double Diamond Quick Reference

| Phase | Mode | Purpose | Strong Signal | Weak Signal |
|-------|------|---------|---------------|-------------|
| Discover | Diverge | Research broadly; understand the problem space | Contextual inquiry, user interviews, competitive analysis, data analysis conducted | Problem assumed known; no exploration |
| Define | Converge | Synthesize insights; frame the problem | Problem statement validated with evidence; How Might We questions articulated | Solution proposed without problem definition |
| Develop | Diverge | Generate multiple solution concepts | 3+ concepts explored; prototypes of different approaches; brainstorming sessions | Single solution developed from the start |
| Deliver | Converge | Refine, test, and ship | Iterative testing; evidence-driven refinement; convergent evidence from multiple rounds | Ship first concept without refinement |

## WCAG Compliance Levels

| Level | Coverage | Practical Guidance |
|-------|----------|-------------------|
| A | Minimum | Basic accessibility — essential for any product; removes the most severe barriers |
| AA | Standard | Industry standard target — addresses the most common accessibility barriers; required by most regulations |
| AAA | Advanced | Best-in-class — not always achievable for all content but should be targeted for critical flows |

**Key checkpoints**: Color contrast (4.5:1 text, 3:1 large text for AA), keyboard navigation, screen reader semantics (ARIA), focus management, alternative text, motion/animation controls, form labeling, error identification.

## Design System Maturity Model

| Level | Description | Signal |
|-------|-------------|--------|
| 5 — Fully Governed Living System | Centralized team; contribution model; versioning; token architecture; analytics on component usage; regular audits | Industry-leading (e.g., Airbnb DLS, Spotify Encore) |
| 4 — Managed System | Documented component library; design tokens; some governance; engineering alignment | Strong practice |
| 3 — Emerging System | Shared component library exists; inconsistent adoption; limited governance | Developing |
| 2 — Pattern Library | Some shared patterns; fragmented ownership; no tokens; inconsistent usage | Early stage |
| 1 — No System | Every project creates bespoke components; no shared vocabulary; no reuse | Absent |

## Prototype Fidelity Progression

| Fidelity | Medium | When to Use | Purpose |
|----------|--------|-------------|---------|
| Paper / Sketches | Hand-drawn on paper or whiteboard | Earliest exploration; brainstorming; concept validation | Test fundamental concepts and flows cheaply; encourage divergent thinking |
| Wireframes | Low-fi digital (Balsamiq, Figma wireframe) | Structure and IA validation; content hierarchy | Test layout, IA, and flow without visual design distraction |
| Interactive Prototype | Clickable flows (Figma, Axure) | Usability testing; task-based validation | Observe real task completion; test interaction patterns |
| High-Fidelity Prototype | Pixel-perfect with real content | Final validation before build; stakeholder buy-in | Test visual design, microinteractions, and brand expression |
| Production Prototype | Coded prototype in target technology | Technical feasibility; performance validation | Test real-world performance, responsiveness, accessibility |

## Research Method Selection Matrix

| Method | Type | Best For | Fidelity Stage | Sample Size |
|--------|------|----------|----------------|-------------|
| Contextual Inquiry | Qualitative | Understanding context of use, workflows, pain points | Pre-design | 5-15 users |
| User Interviews | Qualitative | Goals, motivations, mental models, past experiences | Pre-design / Low-fi | 5-12 users |
| Card Sorting | Qualitative | Information architecture, mental models, labeling | Wireframe | 15-30 users |
| Tree Testing | Quantitative | IA findability validation | Wireframe | 50+ users |
| Task-Based Usability Test | Qualitative | Interaction quality, task flows, error discovery | Interactive+ | 5-8 users per round |
| Think-Aloud Protocol | Qualitative | Real-time cognitive process during task completion | Interactive+ | 5-8 users |
| A/B Testing | Quantitative | Comparing design alternatives at scale | Production | 1000+ users |
| Survey (SUS, NPS, CES) | Quantitative | Satisfaction, usability scoring, effort measurement | Post-launch | 100+ users |
| Diary Study | Qualitative | Longitudinal behavior, habit formation, context shifts | Post-launch | 10-20 users |
| Eye Tracking | Quantitative | Visual attention, hierarchy effectiveness | High-fi+ | 20-40 users |

## Vargo & Lusch Service-Dominant Logic Core Premises

| Premise | Relevance to Design |
|---------|-------------------|
| Service is the fundamental basis of exchange | Products are vehicles for service; design the service, not just the artifact |
| The customer is always a co-creator of value | Value emerges through use, not through delivery; design for participation |
| All economic and social actors are resource integrators | Design must account for the ecosystem of actors (not just end user) |
| Value is always uniquely determined by the beneficiary | Users determine value in their context; designers cannot prescribe value |

## Usability Testing Quality Spectrum

| Level | Description | Signal |
|-------|-------------|--------|
| 5 — Systematic Program | Weekly testing cadence; product trio observes together; think-aloud protocol; same-day iteration; findings traced to design decisions | Industry-leading |
| 4 — Regular Think-Aloud Testing | Regular usability sessions; think-aloud protocol used; representative users; findings documented and acted on | Strong practice |
| 3 — Task-Based Observation | Some task-based testing conducted; findings exist but not systematically acted on | Acceptable |
| 2 — Focus Group Opinions | Users asked "do you like this?" not observed doing tasks; opinions collected, not behavior | Insufficient — Focus Group Fallacy |
| 1 — No Testing | No user testing at all; design based entirely on team assumptions | Absent |

## Usability Risk Mitigation Maturity

| Practice | Level 1 (Absent) | Level 3 (Emerging) | Level 5 (Mature) |
|----------|-------------------|---------------------|-------------------|
| Building Prototypes | No prototypes; straight to code | Some prototyping; single fidelity | Dozens per week; fidelity progression; rapid exploration |
| Task-Based Testing | No testing | Some observation; limited scope | Weekly cadence; think-aloud; representative users |
| Rapid Iteration | Waterfall handoff | Some iteration between testing rounds | Hypothesize-Design-Test-Learn same-day; fail early |
| Empathy Research | No user contact | Occasional interviews | Ongoing contextual inquiry; validated personas; journey maps |
| Collaborative Learning | Designer works alone | PM sees research reports | Product trio observes users together; shared evidence base |

## Persona Quality Spectrum

| Level | Description | Characteristics |
|-------|-------------|-----------------|
| Label | Name/role only | "Power User," "New User" — no depth or differentiation |
| Demographic | Statistical profile | Age, gender, income, location — useful for marketing, not design |
| Behavioral | Actions and patterns | What users do, how they do it, frequency and context of use |
| Goals & Mental Models | Motivations and cognition | What users want to achieve, how they think the system works, their skills and knowledge |
| Journey-Mapped & Validated | Full context with evidence | All above + journey mapped, validated through user interviews, updated with new evidence |

## Physical Context Checklist

Consider whether the design has been evaluated for these real-world usage contexts:

- **No connectivity** — offline mode, sync when reconnected, graceful degradation
- **Noisy environment** — cannot rely on audio feedback; visual and haptic alternatives needed
- **Accessibility constraints** — visual (screen reader, magnification), motor (switch control, voice), cognitive (clear language, predictable patterns)
- **Device limitations** — small screen, slow processor, limited storage, old OS version
- **Gloved operation** — larger touch targets, no fine-motor gestures required
- **Bright sunlight** — sufficient contrast, no reliance on subtle color differences
- **One-handed use** — reachable interactive elements, no mandatory two-hand gestures
- **Distracted/interrupted use** — state preservation, easy re-orientation, forgiving of slips

## Design Crit Framework

Structured collaborative critique format used by teams (Meta, Airbnb, Spotify):

| Round | Purpose | Facilitator Guidance |
|-------|---------|---------------------|
| **Green Round** | Identify what works well | "What aspects of this design are effective and why?" — build on strengths before critiquing |
| **Red Round** | Surface concerns with constructive suggestions | "What concerns do you have, and what alternative would you suggest?" — never critique without offering direction |

**Key rules**: Reiterate the problem before showing work. Best feedback is inquisitive, not prescriptive — ask questions, don't prescribe solutions. 15-30 min blocks per presenter. 3 roles: Presenter, Audience, Facilitator.

## Product Trio Collaboration Model

| Role | Primary Accountability | Integration Points |
|------|----------------------|-------------------|
| **Product Manager** | Value (is this worth building?) + Viability (can the business sustain it?) | Discovery scope, success metrics, business constraints, prioritization |
| **Tech Lead / Engineering** | Feasibility (can we build it?) | Technical constraints, architecture, implementation cost, performance |
| **Product Designer** | Usability (can users figure out how to use it?) | User evidence, interaction design, prototyping, research, testing |

**Healthy trio signal**: All three participate in discovery from inception; debates settled by putting prototypes in front of users; shared accountability for product outcomes.

**Unhealthy trio signal**: Designer receives requirements after PM decides; engineering sees designs only at handoff; usability testing is "designer's job" not a shared activity.

## The 5 Designer Review Lenses Quick Reference

| Lens | Focus | Primary Dimensions | Key Question |
|------|-------|--------------------|-------------|
| **Empathy** | Problem framing, research, accessibility | 1, 5, 6 | Is this meaningfully solving the user's problem? |
| **Friction** | Interaction quality, information architecture | 2, 3 | Can the user understand and complete the task without a manual? |
| **Aesthetic & Brand** | Visual design, service journey | 4, 7 | How does this make the user feel? Does it express the brand? |
| **Feasibility & Viability** | Accessibility, design system, handoff | 6, 10 | Is implementation proportional to user value? Any dark patterns? |
| **Collaborative Critique** | Co-creation, prototyping | 8, 9 | Has the team tested with real users, not just internal opinions? |

## UX Metrics Reference

### Performance Metrics (Behavioral)

| Metric | Description | Benchmark Guidance |
|--------|-------------|-------------------|
| **Task Success Rate** | Binary (pass/fail) or levels (complete/partial/fail); percentage of users completing core tasks | > 85% for critical tasks; < 70% indicates usability problems |
| **Time on Task** | Seconds/minutes to complete a defined task | Compare to benchmarks or prior versions; focus on trends, not absolutes |
| **Error Rate** | Number of errors per task or per session | < 5% for critical flows; any error on destructive actions is serious |
| **Efficiency / Lostness** | Deviation from optimal path (extra clicks, pages, backtracks) | Low lostness = clear IA; high lostness = navigation or labeling problems |
| **Learnability** | Improvement in task metrics over repeated uses | Task time should decrease 30-50% by 3rd use for learnable interfaces |

### Self-Reported Metrics (Attitudinal)

| Metric | Scale | Benchmark | Notes |
|--------|-------|-----------|-------|
| **SUS (System Usability Scale)** | 0-100 (10 questions) | 68 = average; > 80 = good; > 90 = excellent | Industry standard; compare across versions |
| **NPS (Net Promoter Score)** | -100 to +100 (0-6 Detractors, 7-8 Passives, 9-10 Promoters) | > 0 = more promoters than detractors; > 50 = excellent | Passives are vulnerable — don't conflate with loyalty |
| **CES (Customer Effort Score)** | 1-5 or 1-7 | Lower = better; aim for < 2 on critical tasks | Effort predicts churn better than satisfaction |
| **SEQ (Single Ease Question)** | 1-7 post-task | > 5.5 = easy; < 4.5 = needs attention | Quick per-task difficulty gauge |
| **ASQ (After Scenario Questionnaire)** | 1-7 (3 questions: ease, time, support) | > 5 average across all three | Captures multi-dimensional task perception |
| **Product Reaction Cards** | 118 adjectives; users select 5 that best describe the experience | Compare selected adjectives against target brand attributes | Qualitative + quantitative; maps emotional response to brand goals |

### Behavioral / Physiological

| Metric | What It Measures | When to Use |
|--------|-----------------|-------------|
| **Eye Tracking — Dwell Time** | How long users look at specific elements | Visual hierarchy effectiveness; ad/CTA visibility |
| **Eye Tracking — Time to First Fixation** | How quickly users notice a target element | Discoverability; attention design; IA placement |
| **Eye Tracking — Hit Ratio** | Percentage of users who fixate on a target element | Critical element visibility (errors, warnings, CTAs) |
| **Verbal Expression Ratio** | Positive vs. negative expressions during think-aloud | Emotional response to interaction quality |

### Combined Metrics

| Metric | Description | Use Case |
|--------|-------------|----------|
| **SUM (Single Usability Metric)** | Weighted composite of task success, time, errors, and satisfaction | Track overall usability across releases; single trend line |
| **Retention Rate / Curve** | Percentage of users who return over time periods (Day 1, 7, 30, 90) | Long-term product-market fit; should stabilize, not decline |
| **Conversion / Drop-off Rates** | Funnel completion at each step; where users abandon | Identify friction bottlenecks; prioritize design fixes |

## HEART Framework Quick Reference (Google)

User-centric UX evaluation model. Contrasts with business-centric AARRR by centering the user experience.

| Dimension | Key Metrics | Design Focus |
|-----------|------------|--------------|
| **Happiness** | NPS, CSAT, OSAT, CES, Product Reaction Cards | Emotional response and satisfaction; does the experience feel good? |
| **Engagement** | DAU, MAU, session duration, page views, stickiness (DAU/MAU), bounce rate | Involvement level; are users actively engaged or passive? |
| **Adoption** | Conversion rates, new user activation, feature adoption rate | Onboarding quality; can new users get started successfully? |
| **Retention** | Retention rate, churn rate, activity over time periods (7/30/90 day) | Long-term loyalty; do users keep coming back? |
| **Task Success** | Task completion rate, time on task, error rate, SUM | Functional usability; can users accomplish their goals? |

For each: define Goals → map to Signals (measurable metrics) → monitor regularly → pinpoint bottlenecks → iterate.

## AARRR Pirate Metrics Quick Reference

Business-centric growth model. Design implications for each stage:

| Stage | Business Question | Design Implication |
|-------|------------------|-------------------|
| **Acquisition** | How do users find us? | First impression design; landing page clarity; value proposition visibility |
| **Activation** | Do users have a good first experience? | Onboarding flow quality; time-to-value; "aha moment" design |
| **Retention** | Do users come back? | Habit loop design; notification strategy; engagement features |
| **Referral** | Do users tell others? | Sharing mechanisms; viral loops; word-of-mouth triggers |
| **Revenue** | Do users pay? | Pricing UX; conversion design; value communication |

## Satisfaction vs. Loyalty Reference

### The Critical Distinction

| Aspect | Satisfaction | Loyalty |
|--------|-------------|---------|
| Nature | Fleeting attitude | Durable behavior |
| Measures | Transactional adequacy ("was this interaction OK?") | Genuine commitment ("would I come back? recommend? pay more?") |
| Metrics | CSAT, OSAT | Retention Rate, NPS (Promoters), DAU/MAU Stickiness, Earned Growth Rate (EGR) |
| Prediction | Poor predictor of retention | Strong predictor of retention and advocacy |

### The Satisfaction Trap

- **60-80% of defectors** rated themselves "satisfied" before leaving
- **NPS Passives** (scoring 7-8) appear satisfied but are vulnerable to any competitive alternative
- **CSAT/OSAT** measures transactional adequacy, not relationship strength

### True Loyalty Hallmarks

- **Endurance**: Stays through hard times (outages, price increases, service failures)
- **Advocacy**: Voluntarily refers others; co-brands their reputation with the product
- **Superior Economics**: Consolidates purchases; less price-sensitive; higher lifetime value

### Scoring Signal

- **Strong**: Team tracks loyalty metrics (retention, stickiness, EGR) alongside satisfaction; distinguishes Promoters from Passives
- **Weak**: Team relies solely on CSAT/OSAT and declares success; does not track retention or advocacy

## Dark Patterns Taxonomy

The 7 common dark patterns and how to detect them:

| Pattern | Description | Example | Detection Signal |
|---------|-------------|---------|-----------------|
| **Bait and Switch** | Action yields unexpected result | "X" (close) button triggers upgrade dialog | Any action that does something other than what the user expects |
| **Fake Content** | Ads or promotions disguised as real content | "Download" button that's actually an ad | Content that mimics UI elements to trick clicks |
| **Forced Continuity** | Auto-billing after trial without clear warning | Free trial → paid subscription with no reminder | No notification before trial ends; cancellation buried |
| **Friend Spam** | Harvesting contacts for mass invitations | App requests contacts, sends invites to all | Contact permission → bulk messaging without per-contact consent |
| **Misdirection** | Visual emphasis designed to distract from costs/opt-outs | Giant "Add supplies" button; tiny "No thanks" link | Asymmetric visual weight between desired action and opt-out |
| **Roach Motels** | Easy to enter, hard to exit | Sign up in 2 clicks; cancel requires phone call | Significant asymmetry between sign-up and cancellation effort |
| **Trick Questions** | Confusing language or double negatives to trick opt-ins | "Uncheck this box if you prefer not to not receive emails" | Any opt-in/out language that requires re-reading to understand |

## Dark Pattern Advocacy Toolkit

How designers fight back when pressured to implement dark patterns:

- **"Zoom Out" technique**: Show holistic harm — refund rates, support costs, churn increase, app store ratings impact, regulatory risk, reputation damage
- **Ethical persuasion alternative**: Use foot-in-the-door technique (small genuine commitment → larger commitment), genuine value before asking for commitment
- **Present counterexamples**: Use universally hated examples (LinkedIn friend spam, cable company cancellation) to create empathy for the user's experience

## Big Tech Design Review Practices

| Company | Approach | Key Practice | Framework/Tool |
|---------|----------|-------------|----------------|
| **Netflix** | Data-driven experimentation | Every change A/B tested before default rollout; random control/test groups; streaming hours + retention metrics | Experimentation platform; growth design = business × design convergence |
| **Google** | Design Sprint (5-day process) | Understand → Sketch → Decide → Prototype → Test; ≤7 people; Facilitator + Decider roles; real user testing on Day 5 | HEART framework; Sprint Academy |
| **Apple** | Codified design standards | Human Interface Guidelines (HIG) as design law; centralized design leadership; hardware + software unified | HIG; Liquid Glass design system (2025) |
| **Meta** | Formal design critique | 3 roles (Presenter, Audience, Facilitator); reiterate problem before showing work; best feedback is inquisitive, not prescriptive | Weekly critique cadence; 15-30 min per presenter |
| **Airbnb** | Design-led culture | EPIC team structure; DLS (Design Language System) for consistency; "Snow White" storyboarding for emotional journey; CEO-level "Brian Reviews" | DLS master library; 50 screens in hours; grew 35 → 600+ designers |
| **Spotify** | Principles-driven design | 3 principles (Relevant, Human, Unified) as shared critique language; Encore design system as "system of systems" (onion model); anyone can contribute | Encore; design crits; guild meetings; principles in handbook + workshops |

## Complete Product Designer Toolkit

### Tactical (Day-to-Day)

- Heuristic evaluation (Nielsen's 10)
- Task-based usability testing (think-aloud protocol)
- Wireframing and prototyping (paper → interactive → high-fi)
- Design system component usage and contribution
- Accessibility audit (automated + manual)
- Design crit facilitation (green/red rounds)
- Engineering handoff (specs, tokens, edge cases)

### Operational (Sprint/Quarter)

- Persona validation and update cycles
- Service blueprint mapping and validation
- Co-creation workshops with users and stakeholders
- Usability metric tracking (SUS, task success, error rate, SUM)
- Design system governance and contribution reviews
- Prototype iteration cadence (Hypothesize-Design-Test-Learn)
- HEART framework measurement and review

### Strategic (Product/Year)

- Design maturity assessment and growth plan
- Journey mapping across the full service ecosystem
- Design vision and principles evolution
- Product trio collaboration model optimization
- Design culture building (crit culture, shared learning)
- Loyalty metric program (retention, NPS, stickiness, EGR)
- Dark pattern audit and ethical design governance
