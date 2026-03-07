# Security Review — AI/ML Systems

## Domain context

AI/ML systems introduce novel attack vectors: prompt injection, training data poisoning, model theft, adversarial examples, and hallucination-based attacks. LLM-powered agents compound risks by connecting language models to tools, databases, and external APIs. Unlike traditional software, ML models are non-deterministic, opaque, and can be manipulated through their inputs in ways that bypass conventional security controls. The supply chain risk is amplified by large pre-trained models downloaded from public repositories with limited provenance verification.

## OWASP coverage

This domain covers 2 OWASP lists focused on AI/ML security.

### OWASP Top 10 for LLM Applications (2025)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| LLM01 | Prompt Injection | A3: Input Validation |
| LLM02 | Sensitive Information Disclosure | A4: Data Protection |
| LLM03 | Supply Chain | A5: Supply Chain |
| LLM04 | Data and Model Poisoning | A5, T2 |
| LLM05 | Improper Output Handling | A3: Input Validation |
| LLM06 | Excessive Agency | A2: Authorization |
| LLM07 | System Prompt Leakage | A4: Data Protection |
| LLM08 | Vector and Embedding Weaknesses | A3: Input Validation |
| LLM09 | Misinformation | A7: UI/UX Security |
| LLM10 | Unbounded Consumption | A6: Secure Coding |

### OWASP ML Security Top 10 (2023)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| ML01 | Input Manipulation Attack | A3: Input Validation |
| ML02 | Data Poisoning Attack | A5: Supply Chain |
| ML03 | Model Inversion Attack | A4: Data Protection |
| ML04 | Membership Inference Attack | G2: Privacy by Design |
| ML05 | Model Theft | A4: Data Protection |
| ML06 | AI Supply Chain Attacks | A5: Supply Chain |
| ML07 | Transfer Learning Attack | A5: Supply Chain |
| ML08 | Model Skewing | A3: Input Validation |
| ML09 | Output Integrity Attack | A3: Input Validation |
| ML10 | Model Poisoning | A5: Supply Chain |

## Criterion interpretation for AI/ML systems

| Criterion | AI/ML-Specific Interpretation |
|-----------|------------------------------|
| T1 | Map all model endpoints, prompt interfaces, training data pipelines, vector databases, tool integrations, agent action spaces |
| T2 | STRIDE for AI: prompt injection as tampering, training data poisoning as integrity threat, model inversion as info disclosure, excessive agency as elevation of privilege |
| T3 | User prompt → model → tool execution is a critical trust boundary. Retrieval-augmented generation (RAG) introduces data store trust boundary. Training pipeline → model serving is another |
| T4 | Adversaries include: prompt injection attackers, training data poisoners, model extraction attackers, adversarial input crafters |
| A1 | API key authentication for model endpoints. User identity propagation through agent tool calls. Rate limiting per user |
| A2 | Agent tool authorization: which tools can the model invoke? Human-in-the-loop for destructive actions. Scope-limited tool access |
| A3 | Prompt injection defense (input filtering, output filtering, instruction hierarchy). Adversarial input detection. Output validation before rendering |
| A4 | Training data PII protection. Model weight protection (IP). System prompt confidentiality. Vector database access control |
| A5 | Model provenance verification. Pre-trained model scanning for malicious payloads. Training data sourcing and licensing. Third-party model audit |
| A6 | Token/compute limits per request. Timeout for model inference. Memory limits for embedding operations. Graceful degradation under load |
| A7 | Hallucination disclosure (indicate AI-generated content). Confidence indicators. No misleading certainty. Generated citations must be verified |
| O1 | Log all prompts and completions (with PII scrubbing). Monitor for prompt injection patterns, unusual token usage, tool invocation anomalies |
| O2 | Detection rules for prompt injection attempts, data exfiltration via model, abnormal tool usage patterns |
| O3 | Model serving infrastructure hardening. GPU/TPU security. Model file integrity verification. Inference endpoint isolation |
| O4 | Model rollback capability. Training data backup. Fallback to previous model version. Graceful degradation without AI |
| G1 | AI-specific regulations (EU AI Act risk classification). Existing regulation application to AI decisions (GDPR automated decision-making) |
| G2 | Training data consent. Right to explanation for AI decisions. Data minimization in training sets. Membership inference resistance |
| G3 | AI governance framework. Model risk management. Red team testing program. Responsible AI guidelines |
| G4 | Model versioning and lineage tracking. Training data provenance. Decision audit trail for AI-powered actions |

## Top 5 AI/ML-specific anti-patterns

### 1. Prompt Injection Blindness

**Signs**: User input concatenated directly with system prompts without sanitization. No distinction between system instructions and user input in the prompt. No output filtering for model responses. "The model will figure out what is a valid instruction."

**Impact**: Attackers override system instructions to exfiltrate data, bypass safety controls, or cause the model to perform unauthorized actions. Indirect prompt injection via retrieved documents is even harder to detect.

