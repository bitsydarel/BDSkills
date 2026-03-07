# Product Designer Review — Anti-Patterns

Common failure modes in product design practice, organized by severity.

## Critical Anti-Patterns

### 1. Pixel-Perfect Blindness

**Signs**: Design reviews focus exclusively on visual polish (spacing, color, alignment) while fundamental interaction problems go unaddressed. Usability testing reveals task failure, but feedback centers on "making it look better." Team celebrates visual awards while users struggle to complete core tasks.

**Impact**: Users cannot accomplish their goals despite the product looking beautiful. High task failure rates, poor SUS scores, and increasing support tickets — all masked by positive aesthetic reactions. The most dangerous form because stakeholders conflate "looks great" with "works great."

**Fix**: Establish usability metrics (task success rate, time on task, error rate) as gating criteria before visual refinement begins. Run heuristic evaluations before visual design reviews. Make Nielsen's heuristics a mandatory checkpoint.

---

### 2. Research Theater

**Signs**: User research is conducted but findings that contradict design decisions are explained away, de-prioritized, or ignored. Research reports exist but design artifacts don't reflect their conclusions. Team says "we did research" but cannot trace specific design decisions to specific findings.

**Impact**: Wasted research investment; false confidence in design direction. Users encounter the exact problems research predicted. Trust in research erodes as the team learns that findings don't influence outcomes — researchers eventually stop surfacing uncomfortable truths.

**Fix**: Create explicit traceability from research findings to design decisions (finding → insight → design response). When research contradicts a design decision, require a documented rationale for overriding. Have the product trio observe users together so evidence is shared, not filtered.

---

### 3. Siloed Touchpoint Design

**Signs**: Each screen or feature is designed independently without mapping the end-to-end journey. No service blueprint exists. Designers own individual screens but nobody owns the transitions between them. Users experience jarring context switches between channels (web → mobile → email → support).

**Impact**: Fragmented user experience; users fall through the cracks at transition points. Support costs spike as users can't self-serve across journey stages. The product feels like a collection of features rather than a cohesive service. Journey gaps create the highest-friction moments.

**Fix**: Map the full service blueprint (frontstage + backstage) before designing individual screens. Assign ownership of transition points between touchpoints. Conduct journey-level usability testing (complete task flows, not isolated screen evaluations).

---

## Major Anti-Patterns

### 4. Aesthetic Usability Trap

**Signs**: Team assumes an attractive interface is also usable. Usability testing is skipped because "it looks good." Stakeholders approve designs based on visual appeal. Post-launch analytics show poor task metrics despite positive aesthetic feedback.

**Impact**: Aesthetic-usability effect (users initially tolerate more issues with attractive designs) masks problems temporarily, but frustration accumulates. Users churn without complaining — they just leave.

**Fix**: Separate aesthetic review from usability review. Run task-based usability testing independently of visual design approval. Track behavioral metrics (task success, error rate) alongside satisfaction scores.

---

### 5. Accessibility Afterthought

**Signs**: Accessibility is addressed as a final compliance check, not a design constraint. WCAG audit happens after development. Accessibility fixes require significant rework. Team treats accessibility as "nice to have" or "version 2."

**Impact**: Excludes users with disabilities (15-20% of population). Costly retrofitting. Legal compliance risk. Signals that the team does not practice inclusive design as a foundational principle.

**Fix**: Include accessibility in design criteria from day one. Use WCAG AA as a minimum constraint during wireframing, not a post-launch audit. Test with assistive technologies during prototype phase. Include accessibility in definition of done.

---

### 6. Stakeholder-Driven Design

**Signs**: Design decisions are overridden by the highest-paid person's opinion (HiPPO). Stakeholder preferences are treated as user needs. Design review meetings devolve into subjective preference debates. Research findings are dismissed because "the VP wants it this way."

**Impact**: Product reflects organizational politics, not user needs. Designers become order-takers, losing the ability to advocate for users. Design quality degrades to committee consensus — the worst ideas survive because nobody has authority to challenge.

**Fix**: Establish evidence-based decision-making protocols. When opinions conflict, prototype and test with users. Empower the designer's role in the product trio as the accountable owner of usability. Frame user evidence as a shared resource, not a designer's tool.

