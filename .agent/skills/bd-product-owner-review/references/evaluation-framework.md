# Evaluation framework

Detailed scoring criteria for the 10 PO review dimensions.

## Scoring scale

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Excellent | Exceeds standards; evidence-rich, no gaps |
| 4 | Good | Meets standards with minor gaps |
| 3 | Adequate | Partially addressed; notable gaps |
| 2 | Weak | Significant gaps; requires rework |
| 1 | Missing | Not addressed or fundamentally flawed |

## Dimension 1: Strategic alignment

**Proposal questions**: Does the work trace to the product vision and business objectives? Can the PO articulate which OKR or strategic goal this item supports? Is innovation portfolio balance considered (sustaining vs adjacent vs disruptive, e.g. 70/20/10)? Is the PO aware of performance oversupply risk — over-engineering for current customers while ignoring disruptive opportunities?

**Implementation-Compliance questions**: Was strategic justification documented before building? Did the item serve the stated vision at build time?

**Implementation-Results questions**: Does it still serve the current vision? Has strategy shifted since delivery? Is the feature consuming resources that could serve higher-priority objectives?

**Scoring**: 5 = directly traces to vision/OKRs, portfolio balance considered, explicit trade-offs documented; 3 = loosely connected to strategy, no explicit traceability; 1 = no strategic justification or contradicts stated direction.

## Dimension 2: Value maximization

**Proposal questions**: Is the team delivering the highest-value items first? Is there a prioritization rationale beyond gut feel? Is there a check for sustaining-only bias — all resources going to high-margin features while starving disruptive opportunities? For disruptive items, has the target market been identified (fringe/emerging, not forced into mainstream)?

**Implementation-Compliance questions**: Was the item prioritized using a named framework? Was value ordering justified?

**Implementation-Results questions**: Did the delivered value match the prediction? Would a different ordering have delivered more value? Was the cost-of-delay estimate accurate?

**Scoring**: 5 = named framework applied (WSJF, RICE, ROI Scorecard), value-effort ratio calculated, sustaining/disruptive balance checked; 3 = some rationale but informal or gut-feel ordering; 1 = FIFO backlog, no prioritization rationale.

## Dimension 3: Customer empathy and advocacy

**Proposal questions**: Is the work grounded in observed user pain or behavior? Or is it a feature request taken at face value? Has the PO talked to actual users? Can they articulate the job to be done? Are customers being used as co-discoverers or treated as requirement sources?

**Implementation-Compliance questions**: Was customer evidence gathered before building? Did the PO observe behavior, not just collect requests?

**Implementation-Results questions**: Does post-launch data confirm the user pain was real? Are users engaging in ways that indicate the problem is being solved?

**Scoring**: 5 = behavioral observation + quantitative data from real users, clear JTBD articulated; 3 = some interviews but thin evidence or request-driven; 1 = no customer contact, feature request taken at face value.

## Dimension 4: Backlog quality and readiness

**Proposal questions**: Do items meet INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable)? Is the Definition of Ready satisfied? Was Three Amigos conducted before sprint entry with all three perspectives — PO asks "what problem does this solve?", Dev asks "how do we build it?", QA asks "what could go wrong?" Was shared understanding confirmed? For high-uncertainty items: was the right tool chosen? Spikes are for when the team needs to learn (estimation blockers, technical feasibility, story breakdown, org risk) — they are time-boxed, have AC, and produce knowledge, not shippable code. Prototypes are for customer validation (desirability, usability, option exploration) — paper sketches, wireframes, or clickable mockups tested with real users. Feasibility prototypes overlap both (spike + throwaway code to test a technical approach). Was the tool matched to the risk type?

**Implementation-Compliance questions**: Were items ready before they entered the sprint? Were INVEST violations caught during grooming?

**Implementation-Results questions**: Did unready items cause mid-sprint disruption? Were stories split properly? Did the team deliver what was planned?

**Scoring**: 5 = INVEST-compliant, DoR met, Three Amigos conducted with all 3 perspectives, spikes/prototypes used appropriately for unknowns; 3 = partially ready, some criteria missing, Three Amigos skipped or perfunctory; 1 = items pulled into sprint with vague descriptions, no sizing, no AC, no shared understanding.

## Dimension 5: Acceptance criteria and done

**Proposal questions**: Are AC specific, pass/fail testable statements? Were they produced collaboratively in Three Amigos, not dictated by the PO? Are they based on concrete examples, not abstract models? Do they use Given/When/Then format? Do they cover business rules, boundary conditions, and what users *cannot* do (not just happy path)? Do they cover all value attribute categories — Operations, Information, Performance, Non-functional (usability, security, scalability, reliability)? Is there a clear distinction between AC (specific to this PBI: behavior, rules) and DoD (overarching quality standards: unit tests, code review %, architecture compliance, API docs, stakeholder sign-off)? Were edge cases identified by the QA perspective?

