---
name: bd-problem-solving
description: systematic guide for technical problem solving, debugging, and architectural decision making. Use this skill when users present complex bugs, request help understanding unfamiliar codebases, need to make technical trade-off decisions, or require root cause analysis for system failures.
---

# Problem Solving

This skill guides systematic approaches to debugging, solution design, and code comprehension.

## Core Principles

1. **Root Cause over Symptoms**: Never treat symptoms; identify and fix the underlying cause.
2. **Systematic Execution**: Understand the system before changing it.
3. **Verify**: Prove the fix works and prevents recurrence.

## Workflows

### 1. Code Comprehension & Architecture
**Use when**: Exploring unfamiliar code, onboarding, or analyzing system interactions.

* **Map the System**: Use the Graph of Thoughts method to map entry points, data flows, and side effects.
* **See**: [references/analysis.md](references/analysis.md) for "Graph of Thoughts" and "Decision Frameworks".

### 2. Strategic Decision-Making
**Use when**: Designing features, choosing tools, or navigating complex trade-offs.

* **Evaluate Options**: Use the Tree of Thoughts method to branch out at least 3 potential solutions.
* **Analyze Trade-offs**: Document pros, cons, and risks for each branch.
* **See**: [references/analysis.md](references/analysis.md) for "Tree of Thoughts" steps.

### 3. Debugging & Investigation
**Use when**: Fixing bugs, resolving crashes, or investigating performance issues.

* **Isolate**: Reproduce the issue reliably.
* **Identify**: Use the 5 Whys to find the root cause.
* **Fix**: Apply the fix and add regression tests.
* **See**: [references/debugging.md](references/debugging.md) for "Root Cause Analysis", "Performance Investigation", and platform-specific tools.

## Guardrails

* **Avoid Shotgun Debugging**: Do not make random changes hoping one works.
* **Avoid Premature Optimization**: Always profile before optimizing.
* **Isolate Variables**: Change one thing at a time during investigation.