---

### 7. Fidelity Escalation

**Signs**: Team jumps straight to high-fidelity mockups or production-quality prototypes before validating the concept. Low-fidelity exploration (sketches, paper prototypes) is skipped. First prototype is pixel-perfect. Stakeholders expect polished visuals at concept stage.

**Impact**: Sunk-cost bias — once a high-fidelity design exists, the team is psychologically committed. Fundamental concept problems are expensive to address. Exploration of alternative approaches is foreclosed. Concept validation is conflated with visual refinement.

**Fix**: Enforce fidelity progression: paper/sketches → wireframes → interactive prototype → high-fidelity. Explicitly state that early-stage reviews are concept evaluations, not visual reviews. Set stakeholder expectations about fidelity stages.

---

### 8. Designer Hero Complex

**Signs**: Designer works alone, presenting finished designs to the team for approval. No co-creation with users or engineering. Design is treated as a "creative" process that requires isolation. PM and engineering see designs only when they're "ready."

**Impact**: Designs that engineering cannot feasibly implement. Solutions that don't address real user needs because users weren't involved. PM and engineering feel no ownership, reducing buy-in. Designer becomes a bottleneck and single point of failure.

**Fix**: Adopt product trio collaboration — PM, Design, and Engineering work together from discovery. Run co-creation sessions with users. Share rough work early and often. Replace designer-as-artist with designer-as-facilitator.

---

### 9. Journey Gap

**Signs**: Critical transition points between channels or journey stages are not designed. Hand-offs between web and mobile, or between automated and human-supported flows, are abrupt. Users must restart context when switching channels. No one owns the gaps between touchpoints.

**Impact**: Users experience the most friction at transition points — exactly where they're most likely to abandon. Support costs spike at hand-off moments. The product works well in isolation but fails as part of a service.

**Fix**: Map all transition points explicitly in the service blueprint. Design the handoff experience (context preservation, continuity cues, status communication). Test end-to-end journeys that span channels, not just individual screens.

---

### 10. Component Soup

**Signs**: Every new feature introduces bespoke UI elements instead of extending the design system. Designers create custom components for unique visual expression. The component library grows with redundant, overlapping elements. Engineering maintains multiple versions of similar components.

**Impact**: Inconsistent user experience — similar interactions behave differently. Increased engineering maintenance cost. Design system loses credibility as the authoritative source. New designers cannot onboard effectively because there's no coherent system to learn.

**Fix**: Default to existing design system components. Require justification for any new component. When a new pattern is needed, contribute it back to the system. Audit the existing component library quarterly for redundancies.

---

### 11. Empathy Deficit

**Signs**: Personas exist in documentation but were created from stakeholder assumptions, not user research. Empathy maps are filled with the team's projections, not user quotes. No contextual inquiry or user interviews were conducted. Personas are demographic profiles (age, gender, income) without behavioral attributes (goals, mental models, frustrations).

**Impact**: Design decisions are grounded in assumptions about users, not validated understanding. Solutions address imagined problems. The team has false confidence in user-centricity because artifacts exist, even though those artifacts aren't evidence-based.

**Fix**: Validate personas through user interviews (minimum 5-8 per persona). Ground empathy maps in direct user quotes, not team assumptions. Include behavioral attributes: goals, mental models, pain points, skills, context of use. Revisit and update personas as new evidence emerges.

---

### 12. Convergence Without Divergence

**Signs**: Team jumps directly to a solution without exploring the problem space. The first idea is developed without generating alternatives. No "how might we" exploration. Diamond 1 (Discover/Define) of the Double Diamond is skipped entirely. Team starts with "let's build X" instead of "what problem are we solving?"

**Impact**: The first solution — which is rarely the best — gets built. Better alternatives are never explored. The team optimizes a local maximum. Innovation suffers because divergent thinking is never practiced.

**Fix**: Enforce the full Double Diamond: Discover (diverge: research broadly) → Define (converge: frame the problem) → Develop (diverge: explore solutions) → Deliver (converge: refine and ship). Require at least 3 alternative concepts before converging on one.

---

### 13. Dark Pattern Drift

