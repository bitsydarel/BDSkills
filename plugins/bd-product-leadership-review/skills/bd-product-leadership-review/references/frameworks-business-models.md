# Business Model Evaluation Guide

Different business models create different risk profiles. Use this reference to calibrate evaluation criteria based on the product's business model.

---

## SaaS (Software as a Service)

**Key metrics:** LTV:CAC ratio (>3x healthy), net revenue retention (>100% = growth without new customers), expansion revenue, time-to-value, churn rate by cohort.

**Dimension weighting:**
- Value Risk: High — switching costs create urgency for clear value proposition
- Viability Risk: High — unit economics must work at scale; CAC payback < 18 months
- Instrumentation: Critical — cohort tracking and retention curves are table stakes

**Common anti-patterns:** Building enterprise features for SMB pricing; ignoring net revenue retention in favor of new logos; time-to-value exceeds trial period.

**What "good" looks like:** Clear activation metric, measured time-to-value, cohort retention curves showing improvement, expansion paths defined.

---

## Marketplace

**Key metrics:** Liquidity (% of listings that transact), take rate, GMV per cohort, supply/demand ratio, repeat transaction rate.

**Dimension weighting:**
- Value Risk: Critical — must solve for both sides; single-sided value rarely sustains
- Feasibility Risk: High — chicken-and-egg problem requires creative supply-side strategy
- Discovery Evidence: Critical — must have evidence from both sides of the marketplace

**Common anti-patterns:** Optimizing for one side while ignoring the other; subsidizing growth without unit economics path; ignoring liquidity thresholds.

**What "good" looks like:** Strategy for initial supply acquisition (single-player mode, geographic focus, managed supply), clear liquidity targets, take rate model validated with both sides.

---

## Platform / API

**Key metrics:** Developer adoption rate, API call growth, third-party integrations count, ecosystem value (GMV enabled), developer NPS, time-to-first-API-call.

**Dimension weighting:**
- Usability Risk: Critical — developer experience IS the product; poor DX kills adoption
- Feasibility Risk: High — API stability, versioning strategy, backwards compatibility
- Instrumentation: Critical — must track developer journey funnel (signup → first call → production use)

**Common anti-patterns:** Building APIs without talking to developers; no versioning strategy; breaking changes without migration path; documentation as afterthought.

**What "good" looks like:** Developer journey mapped, SDKs in target languages, sandbox environment, clear rate limits and pricing, migration guides for version changes.

---

## B2B Enterprise

**Key metrics:** Deal size (ACV), sales cycle length, win rate, implementation time, customer health score, expansion within accounts.

**Dimension weighting:**
- Viability Risk: Critical — sales cycle ROI, implementation cost, support burden
- Feasibility Risk: High — compliance requirements (SOC2, HIPAA, etc.), multi-tenancy, SSO
- Value Risk: High — must separate champion value from economic buyer value

**Common anti-patterns:** Building for the loudest customer instead of the market; confusing champion enthusiasm with buying authority; underestimating implementation complexity.

**What "good" looks like:** Clear buyer persona (champion + economic buyer + technical evaluator), implementation playbook, land-and-expand strategy, clear compliance story.

---

## B2C Consumer

**Key metrics:** DAU/MAU ratio (>20% = good engagement), viral coefficient (k>1 = organic growth), retention curves (Day 1/7/30), monetization per user (ARPU), session frequency.

**Dimension weighting:**
- Usability Risk: Critical — users have zero tolerance for friction; onboarding is make-or-break
- Value Risk: Critical — must solve a problem users feel viscerally, not intellectually
- Instrumentation: Critical — behavioral analytics drive every decision

**Common anti-patterns:** Optimizing for downloads over retention; adding features that increase complexity for existing users; monetizing before achieving retention.

**What "good" looks like:** Retention curve that flattens (not approaches zero), clear activation moment, organic sharing behavior, engagement loops designed.

---

## B2B2C (Business-to-Business-to-Consumer)

**Key metrics:** Channel partner adoption, end-user activation through partners, partner revenue share, end-user NPS via partner channel.

**Dimension weighting:**
- Value Risk: Critical — must deliver value to BOTH the business partner AND the end consumer
- Viability Risk: High — revenue share model must work for all parties
- Usability Risk: High — two user experiences to design (partner admin + end user)

**Common anti-patterns:** Optimizing for partner sales pitch while ignoring end-user experience; building for partner requests instead of end-user needs; partner dependency without direct user relationship.

**What "good" looks like:** Separate value propositions for partner and end-user, partner success metrics defined, end-user feedback loop exists (not just through partner), migration path if partner relationship ends.

---

## Product-Led Growth (PLG)

**Key metrics:** Activation rate (% completing key action), PQL conversion (30-39% vs 9% for regular leads), time-to-value, expansion revenue from product usage, viral coefficient.

**Dimension weighting:**
- Usability Risk: Critical — the product IS the sales motion; friction = lost revenue
- Instrumentation: Critical — PQL scoring requires comprehensive usage tracking
- Value Risk: High — free tier must deliver real value while creating upgrade desire

**Common anti-patterns:** Free tier too generous (no upgrade motivation) or too restrictive (no value demonstration); optimizing for signups over activation; adding sales-assisted motions that fight the PLG motion.

**What "good" looks like:** Clear activation metric, measured time-to-value < 5 minutes for initial value, PQL model defined and validated, natural upgrade triggers tied to usage milestones.

---

## Applying Business Model Context

When reviewing a proposal:

1. **Identify the business model** from the proposal or product context
2. **Adjust dimension weights** — some dimensions matter more for certain models
3. **Check for model-specific anti-patterns** — each model has characteristic failure modes
4. **Validate metrics** — ensure proposed metrics match the business model's key metrics
5. **Assess "good" alignment** — does the proposal show awareness of what "good" looks like for this model type?

A proposal evaluated against the wrong business model criteria will produce misleading scores.
