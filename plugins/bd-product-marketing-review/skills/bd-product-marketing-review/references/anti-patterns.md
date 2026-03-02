# PMM Anti-Patterns

Named failure modes that PMM reviews must detect. Each pattern includes signs to look for, its impact, and a concrete fix.

## Critical Anti-Patterns

### 1. Invisible Buyer

**Signs**: No buyer persona beyond demographics. Target market is "everyone." LOVED Ambassador fundamental completely absent. Dunford's Step 7 (who cares a lot?) never executed. No decision-making unit mapped (economic buyer, champion, technical evaluator, blocker not identified). No JTBD analysis. Buyer journey not documented.

**Impact**: Product marketed to an abstract buyer solves nobody's buying problem well. Messaging is generic and resonates with no one. Sales team cannot tailor conversations. Win rates decline because the value proposition is diffuse.

**Fix**: Build buyer personas to at least Level 4 (buying behaviors). Map the decision-making unit. Execute Dunford's Step 7 to identify "who cares a lot." Validate with buyer interviews, not internal assumptions. Apply the 4 W's problem framing template.

---

### 2. Feature-List Positioning

**Signs**: Dunford explicitly identifies this as the most common positioning failure. All 5 traps present: Default Positioning (inherited, not deliberate), Phantom Competitors (never actually lose to them), Status Quo Blindness (20-30% of enterprise deals lost to "no decision"). Messaging is a spec sheet, not a value narrative. No market category choice made. No competitive alternatives identified from buyer perspective.

**Impact**: Prospects cannot understand why this product matters to them. Sales cycles lengthen because buyers must do the positioning work themselves. Win rates drop because the product blends into a crowded market. Category Queen economics (76% of market value) go to the competitor who positions deliberately.

**Fix**: Execute Dunford's complete 5-component process: identify competitive alternatives from buyer interviews, map unique attributes with evidence, define 2-4 value themes, validate target customer characteristics, and deliberately choose a market category. Test messaging with 5+ target buyers before launch.

---

### 3. Unarmed Sales Team

**Signs**: LOVED Evangelist fundamental failed. Reps create their own inconsistent decks. No battle cards, no objection guides, no ROI calculators. No training conducted before launch. Dunford's test: "if the lightbulb does not come on in sales calls, positioning is broken." Sales team learns about features from customers or product changelog.

**Impact**: Inconsistent messaging in the market. Every rep tells a different story. Prospects get confused. Win rates vary wildly by rep (a sign of enablement, not talent). Competitive deals lost because reps cannot counter objections. Sales team loses confidence in marketing.

**Fix**: Deploy the full enablement suite before launch: pitch deck, demo script, battle cards per competitor, objection handling guide, ROI calculator, one-pager per persona. Train the sales team and verify readiness. Require that reps can articulate the value proposition independently before launch.

---

## Major Anti-Patterns

### 4. Org-Unready Launch

**Signs**: Feature released without Customer Impact Assessment. No "ripple effect" analysis conducted. Sales, CS, and support learn about changes from customers, not from internal enablement. Existing customer workflows disrupted without warning. Support tickets spike. Neither gentle deployment strategy was applied — the team neither held the release nor released "dark" with feature flags. The PMM's organizational readiness gate was bypassed or did not exist.

**Impact**: Customer trust erodes — they feel the product is a "constantly moving target" that requires continual relearning. Support costs spike. Sales team is blindsided by customer questions. CS scrambles to update documentation. Churn increases as frustrated customers seek stable alternatives. Brand reputation takes a hit that is slow to recover.

**Fix**: Institute a mandatory Customer Impact Assessment before every release. Evaluate the ripple effect on all stakeholders (customers, sales, CS, support, partners). If any stakeholder is unprepared, apply a gentle deployment strategy: hold the release until ready, or release "dark" using feature flags. The PMM controls the market release switch, not engineering.

---

### 5. Launch and Vanish

**Signs**: Launch spike then flatline. GTM treated as a moment, not a system (violates Principle 7). No 90-day post-launch campaign plan. No Lauchengco Release Scale applied. Marketing declares "launch complete" after the announcement. No sustained demand generation. No post-launch retrospective.

