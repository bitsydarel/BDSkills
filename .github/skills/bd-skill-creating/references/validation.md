# Skill Validation Checklist

Pre-publish validation checklist for agent skills.

## Validation Categories

```xml
<ValidationChecklist>
  <Category name="Frontmatter" severity="Critical">
    <Check id="F1">Name field is present</Check>
    <Check id="F2">Name uses only lowercase letters, numbers, and hyphens</Check>
    <Check id="F3">Name is 1-64 characters</Check>
    <Check id="F4">Name does not start or end with hyphen</Check>
    <Check id="F5">Name has no consecutive hyphens</Check>
    <Check id="F6">Name matches parent directory name exactly</Check>
    <Check id="F7">Description field is present</Check>
    <Check id="F8">Description is 1-1024 characters</Check>
    <Check id="F9">Description includes WHAT the skill does</Check>
    <Check id="F10">Description includes WHEN to use it</Check>
    <Check id="F11">Description is written in third person</Check>
  </Category>

  <Category name="Content Structure" severity="Major">
    <Check id="C1">SKILL.md body is under 500 lines</Check>
    <Check id="C2">Has clear introduction section</Check>
    <Check id="C3">Has workflow or process section</Check>
    <Check id="C4">Has anti-patterns or guardrails section</Check>
    <Check id="C5">Links to reference files where appropriate</Check>
    <Check id="C6">No redundant information (context agent already has)</Check>
  </Category>

  <Category name="References" severity="Major">
    <Check id="R1">All references are in references/ directory</Check>
    <Check id="R2">References are one level deep only</Check>
    <Check id="R3">Each reference file covers one topic</Check>
    <Check id="R4">Reference files are under 100 lines each</Check>
    <Check id="R5">All reference links use relative paths</Check>
    <Check id="R6">All reference links use forward slashes</Check>
  </Category>

  <Category name="Content Quality" severity="Minor">
    <Check id="Q1">No time-sensitive information</Check>
    <Check id="Q2">Consistent terminology throughout</Check>
    <Check id="Q3">Examples are concrete and specific</Check>
    <Check id="Q4">No Windows-style paths (backslashes)</Check>
    <Check id="Q5">Clear default provided when multiple options exist</Check>
    <Check id="Q6">No hardcoded paths or versions</Check>
  </Category>

  <Category name="Testing" severity="Major">
    <Check id="T1">Tested with intended agent models</Check>
    <Check id="T2">Triggers activate on expected prompts</Check>
    <Check id="T3">Progressive disclosure works (references load when needed)</Check>
    <Check id="T4">Instructions produce expected outcomes</Check>
  </Category>
</ValidationChecklist>
```

## Quick Validation

### Frontmatter Check

```bash
# Verify name field format
grep -E "^name: [a-z0-9-]+$" SKILL.md

# Check description length
grep "^description:" SKILL.md | wc -c  # Should be < 1024
```

### Structure Check

```bash
# Count SKILL.md lines
wc -l SKILL.md  # Should be < 500

# Verify directory structure
ls -la  # Should have SKILL.md
ls references/  # Should be flat (no subdirectories)
```

### Link Check

```bash
# Find all reference links
grep -E "\[.*\]\(references/.*\)" SKILL.md

# Verify linked files exist
# For each link, check the file exists
```

## Severity Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **Critical** | Specification violation | Must fix before publishing |
| **Major** | Effectiveness issue | Should fix for quality |
| **Minor** | Style/organization | Consider fixing |

## Common Issues

### Critical Issues (Must Fix)

1. **Name mismatch**: Directory name doesn't match frontmatter name
   - Fix: Rename directory or update frontmatter

2. **Missing description**: No description field in frontmatter
   - Fix: Add description with WHAT + WHEN

3. **Invalid characters**: Name contains uppercase, underscores, or spaces
   - Fix: Use only lowercase, numbers, hyphens

### Major Issues (Should Fix)

1. **SKILL.md too long**: Over 500 lines
   - Fix: Move detailed content to references/

2. **Missing triggers**: Description lacks "Use when" clause
   - Fix: Add specific trigger conditions

3. **Deeply nested references**: References in subdirectories
   - Fix: Flatten to single level

### Minor Issues (Consider Fixing)

1. **Time-sensitive content**: Contains dates or version numbers
   - Fix: Use evergreen language

2. **Inconsistent terminology**: Mixed terms for same concept
   - Fix: Choose one term and use consistently
