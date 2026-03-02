# Evaluation Framework

Detailed scoring criteria for the 10 PM review dimensions.

## Scoring Scale

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Excellent | Exceeds standards; evidence-rich, no gaps |
| 4 | Good | Meets standards with minor gaps |
| 3 | Adequate | Partially addressed; notable gaps |
| 2 | Weak | Significant gaps; requires rework |
| 1 | Missing | Not addressed or fundamentally flawed |

## Dimension 1: Problem Validation

**Proposal questions**: Is the problem clearly stated? Is there a specific job to be done? Has the team observed real user behavior (not just collected feature requests)? Is the problem space explored before jumping to solutions? Can the team articulate who has this problem and how often?

**Implementation-Compliance questions**: Was the problem validated before building? Was there a clear problem statement at the outset? Did the team avoid the Build Trap?

**Implementation-Results questions**: Does post-launch data confirm the problem was real? Are users engaging in ways that indicate the problem is being solved?

**Scoring**: 5 = validated with behavioral observation + quantitative data; 3 = problem stated but evidence is thin or anecdotal; 1 = no problem statement, jumped straight to solution.

## Dimension 2: Value Risk

**Proposal questions**: Will customers buy or use this? What demand evidence exists? Is this a must-have, performance feature, or delighter (Kano)? What happens if we do not build it? Have customers demonstrated willingness through concrete commitment (not just "I would use that")?

**Implementation-Compliance questions**: Was value risk assessed before building? Was there demand evidence?

**Implementation-Results questions**: Did customers actually adopt it? What does usage/revenue data show? Retention impact?

**Scoring**: 5 = strong demand evidence (trials, letters of intent, usage data); 3 = some interviews suggest need; 1 = no evidence of customer demand.

## Dimension 3: Usability Risk

**Proposal questions**: Has a prototype been tested with real users? What is the learning curve? Are there task completion criteria? Was design involved? Is the UX validated or assumed?

**Implementation-Compliance questions**: Was usability tested before full build? Were real users involved in validation?

**Implementation-Results questions**: Can users actually complete key tasks? What do usability metrics show (task success rate, time-on-task, error rate, support tickets)?

**Scoring**: 5 = prototype tested with 5+ users, iterated on findings; 3 = design review but no user testing; 1 = no usability consideration.

## Dimension 4: Feasibility Risk

**Proposal questions**: Has engineering validated the approach? Was a spike conducted for uncertain components? Are dependencies confirmed? Are estimates engineer-produced (not stakeholder-imposed)? Is tech debt capacity allocated (10-30% continuous)? Was the tech lead involved in architectural decisions?

**Implementation-Compliance questions**: Were estimates accurate? Was the tech lead involved? Is there a single backlog (features + tech debt together)?

**Implementation-Results questions**: Was it built sustainably? Technical debt incurred? Performance within SLAs? KTLO burden reasonable?

**Scoring**: 5 = engineer-validated with spike, dependencies confirmed, tech debt budgeted; 3 = engineering consulted but no spike; 1 = timeline imposed without engineering input.

## Dimension 5: Business Viability Risk

**Proposal questions**: Are unit economics viable? Legal and compliance reviewed? Can sales and support operationalize it? Is there a GTM plan? Does it create sustainable advantage or is it easily copied?

**Implementation-Compliance questions**: Were business constraints assessed pre-build? Was legal consulted? Was GTM planned?

**Implementation-Results questions**: Is it actually profitable? Support cost per user? Legal issues surfaced? Sales able to position it?

**Scoring**: 5 = full viability analysis (economics, legal, GTM, support); 3 = partial analysis, some areas unchecked; 1 = no viability assessment.

## Dimension 6: Strategic Alignment

**Proposal questions**: Does this serve the product vision? Is the vision customer-centric (not revenue-centric)? Does it align with current OKRs? North Star metric? Does the strategy focus on few pivotal objectives? Does it explicitly state what it will NOT do? Is it insight-driven or stakeholder wish-list driven?

**Implementation-Compliance questions**: Did the feature serve stated strategy at build time? Was there strategic justification?

**Implementation-Results questions**: Does it still serve the current vision? Has strategy shifted since launch? Is it consuming resources that could serve higher-priority objectives?

**Scoring**: 5 = directly serves vision + OKRs, explicit focus trade-offs documented; 3 = loosely connected to strategy; 1 = no strategic justification or contradicts stated direction.

## Dimension 7: Success Metrics & Evidence

**Proposal questions**: Are KPIs outcome-based (not output-based)? Are there both Spock (quantitative: DAU, conversion, NPS) and Oprah (qualitative: interviews, usability findings) evidence sources? Leading vs lagging indicators defined? Instrumentation planned? Baselines established?

**Implementation-Compliance questions**: Were success metrics defined before build? Are they outcome-based?

**Implementation-Results questions**: Are metrics being tracked? Are they being reviewed and acted on? Do dashboards exist and get used? Is the team data-driven or performing Metric Theater?

