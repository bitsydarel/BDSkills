# Product Designer Evaluation Framework

## Scoring Scale

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Excellent | Industry-leading practice; comprehensive, validated, measurably effective |
| 4 | Good | Solid practice with minor gaps; above average rigor |
| 3 | Adequate | Meets basic expectations; clear room for improvement |
| 2 | Weak | Significant gaps; below acceptable standard |
| 1 | Missing | Absent or fundamentally flawed; blocks progress |

---

## Dimension 1: Human-Centered Problem Framing

**Proposal questions**: Is the design grounded in validated user needs or assumptions? Are empathy maps, persona profiles, and problem statements present? Has the problem space been explored before jumping to solutions? Is there evidence of contextual inquiry or user interviews?

**Implementation-Compliance questions**: Were empathy maps created with real user data? Were personas validated against behavioral evidence (not just demographics)? Was a problem statement articulated before solution design began? Were Jobs to Be Done (JTBD) identified?

**Implementation-Results questions**: Does the solution address the validated user need? Do users confirm the problem framing resonates with their lived experience? Has the design reduced the target pain point measurably?

**Scoring**:
- **5 (Excellent)**: Journey-mapped, validated personas; problem space thoroughly explored with contextual research; empathy artifacts grounded in behavioral data; JTBD framework applied
- **4 (Good)**: Behavioral personas with goals and mental models; empathy maps based on user interviews; clear problem statement
- **3 (Adequate)**: Demographic-level personas; some user research conducted; problem statement exists but lacks depth
- **2 (Weak)**: Label-only personas; assumptions not validated; problem framing based on stakeholder opinions
- **1 (Missing)**: No user research; no empathy artifacts; solution-first approach with no problem exploration

**Persona quality check**: Label → Demographic → Behavioral → Goals & Mental Models → Journey-Mapped & Validated

---

## Dimension 2: Usability & Interaction Quality

**Proposal questions**: Does the proposed interaction model follow established heuristics? Is cognitive load managed through progressive disclosure, chunking, and clear hierarchy? Are error states and recovery paths designed? Does the design follow goal-directed principles (Cooper)?

**Implementation-Compliance questions**: Were Nielsen's 10 Heuristics evaluated? Was task-based usability testing conducted (observe behavior, not opinions)? Are error prevention and recovery mechanisms in place? Is the interface learnable within expected timeframes?

**Implementation-Results questions**: What are the task success rates? Time on task within benchmarks? Error rates acceptable? Learnability curve trending down? SUS score above 68 (industry average)?

**Scoring**:
- **5 (Excellent)**: All 10 heuristics satisfied; task-based testing confirms learnability; SUS > 80; error rate < 2%; think-aloud protocol reveals no critical confusion
- **4 (Good)**: Most heuristics satisfied; usability testing conducted with minor issues found and addressed; SUS 68-80
- **3 (Adequate)**: Basic heuristic compliance; some usability testing but limited scope; SUS 50-68
- **2 (Weak)**: Multiple heuristic violations; no usability testing; users report confusion; SUS < 50
- **1 (Missing)**: No heuristic consideration; no testing; fundamental interaction model flaws

**Nielsen's 10 Heuristics checklist**: Visibility of system status; Match between system and real world; User control and freedom; Consistency and standards; Error prevention; Recognition rather than recall; Flexibility and efficiency of use; Aesthetic and minimalist design; Help users recognize, diagnose, and recover from errors; Help and documentation

---

## Dimension 3: Information Architecture & Navigation

**Proposal questions**: Is the content structure aligned with user mental models? Are labeling conventions clear and consistent? Is wayfinding intuitive? Has card sorting or tree testing informed the IA?

**Implementation-Compliance questions**: Was the IA validated through card sorting or tree testing? Are navigation patterns consistent across the product? Does the structure scale for future content growth?

**Implementation-Results questions**: Can users find target content within expected time? Is the findability rate above 80%? Are search-to-navigate ratios healthy?

**Scoring**:
- **5 (Excellent)**: IA validated through card sorting and tree testing; Garrett's 5 Planes fully addressed; findability > 90%; navigation scales gracefully
- **4 (Good)**: Well-structured IA based on user mental models; tested with representative users; minor labeling improvements needed
- **3 (Adequate)**: Reasonable IA structure; follows platform conventions; not user-tested
- **2 (Weak)**: IA reflects org structure rather than user mental models; inconsistent labeling; poor wayfinding
- **1 (Missing)**: No discernible IA strategy; content structure is ad hoc; users cannot find key features

