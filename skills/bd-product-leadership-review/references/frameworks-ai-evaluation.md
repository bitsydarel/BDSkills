# AI Product Evaluation Framework

Use this framework when any proposal involves AI/ML, LLMs, generative AI, automation, or intelligent features. AI products carry unique risks that standard evaluation dimensions don't fully capture.

**Key stat:** Only 5% of AI pilots reach production (MIT 2025). One-third of GenAI users encounter misleading answers (Deloitte 2025). Evaluate AI proposals with appropriate skepticism.

---

## When This Applies

Trigger AI evaluation when the proposal mentions: machine learning, AI, LLM, GPT, neural network, model training, inference, generative, automation with learning, recommendation engine, natural language processing, computer vision, predictive analytics, or intelligent features.

---

## AI Opportunity Assessment Matrix

Evaluate placement on a 2×2 grid before detailed scoring:

|  | Low Technical Feasibility | High Technical Feasibility |
|--|---------------------------|----------------------------|
| **High Business Impact** | Moonshot — high risk, high reward. Requires spikes. | Sweet Spot — pursue with rigor. |
| **Low Business Impact** | Avoid — high cost, low return. | Quick Win — pursue if cheap. Consider rules-based first. |

**Critical first question:** Would a rules-based approach work? If yes, rules-based is usually better (cheaper, more predictable, more maintainable). AI should be used when the problem space is too complex or variable for explicit rules.

---

## AI-Specific Evaluation by Dimension

### Value Risk — AI Additions

- Is AI the right tool for this problem? (vs. rules-based, workflow optimization, better UX)
- Is the problem well-defined enough for AI? (Clear success criteria, measurable outcomes)
- Do users actually want AI here, or is this technology-push?
- What happens when the AI is wrong? (Error tolerance analysis)
- Is the AI solving a $10 problem or a $10,000 problem? (Value must justify AI complexity)

### Usability Risk — AI Additions

- **Trust calibration**: How will users learn when to trust and when to verify AI outputs?
- **Explainability**: Can users understand why the AI made a recommendation/decision?
- **Error recovery**: When AI produces wrong results, how do users correct course?
- **AI transparency**: Is it clear to users when AI is making decisions vs. deterministic logic?
- **Control spectrum**: Can users override, tune, or disable AI features?
- **Expectation management**: Does the UI communicate AI limitations and confidence levels?

### Feasibility Risk — AI Additions

- **Data availability**: Is sufficient training data available? Quality? Quantity? Representativeness?
- **Data pipeline**: Is there infrastructure for data ingestion, cleaning, labeling, versioning?
- **Model selection**: Has model architecture been evaluated? (Custom vs. fine-tuned vs. off-the-shelf)
- **Training infrastructure**: GPU/TPU availability, training time estimates, cost projections
- **Latency requirements**: Can inference meet user experience expectations? (p50, p95, p99)
- **Cost per inference**: What is the unit economics of each AI interaction? Does it scale?
- **Model drift**: How will model performance be monitored and maintained over time?
- **Edge cases**: How does the system handle out-of-distribution inputs?

### Viability Risk — AI Additions

- **Responsible AI compliance** — evaluate across five pillars:
  - *Fairness*: Is the model tested for bias across protected attributes?
  - *Transparency*: Can decisions be explained to stakeholders and regulators?
  - *Accountability*: Is there a human-in-the-loop for high-stakes decisions?
  - *Privacy*: Is training data handling GDPR/CCPA compliant? PII in prompts?
  - *Security*: Prompt injection, adversarial attacks, data exfiltration risks assessed?
- **Regulatory landscape**: Current and anticipated AI regulations (EU AI Act, state laws)
- **AI governance**: Who audits, constrains, or overrides AI decisions?
- **Liability**: Who is responsible when AI causes harm? Insurance considerations?

---

## AI Metrics Trust Stack

AI products need layered metrics beyond standard product metrics:

### Layer 1: Model Performance Metrics
- Accuracy, precision, recall, F1 score (classification)
- MSE, MAE, RMSE (regression)
- BLEU, ROUGE, human evaluation (generation)
- Latency (p50, p95, p99), throughput, cost per inference

### Layer 2: Trust Metrics
- User override rate (how often users reject AI suggestions)
- Trust calibration (do users trust AI appropriately — not too much, not too little?)
- Explanation engagement (do users look at explanations?)
- Feedback submission rate (are users correcting AI?)

### Layer 3: User Experience Metrics
- Task completion rate with AI vs. without AI
- Time-to-task completion with AI vs. without AI
- User satisfaction (NPS, CSAT) for AI-powered features
- Feature adoption and retention curves specific to AI features

### Layer 4: Safety Metrics
- Harmful output rate (toxicity, bias, misinformation)
- Adversarial robustness score
- PII leakage incidents
- Content policy violation rate

---

## AI Evals Framework

Evaluation methods for AI systems, from lightweight to rigorous:

| Method | When to Use | Effort | Reliability |
|--------|-------------|--------|-------------|
| Spot checks | Early prototyping | Low | Low |
| Automated evals (test suites) | Pre-release | Medium | Medium |
| Human evals (internal) | Pre-release | Medium | Medium-High |
| SME labels (domain expert review) | High-stakes domains | High | High |
| A/B experiments | Post-launch | High | High |
| Trajectory tracking | Ongoing | Medium | Medium-High |
| Red teaming | Pre-release + periodic | High | High |

**Minimum bar:** Automated eval suite + human spot checks before any AI feature reaches production. Red teaming for any customer-facing generative AI.

---

## AI Product Maturity Stages

Evaluate where the organization sits on the AI maturity spectrum:

1. **Awareness** — Organization knows AI exists but hasn't applied it. Expect high learning costs.
2. **Experimentation** — Running pilots and proofs of concept. High failure rate is expected and acceptable.
3. **Integration** — AI features in production for specific use cases. Operational maturity developing.
4. **Optimization** — AI deeply integrated into product decisions. MLOps practices mature.
5. **Transformation** — AI is core to the business model. Competitive moat built on AI capabilities.

**Scoring adjustment:** Earlier maturity stages warrant lower feasibility scores and higher risk acknowledgment. A Stage 1 organization proposing Stage 4 capabilities is a red flag.

---

## Applying AI Evaluation in Reviews

1. Determine if the proposal triggers AI evaluation criteria
2. Assess the AI Opportunity Matrix placement
3. Run standard 7-dimension evaluation with AI-specific additions above
4. Layer AI metrics trust stack onto instrumentation evaluation
5. Check AI anti-patterns (see `anti-patterns-ai-product.md`)
6. Evaluate organizational AI maturity stage alignment
7. Note AI-specific findings in the review output alongside standard dimension scores
