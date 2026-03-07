# Anti-Patterns: Strategy & Planning

Failure modes in how work gets prioritized, scoped, and framed before building.

## Opinion-Driven Planning [Critical]

### Signs
- Proposals cite no customer interviews, experiments, or usage data
- Justification is "stakeholder X requested this" or "competitor Y has it"
- Team cannot name a specific customer who has the stated problem
- Discovery section is empty or filled with assumptions

### Impact
Resources are allocated to solutions that do not address validated customer needs, leading to low adoption and wasted effort.

### Fix
Require at minimum 5 customer interviews or prototype tests before any proposal advances past discovery. Document evidence artifacts.

### Detection
- **Document patterns to search for:** "stakeholder requested", "competitor has", "users want", "market opportunity" without supporting data
- **Review questions:** "Can you name 3 customers who described this problem?" "What evidence exists beyond internal opinion?"
- **Test method:** Check if the Discovery Evidence dimension scores 2 or below — if so, this anti-pattern is likely present

---

## Stakeholder-Driven Roadmap [Major]

### Signs
- Roadmap items trace back to executive requests, not customer discovery
- HiPPO (Highest Paid Person's Opinion) determines priority
- Product team acts as a feature-request fulfillment service
- Discovery is skipped because "leadership already decided"

### Impact
Product strategy is disconnected from customer reality. Team loses agency and motivation. Features serve internal politics, not customer needs.

### Fix
Require customer evidence for every roadmap item regardless of source. Product leadership should set problems to solve, not solutions to build.

### Detection
- **Document patterns to search for:** "CEO wants", "board asked for", "leadership priority" without customer validation
- **Review questions:** "Who requested this, and what customer evidence supports it?" "Would this be on the roadmap if the executive hadn't asked?"
- **Test method:** Trace each roadmap item to its origin — if >50% trace to stakeholders rather than customers, this pattern is active

---

## Invisible Customer [Major]

### Signs
- Target customer/persona is not defined or is "everyone"
- No segmentation of who benefits most
- Problem statement uses "users" generically without specificity
- No evidence of direct customer contact

### Impact
Feature solves nobody's problem well because it was designed for an abstract, non-existent user.

### Fix
Name the target persona with demographic, behavioral, and need-based attributes. Validate the problem with representatives of that segment.

### Detection
- **Document patterns to search for:** "users", "customers" used generically without segment qualifier; absence of persona names
- **Review questions:** "Who specifically is the target user? Can you describe their role, context, and needs?" "Which segment would miss this most?"
- **Test method:** Check if Value Risk V4 (Segment Definition) scores 2 or below

---

## Product Theater [Critical]

### Signs
- Agile/product rituals performed without producing actual outcomes (standups with no blockers resolved, retros with no action items implemented, sprint reviews with no stakeholder feedback incorporated)
- Decisions still escalate 3+ levels despite nominally empowered teams
- Discovery "happens" but conclusions are predetermined by leadership
- OKRs exist but nobody references them in day-to-day decisions
- Innovation sprints that produce demos but never ship

### Impact
Organization believes it is product-led while operating as a command-and-control structure. Teams lose trust in process. True product management skills atrophy because they're never actually exercised. Resources spent on ritual overhead without corresponding value.

### Fix
Audit the gap between process and power. Ask: "When was the last time a team's discovery findings changed a leadership decision?" If the answer is "never," the process is theater. Empower teams with real decision authority within bounded constraints. Measure process by outcomes, not compliance.

### Detection
- **Document patterns to search for:** Meeting agendas without outcomes; "we follow agile" alongside top-down feature mandates; OKRs mentioned in planning documents but absent from weekly updates
- **Review questions:** "Can you give an example of a team decision that went against a leader's initial preference, based on evidence?" "When did discovery findings last change the plan?"
- **Test method:** Compare stated process (how the team says they work) to actual decision records (who actually decided what). Gaps indicate theater.

---

## Puppet Master [Major]

### Signs
- Leaders assign problems to teams but impose the solution — "solve engagement, by building feature X"
- "Empowered teams" that can only choose how to implement, not what to build
- Discovery is scoped to validate a predetermined conclusion, not to explore the problem space
- Team proposals that deviate from leadership expectations are redirected back to the original solution
- Solution is defined before the problem is fully understood

### Impact
Teams become demoralized order-takers. Innovation dies because diverse perspectives are filtered out. Solutions are limited to the leader's imagination, missing better alternatives. Ownership is performative — teams don't own outcomes they didn't choose.

### Fix
Leaders should define the problem and constraints, not the solution. Use the Netflix "Informed Captain" model: provide context, let the team decide, hold them accountable for outcomes. If leadership must constrain the solution space, make the constraints explicit and justified ("regulatory requirement," not "because I said so").

### Detection
- **Document patterns to search for:** Problem statements that include specific solutions; "explore options" followed by "we recommend X" from leadership; briefs that describe what to build rather than what problem to solve
- **Review questions:** "Was the solution space open when the team started, or was the solution predetermined?" "Could the team have proposed a completely different approach?"
- **Test method:** Check if the proposal includes alternative solutions that were evaluated and rejected. If only one solution was ever considered, and it matches a leadership directive, Puppet Master is likely active.

---

<AntiPatternSummary>
  <Pattern name="Opinion-Driven Planning" severity="Critical" dimension="Discovery Evidence" appliesTo="Proposal" />
  <Pattern name="Stakeholder-Driven Roadmap" severity="Major" dimension="Discovery Evidence" appliesTo="Both" />
  <Pattern name="Invisible Customer" severity="Major" dimension="Value Risk" appliesTo="Both" />
  <Pattern name="Product Theater" severity="Critical" dimension="All" appliesTo="Both" />
  <Pattern name="Puppet Master" severity="Major" dimension="Discovery Evidence" appliesTo="Both" />
</AntiPatternSummary>
