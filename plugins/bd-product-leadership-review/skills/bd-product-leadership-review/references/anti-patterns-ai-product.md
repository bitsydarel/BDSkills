# AI Product Anti-Patterns

Failure modes specific to AI/ML product development. These compound standard product anti-patterns with AI-specific risks.

---

## AI Solutionism [Critical]

**Signs:** Proposal leads with "AI-powered" without demonstrating why AI is necessary. Business case centers on AI as a technology rather than a user problem. Simpler approaches (rules-based, workflow optimization, better UX) not considered or dismissed without analysis. "AI" appears in funding requests as a magic word.

**Impact:** Over-engineered solutions that are expensive to build, maintain, and scale. Teams spend months on ML pipelines when a SQL query would suffice. Only 5% of AI pilots reach production — many because AI was the wrong tool.

**Fix:** Require a "Why AI?" justification that explicitly compares AI approach to alternatives. If a rules-based approach would achieve 80% of the value at 20% of the cost, it should be the default. AI is justified when the problem space is too variable, high-dimensional, or rapidly evolving for explicit rules.

**Detection:** Ask "What would this look like without AI?" If the team can't answer, they haven't evaluated alternatives. Ask "What rules-based approach did you consider?" If none, flag AI Solutionism.

---

## Pilot Purgatory [Critical]

**Signs:** Successful AI demo or proof-of-concept that generates excitement but never reaches production. Pilot has been running for 6+ months without production timeline. Success criteria keep shifting. "Just one more experiment" before production-ready. No MLOps infrastructure.

**Impact:** Wasted investment with no production value. Team morale degrades as exciting work never ships. Organization builds AI skepticism ("we tried AI, it didn't work") when the problem was operationalization, not technology.

**Fix:** Define production criteria upfront: latency requirements, accuracy thresholds, monitoring plan, cost per inference budget, integration architecture. Set a hard deadline: pilot → production decision within 90 days. If production criteria aren't met, kill the pilot explicitly.

**Detection:** Ask "What is the production timeline?" and "What infrastructure is needed to productionize this?" If answers are vague, the pilot is likely to stay in purgatory. Check: has this pilot been extended more than once?

---

## AI Precision Anti-Pattern [Major]

**Signs:** Using LLMs or probabilistic models for tasks requiring 100% accuracy or consistency. Examples: financial calculations, regulatory compliance checks, legal document generation, safety-critical decisions. Team handwaves error rates because "AI is getting better."

**Impact:** User trust destruction when AI produces incorrect results in high-stakes contexts. Legal and regulatory exposure. Cost of verification may exceed cost of deterministic approach.

**Fix:** Map tasks to accuracy requirements. For tasks requiring >99.9% accuracy and consistency, use deterministic approaches. For tasks tolerating some error (recommendations, search, summarization), AI is appropriate. For high-stakes AI: human-in-the-loop is mandatory, not optional.

**Detection:** Ask "What is the acceptable error rate?" and "What happens when the AI is wrong?" If the answer to the second question involves significant user harm, financial loss, or legal exposure, the accuracy requirements likely exceed what probabilistic AI can guarantee.

---

## Demo-Driven Development [Major]

**Signs:** AI features optimized for impressive demos rather than production value. Cherry-picked examples in presentations. Demo environment uses higher-quality models or curated data not available in production. Product decisions driven by "this demos well" rather than "this solves a user problem."

**Impact:** Production reality disappoints after demo-inflated expectations. Users feel deceived when production quality doesn't match demo experience. Team optimizes for internal stakeholder excitement rather than user value.

**Fix:** Require production-representative demos — same model, same data, same latency constraints. Include failure cases in demos. Measure production metrics (accuracy, latency, user satisfaction) not demo metrics. Demo to real users, not just internal stakeholders.

**Detection:** Ask "Will the demo experience match production?" and "What does a failure case look like?" If the team only shows successes, or if demo environment differs from production, flag this.

---

## Trust Deficit [Major]

**Signs:** AI features deployed without transparency about how they work. No explanation for AI decisions or recommendations. Users can't understand, challenge, or override AI outputs. No confidence scores or uncertainty indicators. "Black box" treated as acceptable.

**Impact:** Users either blindly trust AI (automation bias — dangerous in high-stakes contexts) or refuse to use it (low adoption). Regulatory risk increases as explainability requirements tighten (EU AI Act).

**Fix:** Implement Trust Stack: confidence indicators, explanation mechanisms, override capabilities, feedback loops. Make AI boundaries explicit ("I'm confident about X, less certain about Y"). Let users see the inputs that led to the output. Design graceful degradation when AI confidence is low.

**Detection:** Ask "How does the user know the AI might be wrong?" and "Can the user override the AI?" If neither is addressed, flag Trust Deficit.

---

## AI Theater [Major]

**Signs:** "AI-powered" label on features that are actually rules-based, keyword matching, or simple automation. Marketing claims AI capabilities that don't exist in the product. AI branding used to justify premium pricing without AI-driven value. Performative AI adoption to satisfy board or investor expectations.

**Impact:** Erodes market trust in genuine AI products. Creates liability if AI claims are investigated. Internal confusion about actual technical capabilities. Resources diverted to maintaining the illusion.

**Fix:** Audit AI claims against technical reality. If a feature doesn't use machine learning, don't call it AI. Genuine AI features should be identifiable by the presence of training data, model architecture, and inference pipeline. Reclassify non-AI features honestly.

**Detection:** Ask "What model architecture does this use?" and "Where is the training data?" If answers point to if-then rules or keyword lists, it's not AI — it's automation (which is fine, but shouldn't be labeled AI).

---

## Data Debt [Major]

**Signs:** Building AI on poor-quality, biased, or insufficient training data. No data quality metrics or monitoring. Training data doesn't represent production user base. No data versioning or lineage tracking. Data labeling done without quality controls.

**Impact:** Model performance degrades unpredictably. Bias amplification causes real-world harm and regulatory exposure. Model retraining is unreliable without data provenance. "Garbage in, garbage out" but at AI scale.

**Fix:** Establish data quality framework: completeness, accuracy, consistency, timeliness, representativeness. Version training datasets. Monitor data drift between training and production distributions. Implement labeling quality controls (inter-annotator agreement, sample auditing). Budget data quality effort as 40-60% of total AI project effort.

**Detection:** Ask "What is your training data quality?" and "Does training data represent production users?" If the team can't answer with metrics, data quality is likely insufficient.

---

## AI Governance Gap [Major]

**Signs:** No process for auditing AI decisions. No constraints on what the AI can do. No human override for high-stakes AI outputs. No monitoring for model drift or degradation. No incident response plan for AI failures. AI deployed without cross-functional review (legal, compliance, ethics).

**Impact:** AI failures go undetected until user harm occurs. No ability to explain past decisions for regulatory or legal review. Model drift degrades performance silently. Organization can't answer "why did the AI do that?" when challenged.

**Fix:** Implement AI governance framework: decision auditing, model monitoring, drift detection, human-in-the-loop protocols, incident response plan, regular bias audits. Establish AI review board (cross-functional: product, engineering, legal, ethics). Define escalation criteria for AI decisions.

**Detection:** Ask "Who audits AI decisions?" and "What happens when the model drifts?" If no one owns AI governance, flag this as a structural risk regardless of the AI's current performance.