**Impact**: Initial awareness fades quickly. Pipeline dries up after the launch spike. Feature adoption plateaus at early adopters. Investment in building the feature is not matched by investment in sustained market impact. Competitors who sustain their campaigns outperform.

**Fix**: Apply the bow-tie model — GTM is a sustained system, not a moment. Create a 90-day post-launch campaign plan with sustained demand generation activities. Schedule a post-launch retrospective at 30 days. Track adoption and pipeline metrics weekly, not just at launch.

---

### 6. Competitive Blindness

**Signs**: No battle cards. Status quo not treated as a competitor (Dunford: 20-30% of enterprise deals lost to "no decision"). No win/loss program. Play Bigger category strategy never considered. Team cannot name the top 3 competitive alternatives from the buyer's perspective. Competitive intelligence is based on competitor websites, not buyer feedback.

**Impact**: Deals lost to competitors or status quo without understanding why. Positioning does not address the buyer's real alternatives. Sales team cannot counter competitive objections. Product roadmap is disconnected from competitive dynamics.

**Fix**: Identify competitive alternatives from buyer interviews, not internal assumptions. Always include status quo as a competitor. Create and distribute battle cards. Establish a win/loss program (Clozd methodology). Conduct category strategy analysis (head-to-head, subsegment, or new category).

---

### 7. Assertion Without Evidence

**Signs**: "Industry-leading" claims with zero proof. Violates Principle 8. Clozd research shows buyers challenge unsubstantiated claims in procurement. No case studies, no analyst validation. No Customer Discovery Program for referenceable customers. Marketing collateral filled with superlatives but no data.

**Impact**: Buyer trust collapses during procurement when claims cannot be substantiated. Analyst relations suffer. Competitive comparisons expose empty assertions. Sales team avoids making claims they cannot back up, creating misalignment with marketing.

**Fix**: Execute a Customer Discovery Program to identify and onboard referenceable customers before broad launch. Create case studies with quantified results. Build a proof point library accessible to sales. Obtain analyst validation. Replace every assertion with a proof point: "We reduced invoice processing time by 73% for [Customer]" instead of "industry-leading automation."

---

### 8. One-Size-Fits-All Messaging

**Signs**: Same pitch for economic buyer and technical evaluator. Decision-making unit not mapped. Moore's adoption lifecycle segments not addressed. No persona-specific messaging variants. Marketing produces one deck and one one-pager for all audiences.

**Impact**: Messaging resonates with no one because it tries to speak to everyone. Economic buyers want ROI; technical evaluators want architecture; champions want transformation stories. A single message satisfies none of them. Sales cycles lengthen as reps improvise persona-specific narratives.

**Fix**: Map the decision-making unit and create persona-specific messaging variants. Tailor value propositions to each role: ROI for economic buyers, technical proof for evaluators, transformation narrative for champions. Apply Moore's lifecycle-appropriate messaging.

---

### 9. Channel Spray

**Signs**: Budget across 10+ channels with no buyer behavior data. No channel economics (CAC by channel). Violates Pragmatic Institute market research discipline. "We need to be everywhere" mentality. No performance tracking by channel.

**Impact**: Budget diluted across too many channels. No channel performs well because investment is too thin. Cannot attribute pipeline to channels. Marketing spend increases without corresponding pipeline growth.

**Fix**: Research where target buyers actually consume information. Select 2-3 channels based on buyer behavior data. Model channel economics (CAC, conversion rates). Track performance and optimize. Cut underperforming channels quarterly.

---

### 10. Pricing Vacuum

**Signs**: Finance sets price alone. No competitive benchmark. No willingness-to-pay research (Van Westendorp/Gabor-Granger). No packaging alignment with bow-tie expansion paths. Value metric not identified. Pricing is cost-plus or arbitrary.

**Impact**: Revenue left on the table (priced too low) or deals lost (priced too high). No expansion revenue because packaging does not create upgrade paths. Sales team discounts aggressively because they cannot justify the price. Competitive pricing unknown.

**Fix**: Conduct willingness-to-pay research. Complete competitive pricing benchmark. Identify the value metric. Design packaging with clear upgrade paths aligned to the bow-tie expansion model. Ensure pricing aligns with the GTM motion.

---

### 11. Demo-as-Strategy