**Garrett's 5 Planes assessment**: Strategy (user needs + business objectives) → Scope (features + content requirements) → Structure (IA + interaction design) → Skeleton (navigation + interface + information design) → Surface (visual design)

---

## Dimension 4: Visual Design & Brand Expression

**Proposal questions**: Does the visual language support the brand's experience attributes? Is the typographic hierarchy clear? Are color choices accessible and meaningful? Do Gestalt principles guide visual grouping?

**Implementation-Compliance questions**: Does the visual design follow the brand guidelines? Is the design system's visual language applied consistently? Are contrast ratios WCAG-compliant? Is the visual hierarchy guiding user attention effectively?

**Implementation-Results questions**: Do users associate the visual design with the intended brand attributes? Do Product Reaction Card results align with target experience attributes? Is the visual design supporting (not hindering) task completion?

**Scoring**:
- **5 (Excellent)**: Visual language is distinctive, communicative, and on-brand; typographic hierarchy is clear; Gestalt principles applied; users associate design with intended brand attributes
- **4 (Good)**: Consistent visual language; brand alignment evident; minor hierarchy or spacing issues
- **3 (Adequate)**: Functional visual design; follows conventions but lacks brand distinctiveness; some inconsistencies
- **2 (Weak)**: Inconsistent visual treatment; brand expression unclear; visual clutter impedes comprehension
- **1 (Missing)**: No coherent visual language; brand disconnected; visual design actively hinders usability

---

## Dimension 5: User Research & Evidence Rigor

**Proposal questions**: What research methods inform this proposal? Is there a mix of qualitative and quantitative evidence? Are insights triangulated from multiple sources? Is the research plan proportional to the risk?

**Implementation-Compliance questions**: Were appropriate research methods applied (contextual inquiry, usability testing, surveys, analytics)? Was task-based observation used (not just opinion collection)? Were think-aloud protocols employed? Was the sample representative? Were insights synthesized and documented?

**Implementation-Results questions**: Did research findings drive design decisions? Were contradictory findings investigated rather than dismissed? Is there a closed-loop between research insights and design iteration?

**Scoring**:
- **5 (Excellent)**: Mixed methods with triangulation; think-aloud usability testing with representative users; systematic insight synthesis; research directly drove design decisions; behavior-over-opinion principle followed
- **4 (Good)**: Multiple research methods; usability testing conducted; insights documented and acted upon; minor gaps in triangulation
- **3 (Adequate)**: Some research conducted; limited methods; insights exist but connection to design decisions unclear
- **2 (Weak)**: Minimal research; opinion-based ("do you like this?") rather than task-based observation; findings cherry-picked
- **1 (Missing)**: No user research; design based entirely on assumptions or stakeholder opinions

**Research rigor spectrum**: No research → Informal feedback → Focus group opinions → Task-based observation → Think-aloud with iteration → Systematic program with product trio observing together

---

## Dimension 6: Accessibility & Inclusivity

**Proposal questions**: Has accessibility been considered from the start? Are WCAG levels targeted (A/AA/AAA)? Has the design accounted for diverse contexts (screen readers, motor limitations, cognitive differences, noisy environments, thick gloves)?

**Implementation-Compliance questions**: Does the design meet WCAG 2.1/2.2 AA at minimum? Are contrast ratios compliant? Is keyboard navigation fully supported? Are screen reader semantics correct? Has the design been tested with assistive technologies?

**Implementation-Results questions**: Can users with diverse abilities complete core tasks? Are there accessibility-related support tickets or complaints? Has the design been audited by accessibility specialists?

**Scoring**:
- **5 (Excellent)**: WCAG AAA on critical flows; tested with assistive technologies and diverse user groups; physical context testing (low connectivity, noisy environment, motor constraints); inclusive design principles embedded
- **4 (Good)**: WCAG AA fully met; automated and manual accessibility testing; assistive technology testing conducted
- **3 (Adequate)**: WCAG A met; basic automated testing; some manual checks; known gaps documented
- **2 (Weak)**: Partial WCAG compliance; accessibility addressed reactively; significant gaps
- **1 (Missing)**: No accessibility consideration; excludes users with disabilities; no testing

