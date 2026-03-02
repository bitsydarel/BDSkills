# Product Designer Review — Feedback Template

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Fundamental design flaw; blocks usability or user trust | Must fix before proceeding |
| **Major** | Significant gap that materially weakens the experience | Should fix in current cycle |
| **Minor** | Improvement opportunity; does not block progress | Plan for next iteration |
| **Suggestion** | Enhancement idea; optional but valuable | Consider for backlog |

---

## Full Review Template

```markdown
# Product Designer Review

**Input**: [Title / description of what is being reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Product Designer (UXD, Interaction Design, User Research, Service Design)
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] — [Score]/50

---

### Product Designer Evaluation Scorecard

| # | Dimension | Score (1-5) | Key Observation |
|---|-----------|:-----------:|-----------------|
| 1 | Human-Centered Problem Framing | | |
| 2 | Usability & Interaction Quality | | |
| 3 | Information Architecture & Navigation | | |
| 4 | Visual Design & Brand Expression | | |
| 5 | User Research & Evidence Rigor | | |
| 6 | Accessibility & Inclusivity | | |
| 7 | Service Blueprint & End-to-End Journey | | |
| 8 | Co-Creation & Stakeholder Facilitation | | |
| 9 | Prototyping & Design Validation | | |
| 10 | Design System Coherence & Feasibility | | |
| | **Overall Score** | **/50** | |

### Design Compliance Checklist (Implementation Reviews Only)

| Requirement | Met? | Gap |
|-------------|:----:|-----|
| Empathy maps created with real user data | | |
| Personas validated against behavioral evidence | | |
| Problem statement articulated before solution design | | |
| Nielsen's 10 Heuristics evaluated | | |
| Task-based usability testing conducted (observe, don't ask) | | |
| WCAG AA compliance audited | | |
| Service blueprint mapped (frontstage + backstage) | | |
| Design crits facilitated (green/red rounds) | | |
| Prototypes tested at appropriate fidelity | | |
| Product trio observed users together | | |
| Design system components reused where applicable | | |
| Engineering handoff documentation complete | | |
| Performance metrics tracked (task success, time on task, error rate) | | |
| Self-reported metrics collected (SUS, NPS, CES) | | |
| Loyalty metrics tracked alongside satisfaction (retention, stickiness, EGR) | | |

### Critical Issues

- [ ] [Issue description — why it is critical — which dimension(s) affected]

### Major Issues

- [ ] [Issue description — why it is major — which dimension(s) affected]

### Minor Issues

- [ ] [Issue description — improvement opportunity — which dimension(s) affected]

### Strengths

- [What the design does well — which dimension(s) it excels in]

### Top Recommendation

[Single most impactful action the team should take to improve the design]

### Key Question for the Team

[One question that, if answered, would most improve the design's chances of success]
```

---

## Filled Example 1: Proposal Review

