# Calibration Guide

What excellent PM rigor looks like — reference examples for each evaluation dimension.

## Outcomes vs Outputs

| Output (Weak) | Outcome (Strong) |
|---------------|-----------------|
| "Launch notifications by Q2" | "Increase 7-day re-engagement from 12% to 25%" |
| "Build search autocomplete" | "Reduce zero-result searches from 40% to under 10%" |
| "Ship mobile app redesign" | "Increase task completion rate from 34% to 60% on mobile" |
| "Implement SSO integration" | "Reduce enterprise onboarding time from 14 days to 3 days" |
| "Add dark mode" | "Increase evening session duration by 20% (reduce eye-strain abandonment)" |

**Test**: If the metric can be achieved by shipping broken code, it is an output. If it requires users to actually benefit, it is an outcome.

## Leading vs Lagging Indicators

| Domain | Leading (Predictive, Team-Controlled) | Lagging (Retrospective, Result) |
|--------|--------------------------------------|-------------------------------|
| Retention | 7-day feature return rate | Monthly churn rate |
| Activation | Onboarding step completion rate | 90-day active user rate |
| Revenue | Trial-to-paid conversion rate | Quarterly revenue |
| Engagement | Core action frequency (first 48h) | Monthly active users |
| Quality | Error rate per session | Support ticket volume |
| Growth | Referral invitation send rate | New user acquisition |

**Rule**: Leading indicators are things the team can directly influence this sprint. Lagging indicators confirm whether the strategy worked over time.

## Discovery Evidence Quality Spectrum

| Level | Evidence Type | Confidence | Example |
|-------|--------------|------------|---------|
| 1 - Opinion | Internal assumption | Very Low | "I think users want this" |
| 2 - Anecdote | Single data point | Low | "One customer mentioned it" |
| 3 - Qualitative Pattern | Multiple interviews | Moderate | "8 of 12 interviewees described this pain" |
| 4 - Behavioral Observation | Watching real usage | Moderate-High | "Users try to click X but it does not exist (session recordings)" |
| 5 - Quantitative Signal | Analytics data | High | "40% of searches return zero results (search logs)" |
| 6 - Experimental Result | A/B test or prototype | Very High | "Prototype A had 3x higher task completion than B (n=200)" |
| 7 - Production Data at Scale | Live metrics | Highest | "Feature adoption at 62% with 15% conversion lift (n=50K, p<0.01)" |

**Minimum bar**: Proposals should reach Level 3+ for Problem Validation and Level 4+ for Value Risk. Below Level 3 is the Opinion-Driven Planning anti-pattern.

## Problem Statement Template

> [Target customer] struggles with [problem] when [context], causing [impact].

**Weak**: "Users need better search." (No target, no problem, no context, no impact.)

**Strong**: "Mobile shoppers struggle with finding products when they misspell search terms, causing 40% of searches to return zero results and a 23% drop-off to competitor sites."

**Test**: Can you identify the WHO, WHAT, WHEN, and WHY-IT-MATTERS? If any is missing, the problem statement needs work.

## One-Way vs Two-Way Door Examples

| Decision | Door Type | Evaluation Depth |
|----------|-----------|-----------------|
| Public API contract | One-way | Full rigor; breaking changes affect all clients |
| Pricing model change | One-way | Full rigor; customer trust and revenue at stake |
| Database migration | One-way | Full rigor; data loss risk, rollback is costly |
| Feature flag experiment | Two-way | Lighter; can disable instantly |
| UI copy change | Two-way | Lighter; easily reverted |
| Internal dashboard redesign | Two-way | Lighter; only affects internal users |

**Heuristic**: "If this fails, can we undo it within a week at low cost?" Yes → two-way door → decide quickly. No → one-way door → invest in evidence.

## Spock vs Oprah Approach

The best PMs use both quantitative (Spock) and qualitative (Oprah) evidence.

| Spock (Quantitative) | Oprah (Qualitative) |
|---------------------|-------------------|
| DAU, MAU, conversion rates | User interviews, observation sessions |
| A/B test results with statistical significance | Usability test recordings |
| Funnel analytics, cohort analysis | Customer support conversation themes |
| NPS scores, CSAT ratings | "Tell me about a time when..." |
| Revenue per user, LTV, CAC | Contextual inquiry (watching users in their environment) |

**Spock without Oprah**: You know WHAT is happening but not WHY. You see a 30% drop-off but cannot explain it.

**Oprah without Spock**: You know WHY someone is frustrated but not how widespread the problem is. You have a moving story from 1 user.

**Both together**: "We see a 30% drop-off at step 3 (Spock). User observations reveal the form requires information they do not have at this point (Oprah). This affects 4,200 users/week (Spock)."

