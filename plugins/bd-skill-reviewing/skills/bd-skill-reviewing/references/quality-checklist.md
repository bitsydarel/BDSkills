# Quality Review Checklist

Comprehensive checklist for reviewing agent skills.

## Review Checklist

```xml
<QualityChecklist>
  <Category name="Specification Compliance" severity="Critical">
    <Check>Frontmatter name field is present</Check>
    <Check>Name uses only lowercase, numbers, hyphens</Check>
    <Check>Name is 1-64 characters</Check>
    <Check>Name matches directory name exactly</Check>
    <Check>Name has no consecutive hyphens</Check>
    <Check>Name does not start/end with hyphen</Check>
    <Check>Description field is present</Check>
    <Check>Description is 1-1024 characters</Check>
    <Check>SKILL.md is under 500 lines</Check>
  </Category>

  <Category name="Description Quality" severity="Major">
    <Check>Describes WHAT the skill does</Check>
    <Check>Describes WHEN to use it (triggers)</Check>
    <Check>Written in third person</Check>
    <Check>Uses specific keywords for discovery</Check>
    <Check>Avoids vague terms (helps, assists, various)</Check>
    <Check>Not too short (provides enough context)</Check>
  </Category>

  <Category name="Content Effectiveness" severity="Major">
    <Check>Provides actionable guidance</Check>
    <Check>Includes examples where helpful</Check>
    <Check>Avoids redundant information</Check>
    <Check>Has clear workflow or process steps</Check>
    <Check>Includes anti-patterns section</Check>
  </Category>

  <Category name="Progressive Disclosure" severity="Major">
    <Check>SKILL.md under 100 lines (ideally) or 500 lines (maximum)</Check>
    <Check>Detailed content moved to references/ not inline</Check>
    <Check>Workflow steps are summaries with links, not full details</Check>
    <Check>Checklists and long tables are in references/, not SKILL.md</Check>
    <Check>No duplicate content between SKILL.md and references</Check>
    <Check>Each section links to relevant reference for details</Check>
    <Check>Reference files are focused (one topic per file)</Check>
    <Check>Reference files are reasonable size (under 200 lines each)</Check>
    <Check>Domain-specific content split into separate reference files</Check>
    <Check>Code examples over 10 lines are in references/, not SKILL.md</Check>
  </Category>

  <Category name="Reference Organization" severity="Major">
    <Check>References in references/ directory</Check>
    <Check>References one level deep only</Check>
    <Check>One topic per reference file</Check>
    <Check>All links use relative paths</Check>
    <Check>All links use forward slashes</Check>
    <Check>Linked files actually exist</Check>
  </Category>

  <Category name="Content Quality" severity="Minor">
    <Check>No time-sensitive information</Check>
    <Check>Consistent terminology</Check>
    <Check>No Windows-style paths</Check>
    <Check>Clear default when multiple options</Check>
    <Check>Logical section ordering</Check>
    <Check>Appropriate heading levels</Check>
  </Category>

  <Category name="Testing" severity="Major">
    <Check>Tested with target agent models</Check>
    <Check>Triggers activate correctly</Check>
    <Check>References load correctly when agent needs them</Check>
    <Check>Instructions produce expected results</Check>
  </Category>
</QualityChecklist>
```

## Severity Guide

| Level | Impact | Action |
|-------|--------|--------|
| **Critical** | Skill won't work correctly | Block merge until fixed |
| **Major** | Reduces effectiveness | Request changes |
| **Minor** | Polish/style issues | Suggest improvements |

## Quick Checks

### Frontmatter Validation

```bash
# Check name format
grep "^name:" SKILL.md | head -1
# Should match: name: lowercase-with-hyphens

# Check description exists and has content
grep "^description:" SKILL.md | head -1
# Should be 10+ words, include "Use when"
```

### Structure Validation

```bash
# Check line count
wc -l SKILL.md
# Should be < 500

# Check references depth
find references/ -type d | wc -l
# Should be 1 (just the references/ dir itself)
```

### Link Validation

```bash
# Find all markdown links
grep -oE '\[.*\]\(references/[^)]+\)' SKILL.md

# Verify each linked file exists
ls -la references/
```

### Progressive Disclosure Validation

```bash
# Check SKILL.md line count (should be <100 ideally, <500 max)
wc -l SKILL.md

# Check reference file sizes (should be <200 lines each)
wc -l references/*.md

# Find inline code blocks over 10 lines (should be in references)
awk '/```/{p=1;c=0;next} p{c++} /```/{if(c>10)print "Long code block: "c" lines"; p=0}' SKILL.md

# Check for inline checklists (should be in references)
grep -c "^\s*- \[ \]" SKILL.md  # Should be 0 or few

# Verify sections link to references
grep -E "^##" SKILL.md | while read section; do
  echo "Section: $section"
done
# Each major section should have a "See [references/...]" link

# Check for content duplication
# Compare SKILL.md content with references - look for repeated paragraphs
```

### Progressive Disclosure Red Flags

| Red Flag | Detection | Action |
|----------|-----------|--------|
| SKILL.md > 200 lines | `wc -l SKILL.md` | Split to references |
| No reference links | `grep -c references/ SKILL.md` = 0 | Add links |
| Inline checklists | `grep "- \[ \]" SKILL.md` | Move to references |
| Long code blocks | Visual inspection | Move to references |
| Duplicate content | Compare SKILL.md and references | Remove duplication |

## Review Workflow

1. **Start with frontmatter** - Check name and description compliance
2. **Measure structure** - Line counts, directory depth
3. **Read SKILL.md** - Assess clarity and completeness
4. **Check references** - Organization and linking
5. **Test activation** - Verify triggers work