**Fix**: Implement instruction hierarchy (system > user). Apply input sanitization for known injection patterns. Filter outputs before rendering. Use structured tool calling with explicit parameter validation. Test with prompt injection red-teaming frameworks.

---

### 2. Excessive Agent Authority

**Signs**: LLM agent with unrestricted tool access (file system read/write, database queries, API calls, code execution). No human-in-the-loop for destructive actions. No scope limitation on what the agent can do. "The agent needs admin access to be useful."

**Impact**: Prompt injection or hallucination causes the agent to delete data, exfiltrate information, make unauthorized API calls, or execute malicious code. The agent acts with all the permissions of its service account.

**Fix**: Implement least-privilege tool access: read-only by default, write actions require explicit user confirmation. Scope tool access per conversation/task. Implement action budgets (max N tool calls per turn). Log all tool invocations for audit.

---

### 3. Training Data Negligence

**Signs**: Training data scraped from the web without curation. No PII detection or removal from training sets. No data poisoning detection. Training data provenance undocumented. Copyrighted material included without license review.

**Impact**: PII memorization by the model (extractable via targeted prompts). Data poisoning introduces backdoors or biased behavior. Legal liability from copyrighted training data. Regulatory violations (GDPR right to erasure applies to training data).

**Fix**: Curate and document training data sources. Scan for and remove PII. Implement data poisoning detection (anomaly detection on training samples). Track data provenance. Apply differential privacy to training. Maintain data processing records for GDPR.

---

### 4. Model Supply Chain Trust

**Signs**: Models downloaded from public repositories (HuggingFace, model zoos) without verification. No model scanning for malicious payloads in serialized formats. Model weights treated as opaque blobs without integrity checks. Fine-tuned models without provenance tracking.

**Impact**: Malicious model files can execute arbitrary code during loading (unsafe deserialization). Backdoored models produce attacker-controlled outputs for specific trigger inputs. Compromised model supply chain affects all downstream applications.

**Fix**: Verify model provenance and integrity (checksums, signatures). Scan model files for malicious payloads using tools like ModelScan or Fickling. Prefer safe serialization formats (safetensors over unsafe formats). Host models in private, access-controlled registries.

---

### 5. Hallucination as Feature

**Signs**: AI-generated content presented without confidence indicators or source attribution. Generated URLs, citations, and references not validated before display. No grounding mechanism connecting model outputs to verified data. "The model is usually right."

**Impact**: Users trust fabricated information, citations, or links. Generated URLs may point to attacker-controlled domains (hallucinated package names installed by developers). False medical, legal, or financial information presented as authoritative.

**Fix**: Implement RAG with citation verification. Display confidence indicators for AI outputs. Validate all generated URLs, package names, and references against known-good sources. Clearly label AI-generated content. Implement human review for high-stakes outputs.

---

## Key controls checklist

- [ ] Prompt injection defense: input filtering, instruction hierarchy, output filtering
- [ ] Agent tool access scoped with least privilege; destructive actions require human confirmation
- [ ] Training data curated with PII removed and provenance documented
- [ ] Model files verified (checksums, signatures) and scanned for malicious payloads
- [ ] Token/compute limits per request with timeout and rate limiting
- [ ] All prompts and completions logged (PII-scrubbed) for audit
- [ ] AI-generated content clearly labeled with confidence indicators
- [ ] Generated URLs, citations, and references validated before display
- [ ] Vector database access controlled and injection-tested
- [ ] Model versioning with rollback capability
- [ ] Red team testing for prompt injection, jailbreaking, and data extraction
- [ ] AI-specific regulatory requirements mapped (EU AI Act, GDPR Art 22)

## Company practices

- **Google**: Secure AI Framework (SAIF) with 6 core elements, red team testing for all AI products, adversarial testing infrastructure
- **Microsoft**: Responsible AI Standard, Counterfit (adversarial ML testing tool), PyRIT (red teaming framework for AI), content safety filters across Azure OpenAI
- **OpenAI**: Multi-layer safety system (pre-training, RLHF, system prompt, output filtering), red teaming program, usage policies with monitoring
- **Apple**: On-device ML for privacy (Core ML), minimal server-side processing, Private Cloud Compute for cloud AI with transparency
- **Netflix**: ML platform with model governance, automated model performance monitoring, A/B testing for AI safety

## Tools and standards

- **Red Teaming**: Garak (LLM vulnerability scanner), promptfoo (prompt testing), Microsoft PyRIT, NVIDIA NeMo Guardrails
- **Model Scanning**: ModelScan (Protect AI), Fickling (unsafe deserialization detection)
- **Input/Output Filtering**: Guardrails AI, LLM Guard, Rebuff (prompt injection detection)
- **ML Security**: Adversarial Robustness Toolbox (IBM), CleverHans, TextAttack
- **Standards**: OWASP LLM Top 10 2025, OWASP ML Security Top 10 2023, NIST AI Risk Management Framework, EU AI Act, MITRE ATLAS (Adversarial Threat Landscape for AI Systems)
