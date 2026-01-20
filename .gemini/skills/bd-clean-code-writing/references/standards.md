# Code Standards & Style

## Functions
* **Size**: Small, single-purpose.
* **Purity**: Prefer pure functions; minimize side effects.
* **Arguments**: Max 3. Use parameter objects for more.
* **Flow**: Use early returns to reduce nesting.

## Naming
* **Intent**: Reveal intent without comments.
* **Verbs**: For functions (`calculateTotal`, `validateUser`).
* **Nouns**: For classes (`OrderProcessor`).
* **Booleans**: Question phrasing (`isValid`, `hasPermission`).
* **Prohibited**: Single letters (except counters), abbreviations, generic names (`data`, `handler`).

## Platform-Specific Type Safety

```xml
<Platforms>
  <Platform name="Swift">
    <TypeSystem>Protocols, generics</TypeSystem>
    <Nullability>Optional&lt;T&gt;</Nullability>
    <NamedArgs>Labels required</NamedArgs>
  </Platform>
  <Platform name="Kotlin">
    <TypeSystem>Interfaces, generics</TypeSystem>
    <Nullability>T? nullable</Nullability>
    <NamedArgs>Named supported</NamedArgs>
  </Platform>
  <Platform name="Dart">
    <TypeSystem>Abstract classes</TypeSystem>
    <Nullability>T? nullable</Nullability>
    <NamedArgs>Named with {}</NamedArgs>
  </Platform>
  <Platform name="TypeScript">
    <TypeSystem>Interfaces, generics</TypeSystem>
    <Nullability>T | undefined</Nullability>
    <NamedArgs>Object destructuring</NamedArgs>
  </Platform>
  <Platform name="Python">
    <TypeSystem>Type hints</TypeSystem>
    <Nullability>Optional[T]</Nullability>
    <NamedArgs>Keyword args</NamedArgs>
  </Platform>
  <Platform name="Go">
    <TypeSystem>Interfaces</TypeSystem>
    <Nullability>Pointers</Nullability>
    <NamedArgs>N/A</NamedArgs>
  </Platform>
  <Platform name="Rust">
    <TypeSystem>Traits, generics</TypeSystem>
    <Nullability>Option&lt;T&gt;</Nullability>
    <NamedArgs>N/A</NamedArgs>
  </Platform>
</Platforms>

```
