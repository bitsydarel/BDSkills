# Anti-Patterns: Outcomes & Metrics

Failure modes in how outcomes are defined, measured, and acted upon.

## Feature Factory [Critical]

### Signs
- Success defined as "shipped on time" rather than "problem solved"
- Roadmap is a list of features with dates, not problems with outcomes
- Team celebrates releases, never measures impact
- OKRs (if they exist) are output-based: "Launch X by Q2"

### Impact
Organization builds features that nobody uses while real customer problems go unsolved.

### Fix
Reframe every roadmap item as a problem to solve with an outcome-based KR. Require a post-launch impact review within 30 days.

### Detection
- **Document patterns to search for:** "launch by", "ship by", "deliver by" without accompanying outcome metrics; KRs that start with verbs like "build", "deploy", "complete"
- **Review questions:** "What changes for the customer when this ships?" "How will you know if this succeeded 30 days after launch?"
- **Test method:** Check if Product Outcomes P1 (Outcome-Based OKRs) is Missing — if so, this anti-pattern is likely active

---

## Metric Theater [Major]

### Signs
- Metrics are defined but never reviewed or acted upon
- Dashboards exist but nobody looks at them
- Success is declared without checking the actual numbers
- Team cannot state current values for their KRs

### Impact
The appearance of data-driven decision-making without the substance. Bad outcomes persist because metrics are performative, not operational.

### Fix
Institute weekly metric reviews where the team examines KR progress. Require data citations in every status update. If a metric isn't reviewed regularly, remove it — it is noise.

### Detection
- **Document patterns to search for:** Status updates that mention "progress" without numbers; dashboards with no recent views
- **Review questions:** "What are the current values for your KRs?" "When was the last time this dashboard was reviewed in a team meeting?"
- **Test method:** Ask the team to state their current KR values without checking — inability to do so signals this pattern

---

## Ship and Forget [Major]

### Signs
- Feature was launched but no post-launch review was conducted
- Original success criteria exist but were never checked against actual results
- Team moved to the next project immediately after release
- No iteration based on post-launch learnings
- "We shipped it" is treated as the end state

### Impact
Organization never learns whether its products actually work. Failed features consume resources indefinitely. Success stories cannot be replicated because outcomes were never confirmed.

### Fix
Require post-launch review at defined intervals (30, 60, 90 days). Compare actual metrics to predicted outcomes. Feed learnings into the next iteration cycle.

### Detection
- **Document patterns to search for:** Features with launch dates but no post-launch review artifacts; absence of iteration tickets after launch
- **Review questions:** "What happened after this shipped? Was the original success metric achieved?" "What did the 30-day review show?"
- **Test method:** For implementation reviews, check if the team can produce post-launch data — inability signals this pattern

---

## Imbalanced Discovery [Major]

### Signs
- All team effort goes to exploitation (optimizing known solutions) with zero exploration (discovering new opportunities)
- Discovery backlog is empty or perpetually deprioritized
- Every initiative is an iteration on existing features — no genuinely new problems explored
- Team only validates known ideas; never generates new hypotheses from observation
- "We know what users want" used to justify skipping discovery
- Innovation only happens in designated "hackathon" periods, not as continuous practice

### Impact
Product becomes incrementally better at yesterday's solution while missing tomorrow's opportunity. Competitors who explore new problem spaces leapfrog. Team's discovery skills atrophy. The organization becomes vulnerable to disruption because it stopped sensing the market.

### Fix
Allocate explicit time for exploration — Ant Murphy recommends 20-30% of discovery capacity for exploration (new problems, new segments, new technologies). Track exploration outcomes separately from exploitation outcomes. Celebrate learning from exploration, not just shipping from exploitation.

### Detection
- **Document patterns to search for:** Roadmap consisting entirely of iterations on existing features; absence of research initiatives; "we already know" language
- **Review questions:** "What new problem space has the team explored in the last quarter?" "What hypothesis was disproven recently?" "When was the last time discovery led to a genuinely new initiative (not an iteration)?"
- **Test method:** Review the last 3 months of discovery activities. If 100% are validation of existing ideas with 0% exploration of new opportunities, this pattern is active.

---

<AntiPatternSummary>
  <Pattern name="Feature Factory" severity="Critical" dimension="Product Outcomes" appliesTo="Both" />
  <Pattern name="Metric Theater" severity="Major" dimension="Product Outcomes" appliesTo="Both" />
  <Pattern name="Ship and Forget" severity="Major" dimension="Product Outcomes" appliesTo="Implementation" />
  <Pattern name="Imbalanced Discovery" severity="Major" dimension="Discovery Evidence" appliesTo="Both" />
</AntiPatternSummary>