**Signs**: Interaction patterns subtly serve business metrics at the expense of user trust. Opt-out language uses double negatives. Unsubscribe flows require excessive steps. Free trial transitions to paid without clear warning. "Add to cart" is prominent while "No thanks" is minimized or hidden.

**Impact**: Short-term metric gains (higher conversion, lower churn) but long-term trust erosion. Increased support contacts, refund requests, and negative reviews. Regulatory risk (FTC, GDPR dark pattern enforcement). Reputational damage that compounds over time.

**Fix**: Audit all interaction patterns against the 7 dark pattern categories (Bait and Switch, Fake Content, Forced Continuity, Friend Spam, Misdirection, Roach Motels, Trick Questions). Apply the "zoom out" technique: show the holistic harm including support costs, refunds, churn, and reputation. Replace deceptive patterns with genuine value propositions.

---

### 14. Handoff Chasm

**Signs**: Design specifications are incomplete, ambiguous, or impossible to implement. Engineering must reinterpret the design during development. Edge cases, responsive behavior, error states, and loading states are not specified. Designers use tools/formats engineering cannot consume.

**Impact**: Production diverges significantly from intended design. Engineering-design friction increases. Ship dates slip as engineering discovers unspecified scenarios mid-sprint. Users experience inconsistencies because each developer interpreted the design differently.

**Fix**: Include responsive breakpoints, interaction states (hover, active, disabled, loading, error, empty), animation specifications, and edge cases in every design handoff. Use design tokens to bridge design-engineering vocabulary. Conduct design-engineering pairing sessions during implementation.

---

### 15. Requirements Receiver

**Signs**: Designer receives requirements from PM and creates visuals to match. No involvement in product discovery. Design starts after PRDs are written. Designer is not part of the product trio — they're downstream of decisions. User research is "PM's job."

**Impact**: Design is reduced to UI production — creating screens for pre-determined solutions. The team loses the designer's unique contribution: owning usability risk, challenging assumptions through prototyping, and bringing user evidence to strategic decisions. Innovation is limited to visual execution.

**Fix**: Restructure the designer's role to be part of the product trio from inception. Designer participates in discovery alongside PM and engineering. Research and prototyping happen before solutions are defined. Designer shares accountability for product outcomes, not just deliverable quality.

---

### 16. Opinion Over Evidence

**Signs**: Design debates are settled by who argues most persuasively or who has the most seniority. "I think users want..." replaces "we observed users doing..." Prototypes exist but are presented for stakeholder approval, not tested with users. Disagreements within the product trio persist without resolution.

**Impact**: The most persuasive person wins, regardless of what's best for users. Design quality depends on team dynamics rather than evidence. Bad ideas survive because they're championed by influential people. Good ideas die because they lack internal advocates.

**Fix**: Establish "prototype and test" as the default resolution for design disagreements. When the product trio disagrees, put it in front of users. Frame debates as testable hypotheses. Make user testing results the deciding factor, not internal consensus.

---

### 17. Focus Group Fallacy

**Signs**: User research asks "do you like this?" instead of "complete this task while I observe." Users are shown designs and asked for opinions rather than being observed using the product. Research reports contain quotes like "users said they liked the new layout" without behavioral evidence. Team conflates user preference statements with usability evidence.

**Impact**: Opinions and behavior diverge significantly — users say they like things they can't use, and dislike things that work well. "Positive research results" create false confidence. Real usability issues go undetected because they're only visible through observation, not self-report.

**Fix**: Replace opinion-gathering with task-based observation. Use think-aloud protocol: give users realistic tasks and observe their behavior. Focus on what users DO, not what they SAY. Keep users out of "critique mode" — they should be completing tasks, not evaluating designs.

---

### 18. Satisfaction Score Complacency

**Signs**: Team celebrates high CSAT or OSAT scores as proof of design success. No loyalty metrics (retention rate, NPS, stickiness, EGR) are tracked alongside satisfaction. "Users are satisfied" is used to resist design improvements. Product Reaction Cards or CES data is not collected.

**Impact**: 60-80% of defectors rated themselves "satisfied" before leaving — satisfaction is a fleeting attitude, not a predictor of loyalty. NPS "Passives" (scoring 7-8) appear satisfied but are vulnerable to competitors. Teams optimize for a vanity metric while users quietly churn.