**Implementation-Compliance questions**: Were AC defined before building? Were they collaboratively written? Is DoD satisfied?

**Implementation-Results questions**: Did the delivered increment meet all AC? Were AC sufficient to catch defects? Did DoD hold, or were quality shortcuts taken?

**Scoring**: 5 = AC collaboratively produced from concrete examples, Given/When/Then, covers happy path + boundaries + negative cases + non-functional, clear AC/DoD distinction, edge cases identified; 3 = AC exist but are vague or PO-dictated, missing boundary conditions; 1 = no AC, or untestable statements like "search should work well."

## Dimension 6: Stakeholder management and conflict resolution

**Proposal questions**: Has stakeholder mapping been done (Influence/Interest matrix, RACI) to identify power and interest before engaging? Is the PO using shuttle diplomacy (1-on-1s using GROW: Goals, Reality, Options, Way forward) before group sessions? Is outcome-shifting used ("why is that important?") to uncover the root problem behind requests? Are objective frameworks used to resolve conflicts (ROI Scorecard, Kano Model, Vision vs Survival)? Is data used as an "outside arbitrator" to break deadlocks (quick tests, prototypes, feature stubs)? Does the PO show their work via visual artifacts (Opportunity Solution Tree, Story Map, Kanban)? Are independent judgments collected before open discussion (written feedback before anyone speaks)? Is structured facilitation used (dot-voting, ranking exercises)? Were key stakeholders pre-socialized via 1-on-1s before group reviews? Does the PO defer to expertise (tech lead for architecture, designer for UX) rather than building consensus?

**Implementation-Compliance questions**: Were conflicting demands resolved before reaching the team? Was stakeholder mapping conducted?

**Implementation-Results questions**: Did stakeholder conflicts cause mid-sprint scope changes? Was the team shielded from politics?

**Scoring**: 5 = stakeholder map done, shuttle diplomacy used, conflicts resolved with data and frameworks, team shielded, defers to expertise; 3 = some stakeholder management but reactive, conflicts sometimes reach the team; 1 = no stakeholder mapping, team exposed to conflicting demands, HiPPO decides.

## Dimension 7: Feasibility-viability-desirability balance

**Proposal questions**: Did the Product Triad (PO + Designer + Tech Lead) collaborate on this? Is the PO focused on "What" while the team owns "How"? Were engineers integrated into discovery early (not first seeing ideas at sprint planning)? Were feasibility prototypes or spikes conducted for uncertain solutions? Has the Desirability-Feasibility-Viability three-lens test been applied?

**Implementation-Compliance questions**: Was the Product Triad involved from discovery? Were feasibility concerns addressed before committing?

**Implementation-Results questions**: Were there late feasibility surprises? Did viability assumptions hold? Is the feature desirable in practice?

**Scoring**: 5 = Product Triad collaborated from discovery, DFV test applied, spikes/prototypes for unknowns, engineers heard customer pain directly; 3 = some collaboration but PO estimated feasibility alone or engineering joined late; 1 = no triad collaboration, feasibility not assessed until sprint planning.

## Dimension 8: Scope control and prioritization

**Proposal questions**: Is scope bounded? Can the PO articulate what is out of scope and why? Is a named framework used (WSJF/Cost of Delay, MoSCoW, ROI Scorecard, Kano, DFV, RICE = Reach x Impact x Confidence / Effort, Opportunity Scoring = Importance x (1 - Satisfaction), Buy a Feature, Vision vs Survival)? For ROI: is value scored on a ratio scale? Is effort cross-functional (dev + docs + training + marketing + maintenance)? Is a confidence multiplier applied for uncertainty? Is the result rank-ordered? Are frameworks used as tools to aid judgment (considering intangibles like market timing, dependencies, client promises), not as final answers? Is feature chunking applied (must-haves + one differentiator)? For MVPs: is an MVS defined (narrow target, not "everyone")? Is "minimum" about scope, not quality (viable = reliable, usable, delightful)? Is the MVP format matched to the risk type (landing page, concierge, Wizard of Oz, single use case)? Is a 3x3 grid (High/Med/Low Value x Effort) acceptable when precise scoring is not feasible?

**Implementation-Compliance questions**: Was scope documented and held? Were mid-sprint additions handled with trade-offs?

**Implementation-Results questions**: Did scope creep occur? Was the delivered scope appropriate for the value delivered?

