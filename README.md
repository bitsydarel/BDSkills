# BD Skills - Agent Skills Repository

Professional development skills for AI coding agents. Works with multiple agent tools including OpenCode, Cursor, Gemini CLI, and the Claude Code Plugin Marketplace.

## Quick Start

After cloning the repository, run the setup script:

```bash
./scripts/setup.sh
```

This installs git hooks and syncs skills to all agent tool locations.

## Global Skills Installation

To make BD Skills available system-wide for OpenCode, Gemini CLI, Claude Code, and Cursor, use:

```bash
./scripts/install-skills-globally.sh        # Installs/updates all skills globally
./scripts/install-skills-globally.sh --dry-run  # Preview actions without making changes
./scripts/install-skills-globally.sh --verbose  # Detailed output during install
./scripts/install-skills-globally.sh --verify   # Deep verification after install
./scripts/install-skills-globally.sh --status   # Show current global install status
```

- Installs all skills from the canonical `skills/` directory to each global config location for the tools:
    - `~/.config/opencode/skills/` (OpenCode)
    - `~/.gemini/skills/` (Gemini CLI)
    - `~/.claude/skills/` (Claude Code)
    - `~/.cursor/skills/` (Cursor)
- Uses hard links for efficient syncing (no duplication). Automatically falls back to copying files when hard linking isn't supported, with warnings printed.
- After install, automated verification confirms every skill and file is correctly present and linked/copies match the canonical source.
- Supports complex skills with references, subdirectories, and assets, not just SKILL.md.

### Windows Compatibility
- Run script via **WSL** or **Git Bash** for full functionality.
- If you encounter errors with hard linking (common on network/cloud drives), the script will copy files and print a warning.
- For _native PowerShell_ currently manual copy is needed: copy the contents of `skills/` to the matching config directory (e.g., `%USERPROFILE%\.config\opencode\skills\`). Native PowerShell support is planned for future.

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
│   ├── sync-skills.sh         # Sync skills to all locations
│   └── install-skills-globally.sh # Global skills installer (system-wide for all tools)
│
└── hooks/                     # Git hook templates
```

## How It Works

The `skills/` directory is the **single source of truth**. All other locations contain symlinks, hard links, or copies pointing to this directory. This ensures:

- **One place to edit**: Modify skills in `skills/` only.
- **Automatic updates**: Changes propagate to all agent tools instantly.
- **No duplicates**: No risk of skills getting out of sync.

## Supported Agent Tools

| Tool | Location | Format |
|------|----------|--------|
| OpenCode | `.opencode/skill/<name>/SKILL.md` | Agent Skills |
| Cursor | `.cursor/skills/<name>/SKILL.md` | Agent Skills |
| Gemini CLI | `.gemini/skills/<name>/SKILL.md` | Agent Skills |
| Claude Code Plugin | `plugins/<name>/skills/<name>/SKILL.md` | Marketplace |

## Available Skills

| Skill Name                | Description                                                               |
|-------------------------- |---------------------------------------------------------------------------|
| bd-create-agents-md       | Step-by-step guide for creating AGENTS.md/CLAUDE.md for repo context, onboarding, core commands.   |
| bd-test-design            | Comprehensive guide for designing and implementing software tests (Unit, Integration, E2E, UI, AI). |
| bd-clean-code-writing     | Workflow for generating/refactoring/reviewing code with SOLID principles, separation, type safety.  |
| bd-skill-creating         | Step-by-step guide for creating effective agent skills (open agent-skills standard).                |
| bd-skill-reviewing        | Framework for reviewing and improving agent skills for quality, effectiveness, compliance.           |
| bd-software-architecture  | Architectural enforcement for software design. Guides layering, dependency, design/refactor.         |
| bd-quality-assurance      | Enforces code standards, release readiness, guides pre-commit checks and finalization.              |
| bd-project-conventions    | Standards for project structure, environment config, code organization, across all platforms.        |
| bd-problem-solving        | Systematic guide for technical problem solving, debugging, decision making, root cause analysis.    |
| teg-mobile-architecture   | Enforces TEG mobile architecture standard across Flutter, iOS, Android; layers, folder structure.   |

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

## Troubleshooting
- For missing skills or files in any global tool, re-run the installer script.
- Use `--verify` for a deep check of file presence and correctness.
- If you see hard link errors, your OS/filesystem may not support them for the target; copying will be used automatically.
- For Windows native (PowerShell), manually copy until official support is added.

## License

Apache-2.0
