---
name: bd-create-agents-md
description: Step-by-step guide for creating your repo’s AGENTS.md or CLAUDE.md file—use whenever you want coding agents to reliably understand your repository’s core purpose, product, and target audience. Applies equally to AGENTS.md and CLAUDE.md, focusing on universal core elements for any repo type (agnostic). Triggers: new repo setup, restructuring, onboarding, compatibility checks, or major feature additions. Follows open standards and progressive disclosure.
---

## Understanding AGENTS.md and CLAUDE.md

AGENTS.md (and CLAUDE.md) are open standard Markdown files providing context and instructions to AI coding agents, helping them work effectively on your project. Use either file—they are functionally equivalent—to focus on your repo's core purpose or product. Limit content to universally applicable info. For technical details or specifics, use progressive disclosure: link to separate docs or our [Checklist](references/checklist.md) and [Example AGENTS.md](references/example-agents-md.md) instead of duplicating content.

## Workflow

1. Identify your repo’s universal purpose/product and clearly specify the software’s target audience—i.e., the intended users, customers, or beneficiaries of the software/system (e.g., 'for data scientists using analytics tools', 'for enterprise teams adopting workflow automation', 'for students learning Python').
   - Always update AGENTS.md after significant repository, team, or workflow/process changes—not just initial setup or major feature additions. See [Anti-Patterns](references/anti-patterns.md) for common mistakes and quick fixes.
2. List core conventions and key commands/styles that agents will need for any environment: setup, build, test, run, deploy. LLMs will infer concrete commands based on repo files (e.g., `npm install`, `pip install`).
3. Draft high-level sections (Project Overview, Target Audience, Key Commands, Security, and Additional Docs). See [Sample AGENTS.md](references/example-agents-md.md) for structure.
4. Reference separate docs for advanced or technical specifics (e.g., building.md, .github/workflows/ci.yml) to provide detail via progressive disclosure—no duplication.
5. Always include security considerations, repo-relevant info (e.g., PR/code style if GitHub Actions detected), and ensure details help agents make better decisions in context.
6. Test for conciseness (<300 lines), universal applicability (agnostic), and agent compatibility. Use [Checklist](references/checklist.md) to confirm.

## Single-Repo vs. Monorepo Guidance

Most repositories are single-project (web, mobile, or backend). Start with the minimal example below for nearly all projects. Use the complex/monorepo patterns only if your repo manages multiple platforms or independent packages in a unified codebase.

Avoid overcomplicating your AGENTS.md—clarity and simplicity are preferred for single-repo projects.

## Examples

A minimal, fully agnostic AGENTS.md or CLAUDE.md should look like this:

```markdown
## Project Overview
This repository provides tools for efficient data management.

## Target Audience
Intended for researchers, analysts, and engineers who will use this software for automated data workflows.

## Key Commands
- Setup: `[SETUP_COMMAND]` (e.g., `npm install`, `pip install -r requirements.txt`)
- Build: `[BUILD_COMMAND]` (e.g., `npm run build`, `make`)
- Test: `[TEST_COMMAND]` (e.g., `npm test`, `pytest`)
- Run: `[RUN_COMMAND]` (e.g., `npm start`, `python app.py`)
- Deploy: `[DEPLOY_COMMAND]` (optional)

## Security
Follow organizational best practices. See [security.md](security.md) if present.

## Additional Docs
- CONTRIBUTING.md: Contribution workflows
- .github/workflows/ci.yml: CI details (if present)
```

Want more nuanced or advanced samples (e.g., monorepos, APIs, mobile)? See [Complex Examples](references/complex-examples.md), [Example AGENTS.md](references/example-agents-md.md), and [Anti-Patterns](references/anti-patterns.md) for what to avoid.

### Complex Example: Monorepo with Multiple Platforms

```markdown
## Project Overview
Manages components for Web, Mobile (iOS/Android), and Backend services in a monorepo.

## Target Audience
Developers building full-stack solutions (React, Flutter, Node.js).

## Key Commands
- Setup: `npm install --workspaces`
- Build Web: `npm run build:web`
- Build Mobile: `npm run build:mobile`
- Build Backend: `npm run build:server`
- Test: `npm test`

## Security
See [references/security.md](references/security.md).

## Platform Docs
- [references/web-readme.md](references/web-readme.md)
- [references/mobile-readme.md](references/mobile-readme.md)
- [references/server-readme.md](references/server-readme.md)
- CI/CD: [.github/workflows/ci.yml](.github/workflows/ci.yml)
```

## Pitfalls and Best Practices

- **Pitfall:** Including changeable info like versions—avoid! 
- **Pitfall:** Overfitting to one repo type—keep instructions universal; let agents specialize.
- **Best Practice:** Use progressive disclosure: link out to details, checklists, or workflow docs instead of duplicating.
- **Best Practice:** Always specify the software's or system’s target audience—i.e., who will actually use the product, library, or service described by this repo (e.g., 'for open source contributors using the library', 'for enterprise users of workflow tools'). This context helps agents interpret requirements and constraints accurately.
- **Best Practice:** Always mention security and repo-relevant details (e.g., PR/code style/security); LLMs will adapt if files like .github/workflows are present.
- Before finishing, confirm you meet all agent-readiness requirements via the [Checklist](references/checklist.md).
- Regularly review and update AGENTS.md after major repo or team changes. See [Anti-Patterns](references/anti-patterns.md) for examples of what to avoid and their quick fixes.

## Resources

- [agents.md Open Standard](https://agents.md)
- [HumanLayer Blog – Writing a Good CLAUDE.md](https://humanlayer.dev/blog/writing-a-good-claude-md)
- For deep dives and more samples, see /references in this skill
