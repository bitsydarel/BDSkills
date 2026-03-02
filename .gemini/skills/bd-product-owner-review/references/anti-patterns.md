# PO anti-patterns

Named failure modes that PO reviews must detect. Each pattern includes signs to look for, its impact, and a concrete fix.

## Critical anti-patterns

### 1. Backlog swamp

**Signs**: Backlog has hundreds of items. No grooming cadence. Stale items from six months ago sit alongside new requests. No ordering beyond "recent on top." The team scrolls past dozens of irrelevant items to find sprint candidates. Nobody knows what half the items mean anymore.

**Impact**: The backlog stops being a planning tool. The PO cannot articulate what the team should build next because the signal is buried in noise. Sprint planning takes hours because every item needs re-explanation.

**Fix**: Ruthlessly cull. Delete or archive anything not touched in 90 days. Establish a weekly grooming cadence. Keep the active backlog under 40-50 items. If something is important, it will come back.

---

### 2. Missing acceptance criteria

**Signs**: PBIs enter sprint with titles and one-line descriptions. No testable statements. AC field is blank or contains "see discussion." QA discovers expected behavior during testing by asking the PO mid-sprint. Developers interpret requirements differently.

**Impact**: "Done" becomes subjective. QA cannot verify behavior. Rework spikes because developers built the wrong thing. Sprint velocity is unpredictable because stories expand mid-sprint.

**Fix**: No item enters sprint without written, testable AC in Given/When/Then format. Run Three Amigos before sprint entry. If AC cannot be written, the item is not ready.

---

### 3. Absent Product Owner

**Signs**: PO is "too busy" for sprint planning, daily standups, or review. They attend ceremonies in body but not in mind (multitasking, arriving late, leaving early). Team sends Slack messages asking "is this what you meant?" with no response for days. Proxy PO makes decisions that get overridden later.

**Impact**: Team guesses at priority and scope. Decisions stall. Mid-sprint clarifications take days instead of minutes. Work gets rejected at review because it does not match the PO's unstated expectations.

**Fix**: PO availability is non-negotiable. If the PO cannot dedicate at least 50% of their time to the team, they are overextended. Either reduce their portfolio or assign a dedicated PO. The proxy-PO pattern only works if the proxy has genuine decision authority.

---

## Major anti-patterns

### 4. Order taker

**Signs**: PO receives feature requests from stakeholders and passes them directly to the team. No "why" asked. No investigation of the underlying need. Backlog is a queue of stakeholder demands. PO measures success by request fulfillment speed. "The VP wants this" is the justification.

**Impact**: Product becomes a patchwork of disconnected features. Real user problems go unsolved. PO loses strategic influence and becomes a project coordinator with a fancy title.

**Fix**: For every request, ask "what problem does this solve?" and "how would we know it worked?" Investigate the underlying need. Present options and trade-offs, not just orders. The PO's job is to say "I understand what you want, let me figure out what we need."

---

### 5. Scope creep enabler

**Signs**: Mid-sprint, the PO adds items to the sprint backlog without removing anything. "Just one more small thing" happens every sprint. Sprint goal gets diluted. The team works overtime to absorb additions. PO cannot say no to stakeholders during the sprint.

**Impact**: Sprint commitments become meaningless. Team trust erodes because they never deliver what they planned. Burnout accumulates. Quality drops because everything is rushed.

**Fix**: Sprint backlog is frozen after sprint planning. New items go to the product backlog for the next sprint. If something truly urgent comes in, the PO must trade: add one, remove one of equal size. No free additions.

---

### 6. Gold-plated stories

**Signs**: AC include nice-to-have edge cases that inflate effort without proportional value. "While we're at it" additions. Stories that should be a 3 become an 8 because of unnecessary completeness. PO conflates "thorough" with "everything at once."

**Impact**: Fewer stories delivered per sprint. Value delivery slows. The team builds features to 100% completion when 80% would have validated the hypothesis.

**Fix**: Split stories ruthlessly. Ship the must-have AC first. Move nice-to-haves to separate stories that compete on value with everything else in the backlog. Ask: "Would a user pay for this edge case?"

---

### 7. FIFO backlog

**Signs**: Items built in the order they were requested. No prioritization framework applied. Backlog is a chronological queue. When asked "why this next?", the answer is "it was requested first" or "it is at the top of the list."

**Impact**: High-value items wait behind low-value items. Opportunity cost accumulates silently. The team optimizes for throughput, not impact. Cost of Delay is never calculated.

**Fix**: Apply a named prioritization framework (WSJF, RICE, ROI Scorecard, Kano). Re-prioritize regularly as new information arrives. Use compare-and-contrast framing ("which of these three is most valuable now?"), not "should we build this?"

---

### 8. Phantom readiness

**Signs**: Items are declared "ready" to hit a sprint planning deadline. DoR checklist is rubber-stamped. AC are vague or missing. Sizing was done without the full team. Dependencies are unconfirmed. Three Amigos was skipped or lasted five minutes.