```markdown
# Product Designer Review

**Input**: Mobile Banking App — New Onboarding Flow Redesign
**Review Mode**: Proposal Review
**Perspective**: Product Designer (UXD, Interaction Design, User Research, Service Design)
**Verdict**: Proceed with Conditions — 34/50

---

### Product Designer Evaluation Scorecard

| # | Dimension | Score (1-5) | Key Observation |
|---|-----------|:-----------:|-----------------|
| 1 | Human-Centered Problem Framing | 4 | Strong persona work based on 12 user interviews; empathy maps validated; JTBD articulated |
| 2 | Usability & Interaction Quality | 3 | Reasonable flow but progressive disclosure missing on KYC steps; error states incomplete |
| 3 | Information Architecture & Navigation | 3 | Onboarding is linear which suits the task; but no consideration of re-entry points for abandoned flows |
| 4 | Visual Design & Brand Expression | 4 | Clean visual hierarchy; brand-aligned illustrations; warm/trustworthy tone appropriate for banking |
| 5 | User Research & Evidence Rigor | 3 | Good qualitative research (interviews) but no quantitative baseline; competitor analysis is surface-level |
| 6 | Accessibility & Inclusivity | 2 | WCAG AA not explicitly targeted; no mention of screen reader testing or motor constraint scenarios |
| 7 | Service Blueprint & End-to-End Journey | 3 | Onboarding journey mapped but backstage (compliance review, fraud checks) not integrated into UX timing |
| 8 | Co-Creation & Stakeholder Facilitation | 4 | Product trio involved from discovery; compliance team workshopped KYC requirements |
| 9 | Prototyping & Design Validation | 3 | Wireframes exist but no prototype testing planned before build; single fidelity level |
| 10 | Design System Coherence & Feasibility | 5 | Fully leverages existing mobile design system; no bespoke components; clear handoff spec |
| | **Overall Score** | **34/50** | |

### Critical Issues

- [ ] **Accessibility not addressed from the start** (Dim 6) — Banking onboarding must be accessible to all users including those with visual/motor impairments. No WCAG target specified; screen reader flow not designed. Must establish AA compliance target and test with assistive technologies before build.

### Major Issues

- [ ] **No prototype testing planned** (Dim 9) — Onboarding is high-stakes (user drops off = lost customer). Plan at least 2 rounds of prototype testing with representative users (including older demographics) before committing to engineering.
- [ ] **Error states and recovery paths incomplete** (Dim 2) — KYC document upload failure, camera permission denial, and network interruption scenarios not designed. These are high-frequency failure modes in mobile banking onboarding.
- [ ] **Backstage timing not reflected in UX** (Dim 7) — Compliance review can take 1-48 hours. The proposal shows a "you're all set!" screen immediately after submission but doesn't design the waiting state, notification flow, or failed verification recovery.

### Minor Issues

- [ ] **No quantitative baseline** (Dim 5) — Current onboarding completion rate and drop-off funnel not documented. Without a baseline, improvement cannot be measured.
- [ ] **Re-entry points for abandoned flows** (Dim 3) — What happens when a user closes the app mid-KYC? Proposal doesn't address save-and-resume.

### Strengths

- Excellent design system alignment (Dim 10) — all components from existing library, clear engineering handoff
- Strong problem framing with validated personas and JTBD (Dim 1) — research-grounded, not assumption-driven
- Product trio collaboration from discovery (Dim 8) — compliance stakeholders included early

### Top Recommendation

Conduct 2 rounds of task-based usability testing with low-fidelity prototypes (focus on the KYC document upload and waiting-state flows) before committing to engineering. Observe users doing realistic tasks — do not ask "do you like it?"

### Key Question for the Team

What happens when a user fails identity verification — have you designed the full recovery journey (notification, re-submission, support escalation), or only the happy path?
```

---

## Filled Example 2: Implementation Review

