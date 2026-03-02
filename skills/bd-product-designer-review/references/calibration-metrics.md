# Product Designer Review — Calibration Reference: UX Metrics & Team Practices

UX metrics, measurement frameworks, and team practices for calibrating implementation reviews. See [calibration-frameworks.md](calibration-frameworks.md) for scoring framework references.

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