**Physical context checklist**: No connectivity, noisy environment, accessibility constraints (visual/motor/cognitive), device limitations, gloved operation, bright sunlight, one-handed use

---

## Dimension 7: Service Blueprint & End-to-End Journey

**Proposal questions**: Is the feature situated within the broader service journey? Are frontstage/backstage interactions mapped? Are pain points and moments of truth identified? Are transition points between channels covered?

**Implementation-Compliance questions**: Was a service blueprint created? Are all touchpoints documented? Are backstage processes (support, fulfillment, systems) aligned with the frontstage experience? Were pain points at transition points addressed?

**Implementation-Results questions**: Is the end-to-end experience cohesive across channels? Are there drop-off points at channel transitions? Do service metrics (resolution time, handoff quality) confirm smooth operation?

**Scoring**:
- **5 (Excellent)**: Fully validated cross-channel service blueprint; frontstage/backstage aligned; moments of truth designed and measured; transition points seamless; Stickdorn's 5 principles applied
- **4 (Good)**: Service blueprint exists; key touchpoints and transitions mapped; backstage alignment addressed; minor gaps at edge cases
- **3 (Adequate)**: Journey map exists but limited to frontstage; some touchpoints unmapped; backstage not explicitly considered
- **2 (Weak)**: Fragmented journey awareness; only individual screens designed; channel transitions ignored
- **1 (Missing)**: No journey or service thinking; isolated screen design; no awareness of broader ecosystem

---

## Dimension 8: Co-Creation & Stakeholder Facilitation

**Proposal questions**: Were users or stakeholders involved in ideation? Were design sprints, workshops, or participatory design sessions conducted? Is the product trio (PM, Design, Engineering) collaborating from inception?

**Implementation-Compliance questions**: Were co-creation sessions held with real users? Did the product trio observe users together? Were design crits facilitated (green/red rounds)? Were stakeholder workshops conducted to align on priorities?

**Implementation-Results questions**: Did collaborative sessions produce actionable insights that shaped the design? Does the team report shared understanding of user needs? Are opinion-based debates replaced by evidence-based decisions?

**Scoring**:
- **5 (Excellent)**: Product trio co-drives discovery; regular co-creation with users; design crits with green/red rounds operational; stakeholders participate actively; shared learning replaces opinion debates
- **4 (Good)**: Product trio involved; some co-creation with users; design crits happening; stakeholder alignment sessions conducted
- **3 (Adequate)**: Designer works with PM but limited user co-creation; informal design reviews; stakeholder input collected but not structured
- **2 (Weak)**: Designer works mostly alone; design reviews are presentation-only; stakeholder involvement is approval-seeking
- **1 (Missing)**: Designer in isolation; no co-creation; no design crits; no structured stakeholder involvement

**Collaborative shared learning quality check**: Does the product trio observe users together around prototypes? Are debates settled with behavioral evidence? Is design crit structured (green round → red round)?

---

## Dimension 9: Prototyping & Design Validation

**Proposal questions**: Is the prototyping plan appropriate for the risk level? Is fidelity progression planned (low → high)? Are hypotheses stated before prototyping? Will prototypes be tested with real users?

**Implementation-Compliance questions**: Were prototypes created at appropriate fidelity levels? Was the Hypothesize-Design-Test-Learn cycle followed? Were prototypes tested with representative users? Were iterations made same-day based on findings?

**Implementation-Results questions**: How many prototype iterations were tested? Did prototype testing kill any bad ideas before engineering began? Did the final design reflect learnings from prototype testing?

**Scoring**:
- **5 (Excellent)**: Multiple fidelity levels tested; dozens of prototypes explored; Hypothesize-Design-Test-Learn cadence with same-day iterations; bad ideas killed early; convergent evidence from multiple rounds
- **4 (Good)**: Prototypes tested at appropriate fidelity; several iterations conducted; hypotheses stated; findings drove changes
- **3 (Adequate)**: Some prototyping done; limited testing; fidelity progression not systematic
- **2 (Weak)**: Single high-fidelity prototype presented; no iteration; prototype used to confirm, not to learn
- **1 (Missing)**: No prototyping; design went directly to engineering; no validation before build