## Iron Triangle Trade-off Scenarios

The PM must make explicit trade-offs between scope, schedule, resources, and quality.

| Scenario | Trade-off Decision | PM Framing |
|----------|-------------------|------------|
| Deadline fixed, scope growing | Cut scope to protect quality | "Which features can we defer to v2 without losing the core value?" |
| Budget constrained | Reduce scope or extend timeline | "Given the team size, we can deliver A+B by Q2 or A+B+C by Q3. Which serves the OKR better?" |
| Quality bar non-negotiable | Flex scope and timeline | "We will not ship with known usability issues. Here is what fits in the timeline at our quality bar." |
| Team asked to do everything | Prioritize ruthlessly | "We have capacity for 3 of these 8 initiatives. Here is the ROI ranking." |

**Anti-pattern**: Promising all four (full scope, on time, within budget, high quality). Something always gives — the PM's job is to make the trade-off explicit.

## Compare-and-Contrast Framing

| Weak Framing | Strong Framing |
|-------------|---------------|
| "Should we build dark mode?" (whether or not) | "Which of these 3 retention initiatives should we prioritize: dark mode, notification preferences, or onboarding redesign?" (compare-and-contrast) |
| "Should we invest in search?" (single option) | "Given our 'reduce friction' strategy, which has higher ROI: search autocomplete or improved filtering?" (compare-and-contrast) |

**Why it matters**: "Whether or not" framing creates a false binary and invites groupthink. Compare-and-contrast forces explicit trade-offs and reveals opportunity costs.

## Ethics Evaluation Checklist

- **Harm potential**: What happens if this feature is misused? At scale? By bad actors?
- **Bias**: Does the data or algorithm exclude or disadvantage any group? Are training sets representative?
- **Accessibility**: Does the feature meet WCAG standards? Can it be used with assistive technology?
- **Privacy**: What data is collected? Is consent informed and genuine? Can users delete their data?
- **Environmental**: What is the compute/energy cost at scale? Are there sustainable alternatives?
- **Unintended consequences**: If this succeeds wildly, what second-order effects emerge?

## Influence vs Authority Examples

| Authority Approach (Weak PM) | Influence Approach (Strong PM) |
|-----------------------------|-----------------------------|
| "Build this feature by March" (dictating) | "Here is the problem, the evidence, and three options. Which approach does the team think best solves it?" (collaborative) |
| "I decided we are using React" (overstepping) | "Given our constraints [X, Y, Z], the tech lead recommends React. Here is the trade-off analysis." (facilitating) |
| "This is the priority because I said so" | "Here is the RICE analysis showing this has 3x the impact-per-effort of alternatives" (evidence) |
| Sending requirements doc to engineering | Running a Three Amigos session (PM + Design + Engineering) to explore solutions together |

**Principle**: The PM who uses evidence and collaboration earns more influence than the PM who demands authority.

## Customer Observation Examples

| Taking Feature Requests (Weak) | Observing Behavior (Strong) |
|-------------------------------|---------------------------|
| Customer says: "I want an export button" → PM adds "export button" to backlog | PM asks: "Show me what you do with the data after you get it" → discovers customer copies data to spreadsheet for pivot tables → PM explores in-app analytics instead |
| Customer says: "Make it faster" → PM files "improve performance" ticket | PM watches session recording → discovers user clicks 6 times to reach a page that could be 2 clicks → PM redesigns navigation |
| Customer says: "Add a notification" → PM builds notification | PM asks: "What were you doing when you realized you needed that information?" → discovers the real need is a dashboard, not a notification |

**Principle**: Customers describe solutions in terms of what they already know. The PM's job is to observe the underlying behavior and innovate on their behalf.

## Complete PM Toolkit

All techniques a PM reviewer checks for, organized by application scope.

**Tactical (Day-to-Day Execution)**:
- Acceptance criteria defined and testable
- Three Amigos review (PM + Design + Engineering)
- Tactical data used in decisions (CTR, DAU, A/B results, error rates)
- Retrospectives feeding next iteration
- Bug/defect triage with severity classification

**Operational (Feature/Quarter Level)**:
- Outcome vs output check on every KR
- MVP or prototype validation before full build
- Stakeholder iteration reviews during discovery (not after)
- Pirate Metrics (AARRR: Acquisition, Activation, Retention, Referral, Revenue)
- Iteration decisions based on post-launch data

**Strategic (Product/Annual Level)**:
- North Star metric alignment verified
- Cross-functional viability review (legal, sales, support, marketing)
- ROI and opportunity cost analysis
- Shuttle Diplomacy for stakeholder alignment
- Riskiest Assumption Tests (RATs) for big bets
- Kano Model classification for feature categorization
- Cost of Delay estimation for time-sensitive decisions
