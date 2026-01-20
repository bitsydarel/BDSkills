# Architecture & Dependencies

## Layer Responsibilities

```xml
<layers>
  <layer>
    <name>Presentation</name>
    <responsibility>UI, controllers, views</responsibility>
    <dependencies>Domain only</dependencies>
  </layer>
  <layer>
    <name>Domain</name>
    <responsibility>Business rules, entities</responsibility>
    <dependencies>None (pure)</dependencies>
  </layer>
  <layer>
    <name>Data</name>
    <responsibility>Repositories, Services, DataSource Contracts</responsibility>
    <dependencies>Domain interfaces</dependencies>
  </layer>
  <layer>
    <name>Infrastructure</name>
    <responsibility>Frameworks, libraries</responsibility>
    <dependencies>Implements DataSource Contracts</dependencies>
  </layer>
</layers>

```

## Dependency Rules
1.  **Direction**: Dependencies flow inward (UI → Domain ← Data).
2.  **Isolation**: Core business logic must not depend on external frameworks.
3.  **Injection**: All dependencies must be explicit in constructor/parameters.

## Anti-Patterns (Forbidden)
* **Magic strings**: Use enums/constants.
* **Hidden dependencies**: No internal instantiation of services.
* **God classes**: Split immediately.
* **Deep inheritance**: Prefer composition.
* **Premature abstraction**: Wait for duplication before abstracting.
* **Feature envy**: Methods using another class's data exclusively.
* **Primitive obsession**: Use domain types (`Email`) not primitives (`String`).