**Scoring**: 5 = named framework, bounded scope, ROI rigor with cross-functional effort and confidence multiplier, MVP scoped to narrow target, PO says "no" with rationale; 3 = some scope management but no formal framework, informal trade-offs; 1 = unbounded scope, no prioritization, PO accepts everything.

## Dimension 9: Outcome measurement

**Proposal questions**: Are success metrics defined across four categories?
1. **Engagement/Traction** — Feature Usage Rate, Adoption Rate, DAU/MAU, Stickiness (DAU/MAU ratio), Actions per Session, Task Completion Rate
2. **Satisfaction/Sentiment** — NPS, CSAT, CES
3. **Business/Strategic** — Retention Rate, Churn Rate, Conversion Rate, ARPU, CLTV/LTV, CAC
4. **Operational Quality (Guardrails)** — Escaped Defects, Defect Density, Performance (latency, uptime, crashes)

Are strategic frameworks applied (HEART: Happiness, Engagement, Adoption, Retention, Task Success; or AARRR: Acquisition, Activation, Retention, Revenue, Referral)? Are leading indicators (team-controlled, measurable quickly — e.g. first-week engagement, activation rate) paired with lagging indicators (cross-department, months to measure — e.g. retention, revenue)? Is there a causal hypothesis linking leading to lagging ("early engagement predicts retention because X")? Are team/sprint goals assigned as leading indicators? Are mutually destructive pairs defined (e.g. conversion + retention, speed + quality) to prevent gaming?

**Implementation-Compliance questions**: Were metrics defined before building? Do they cover all four categories?

**Implementation-Results questions**: Are metrics being tracked? Are leading indicators predicting lagging results? Are guardrail pairs holding?

**Scoring**: 5 = metrics across all 4 categories, leading/lagging paired with causal hypothesis, guardrail pairs defined, framework applied (HEART/AARRR); 3 = some metrics but only one category, no leading/lagging distinction; 1 = no metrics defined, or only "stories shipped" tracked.

## Dimension 10: Iterative learning and feedback

**Proposal questions**: Is sprint review planned as a feedback session, not a demo? Is inspect-and-adapt built into the process? For uncertain or disruptive items: are plans framed as "plans to learn" (discovery-driven), not "plans to execute"? Are cheap, fast experiments planned to test assumptions? If an MVP is proposed, are testable hypotheses articulated? Is "currency" defined to measure real commitment (money, email, time — not vanity metrics)? Is a Build-Measure-Learn cycle planned (persevere, iterate, or pivot based on data)?

**Implementation-Compliance questions**: Was sprint review feedback captured? Did it influence the next iteration?

**Implementation-Results questions**: Is the team learning from delivery data? Are pivots or iterations based on evidence? Is the PO adapting the backlog based on what was learned?

**Scoring**: 5 = sprint review captures actionable feedback, backlog updated based on data, BML cycle for uncertain items, testable hypotheses with defined currency; 3 = reviews happen but feedback is not systematically captured or acted on; 1 = no feedback loops, ship and forget pattern.

## Dimension weighting guide

Default weighting is equal (all dimensions scored 1-5, summed to /50). Adjust emphasis by input type:

| Input Type | Higher Weight Dimensions | Lower Weight Dimensions |
|-----------|------------------------|------------------------|
| New PBI | Backlog Quality, AC & Done, Customer Empathy | Outcome Measurement (not yet measurable) |
| Sprint Plan | Value Maximization, Scope Control, Backlog Quality | Iterative Learning (no delivery yet) |
| Delivered Increment | Outcome Measurement, Iterative Learning, AC & Done | Backlog Quality (already past that gate) |
| Backlog Health Check | Backlog Quality, Value Maximization, Strategic Alignment | Feasibility-Viability-Desirability (item-level concern) |
| Stakeholder Request | Stakeholder Management, Customer Empathy, Scope Control | Iterative Learning (request stage) |

Weighting adjusts emphasis in the rationale, not the scoring scale. All dimensions still receive a 1-5 score.

## Verdict thresholds

### Proposal reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Proceed** | 42-50 | Strong across all dimensions; ready to build |
| **Proceed with Conditions** | 27-41 | Viable but gaps need addressing before or during build |
| **Rework Required** | 0-26 | Fundamental gaps; return to refinement |

### Implementation reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Meets Standards** | 42-50 | Well-executed; outcomes being achieved |
| **Needs Improvement** | 27-41 | Functional but significant gaps to address |
| **Critical Gaps** | 0-26 | Fundamental issues; remediation plan needed |

### Critical dimension rules

Regardless of total score:
- Any dimension scoring 1 = cannot receive "Proceed" or "Meets Standards" verdict
- Backlog Quality + AC & Done both scoring 2 or below = automatic "Rework Required" / "Critical Gaps"
