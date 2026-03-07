# CLI / Terminal — Platform Heuristics

**Key references**: clig.dev, Heroku 12-Factor CLI, POSIX, GNU Coding Standards, GitHub CLI accessibility

## Platform Complexity Checklist

A thorough CLI review must evaluate:

- Terminal width adaptation (80-col default, `$COLUMNS` detection, wrapping strategy)
- Color handling (`NO_COLOR`, `FORCE_COLOR`, `TERM=dumb`, 256-color vs truecolor)
- Interactive vs non-interactive mode (`isatty()` detection)
- Piping composability (stdin/stdout/stderr contracts)
- Shell completion (bash/zsh/fish)
- Config hierarchy (XDG Base Directory: `$XDG_CONFIG_HOME`, flags > env > config file > defaults)
- Progress indicators (spinner/counter/progress bar on stderr, not stdout)
- Pagination (`PAGER` env, `less -FIRX` pattern)
- Cross-platform (Windows cmd/PowerShell/WSL path differences)
- Exit codes (0 success, 1 general error, 2 misuse, 126/127 permission/not found, 128+N signal)
- Signal handling (SIGINT/SIGTERM graceful shutdown, cleanup on interrupt)
- Verbose/quiet/debug output levels (`-v`, `-q`, `--debug`)
- Machine-readable output (`--json`, `--format=csv|table|yaml`)

## Dimension Interpretation Table

| Dim | Generic Meaning | CLI Interpretation |
|-----|----------------|-------------------|
| 1 | Human-centered problem framing | Does the CLI solve a real workflow problem? Are commands modeled after user tasks, not internal architecture? |
| 2 | Usability & interaction quality | Command ergonomics: memorable names, consistent flags, actionable error messages, composable output |
| 3 | Information architecture | Command hierarchy: logical subcommand tree, `--help` quality, discoverability via completion and man pages |
| 4 | Visual design & brand | Terminal output formatting: tables, colors (with NO_COLOR support), whitespace, consistent output structure |
| 5 | User research & evidence | Has the CLI been tested with real terminal workflows? Observed in CI/CD pipelines, scripts, and interactive use? |
| 6 | Accessibility & inclusivity | Screen reader compatibility (static text mode), NO_COLOR support, non-animated alternatives, clear error output |
| 7 | Service blueprint & journey | Full workflow: install → configure → first command → daily use → scripting → troubleshooting → upgrade |
| 8 | Co-creation & facilitation | Community input on command design, RFC process for breaking changes, plugin/extension architecture |
| 9 | Prototyping & validation | Alpha/beta CLI releases, `--dry-run` support, user testing with real terminal workflows |
| 10 | Design system coherence | Flag naming conventions (`--verbose` not `-V` in one place and `--debug` in another), output format consistency, error format consistency |

## Anti-Patterns (CLI-Specific)

**1. GUI-in-a-Terminal**
- **Signs**: Full-screen TUI for simple tasks, mouse interaction expected, non-keyboard-navigable menus, breaks when piped
- **Impact**: Unusable in scripts, CI/CD pipelines, remote sessions. Violates composability — the core value of CLI tools
- **Fix**: Interactive prompts as enhancement only; all functionality available via flags. Detect `isatty()` and degrade gracefully

**2. Flag Explosion**
- **Signs**: 30+ flags on a single command, no subcommand structure, `--help` output exceeds terminal height, flags with overlapping semantics
- **Impact**: Unlearnable; users can't discover or remember flags. Cognitive overload. Error-prone command construction
- **Fix**: Group into subcommands (`tool config set` not `tool --config-set`). Limit top-level flags to 10-12. Use config files for rarely-changed options

**3. Silent Failure**
- **Signs**: Exit code 0 on error, no stderr output on failure, partial completion without notification, swallowed exceptions
- **Impact**: Scripts continue past failures causing cascading damage. Users trust output that is actually incomplete. Debugging is impossible
- **Fix**: Non-zero exit codes for all failures. Actionable error messages on stderr. `--verbose` flag for diagnostic detail. Distinguish partial from complete success

**4. Unpipeable Output**
- **Signs**: Progress bars/spinners on stdout, ANSI color codes in piped output, human text mixed with data, no `--json` or structured output option
- **Impact**: Cannot compose with other tools (`grep`, `jq`, `awk`). Breaks the Unix philosophy. Forces users to parse human-readable text
- **Fix**: Data on stdout, progress/status on stderr. Strip ANSI when `isatty()` is false. Provide `--json` / `--format` for machine consumption

**5. Inconsistent Naming**
- **Signs**: Mix of `get`/`show`/`list`/`describe` for similar operations, inconsistent flag names (`--output` vs `--format` vs `--type`), verb-noun order varies
- **Impact**: Users can't predict command names. Every new command requires reading docs. Muscle memory doesn't transfer between subcommands
- **Fix**: Establish a verb vocabulary (`list`, `get`, `create`, `delete`, `update`) and apply consistently. Use the same flag name for the same concept everywhere

## Key Heuristics

1. **Composability first** — stdout is for data, stderr is for humans. Every command should work in a pipeline
2. **Generous input, structured output** — Accept flexible input formats; output should be parseable (`--json`)
3. **Fail loudly and specifically** — Non-zero exit codes, stderr messages that name the problem and suggest a fix
4. **Progressive complexity** — Simple tasks = simple commands. Advanced features available but not required
5. **Respect the environment** — Honor `NO_COLOR`, `PAGER`, `EDITOR`, `XDG_*`, terminal width. Don't fight the user's setup

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **GitHub CLI** | `--json` with built-in `--jq`; `gh a11y` screen reader mode (static text replaces spinners); consistent verb-noun structure |
| **Google Cloud CLI** | Tree-structured commands mirroring API resources; `--format=json|yaml|csv|table`; accessibility mode; waiter commands for async ops |
| **Stripe CLI** | Local dev bridging (`stripe listen`); event simulation; consistent flag naming across all commands |
| **Heroku CLI** | Colon-separated subcommands; oclif framework; grep-parseable table output; `--json` everywhere |
| **AWS CLI** | JMESPath `--query` for output filtering; waiter commands; `--dry-run`; paginated output with `--max-items` |
| **Vercel CLI** | Zero-config detection; minimal output by default; contextual `--help`; CI-friendly non-interactive mode |
