# Review Pipeline — Context Adaptation Principles

This document defines the principles governing how each reviewer adapts to plan context. For per-stage context adaptation tables and skill invocation instructions, see the individual files in [stages/](stages/).

---

## Context Adaptation Principles

1. **Every reviewer executes** — the question is "which dimensions apply?" not "should this run?"
2. **N/A is not a failure** — marking dimensions as N/A means the reviewer correctly identified they don't apply to this plan context
3. **Partial applicability is normal** — a reviewer with 2/10 applicable dimensions provides a perfectly valid review of those 2 dimensions
4. **Context informs, it does not override** — if a reviewer notices a concern outside their typical scope for this plan type, they should still flag it (as a note, not as a plan addition)
5. **Ratings reflect applicable dimensions only** — PASS/CONDITIONAL PASS/NEEDS WORK/FAIL are based solely on how the plan performs on its applicable dimensions

---

## Stage Index

For each stage, load the corresponding file from `stages/` for per-reviewer context adaptation:

| # | Stage File | Role |
|---|-----------|------|
| 1 | [01-product-leadership.md](stages/01-product-leadership.md) | Product Leadership |
| 2 | [02-product-manager.md](stages/02-product-manager.md) | Product Manager |
| 3 | [03-product-marketing.md](stages/03-product-marketing.md) | Product Marketing |
| 4 | [04-business-analyst.md](stages/04-business-analyst.md) | Business Analyst |
| 5 | [05-product-designer.md](stages/05-product-designer.md) | Product Designer |
| 6 | [06-product-owner.md](stages/06-product-owner.md) | Product Owner |
| 7 | [07-software-architecture.md](stages/07-software-architecture.md) | Software Architect |
| 8 | [08-security-review.md](stages/08-security-review.md) | Security Reviewer |
| 9 | [09-test-design.md](stages/09-test-design.md) | Test Designer |
| 10 | [10-quality-assurance.md](stages/10-quality-assurance.md) | QA Engineer |
| 11 | [11-clean-code-writing.md](stages/11-clean-code-writing.md) | Clean Code Engineer |