**Fix**: Track loyalty metrics alongside satisfaction: Retention Rate, NPS (distinguishing Promoters from Passives from Detractors), DAU/MAU Stickiness, Earned Growth Rate. Use the HEART framework (Happiness, Engagement, Adoption, Retention, Task Success) for holistic UX measurement. Acknowledge that true loyalty hallmarks are endurance through hard times and voluntary advocacy, not survey scores.

---

## Anti-Pattern Summary

| Pattern | Severity | Primary Dimension | Applies To |
|---------|----------|-------------------|------------|
| Pixel-Perfect Blindness | Critical | 2 (Usability) | Both |
| Research Theater | Critical | 5 (Research) | Both |
| Siloed Touchpoint Design | Critical | 7 (Service Blueprint) | Both |
| Aesthetic Usability Trap | Major | 2 (Usability) | Both |
| Accessibility Afterthought | Major | 6 (Accessibility) | Both |
| Stakeholder-Driven Design | Major | 1 (Problem Framing) | Both |
| Fidelity Escalation | Major | 9 (Prototyping) | Proposal |
| Designer Hero Complex | Major | 8 (Co-Creation) | Both |
| Journey Gap | Major | 7 (Service Blueprint) | Both |
| Component Soup | Major | 10 (Design System) | Implementation |
| Empathy Deficit | Major | 1 (Problem Framing) | Both |
| Convergence Without Divergence | Major | 9 (Prototyping) | Proposal |
| Dark Pattern Drift | Major | 2 (Usability) | Both |
| Handoff Chasm | Major | 10 (Design System) | Implementation |
| Requirements Receiver | Major | 8 (Co-Creation) | Both |
| Opinion Over Evidence | Major | 5 (Research) | Both |
| Focus Group Fallacy | Major | 5 (Research) | Both |
| Satisfaction Score Complacency | Major | 5 (Research) | Implementation |

---

## Platform-Specific Anti-Patterns

The following anti-patterns are unique to specific platforms. Full details (Signs, Impact, Fix) are in the individual platform files linked from [platform-overview.md](platform-overview.md).

### CLI / Terminal

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| GUI-in-a-Terminal | Major | 2 (Usability) |
| Flag Explosion | Major | 3 (IA) |
| Silent Failure | Critical | 2 (Usability) |
| Unpipeable Output | Major | 10 (Design System) |
| Inconsistent Naming | Major | 10 (Design System) |

### Web Applications

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| Desktop-First Neglect | Major | 2 (Usability) |
| SPA Amnesia | Critical | 3 (IA) |
| Form Fatigue | Major | 2 (Usability) |
| Performance Blindness | Major | 2 (Usability) |
| SEO Invisibility | Major | 3 (IA) |

### Mobile Applications

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| Platform Denial | Critical | 10 (Design System) |
| Desktop Miniaturization | Critical | 2 (Usability) |
| Notification Spam | Major | 7 (Service Blueprint) |
| Gesture Mystery | Major | 2 (Usability) |
| Permission Ambush | Major | 1 (Problem Framing) |

### IDE Plugin Extensions

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| Editor Hijack | Critical | 2 (Usability) |
| Kitchen Sink Settings | Major | 3 (IA) |
| Notification Flood | Major | 2 (Usability) |
| Reinventing Host UI | Major | 10 (Design System) |
| Context Ignorance | Major | 1 (Problem Framing) |

### Desktop Applications

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| Web-in-a-Window | Critical | 10 (Design System) |
| Menu Bar Desert | Major | 3 (IA) |
| Single Window Tyranny | Major | 2 (Usability) |
| Update Interruption | Major | 7 (Service Blueprint) |
| File System Ignorance | Major | 10 (Design System) |

### API / Developer Tools

| Pattern | Severity | Primary Dimension |
|---------|----------|-------------------|
| Cryptic Errors | Critical | 2 (Usability) |
| Documentation Drift | Critical | 3 (IA) |
| Breaking in the Dark | Critical | 10 (Design System) |
| Auth Labyrinth | Major | 2 (Usability) |
| Undiscoverable API | Major | 3 (IA) |