**Scoring**: 5 = outcome-based KPIs with leading + lagging indicators, baselines, instrumentation, and regular review cadence; 3 = metrics defined but output-based or not instrumented; 1 = no success metrics defined.

## Dimension 8: MVP & Experimentation

**Proposal questions**: What is the smallest testable version? Is this a one-way door (irreversible, high stakes) or two-way door (easily reversible)? What is the riskiest assumption and what is the cheapest way to validate it? Is the team building a prototype or going straight to production? Is the scope appropriate for the risk level?

**Implementation-Compliance questions**: Was an MVP or prototype tested before full build? Was the riskiest assumption validated first?

**Implementation-Results questions**: Did the MVP approach save resources? Were assumptions validated before scaling? Was scope managed appropriately?

**Scoring**: 5 = clear MVP scoped to riskiest assumption, experiment designed, decision sizing appropriate; 3 = some scope management but no explicit experimentation strategy; 1 = full feature built without validation.

## Dimension 9: Prioritization & Trade-offs

**Proposal questions**: Why this over other options? Is there a structured prioritization approach (ROI, RICE, Cost of Delay, Kano, or similar)? Are Iron Triangle trade-offs acknowledged (scope vs schedule vs resources vs quality)? Is the framing compare-and-contrast ("which of these is most important now?") rather than "whether or not"? Opportunity cost considered?

**Implementation-Compliance questions**: Was this prioritized against alternatives? Was a framework used? Were trade-offs documented?

**Implementation-Results questions**: Was the prioritization decision correct in hindsight? Did trade-offs play out as expected? Was opportunity cost justified?

**Scoring**: 5 = structured framework, explicit trade-offs, opportunity cost documented, compare-and-contrast framing; 3 = some justification but no formal framework; 1 = no prioritization rationale, FIFO backlog.

## Dimension 10: Ethics & Responsibility

**Proposal questions**: What potential harm could result if misused? Has bias been considered (data bias, algorithmic bias, exclusion)? Is accessibility addressed (WCAG, assistive tech)? Are there environmental or social consequences? What are the unintended consequences if this succeeds at scale?

**Implementation-Compliance questions**: Was an ethics review conducted? Were accessibility standards met? Was bias tested?

**Implementation-Results questions**: Have any harmful patterns emerged in production? Are there user complaints about bias or accessibility? Have unintended consequences surfaced?

**Scoring**: 5 = explicit harm assessment, bias testing, accessibility compliance, unintended consequence analysis; 3 = some consideration but not systematic; 1 = no ethical evaluation.

## Dimension Weighting Guide

Default weighting is equal (all dimensions scored 1-5, summed to /50). Adjust emphasis by input type:

| Input Type | Higher Weight Dimensions | Lower Weight Dimensions |
|-----------|------------------------|------------------------|
| New Product | Problem Validation, Value Risk, Strategic Alignment | Prioritization (fewer alternatives) |
| Feature Addition | Prioritization & Trade-offs, Strategic Alignment | Problem Validation (if product-market fit exists) |
| Technical Initiative | Feasibility Risk, Business Viability | Usability Risk (if internal tooling) |
| Growth Experiment | MVP & Experimentation, Success Metrics | Ethics (unless user-facing) |
| UX Redesign | Usability Risk, Value Risk | Feasibility Risk (if tech stack stable) |

Weighting adjusts emphasis in the rationale, not the scoring scale. All dimensions still receive a 1-5 score.

## Verdict Thresholds

### Proposal Reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Proceed** | 42-50 | Strong across all dimensions; ready to build |
| **Proceed with Conditions** | 27-41 | Viable but gaps need addressing before or during build |
| **Rework Required** | 0-26 | Fundamental gaps; return to discovery |

### Implementation Reviews

| Verdict | Score Range | Meaning |
|---------|-----------|---------|
| **Meets Standards** | 42-50 | Well-executed; outcomes being achieved |
| **Needs Improvement** | 27-41 | Functional but significant gaps to address |
| **Critical Gaps** | 0-26 | Fundamental issues; remediation plan needed |

### Critical Dimension Rules

Regardless of total score:
- Any dimension scoring 1 = cannot receive "Proceed" or "Meets Standards" verdict
- Problem Validation + Value Risk both scoring 2 or below = automatic "Rework Required" / "Critical Gaps"

## Decision Sizing Guide

Not every decision requires the same depth of evaluation. Use decision sizing to calibrate review rigor.

**One-Way Doors** (irreversible or very costly to reverse):
- Large infrastructure changes, public API contracts, pricing model changes, market entry
- Apply full 10-dimension evaluation with maximum rigor
- Require strong evidence (score 4+ on critical dimensions)

**Two-Way Doors** (easily reversible, low cost to undo):
- UI experiments, internal tooling changes, A/B tests, feature flags
- Lighter evaluation acceptable; focus on Value Risk and MVP dimensions
- Lower evidence bar acceptable (score 3+ on critical dimensions)

**Sizing Heuristic**: "If this fails, can we undo it within a week at low cost?" If yes → two-way door. If no → one-way door. When in doubt, treat as one-way.