**Impact**: Mid-sprint chaos. Stories expand once the team starts building and discovers gaps. Sprint goals are missed not because of capacity but because of unready work. The team loses faith in the grooming process.

**Fix**: Treat DoR as a gate, not a suggestion. The team has the right to refuse unready items at sprint planning. PO must prepare items 1-2 sprints ahead, not the night before planning.

---

### 9. Demo-only sprint reviews

**Signs**: Sprint review is a one-way presentation. PO shows slides or a demo, stakeholders nod. No questions asked. No feedback captured. Meeting is overcrowded — too-wide audience means hierarchy bias dominates (junior team members stay silent, senior stakeholders derail with untimely details). Creativity gets squashed because the format rewards polish, not learning.

**Impact**: The primary feedback loop in Scrum is broken. The PO does not learn what stakeholders actually think. Problems surface weeks or months later when it is expensive to fix. The team builds in a vacuum.

**Fix**: Restructure reviews as feedback sessions. Limit attendance to relevant stakeholders. Provide hands-on time with the increment. Ask directed questions: "Does this solve the problem you described?" Capture feedback in writing and map it to backlog items. Use independent written feedback before open discussion to prevent groupthink.

---

### 10. Ship and forget

**Signs**: Feature delivered. Success criteria exist but were never checked. PO moved to the next sprint immediately. No post-launch review. No usage data collected. "We shipped it" is the end state.

**Impact**: The organization never learns whether features work. Failed features consume resources indefinitely. The PO cannot demonstrate value to stakeholders because there is no evidence.

**Fix**: Require post-launch reviews at 30, 60, 90 days. Compare actual metrics to predictions. Feed learnings into the next iteration. If a metric is not reviewed, remove it — it is noise.

---

### 11. Stakeholder whiplash

**Signs**: Backlog priority changes every week based on whichever stakeholder the PO talked to last. The team starts work on item A, then B becomes urgent, then C. No stability in the sprint goal. Stakeholders have learned that yelling loudest gets their item prioritized.

**Impact**: Team cannot finish anything. Partially-built features accumulate. Context-switching destroys productivity. Team morale drops because nothing they start gets completed.

**Fix**: PO must consolidate demands through shuttle diplomacy (1-on-1s before group sessions). Use a prioritization framework to make ordering objective. Sprint goals are commitments, not suggestions. Changes happen at sprint boundaries, not mid-sprint.

---

### 12. Story splitting failure

**Signs**: Stories are too large (consistently 8+ points). "Epics" enter sprint planning as single items. The team struggles to finish stories within a sprint. PBIs conflate multiple behaviors into one story.

**Impact**: Incomplete stories carry over sprint after sprint. The team never gets the satisfaction of finishing. Progress is invisible because nothing is "done." Risk accumulates in large batches.

**Fix**: Apply story splitting patterns: by workflow step, by business rule, by data variation, by interface. Each story must deliver independently testable value. If it cannot be split, it is an epic that needs decomposition before sprint entry.

---

### 13. Definition of Done decay

**Signs**: DoD was written once and never updated. Quality steps get skipped "just this sprint" — and then permanently. Code review percentage drops. Test coverage erodes. Architecture standards are ignored. "We will fix it later" becomes the norm.

**Impact**: Technical debt compounds silently. Each sprint delivers a slightly worse product. Eventually, the team spends more time on defects than on features. Product quality degrades until customers notice.

**Fix**: Review DoD quarterly. DoD is a team agreement, not a document. If a step is consistently skipped, either enforce it or consciously remove it (with acknowledged trade-offs). DoD should ratchet up over time, not erode.

---

### 14. Single-stakeholder capture

**Signs**: One powerful stakeholder dominates the backlog. Their requests always land at the top. Other stakeholders stop submitting because they know they will be deprioritized. The PO has become that stakeholder's personal product team.

**Impact**: Product serves one internal faction, not customers. Other business needs are starved. The product becomes strategically vulnerable — if that stakeholder leaves or their priority changes, the backlog has no foundation.

**Fix**: Stakeholder mapping (Influence/Interest matrix). Ensure backlog items trace to diverse sources. Use data to arbitrate conflicts. The PO represents the customer, not any single internal faction.

---

### 15. Design by committee

**Signs**: Every stakeholder gets a vote on feature design. Meetings end with "let's incorporate everyone's feedback." Features are Frankenstein composites of conflicting opinions. Nobody is satisfied because the result is a compromise, not a decision.

**Impact**: The product lacks coherence. Each feature tries to please everyone and delights nobody. Decision-making is slow because it requires unanimous agreement. Bold ideas get watered down to the least controversial version.

**Fix**: Defer to the relevant expert. Tech lead decides architecture. Designer decides UX patterns. PO decides value priority. Collaboration means gathering input and perspectives, not voting. The PO makes the final call on what gets built, informed by expertise, and communicates the rationale transparently.

---

