# Dimension 6: Discovery Evidence

Is the work grounded in data from user tests, experiments, and customer interactions — or in opinions and stakeholder dictates?

## Criteria

- **D1: Discovery Activities** — What discovery activities were conducted (interviews, tests, experiments)?
- **D2: Customer Breadth** — How many customers were involved? How representative are they?
- **D3: Artifact Existence** — Do evidence artifacts exist (interview notes, test results, survey data)?
- **D4: Evidence Recency** — How recent is the evidence? Is it still valid for the current context?

## Proposal Questions

1. What discovery activities were conducted? (D1)
2. How many customers were directly involved? (D2)
3. Do artifacts exist — interview notes, test results, survey data, experiment outcomes? (D3)
4. How recent is the evidence? Is it from the current market context? (D4)

## Implementation — Compliance Questions

1. Was discovery done before building? (D1)
2. Were artifacts produced and preserved? (D3)
3. Was there direct customer contact, or only proxies (sales feedback, support tickets)? (D2)

## Implementation — Results Questions

1. Is post-launch data being collected systematically? (D1)
2. Are learnings feeding the next iteration cycle? (D3)
3. Are regular outcome reviews being conducted? (D1, D4)
4. Have post-launch interviews been conducted with users? (D2)

## Scoring

| Score | Description |
|-------|-------------|
| 5 | 10+ customer interviews; prototype tested; quantitative validation; artifacts preserved; evidence is recent |
| 4 | 5-10 interviews with artifacts; some quantitative validation; evidence within last quarter |
| 3 | Few conversations (2-4); limited artifacts; qualitative only |
| 2 | No direct customer contact; relying on stakeholder opinion, sales anecdotes, or competitor imitation |
| 1 | No discovery of any kind; gut feel or executive mandate |

## Quality Check

A score of 4+ requires at minimum: documented interviews or tests with real customers, preserved artifacts, and evidence gathered within the last quarter.

## Evidence Quality Spectrum

Use this spectrum to classify the strongest evidence type present:

| Level | Source | Confidence |
|-------|--------|------------|
| 1 | Opinion or gut feel | Very Low |
| 2 | Stakeholder or executive request | Low |
| 3 | Market research or analyst report | Low-Medium |
| 4 | Customer interview (qualitative) | Medium |
| 5 | Prototype or usability test | Medium-High |
| 6 | Quantitative experiment (A/B test) | High |
| 7 | Production data at scale | Very High |

**Principle:** Move right on this spectrum before committing significant resources. A proposal at Level 1-2 should not proceed to build. Level 4+ is the minimum for responsible resource commitment.

---

## Extended Criteria

### D5: Evidence Quality

Not all discovery is equal. Assess the methodological rigor of the evidence presented.

- **Interview depth**: Were interviews structured (consistent questions, probing follow-ups) or conversational (unguided chat)? Structured interviews produce more reliable insights.
- **Sample representativeness**: Do participants reflect the target user base? Or are they convenience samples (friendly customers, internal employees, personal network)?
- **Longitudinal validity**: Is the evidence a snapshot or does it track behavior over time? Single-session observations are weaker than longitudinal data.
- **Triangulation**: Is the same insight supported by multiple evidence types (interviews + usage data + support tickets)? Single-source evidence is fragile.

**Scoring impact:** High D5 quality can boost scores — rigorous evidence from 5 interviews may be worth more than casual evidence from 15.

**Cross-reference:** Teresa Torres' discovery anti-patterns apply here:
- **Confirmation bias trap**: Only seeking evidence that supports the existing hypothesis
- **Solution interview**: Asking users about solutions instead of problems (users describe needs, not designs)
- **Happy path testing**: Only testing the ideal flow, ignoring edge cases and failure modes
- **Proxy problem**: Talking to proxies (sales, support) instead of actual end users
