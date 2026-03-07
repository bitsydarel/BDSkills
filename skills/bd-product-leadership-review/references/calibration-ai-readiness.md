# AI Readiness Calibration

Weak/adequate/strong examples for evaluating AI product proposals across the standard dimensions with AI-specific considerations.

---

## Value Risk — AI Calibration

**Strong (Score 5):** Problem clearly requires AI (too variable for rules). Compared AI approach to alternatives and justified AI choice. User research validates AI-specific value (not just general feature value). Error tolerance defined and acceptable.

**Adequate (Score 3):** Problem plausibly benefits from AI but alternatives not fully explored. Some user validation but not specific to AI-powered experience. Error tolerance mentioned but not quantified.

**Weak (Score 1-2):** "AI" used as a buzzword without clear problem justification. No comparison to non-AI alternatives. No consideration of error tolerance. Solution-first thinking ("we should use AI") rather than problem-first.

---

## Usability Risk — AI Calibration

**Strong (Score 5):** Trust calibration designed (users understand when to trust AI). Explainability built into UX. Override and correction mechanisms present. AI transparency clear (users know when AI is involved). Confidence indicators shown. Tested with users who have varying AI comfort levels.

**Adequate (Score 3):** Some transparency about AI involvement. Override possible but not prominently designed. Explainability partially addressed. No user testing specific to AI interactions.

**Weak (Score 1-2):** Black box AI — users don't know AI is making decisions. No override capability. No explanation mechanism. No consideration of user trust or AI comfort levels.

---

## Feasibility Risk — AI Calibration

**Strong (Score 5):** Data quality assessed (completeness, bias, representativeness). Model architecture evaluated with spike results. Latency requirements defined and achievable. Cost per inference budgeted. MLOps infrastructure planned. Model drift monitoring designed.

**Adequate (Score 3):** Data exists but quality not rigorously assessed. Model selection made but not validated with spike. Latency and cost estimated but not measured. MLOps planned at high level.

**Weak (Score 1-2):** No data quality assessment. "We'll use GPT" without model evaluation. No latency or cost projections. No MLOps infrastructure or plan. No consideration of model drift.

---

## Viability Risk — AI Calibration

**Strong (Score 5):** Responsible AI framework applied (fairness, transparency, accountability, privacy, security). Regulatory landscape assessed (EU AI Act, state laws). AI governance plan defined. Liability considerations documented. Bias testing planned.

**Adequate (Score 3):** Privacy considerations noted. Some awareness of AI regulations. Governance informal or planned but not implemented. Bias acknowledged but no testing plan.

**Weak (Score 1-2):** No responsible AI considerations. Regulatory landscape ignored. No governance plan. No bias assessment. "We'll handle ethics later."

---

## Worked Example: AI-Powered Recommendation Engine

**Proposal:** Build a recommendation engine to suggest relevant resources to users based on their usage patterns, role, and stated goals.

### Standard Dimension Scores

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Value Risk | 4 | User interviews (n=12) confirm discovery is a pain point. Compared to manual curation (current state) and rules-based (evaluated, insufficient for content volume). AI justified. |
| Usability Risk | 3 | Prototype shows recommendations with "Why this?" explanations. No user testing yet. Override (dismiss/hide) designed but feedback loop (thumbs up/down) not detailed. |
| Feasibility Risk | 3 | 18 months of usage data available. Collaborative filtering spike completed with promising results. Latency target (200ms p95) achievable. Cost per inference not budgeted. No MLOps plan. |
| Viability Risk | 3 | Privacy review completed (no PII in recommendation features). No bias audit planned. Regulatory assessment not done. Basic governance ("PM reviews weekly"). |
| Product Outcomes | 4 | North Star: increase in resource engagement rate. Leading indicators: recommendation click-through, time-to-relevant-resource. Guardrails: diversity of recommendations, no filter bubble metric. |
| Discovery Evidence | 4 | 12 user interviews, usage pattern analysis, competitive analysis (3 competitors with recommendations). Evidence is recent (last 2 months). |
| Instrumentation | 3 | CTR tracking planned. A/B test framework exists. No model performance monitoring. No drift detection. Trust metrics (override rate, explanation engagement) not planned. |

### AI Overlay Assessment

| AI Criterion | Assessment |
|-------------|------------|
| AI justification | Strong — content volume and user variability make rules-based insufficient |
| AI maturity alignment | Organization at Stage 2 (Experimentation) — feasibility score appropriate |
| AI Metrics Trust Stack | Partially addressed — Layer 1 (model performance) and Layer 3 (UX metrics) present, Layer 2 (trust) and Layer 4 (safety) missing |
| AI anti-patterns | Minor Demo-Driven risk (prototype impressive but production performance unvalidated) |

### Verdict: Proceed with Conditions (24/35)

**Required before build:**
1. Budget cost per inference and validate unit economics at scale
2. Add trust metrics to instrumentation plan (override rate, explanation engagement)
3. Plan bias audit for recommendation diversity (demographic, content-type)
4. MLOps plan with model monitoring and drift detection
5. User test the AI-specific UX (explanations, overrides, confidence indicators)
