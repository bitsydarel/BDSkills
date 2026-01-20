---
name: bd-quality-assurance
description: Enforces code standards, validates release readiness, and guides pre-commit checks. Use when the user is finalizing features, preparing pull requests, running local CI checks, debugging build failures, or asking about code quality standards.
---

# Quality Assurance

This skill guides the execution of quality checks. Run these checks before committing code or submitting pull requests.

## Pre-Commit Execution Flow

Run checks in this dependency order. If a step fails, fix it before moving to the next.

1.  **Format**: Consistent code style (whitespace, indentation)
2.  **Lint**: Code quality, potential bugs, and patterns
3.  **Type**: Static type safety verification
4.  **Test**: Behavior verification and regression checking
5.  **Build**: Compilation and bundling verification

## Platform-Specific Commands

For specific CLI commands (Python, TypeScript, Swift, Go, Rust, etc.), see **[references/commands.md](references/commands.md)**.

## Standards and Gates

Ensure code meets the defined quality gates before pushing.

* **Complexity & Patterns**: For complexity limits (nesting, function length) and required/forbidden patterns, see **[references/standards.md](references/standards.md)**.
* **Coverage**:
    * New code: 80% line coverage
    * Critical paths: 90%+ coverage
    * Bug fixes: Must include a test covering the fix

## Pull Request Preparation

For the PR Readiness Checklist and Commit Message formatting standards, see **[references/process.md](references/process.md)**.

## Handling Failures

```xml
<Failures>
  <Failure>
    <Type>Format</Type>
    <Action>Run the auto-formatter and commit changes.</Action>
  </Failure>
  <Failure>
    <Type>Lint</Type>
    <Action>Fix issues. Only suppress if false positive (requires comment explanation).</Action>
  </Failure>
  <Failure>
    <Type>Type</Type>
    <Action>Fix type errors. <b>Never</b> use <code>any</code> or equivalent to bypass.</Action>
  </Failure>
  <Failure>
    <Type>Test</Type>
    <Action>Fix the code or update the test. <b>Never</b> skip tests to force a merge.</Action>
  </Failure>
  <Failure>
    <Type>Build</Type>
    <Action>Resolve compilation errors.</Action>
  </Failure>
</Failures>

```

### CI/CD Alignment rules
* **Match Versions**: Local tools must match CI versions.
* **Pre-Push**: Run the full chain locally (`format && lint && type && test && build`) before pushing.