**Signs**: GTM is "show them the product." No narrative arc. Dunford's "Sales Pitch" methodology completely absent. No discovery framework before demos. Every prospect gets the same demo regardless of persona or use case. Marketing's primary asset is a product walkthrough.

**Impact**: Prospects see features but do not understand value. Demos become feature tours that fail to connect to buyer problems. Win rates depend entirely on whether the prospect can self-discover the value. Complex B2B sales fail because the narrative does not build a compelling case for change.

**Fix**: Apply Dunford's Sales Pitch methodology: define the problem, present alternatives and their limitations, introduce the product's unique approach, prove the value with evidence, and close with the specific customer fit. Require discovery before every demo. Create persona-specific demo scripts.

---

### 12. Internal Echo Chamber

**Signs**: Messaging validated internally, not with buyers. Violates LOVED Ambassador fundamental. No message testing (Wynter-style). Dunford's advice: "hang out with sales" to hear real buyer reactions. Marketing team writes messaging in isolation. "Everyone here thinks it sounds great" treated as validation.

**Impact**: Messaging sounds great inside the building but falls flat with buyers. Jargon and internal terminology confuse prospects. Value propositions miss the mark because they are based on internal understanding, not buyer language. Launch messaging requires post-launch rework.

**Fix**: Test messaging with 5+ target buyers before launch. Use Wynter-style message testing or buyer interviews. Observe sales calls to hear how buyers react to messaging. Require that messaging uses the customer's own language, not internal terminology.

---

### 13. GTM Motion Mismatch

**Signs**: Enterprise sales team for a $20/mo self-serve product. MOVE framework stage ignored. Motion does not match ACV, buyer complexity, or CAC tolerance. Product-led motion for a product requiring committee buy-in. High-touch sales for a product that should be self-serve.

**Impact**: CAC exceeds LTV. Sales team frustrated by misaligned compensation and process. Buyer experience is wrong — prospects wanting self-serve are forced through sales calls, or prospects needing guidance are left to figure it out alone. Growth stalls because the GTM engine is fighting the product's natural motion.

**Fix**: Apply the GTM Motion Selection Matrix (MOVE-aligned). Match the motion to ACV, buyer complexity, CAC tolerance, and MOVE stage. If ACV is less than $5K, consider product-led. If ACV exceeds $25K with committee buy-in, consider sales-led. Validate the motion with early data before scaling.

---

### 14. Vanity Metrics Masquerade

**Signs**: Impressions replace pipeline contribution. No bow-tie metrics. No marketing attribution. Success declared without revenue connection. "We got 10,000 page views" treated as evidence of market impact. No distinction between marketing-sourced and marketing-influenced pipeline.

**Impact**: Marketing appears successful but does not drive revenue. Budget justification based on activity metrics, not business outcomes. Leadership loses trust in marketing's impact. Resources allocated based on vanity instead of pipeline contribution.

**Fix**: Define marketing attribution (pipeline creation + pipeline influence). Track metrics across both bow-tie halves — acquisition (pipeline generated, win rate, CAC) AND expansion (NRR, expansion revenue, logo retention). Report on revenue impact, not activity metrics. Replace vanity metrics with pipeline and revenue KPIs.

---

## Anti-Pattern Summary

| Pattern | Severity | Primary Dimension | Applies To |
|---------|----------|-------------------|------------|
| Invisible Buyer | Critical | Market Understanding | Both |
| Feature-List Positioning | Critical | Positioning & Messaging | Both |
| Unarmed Sales Team | Critical | Sales Enablement | Both |
| Org-Unready Launch | Major | Launch Planning | Both |
| Launch and Vanish | Major | Launch Planning | Both |
| Competitive Blindness | Major | Competitive Differentiation | Both |
| Assertion Without Evidence | Major | Customer Evidence | Both |
| One-Size-Fits-All Messaging | Major | Positioning & Messaging | Both |
| Channel Spray | Major | Channel Strategy | Both |
| Pricing Vacuum | Major | Pricing & Packaging | Both |
| Demo-as-Strategy | Major | GTM Strategy | Both |
| Internal Echo Chamber | Major | Positioning & Messaging | Proposal |
| GTM Motion Mismatch | Major | GTM Strategy | Both |
| Vanity Metrics Masquerade | Major | Market Performance | Both |