```markdown
# Product Designer Review

**Input**: E-Commerce Checkout Redesign — launched 45 days ago, mixed usability results
**Review Mode**: Implementation Review
**Perspective**: Product Designer (UXD, Interaction Design, User Research, Service Design)
**Verdict**: Needs Improvement — 29/50

---

### Product Designer Evaluation Scorecard

| # | Dimension | Score (1-5) | Key Observation |
|---|-----------|:-----------:|-----------------|
| 1 | Human-Centered Problem Framing | 3 | Personas exist but based on demographics, not validated behavioral patterns; problem was framed as "reduce cart abandonment" without investigating underlying causes |
| 2 | Usability & Interaction Quality | 2 | SUS score of 58 (below avg); users struggle with address form auto-complete and payment method switching; 3 heuristic violations identified |
| 3 | Information Architecture & Navigation | 3 | Checkout flow is logical (cart → shipping → payment → confirm); but back-navigation loses entered data |
| 4 | Visual Design & Brand Expression | 4 | Brand-consistent; trust signals well-placed; visual hierarchy guides attention to CTAs |
| 5 | User Research & Evidence Rigor | 2 | Pre-launch testing was a focus group ("do you like this?") not task-based observation; post-launch analytics exist but usability testing not conducted |
| 6 | Accessibility & Inclusivity | 3 | WCAG A met; keyboard navigation works; but screen reader announces form errors inconsistently; color-only error indicators on some fields |
| 7 | Service Blueprint & End-to-End Journey | 2 | Checkout designed in isolation; post-purchase journey (confirmation email, tracking, returns) not connected; support tickets spiking for order modification |
| 8 | Co-Creation & Stakeholder Facilitation | 3 | PM and engineering collaborated; but no user co-creation; design crits were informal with no structured feedback |
| 9 | Prototyping & Design Validation | 2 | Single high-fidelity mockup presented to stakeholders; no iterative testing; jumped from concept to production |
| 10 | Design System Coherence & Feasibility | 5 | Excellent design system usage; all components from shared library; engineering handoff was clean |
| | **Overall Score** | **29/50** | |

### Design Compliance Checklist (Implementation Reviews Only)

| Requirement | Met? | Gap |
|-------------|:----:|-----|
| Empathy maps created with real user data | Partial | Empathy map exists but based on stakeholder assumptions, not user interviews |
| Personas validated against behavioral evidence | No | Demographic personas only; no behavioral validation |
| Problem statement articulated before solution design | Partial | "Reduce cart abandonment" stated but root causes not investigated |
| Nielsen's 10 Heuristics evaluated | No | 3 violations found post-launch; no pre-launch heuristic review |
| Task-based usability testing conducted (observe, don't ask) | No | Focus group used; users asked opinions, not observed doing tasks |
| WCAG AA compliance audited | Partial | A level met; AA gaps in form error handling and color contrast |
| Service blueprint mapped (frontstage + backstage) | No | Checkout designed without post-purchase journey consideration |
| Design crits facilitated (green/red rounds) | No | Informal reviews only; no structured crit process |
| Prototypes tested at appropriate fidelity | No | Single high-fidelity mockup; no iterative testing |
| Product trio observed users together | No | Designer presented to PM and eng; no shared user observation |
| Design system components reused where applicable | Yes | Full compliance |
| Engineering handoff documentation complete | Yes | Comprehensive spec delivered |
| Performance metrics tracked (task success, time on task, error rate) | Partial | Completion rate tracked; time on task and error rate not measured |
| Self-reported metrics collected (SUS, NPS, CES) | Partial | SUS collected (58); NPS and CES not measured |
| Loyalty metrics tracked alongside satisfaction (retention, stickiness, EGR) | No | Only CSAT collected; no retention or loyalty tracking |

### Usability Metrics Summary

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Task success rate (checkout completion) | 72% | 85%+ | Below |
| SUS score | 58 | 68 (avg) | Below |
| Cart abandonment rate | 34% | 25% (target) | Above |
| Time on task (checkout) | 4m 12s | < 3m | Above |
| Error rate (form submission) | 18% | < 5% | Critical |
| CSAT (post-purchase) | 3.8/5 | 4.0+ | Below |

### Critical Issues

- [ ] **Focus group research instead of task-based testing** (Dim 5, Anti-pattern: Focus Group Fallacy) — Pre-launch research asked users "do you like the new checkout?" instead of observing them complete a purchase. The 18% form error rate and SUS of 58 show usability problems that opinions-based research missed. Fix: Conduct 5-8 task-based usability sessions immediately; observe users completing realistic purchase tasks with think-aloud protocol.
- [ ] **Form error rate of 18% with 3 heuristic violations** (Dim 2) — Address auto-complete overwrites manual entry; payment method switching resets billing address; error messages appear below the fold. Fix: Heuristic audit + targeted usability testing on the 3 violation areas.

### Major Issues

- [ ] **Post-purchase journey not designed** (Dim 7, Anti-pattern: Siloed Touchpoint Design) — Checkout ends at "Order Confirmed" but the journey continues: confirmation email, shipping updates, order modification, returns. Support tickets for order changes spiked 40% post-launch because there's no self-service path. Map the full service blueprint including backstage processes.
- [ ] **No prototype iteration before build** (Dim 9, Anti-pattern: Fidelity Escalation) — Single high-fidelity mockup went to stakeholder approval, then straight to engineering. Multiple usability issues could have been caught with 2-3 rounds of prototype testing at lower fidelity.
- [ ] **Satisfaction measured but not loyalty** (Dim 5, Anti-pattern: Satisfaction Score Complacency) — CSAT of 3.8 is reported as "close to target." But no retention, repeat purchase, or NPS tracking. 60-80% of defectors rate themselves "satisfied." Track repeat purchase rate, NPS, and checkout stickiness (returning vs. new user completion rates).

### Minor Issues

- [ ] **Screen reader form error announcements inconsistent** (Dim 6) — Some errors announced automatically, others require manual navigation. Standardize aria-live regions for all form validation.
- [ ] **Back-navigation loses data** (Dim 3) — Users who navigate back from Payment to Shipping lose entered address data. Implement form state persistence.

### Strengths

- Excellent design system coherence (Dim 10) — zero bespoke components, clean engineering handoff
- Strong visual design and trust signals (Dim 4) — brand-consistent, clear CTAs, security badges well-placed
- Logical checkout flow structure (Dim 3) — step progression matches user mental model

### Top Recommendation

Immediately conduct 5-8 task-based usability sessions observing real users completing checkout tasks (not asking opinions). Focus on the three heuristic violations: address auto-complete, payment method switching, and error message visibility. Use think-aloud protocol and iterate same-day between sessions.

### Key Question for the Team

Why was a focus group chosen over task-based usability testing, and what would it take to establish a weekly cadence where the product trio observes real users together?
```

---

## Quick Review Template

```markdown
**Product Designer Quick Review** | [Input] | [Proposal/Implementation] | Score: __/50 | Verdict: [Proceed/Conditions/Rework]

**Top 3 Issues**: 1) [Critical/Major — description] 2) [Critical/Major — description] 3) [Major/Minor — description]

**Top Strength**: [What works well]

**Key Question**: [One question for the team]

**Scorecard**: D1:_ D2:_ D3:_ D4:_ D5:_ D6:_ D7:_ D8:_ D9:_ D10:_
```
