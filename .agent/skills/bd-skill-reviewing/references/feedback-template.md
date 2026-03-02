# Review Feedback Template

Structure for providing skill review feedback.

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **Critical** | Specification violations | Must fix before merge |
| **Major** | Effectiveness issues | Should fix for quality |
| **Minor** | Style/organization | Consider fixing |
| **Suggestion** | Enhancement ideas | Optional |

## Feedback Template

```markdown
## Review Summary

**Skill**: [skill-name]
**Reviewer**: [name]
**Overall**: [Pass / Needs Work / Reject]

### Critical Issues
- [ ] [Issue]: [Location] - [Fix required]

### Major Issues
- [ ] [Issue]: [Location] - [Recommended fix]

### Minor Issues
- [ ] [Issue]: [Location] - [Suggestion]

### Suggestions
- [Enhancement idea]

### What Works Well
- [Positive feedback]
```

## Example Review

```markdown
## Review Summary

**Skill**: data-processing
**Reviewer**: Team Lead
**Overall**: Needs Work

### Critical Issues
- [ ] Name mismatch: Directory is `data_processing`, frontmatter is `data-processing` - Rename directory

### Major Issues
- [ ] Missing triggers: Description lacks "Use when" clause - Add trigger conditions
- [ ] No references: SKILL.md is 250 lines with no progressive disclosure - Split into references/

### Minor Issues
- [ ] Time-sensitive: Line 45 mentions "as of 2024" - Use evergreen language

### Suggestions
- Consider adding examples section

### What Works Well
- Clear workflow steps
- Good anti-patterns section
```

## Quick Feedback (For Minor Reviews)

For quick reviews without major issues:

```markdown
## Review Summary

**Skill**: [skill-name]
**Overall**: Pass

**Notes**: [Brief comment if any]
```
