# Feedback Template

Structured output format for Product Marketing Manager reviews.

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Market risk unaddressed or GTM broken | Must resolve before proceeding |
| **Major** | Significant gap in market readiness or process | Should resolve for quality |
| **Minor** | Small gap or improvement opportunity | Consider addressing |
| **Suggestion** | Enhancement idea | Optional |

## Full Review Template

```markdown
## Product Marketing Manager Review

**Input**: [What was reviewed]
**Review Mode**: [Proposal Review / Implementation Review]
**Perspective**: Product Marketing Manager
**Verdict**: [Proceed / Proceed with Conditions / Rework Required] or [Meets Standards / Needs Improvement / Critical Gaps]

### PMM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Market Understanding & Buyer Personas | /5 | |
| 2 | Positioning & Messaging Clarity | /5 | |
| 3 | Competitive Differentiation | /5 | |
| 4 | Go-to-Market Strategy & Execution | /5 | |
| 5 | Sales Enablement & Cross-Functional Readiness | /5 | |
| 6 | Launch Planning & Execution | /5 | |
| 7 | Market Performance Measurement | /5 | |
| 8 | Pricing & Packaging Strategy | /5 | |
| 9 | Channel Strategy & Distribution | /5 | |
| 10 | Customer Evidence & Proof Points | /5 | |
| | **Overall Score** | **/50** | |

### PMM Compliance Checklist (Implementation Reviews Only)

| Requirement | Met? | Gap |
|-------------|------|-----|
| Buyer personas defined with buying triggers and objections | [Yes/No] | |
| Decision-making unit mapped (economic buyer, champion, evaluator) | [Yes/No] | |
| Positioning framework created using Dunford's 5 components | [Yes/No] | |
| Messaging tested with target buyers before launch | [Yes/No] | |
| Competitive battle cards created and distributed to sales | [Yes/No] | |
| Customer Impact Assessment conducted (ripple effect) | [Yes/No] | |
| Organization confirmed ready before release (or feature held "dark") | [Yes/No] | |
| GTM motion selected and documented with rationale | [Yes/No] | |
| Sales enablement assets delivered (deck, demo, objection guide, ROI calculator) | [Yes/No] | |
| Sales team trained and readiness verified before launch | [Yes/No] | |
| Launch tiered appropriately (T1/T2/T3) with coordinated plan | [Yes/No] | |
| Pricing benchmarked against competitors and WTP validated | [Yes/No] | |
| Channels selected based on buyer behavior with economics modeled | [Yes/No] | |
| Customer Discovery Program executed — referenceable customers identified | [Yes/No] | |
| Market performance KPIs defined across both bow-tie sides | [Yes/No] | |
| Post-launch win/loss data driving positioning iteration | [Yes/No] | |

### Critical Issues
- [ ] [Issue] — [Dimension] — [Required action]

### Major Issues
- [ ] [Issue] — [Dimension] — [Recommended action]

### Minor Issues
- [ ] [Issue] — [Dimension] — [Suggestion]

### Strengths
- [What is well-done from a PMM perspective]

### Top Recommendation
[One highest-priority action the plan owner should take]

### Key Question for the Team
[The single most important question the PMM would ask]
```

## Filled Example 1: Proposal Review