**Fidelity progression check**: Paper/sketches → Wireframes → Interactive prototype → High-fidelity prototype → Production prototype

---

## Dimension 10: Design System Coherence & Feasibility

**Proposal questions**: Does the proposal reuse existing design system components? Are new components justified? Is the engineering handoff plan clear? Are design tokens defined? For hardware: Are DFM and materials considered?

**Implementation-Compliance questions**: Were design system components used consistently? Were new components contributed back to the system? Is the design specification implementable as intended? Are design tokens and variables properly documented?

**Implementation-Results questions**: Did engineering implement the design as specified? Are there design-engineering discrepancies in production? Is the design system growing coherently?

**Scoring**:
- **5 (Excellent)**: Full design system alignment; components reused and contributed; token architecture mature; engineering handoff seamless; zero design-drift in production
- **4 (Good)**: Design system largely followed; new components well-documented; handoff quality good; minor implementation discrepancies
- **3 (Adequate)**: Design system partially used; some bespoke elements; handoff documentation exists but incomplete
- **2 (Weak)**: Significant design system deviation; many bespoke components; handoff unclear; engineering had to reinterpret
- **1 (Missing)**: No design system adherence; every element bespoke; no handoff documentation; engineering built from scratch

---

## Dimension Weighting Guide

| Input Type | Higher Weight Dimensions | Lower Weight Dimensions |
|---|---|---|
| New Product Design | 1 (Problem Framing), 2 (Usability), 5 (Research) | 10 (Design System) |
| Feature Redesign | 2 (Usability), 3 (IA), 9 (Prototyping) | 7 (Service Blueprint) |
| Service Design | 7 (Service Blueprint), 8 (Co-Creation), 1 (Problem Framing) | 4 (Visual Design) |
| Design System | 10 (Design System), 2 (Usability), 6 (Accessibility) | 7 (Service Blueprint) |
| Hardware Product | 10 (Feasibility/DFM), 1 (Problem Framing), 2 (Usability) | 3 (IA) |

### Platform-Specific Weighting

When the target platform is known, layer these weights on top of input-type weights. See [platform-overview.md](platform-overview.md) for full dimension interpretation per platform.

| Platform | Higher Weight Dimensions | Lower Weight Dimensions |
|----------|------------------------|------------------------|
| CLI / Terminal | 2 (command ergonomics), 3 (command hierarchy), 10 (flag/output consistency) | 4 (visual design) |
| Web | 2 (responsive usability), 3 (URL/IA), 6 (WCAG 2.2) | — |
| Mobile | 2 (touch/gesture), 6 (accessibility — VoiceOver/TalkBack/Dynamic Type), 4 (platform visual conventions) | — |
| IDE Plugin | 2 (non-disruptive), 10 (host integration), 3 (command palette/panel IA) | 4 (visual design), 7 (service blueprint) |
| Desktop | 2 (keyboard-first), 3 (menu/toolbar IA), 10 (OS toolkit compliance) | 7 (service blueprint) |
| API / Developer Tools | 2 (consistency/ergonomics), 3 (documentation IA), 10 (SDK coherence) | 4 (visual design), 8 (co-creation) |

---

## Verdict Thresholds

### Proposal Reviews

| Score Range | Verdict | Meaning |
|---|---|---|
| 42-50 | Proceed | Design foundations are strong; minor refinements only |
| 27-41 | Proceed with Conditions | Viable but specific gaps must be addressed before build |
| 0-26 | Rework Required | Fundamental design issues; return to discovery |

### Implementation Reviews

| Score Range | Verdict | Meaning |
|---|---|---|
| 42-50 | Healthy | Design is performing well; continue iterating |
| 27-41 | Needs Improvement | Measurable gaps; prioritize design debt |
| 0-26 | Rework Required | Critical design failures; redesign needed |

### Critical Dimension Rules

- Any single dimension scoring **1** blocks a "Proceed" or "Healthy" verdict regardless of total score
- Dimensions 1 (Problem Framing) and 2 (Usability) both scoring **≤ 2** triggers automatic "Rework Required"
- Dimensions 5 (Research) and 9 (Prototyping) both scoring **≤ 2** triggers automatic "Rework Required" — indicates no evidence-based design process
