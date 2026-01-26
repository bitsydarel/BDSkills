# Changelog

All notable changes to this repository will be documented in this file.

## [1.0.0] - 2026-01-26
### Added
- Initial public release of BDSkills repository.
- Canonical `skills/` directory containing:
  - bd-create-agents-md
  - bd-test-design
  - bd-clean-code-writing
  - bd-skill-creating
  - bd-skill-reviewing
  - bd-software-architecture
  - bd-quality-assurance
  - bd-project-conventions
  - bd-problem-solving
  - teg-mobile-architecture
- Cross-platform global installer script: `scripts/install-skills-globally.sh`.
  - Installs skills from canonical source to agent tool config locations (OpenCode, Gemini CLI, Claude Code, Cursor).
  - Hard-link first, auto-fallback to copy with warnings; compatible with Linux/macOS/WSL/Git Bash.
  - Automated verification (`--verify`) ensures skill integrity in all global installs.
  - Flags for `--dry-run`, `--verbose`.
  - Enhanced help output and troubleshooting notes for cross-platform use, including PowerShell manual steps.
- Substantive reference docs for each skill (checklists, architecture, heuristic examples, templates, patterns, platform/components, validation/specification).
- Updated README.md:
  - Current skill list, accurate descriptions from SKILL.md.
  - Documented install workflow, troubleshooting, and agent tool details.

### Changed
- README: Replaced obsolete skill list with auto-canonical listing and descriptions from SKILL.md.
- Enhanced `install-skills-globally.sh` verification and logging.

### Fixed
- None (first release).