```markdown
## Product Marketing Manager Review

**Input**: Enterprise Analytics Platform: New Mid-Market Segment Launch Plan
**Review Mode**: Proposal Review
**Perspective**: Product Marketing Manager
**Verdict**: Proceed with Conditions

### PMM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Market Understanding & Buyer Personas | 4/5 | Mid-market buyer personas defined at Level 4 (buying behaviors documented). Decision-making unit mapped: VP Analytics (economic buyer), Data Team Lead (champion), IT Security (blocker). Problem scores high on 3 of 4 U's — Unworkable (manual reporting takes 12 hrs/week), Unavoidable (regulatory reporting), Urgent (board visibility). Underserved is weaker — competitors exist but are over-priced for mid-market. TAM/SAM/SOM present. |
| 2 | Positioning & Messaging Clarity | 3/5 | Dunford's framework partially applied. Competitive alternatives identified (Tableau, Power BI, status quo spreadsheets) but from internal analysis, not buyer interviews. Value themes defined ("enterprise analytics at mid-market price") but not validated with buyers. Market category is "mid-market analytics" — reasonable but default, not deliberate. Messaging not tested with target buyers. |
| 3 | Competitive Differentiation | 4/5 | Competitive analysis thorough. Category strategy is "big fish, small pond" (subsegment) — own the mid-market where Tableau/Power BI are overbuilt and overpriced. Differentiation is defensible: pre-built industry templates that enterprise tools lack. Battle cards drafted for top 3 competitors. |
| 4 | Go-to-Market Strategy & Execution | 3/5 | GTM motion defined (sales-assisted PLG) but covers acquisition funnel only. No expansion/retention strategy — right side of the bow-tie is absent. MOVE stage identified as Transition (account-focused), which aligns with the motion. Funnel metrics defined for top-of-funnel but not for full journey. |
| 5 | Sales Enablement & Cross-Functional Readiness | 4/5 | Strong enablement plan: pitch deck, demo script, competitive battle cards, and objection guide planned. ROI calculator in development. Training scheduled 2 weeks pre-launch. Gap: no readiness verification step defined — training is planned but verification is not. |
| 6 | Launch Planning & Execution | 5/5 | Launch classified as T1 (new segment, strategic importance, top-of-funnel impact). Full launch brief with all sections. Go/no-go review scheduled 4 weeks pre-launch. Activities matched to T1: press release, launch event, executive sponsorship, analyst briefing, full enablement. Post-launch retrospective at 30 days. |
| 7 | Market Performance Measurement | 3/5 | Pipeline metrics defined (MQLs, SQLs, pipeline generated) but no expansion metrics planned. No win/loss program defined for the new segment. Marketing attribution model exists for existing segments but not adapted for mid-market. |
| 8 | Pricing & Packaging Strategy | 4/5 | Pricing researched via competitive benchmark (30-40% below enterprise competitors). Van Westendorp conducted with 15 mid-market prospects. Packaging creates clear upgrade paths (Starter → Pro → Enterprise). Gap: value metric not explicitly defined — seat-based pricing may not align with mid-market value perception. |
| 9 | Channel Strategy & Distribution | 3/5 | Channels selected (LinkedIn, G2, industry events) but based on enterprise buyer behavior, not mid-market research. Channel economics not modeled for the new segment. Content planned but not mapped to mid-market buyer journey stages. |
| 10 | Customer Evidence & Proof Points | 3/5 | Customer Discovery Program defined — 5 design partners identified for early access. But no referenceable customers yet (expected). Case study plan exists but is contingent on design partner results. No analyst briefing for mid-market positioning yet. |
| | **Overall Score** | **36/50** | |

### Customer Impact Assessment

| Stakeholder | Impact | Ready? |
|-------------|--------|--------|
| Existing enterprise customers | Low — separate segment, no product changes | Yes |
| Sales team | High — new pitch, new personas, new competitive landscape | Partial — training planned but unverified |
| CS/Support | Medium — need mid-market playbooks, different SLA expectations | No — no mid-market support documentation |
| Partners | Low — no channel partner involvement initially | N/A |

**Recommendation**: Proceed with launch but ensure CS/Support documentation is complete before go/no-go. Consider "soft launch" with design partners before broad market push to build evidence.

### Critical Issues
- [ ] Positioning not validated with buyers — Positioning & Messaging — Dunford's competitive alternatives identified internally. Test the full 5-component positioning with 5+ mid-market buyers before launch. Messaging that "enterprise analytics at mid-market price" resonates internally but may not match how mid-market buyers describe their problem.

### Major Issues
- [ ] No expansion/retention GTM strategy — GTM Strategy — Bow-tie right side completely absent. Mid-market has high churn risk. Define onboarding, adoption, and expansion playbooks. Track NRR from launch.
- [ ] No win/loss program for new segment — Market Performance — Define win/loss methodology before launch so the team can learn from early wins and losses in an unfamiliar segment.
- [ ] Channels based on enterprise behavior — Channel Strategy — Mid-market buyers may not attend the same events or consume the same content as enterprise buyers. Research mid-market information consumption patterns.

### Minor Issues
- [ ] No sales readiness verification — Sales Enablement — Training is planned but there is no mechanism to verify reps can articulate the mid-market value proposition independently. Add a readiness check.
- [ ] Value metric unclear — Pricing — Seat-based pricing may not align with mid-market value perception. Consider usage-based or team-based alternatives.

### Strengths
- Excellent launch planning with T1 classification, full brief, and go/no-go process
- Strong competitive differentiation with deliberate subsegment strategy (big fish, small pond)
- Customer Discovery Program with design partners — building evidence before broad launch
- Pricing validated with willingness-to-pay research and clear upgrade paths

### Top Recommendation
Test the full positioning framework with 5+ mid-market buyers before launch. The biggest risk is that internally-developed positioning does not resonate with a buyer segment the team has not served before.

### Key Question for the Team
How do mid-market analytics buyers describe their problem in their own words — and does "enterprise analytics at mid-market price" match that language, or is it how we describe it internally?
```

## Filled Example 2: Implementation Review

