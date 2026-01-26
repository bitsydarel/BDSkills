---
name: bd-skill-reviewing
description: Framework for reviewing and improving agent skills for quality, effectiveness, and compliance with the agent-skills standard. Use when auditing existing skills, providing feedback on skill PRs, improving skill descriptions, or troubleshooting underperforming skills.
---

# Skill Review Guide

This skill provides a systematic framework for evaluating and improving agent skills.

## Review Criteria

Evaluate skills against four dimensions:

1. **Correctness**: Follows specification requirements
2. **Clarity**: Instructions are unambiguous and actionable
3. **Effectiveness**: Triggers appropriately and guides well
4. **Maintainability**: Well-organized and easy to update

## Review Workflow

1. **Validate Structure**: Check directory and file organization
2. **Evaluate Frontmatter**: Verify name and description compliance
3. **Assess Content**: Review clarity, completeness, progressive disclosure
4. **Check References**: Verify organization and linking
5. **Test Effectiveness**: Confirm triggers and guidance work

For detailed checklist with specific checks per category, see [references/quality-checklist.md](references/quality-checklist.md).

## Common Issues

For anti-patterns to identify during review (with detection methods and fixes), see [references/anti-patterns.md](references/anti-patterns.md).

## Improvement Guidance

For patterns to fix common issues (with before/after examples), see [references/improvement-patterns.md](references/improvement-patterns.md).

## Feedback Format

For review feedback templates and severity guidelines, see [references/feedback-template.md](references/feedback-template.md).

## Anti-Patterns in Reviews

- **Rubber-stamping**: Approving without thorough review
- **Style-only focus**: Missing structural or effectiveness issues
- **No actionable feedback**: Identifying problems without suggesting fixes
- **Inconsistent severity**: Misclassifying critical issues as minor
