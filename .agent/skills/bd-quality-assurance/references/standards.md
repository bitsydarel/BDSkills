# Code Standards & Quality Gates

## Complexity Limits

Refactor code that exceeds these limits.

```xml
<ComplexityLimits>
  <Metric name="Cognitive complexity" limit="≤15 per function">
    <Remediation>Refactor into smaller units</Remediation>
  </Metric>
  <Metric name="Function length" limit="≤30 lines">
    <Remediation>Extract sub-functions</Remediation>
  </Metric>
  <Metric name="File length" limit="≤400 lines">
    <Remediation>Split into modules</Remediation>
  </Metric>
  <Metric name="Nesting depth" limit="≤3 levels">
    <Remediation>Use early returns / guard clauses</Remediation>
  </Metric>
  <Metric name="Parameters" limit="≤3-4 per function">
    <Remediation>Use parameter objects/structs</Remediation>
  </Metric>
</ComplexityLimits>
```

## Required Patterns

* **Type annotations**: All function signatures must be typed.
* **Named arguments**: Use for all boolean flags or functions with >2 args.
* **Enum values**: Use Enums for all bounded strings/status codes.
* **Error handling**: All errors explicitly handled (no empty catch blocks).
* **Resource cleanup**: All resources (files, sockets, streams) properly released.

## Forbidden Patterns

```xml
<ForbiddenPatterns>
  <Pattern name="Hardcoded secrets">
    <Reason>Security risk. Use environment variables.</Reason>
  </Pattern>
  <Pattern name="Magic strings/numbers">
    <Reason>Reduces maintainability. Use constants.</Reason>
  </Pattern>
  <Pattern name="Commented-out code">
    <Reason>Clutter. Version control handles history.</Reason>
  </Pattern>
  <Pattern name="TODO without issue">
    <Reason>Orphaned intentions. Link to a ticket/issue.</Reason>
  </Pattern>
  <Pattern name="Console logs in prod">
    <Reason>Performance and security risk.</Reason>
  </Pattern>
  <Pattern name="Any/dynamic types">
    <Reason>Defeats the purpose of the type system.</Reason>
  </Pattern>
</ForbiddenPatterns>
```

## Quality Gates

1.  **All checks pass**: Zero errors from format, lint, type, test, and build.
2.  **Tests pass**: 100% of tests green.
3.  **Coverage maintained**: No decrease in overall percentage.
4.  **No new warnings**: Fix or explicitly suppress with justification.