```markdown
## Product Marketing Manager Review

**Input**: Collaboration Feature (launched 60 days ago, mixed market results)
**Review Mode**: Implementation Review
**Perspective**: Product Marketing Manager
**Verdict**: Needs Improvement

### PMM Evaluation Scorecard

| # | Dimension | Score | Rationale |
|---|-----------|-------|-----------|
| 1 | Market Understanding & Buyer Personas | 3/5 | Buyer personas exist at Level 3 (behavioral) but buying triggers and objections were not documented. JTBD analysis: functional job identified ("collaborate on documents in real-time") but social and emotional jobs not explored. Decision-making unit partially mapped — champion identified but economic buyer's priorities unknown. Problem scores on 2 of 4 U's (Urgent + Underserved). |
| 2 | Positioning & Messaging Clarity | 2/5 | Feature-list positioning. Website says "Real-time collaboration with commenting, version history, and permissions." No Dunford framework applied. No competitive alternatives identified from buyer perspective. No value themes — only feature descriptions. Messaging never tested with buyers. Win/loss interviews (post-launch) reveal prospects say "sounds like Google Docs but inside your tool" — positioning has not differentiated. |
| 3 | Competitive Differentiation | 3/5 | Competitive landscape partially mapped (Google Workspace, Microsoft 365, Notion). Battle cards created for Google and Microsoft but do not address status quo ("email attachments back and forth"). Status quo is the actual primary competitor per win/loss data — 45% of lost deals chose "keep doing what we do." No category strategy chosen. |
| 4 | Go-to-Market Strategy & Execution | 3/5 | Acquisition-side GTM executed (launch campaign, content, webinar). No expansion strategy — existing customers unaware of the feature 60 days post-launch. Adoption metrics show only 18% of existing accounts have activated collaboration. Right side of bow-tie completely absent. MOVE stage: Execution (customer-focused growth) — but GTM was treated as Ideation (lead-focused). |
| 5 | Sales Enablement & Cross-Functional Readiness | 2/5 | Pitch deck created but no demo script, no objection guide, no ROI calculator. Sales team received a 30-minute webinar but no hands-on training. Post-launch survey: 40% of reps say they "are not confident explaining the collaboration feature." Battle cards not distributed until 2 weeks after launch. Reps creating their own slides. |
| 6 | Launch Planning & Execution | 3/5 | Launch treated as T2 but activities matched T3 (blog post, changelog, email). No launch brief. No go/no-go review — feature shipped when engineering completed it. No post-launch retrospective conducted. Launch timing coincided with a competitor's major announcement, diluting share of voice. |
| 7 | Market Performance Measurement | 2/5 | CRM win/loss codes only — Clozd research shows these are 85% inaccurate. Pipeline metrics tracked for acquisition but no expansion measurement. No marketing attribution for the collaboration launch specifically. Win/loss interviews conducted post-hoc (good) but not systematic — only 8 interviews completed in 60 days. |
| 8 | Pricing & Packaging Strategy | 4/5 | Collaboration included in existing Pro and Enterprise tiers (correct decision — table stakes feature for retention). No pricing change required. Packaging aligns with bow-tie expansion — collaboration is a driver for team-plan upgrades. Value metric clear (per-seat, teams benefit from more seats). |
| 9 | Channel Strategy & Distribution | 3/5 | Launch channels: blog, email to existing customers, Product Hunt. Blog and email appropriate for existing customer communication. Product Hunt drove awareness but wrong audience (individual users, not teams). No channel economics tracked. No content mapped to buyer journey for the collaboration use case. |
| 10 | Customer Evidence & Proof Points | 2/5 | No Customer Discovery Program executed. Feature launched without referenceable customers. Post-launch: 3 customers willing to provide quotes but no quantified case studies. Claims on website ("transform how your team works") are assertions without proof. No analyst briefing conducted. |
| | **Overall Score** | **27/50** | |

### PMM Compliance Checklist

| Requirement | Met? | Gap |
|-------------|------|-----|
| Buyer personas defined with buying triggers and objections | Partial | Personas exist but buying triggers/objections not documented |
| Decision-making unit mapped | Partial | Champion identified, economic buyer priorities unknown |
| Positioning framework created using Dunford's 5 components | No | Feature-list positioning; no framework applied |
| Messaging tested with target buyers before launch | No | Tested internally only |
| Competitive battle cards created and distributed to sales | Partial | Created but distributed 2 weeks late |
| Customer Impact Assessment conducted (ripple effect) | No | Not conducted — see impact below |
| Organization confirmed ready before release (or feature held "dark") | No | Feature released when engineering completed, not when org was ready |
| GTM motion selected and documented with rationale | No | Ad-hoc GTM, no motion documented |
| Sales enablement assets delivered (deck, demo, objection guide, ROI calculator) | Partial | Deck only; no demo script, objection guide, or ROI calculator |
| Sales team trained and readiness verified before launch | Partial | 30-min webinar; no readiness verification; 40% not confident |
| Launch tiered appropriately (T1/T2/T3) with coordinated plan | No | Called T2 but executed as T3 |
| Pricing benchmarked against competitors and WTP validated | Yes | Included in existing tiers — appropriate for retention play |
| Channels selected based on buyer behavior with economics modeled | No | Channels selected by convention; no economics |
| Customer Discovery Program executed — referenceable customers identified | No | No program; launched without reference customers |
| Market performance KPIs defined across both bow-tie sides | No | Acquisition metrics only; no expansion tracking |
| Post-launch win/loss data driving positioning iteration | Partial | 8 interviews conducted but not systematically analyzed |

### Customer Impact Assessment (Conducted Post-Hoc)

**Finding**: Customer Impact Assessment was NOT conducted before launch. The consequences:
- **Existing customers**: 23% of support tickets in weeks 2-4 were collaboration-related ("how do I control who edits my documents?"). Permissions model was unclear.
- **Sales team**: 40% not confident discussing the feature. Some reps avoided mentioning it.
- **CS/Support**: Documentation published on launch day — support team had no advance training. Average handle time for collaboration tickets was 3x normal.
- **Verdict**: The organization was not ready. The feature should have been released "dark" to a beta group while CS was trained and documentation was refined.

### Win/Loss Insights (From 8 Post-Launch Buyer Interviews)

- 45% of lost deals: "We are fine with email and Dropbox" (status quo competitor not addressed)
- 30% of lost deals: "Google Docs already does this and it is free" (positioning did not differentiate)
- 25% of won deals: "The fact that it is inside the tool I already use is the reason" (embedded value — not captured in positioning)
- **Key insight**: The winning value theme is "embedded collaboration without context-switching" — but this is not in any positioning or messaging material.

### Critical Issues
- [ ] Feature-list positioning — Positioning & Messaging — Win/loss interviews reveal the winning value theme ("embedded collaboration without context-switching") is not in any messaging. Apply Dunford's 5-component framework to reposition based on actual buyer feedback. Current positioning ("real-time collaboration with commenting, version history, and permissions") is a feature list that buyers compare unfavorably to Google Docs.
- [ ] No Customer Impact Assessment — Launch Planning — Organization was not ready. Support tickets spiked. CS had no training. This must be remediated immediately and instituted as a mandatory process for future releases.

### Major Issues
- [ ] Status quo competitor ignored — Competitive Differentiation — 45% of losses are to "doing nothing." Battle cards must address status quo as the primary competitor, not just Google and Microsoft. Rewrite competitive strategy.
- [ ] Expansion strategy absent — GTM Strategy — 82% of existing accounts have not activated collaboration. This is a retention/expansion feature but GTM treated it as acquisition. Create an adoption campaign for existing customers. Track activation rate as a primary KPI.
- [ ] Sales enablement inadequate — Sales Enablement — 40% of reps not confident. Deploy full enablement suite immediately: demo script, objection guide (especially vs status quo), ROI calculator showing productivity gains.
- [ ] Win/loss program ad-hoc — Market Performance — 8 interviews in 60 days is insufficient. Systematize using Clozd methodology. Publish monthly Voice of Buyer brief. The insights from these 8 interviews are already transformative — imagine what systematic collection would reveal.

### Minor Issues
- [ ] Product Hunt was wrong channel — Channel Strategy — Drove individual signups, not team accounts. For collaboration features targeting teams, consider G2, Capterra, or industry-specific communities.
- [ ] No referenceable customers — Customer Evidence — 3 willing customers is a start. Execute a Customer Discovery Program to develop quantified case studies from early adopters showing productivity gains.

### Strengths
- Pricing and packaging decision was sound — including collaboration in existing tiers supports retention and team expansion
- Post-launch buyer interviews (even if ad-hoc) produced actionable insights that can reframe positioning
- The winning value theme ("embedded collaboration without context-switching") is a strong, defensible differentiator once captured in positioning
- Feature itself is technically solid — the product is not the problem; the go-to-market is

### Top Recommendation
Reposition immediately using the winning value theme from buyer interviews: "embedded collaboration without context-switching." Apply Dunford's 5-component framework. Test the new messaging with 5+ buyers. Then redeploy enablement assets and retrain the sales team. The product has a defensible differentiator — it is just not in any of the marketing materials.

### Key Question for the Team
If 45% of losses are to "doing nothing" and the winning value theme is not in any messaging, what would happen if we repositioned entirely around the insight buyers are already telling us?
```

## Quick Review Template

```markdown
## Product Marketing Manager Review (Quick)

**Input**: [What was reviewed] | **Mode**: [Proposal / Implementation] | **Verdict**: [Verdict] | **Score**: /50

**Top Risks**: [1-2 highest concerns with dimension names]
**Strengths**: [1-2 positive signals]
**Top Recommendation**: [Single action item]
**Key Question**: [One question for the team]
```
