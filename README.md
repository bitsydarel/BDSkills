# BD Skills - Agent Skills Repository

Professional development skills for AI coding agents. Works with multiple agent tools including OpenCode, Cursor, Gemini CLI, and the Claude Code Plugin Marketplace.

## Quick Start

After cloning the repository, run the setup script:

```bash
./scripts/setup.sh
```

This installs git hooks and syncs skills to all agent tool locations.

## Repository Structure

```
BDSkills/
├── skills/                    # CANONICAL SOURCE (edit skills here)
│   ├── bd-clean-code-writing/
│   ├── bd-test-design/
│   ├── bd-problem-solving/
│   ├── bd-quality-assurance/
│   ├── bd-project-conventions/
│   └── bd-software-architecture/
│
├── .opencode/skill/           # Symlinks for OpenCode
├── .cursor/skills/            # Symlinks for Cursor
├── .gemini/skills/            # Symlinks for Gemini CLI
├── plugins/                   # Symlinks for Plugin Marketplace
│
├── scripts/
│   ├── setup.sh               # Initial setup (run after clone)
│   └── sync-skills.sh         # Sync skills to all locations
│
└── hooks/                     # Git hook templates
```

## How It Works

The `skills/` directory is the **single source of truth**. All other locations contain symlinks pointing to this directory. This ensures:

- **One place to edit**: Modify skills in `skills/` only
- **Automatic updates**: Changes propagate to all agent tools instantly
- **No duplicates**: No risk of skills getting out of sync

## Supported Agent Tools

| Tool | Location | Format |
|------|----------|--------|
| OpenCode | `.opencode/skill/<name>/SKILL.md` | Agent Skills |
| Cursor | `.cursor/skills/<name>/SKILL.md` | Agent Skills |
| Gemini CLI | `.gemini/skills/<name>/SKILL.md` | Agent Skills |
| Claude Code Plugin | `plugins/<name>/skills/<name>/SKILL.md` | Marketplace |

## Available Skills

| Skill | Description |
|-------|-------------|
| bd-clean-code-writing | SOLID principles, clean code guidelines, type safety |
| bd-test-design | Test strategies, TDD, edge case coverage, property-based testing |
| bd-problem-solving | Debugging methodology, root cause analysis, code comprehension |
| bd-quality-assurance | Pre-commit checks, quality gates, CI/CD standards |
| bd-project-conventions | Project structure, environment setup, dependency management |
| bd-software-architecture | Layer separation, dependency rules, feature structure |

## Manual Sync

If symlinks get out of sync, run:

```bash
./scripts/sync-skills.sh
```

To check current status without making changes:

```bash
./scripts/sync-skills.sh --status
```

## Git Hooks

After running `./scripts/setup.sh`, git hooks are installed that automatically sync skills after:

- `git checkout` / `git switch`
- `git pull` / `git merge`

## Installation (Plugin Marketplace)

To install skills via Claude Code Plugin Marketplace:

```bash
/plugin marketplace add darelbitsy/BDSkills
```

Then browse and install skills:

```bash
/plugin menu
```

## Platform Support

All skills apply universally to:

- **Mobile**: Flutter, iOS (Swift), Android (Kotlin)
- **Web**: React, Vue, Angular, TypeScript
- **Backend**: Python, Node.js, Go, Rust
- **AI/ML**: Training pipelines, model serving

## License

Apache-2.0
