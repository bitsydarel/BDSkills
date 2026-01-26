# Skill Anti-Patterns

Common issues to identify during skill reviews.

## Critical Anti-Patterns

### 1. Name Mismatch

**Signs:**
- Directory name differs from frontmatter `name` field
- Name contains uppercase, underscores, or spaces

**Impact:** Skill may not load or activate correctly

**Detection:**
```bash
# Compare directory name to frontmatter name
dirname=$(basename $(pwd))
skillname=$(grep "^name:" SKILL.md | cut -d: -f2 | tr -d ' ')
[ "$dirname" = "$skillname" ] && echo "OK" || echo "MISMATCH"
```

**Fix:** Rename directory to match frontmatter name exactly

---

### 2. Missing or Vague Description

**Signs:**
- Description is absent or empty
- Uses vague terms: "helps with", "assists", "handles various"
- Under 20 characters
- Missing "Use when" clause

**Impact:** Poor trigger accuracy, skill not activated when needed

**Detection:**
```yaml
# Bad examples
description: Helps with documents.
description: A useful skill.
description: Does things.
```

**Fix:** Rewrite with specific WHAT + WHEN format:
```yaml
description: Extracts text from PDF files, fills forms, merges documents. Use when working with PDFs or when the user mentions document extraction.
```

---

## Major Anti-Patterns

### 3. Information Overload

**Signs:**
- SKILL.md exceeds 200 lines without references
- SKILL.md exceeds 500 lines (hard limit)
- Long blocks of detailed instructions in main file

**Impact:** Wastes context window, reduces effectiveness

**Detection:**
```bash
wc -l SKILL.md  # Should be < 500, ideally < 200
```

**Fix:**
- Move detailed content to `references/` directory
- Keep SKILL.md as overview with links to details
- Each reference file should cover one topic

---

### 4. Missing Trigger Conditions

**Signs:**
- Description only says WHAT, not WHEN
- No "Use when" phrase or equivalent
- Generic keywords that match too broadly

**Impact:** Skill may not activate or may activate inappropriately

**Detection:**
```bash
# Check for trigger language
grep -i "use when\|use for\|activate when" SKILL.md
```

**Fix:** Add explicit trigger conditions:
- "Use when the user asks to..."
- "Use when working with..."
- "Use when the user mentions..."

---

### 5. Deeply Nested References

**Signs:**
- References in subdirectories: `references/advanced/details.md`
- Chain of references: SKILL.md → ref1.md → ref2.md → actual info
- More than one level of indirection

**Impact:** Agent may not find content, partial reads, incomplete information

**Detection:**
```bash
# Check for subdirectories in references
find references/ -type d | wc -l  # Should be 1
```

**Fix:** Flatten to single level:
- All reference files directly in `references/`
- Link directly from SKILL.md to final content

---

### 6. Inline Checklists

**Signs:**
- Long checklists (>5 items) directly in SKILL.md
- Validation rules listed inline instead of referenced
- Step-by-step procedures with many sub-steps

**Impact:** Bloats SKILL.md, wastes context tokens on content not always needed

**Detection:**
```bash
# Count checkbox items in SKILL.md
grep -c "^\s*- \[ \]" SKILL.md  # Should be <5

# Count total list items
grep -c "^\s*- " SKILL.md  # Watch for >20
```

**Fix:** Move checklists to `references/checklist.md` and link:
```markdown
For validation checklist, see [references/validation.md](references/validation.md).
```

---

### 7. Missing Reference Links

**Signs:**
- SKILL.md has no links to references/ directory
- References exist but aren't linked from SKILL.md
- Sections have detailed content but no "See [reference]" links

**Impact:** Agent won't discover reference content, defeating progressive disclosure

**Detection:**
```bash
# Count reference links in SKILL.md
grep -c "references/" SKILL.md  # Should be >0

# List references that exist but aren't linked
ls references/*.md | while read f; do
  basename "$f" | xargs -I{} sh -c 'grep -q "{}" SKILL.md || echo "Unlinked: {}"'
done
```

**Fix:** Add links in relevant sections:
```markdown
For detailed specification, see [references/specification.md](references/specification.md).
```

---

### 8. Duplicate Content

**Signs:**
- Same explanation appears in SKILL.md and a reference file
- Reference file repeats SKILL.md content with minor additions
- Workflow steps detailed in both places

**Impact:** Wastes tokens, creates maintenance burden, risks inconsistency

**Detection:**
- Manual comparison of SKILL.md and references
- Look for repeated paragraphs or similar headings

**Fix:**
- Keep summary in SKILL.md
- Keep details in references only
- Link from summary to details

---

### 9. Long Code Blocks Inline

**Signs:**
- Code examples over 10 lines in SKILL.md
- Multiple code blocks in single section
- Complete scripts inline instead of in scripts/ or references/

**Impact:** Inflates SKILL.md size, loads code even when not needed

**Detection:**
```bash
# Find code blocks and count lines
awk '/```/{if(p){print c; c=0}; p=!p; next} p{c++}' SKILL.md | sort -rn | head -5
# Any block >10 lines should move to references
```

**Fix:**
- Move long examples to `references/examples.md`
- Move scripts to `scripts/` directory
- Keep only minimal examples (1-5 lines) inline

---

## Minor Anti-Patterns

### 10. Time-Sensitive Content

**Signs:**
- Specific dates: "as of January 2024"
- Version numbers: "requires v3.2.1"
- Phrases like "currently", "latest", "new"

**Impact:** Information becomes stale over time

**Detection:**
```bash
# Search for time-sensitive language
grep -iE "(as of|currently|latest|new in|v[0-9]+\.[0-9]+|202[0-9])" SKILL.md
```

**Fix:** Use evergreen language:
- Remove dates where possible
- Use "current method" vs "new method"
- Put version-specific content in collapsible sections

---

### 7. Windows-Style Paths

**Signs:**
- Backslashes in paths: `references\guide.md`
- Mixed path separators

**Impact:** Broken links on Unix systems

**Detection:**
```bash
grep '\\' SKILL.md references/*.md
```

**Fix:** Use forward slashes everywhere:
- `references/guide.md` (correct)
- `scripts/helper.py` (correct)

---

### 8. Too Many Options

**Signs:**
- Lists multiple approaches without clear default
- "You can use X, or Y, or Z"
- No recommended path

**Impact:** Decision paralysis, inconsistent behavior

**Detection:** Look for phrases like:
- "alternatively"
- "you could also"
- "another option is"

**Fix:** Provide clear default with escape hatch:
```markdown
Use pdfplumber for text extraction (recommended).

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

---

## Anti-Pattern Summary

```xml
<AntiPatternSummary>
  <Pattern name="Name Mismatch" severity="Critical" />
  <Pattern name="Vague Description" severity="Critical" />
  <Pattern name="Information Overload" severity="Major" />
  <Pattern name="Missing Triggers" severity="Major" />
  <Pattern name="Deep Nesting" severity="Major" />
  <Pattern name="Time-Sensitive" severity="Minor" />
  <Pattern name="Windows Paths" severity="Minor" />
  <Pattern name="Too Many Options" severity="Minor" />
</AntiPatternSummary>
```