### 16. HiPPO surrender

**Signs**: The Highest-Paid Person's Opinion overrides evidence and frameworks. PO had data supporting option A, but the VP wanted option B, so option B won. No experiment was proposed. PO did not push back. Too-wide stakeholder audience in review meetings amplifies this — more senior people in the room means more deference to hierarchy.

**Impact**: Data-driven culture is performative. The PO loses credibility with the team because decisions are political, not evidence-based. Features fail because opinions are not validated.

**Fix**: Run a quick prototype, test, or feature stub with real users. Let customer data act as the "outside arbitrator" to break the tie. Use objective prioritization frameworks to make the decision visible. Check: were experiments available but not run? Did the PO default to opinion when evidence was obtainable? Limit review audiences to relevant stakeholders to reduce hierarchy bias.

---

### 17. Late feasibility check

**Signs**: Engineering sees the PBI for the first time at sprint planning. No spike was conducted. No tech lead was consulted during refinement. The PO estimated effort alone. Architecture concerns surface during the sprint.

**Impact**: Late-stage rework. Sprint goals missed because of unforeseen technical complexity. Engineers feel disrespected because they were handed a solution, not a problem. Technical debt accumulates from rushed workarounds.

**Fix**: Include engineering in refinement sessions. Run spikes for uncertain items 1-2 sprints before they are needed. The PO decides *what* to build; the team decides *how*. Feasibility is the team's assessment, not the PO's guess.

---

### 18. Skipped core team review

**Signs**: The PO jumped straight to a stakeholder review without the internal team (dev, QA, design) reviewing first. External stakeholders find basic issues — missing edge cases, obvious UX problems, technical impossibilities — that the team should have caught. The team feels blindsided and embarrassed.

**Impact**: Stakeholder trust erodes because they see amateur-level mistakes. The team resents the PO for exposing unfinished work. Review sessions become adversarial instead of collaborative.

**Fix**: Always conduct an internal team review before any external stakeholder session. The team catches 80% of issues at a fraction of the cost. External reviews should focus on strategic fit and customer relevance, not basic quality.

---

### 19. Review theater

**Signs**: Feedback in reviews is subjective and unconstructive ("I don't like it," "it feels off," "can we make it pop?"). No reference to personas, user scenarios, metrics, or design principles. Creators become immediately defensive instead of listening. Reviews produce opinions, not actionable items.

**Impact**: Reviews waste time. Nothing improves because feedback is not specific enough to act on. Team dreads reviews because they feel like personal critiques. Real issues are missed because the conversation stays at the surface.

**Fix**: Require structured feedback: reference a persona, scenario, metric, or principle. "This doesn't match the onboarding persona's mental model because..." is actionable. "I don't like it" is not. Collect written feedback before discussion. Facilitate, do not argue.

---

### 20. Late stakeholder validation

**Signs**: The PO waits until after engineering has built the feature to show it to stakeholders. Stakeholders uncover major constraint mismatches — regulatory requirements, integration dependencies, market timing issues — that should have been identified earlier. Significant rework follows.

**Impact**: Expensive rework on code that should never have been built in its current form. Team morale drops because their work is thrown away. Delivery timelines slip. This is distinct from Late Feasibility Check (which is about engineers); this is about business/market stakeholders seeing the work too late.

**Fix**: Pre-socialize with key stakeholders during refinement, not after delivery. Use low-fidelity artifacts (wireframes, story maps) to validate direction before investing engineering time. Show work early and cheap, not late and expensive.

---

## Anti-pattern summary

| Pattern | Severity | Primary Dimension | Applies To |
|---------|----------|-------------------|------------|
| Backlog Swamp | Critical | Backlog Quality | Both |
| Missing Acceptance Criteria | Critical | AC & Done | Both |
| Absent Product Owner | Critical | Stakeholder Management | Both |
| Order Taker | Major | Customer Empathy | Both |
| Scope Creep Enabler | Major | Scope Control | Implementation |
| Gold-Plated Stories | Major | Scope Control | Proposal |
| FIFO Backlog | Major | Value Maximization | Both |
| Phantom Readiness | Major | Backlog Quality | Proposal |
| Demo-Only Sprint Reviews | Major | Iterative Learning | Implementation |
| Ship and Forget | Major | Outcome Measurement | Implementation |
| Stakeholder Whiplash | Major | Stakeholder Management | Both |
| Story Splitting Failure | Major | Backlog Quality | Proposal |
| Definition of Done Decay | Major | AC & Done | Implementation |
| Single-Stakeholder Capture | Major | Value Maximization | Both |
| Design by Committee | Major | Stakeholder Management | Both |
| HiPPO Surrender | Major | Stakeholder Management | Both |
| Late Feasibility Check | Major | FVD Balance | Proposal |
| Skipped Core Team Review | Major | Iterative Learning | Both |
| Review Theater | Major | Iterative Learning | Both |
| Late Stakeholder Validation | Major | Stakeholder Management | Both |
