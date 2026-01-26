# AGENTS.md Anti-Patterns & Quick Fixes

## Why This Matters

Poorly written AGENTS.md files confuse coding agents and collaborators. Use these examples to spot common mistakes—and see how to fix them using the agent-skills workflow.

---

## Anti-Pattern #1: Kitchen Sink Dump

```markdown
## Project Overview
This repo does APIs, web apps, ML, blockchain, crypto, IoT, and more!

## Target Audience
Everyone.

## Key Commands
npm install, pip install, go install, all the commands for each folder.

## Details
Refer to EVERY file in the repo for specifics.

## Security
We might use OWASP but check README instead.
```

**Fix:**
- Focus only on repos main purpose and core audience
- Remove unrelated tech/features, clarify commands

```markdown
## Project Overview
This repository provides data analytics APIs and web dashboards.

## Target Audience
Product teams and data analysts using analytics tools.

## Key Commands
- Setup: npm install
- Build: npm run build
- Test: npm test
- Run: npm start

## Security
Follows OWASP Top Ten 2025. See /references/security.md.
```

---
## Anti-Pattern #2: Outdated/Unmaintained Info

```markdown
## Project Overview
Old microservices repo, last updated 2021.

## Target Audience
No longer maintained.

## Key Commands
npm install, outdated scripts, missing new features.

## Security
Not specified.
```

**Fix:**
- Regularly review and update AGENTS.md after major repo/team changes
- Specify current purpose, audience, and supported workflows
- Reference security docs/standards even for legacy code

```markdown
## Project Overview
Microservices API supporting current data workflow.

## Target Audience
Backend and devops engineers maintaining production services.

## Key Commands
- Setup: npm install
- Build: npm run build
- Test: npm test

## Security
OWASP API Top Ten 2023. Reviewed annually.
```

---

## Anti-Pattern #3: Missing Audience/Progressive Disclosure

```markdown
## Project Overview
All scripts for company.

## Key Commands
Assortment for different teams.
```

**Fix:**
- Clearly specify audience and link to separate doc for team-specific workflows

```markdown
## Project Overview
Scripts for analytics and reporting.

## Target Audience
Data analysts and reporting engineers.

## Key Commands
- Setup: pip install -r requirements.txt
- Run: python run_reports.py

## Additional Docs
- team_workflows.md (team-specific details)
```

---

## Tips
- Always update AGENTS.md after major repo, team, or process changes.
- Prefer linking to current workflows/security references rather than duplicating content.
- Use the [Checklist](checklist.md) before publishing changes.

