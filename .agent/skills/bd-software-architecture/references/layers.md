# Architecture Layers & Dependencies

## Layer Responsibilities

```xml
<layers>
  <layer>
    <name>Presentation</name>
    <responsibility>How data is shown/received</responsibility>
    <platformExamples>Views, CLI, API handlers, Controllers</platformExamples>
  </layer>
  <layer>
    <name>Use Cases</name>
    <responsibility>What the app does (business operations)</responsibility>
    <platformExamples>Application services, Command handlers</platformExamples>
  </layer>
  <layer>
    <name>Repositories</name>
    <responsibility>How data is coordinated</responsibility>
    <platformExamples>Cache strategies, query aggregation</platformExamples>
  </layer>
  <layer>
    <name>Services</name>
    <responsibility>How capabilities work</responsibility>
    <platformExamples>Auth, payments, notifications, analytics</platformExamples>
  </layer>
  <layer>
    <name>Data Sources</name>
    <responsibility>Where data lives</responsibility>
    <platformExamples>APIs, DBs, files, ML models</platformExamples>
  </layer>
  <layer>
    <name>Domain Models</name>
    <responsibility>What data is (pure)</responsibility>
    <platformExamples>Entities, value objects, enums</platformExamples>
  </layer>
</layers>

```

## Dependency Matrix

**Rule**: Dependencies flow one-way toward high-level policies.

```xml
<dependencyMatrix>
  <row from="Presentation">
    <to layer="Presentation">✅</to>
    <to layer="Use Cases">✅</to>
    <to layer="Repos/Services">❌</to>
    <to layer="DS Contracts">❌</to>
    <to layer="DS Impls">❌</to>
  </row>
  <row from="Use Cases">
    <to layer="Presentation">❌</to>
    <to layer="Use Cases">✅</to>
    <to layer="Repos/Services">✅</to>
    <to layer="DS Contracts">❌</to>
    <to layer="DS Impls">❌</to>
  </row>
  <row from="Repos/Services">
    <to layer="Presentation">❌</to>
    <to layer="Use Cases">❌</to>
    <to layer="Repos/Services">✅</to>
    <to layer="DS Contracts">✅</to>
    <to layer="DS Impls">❌</to>
  </row>
  <row from="DS Contracts">
    <to layer="Presentation">❌</to>
    <to layer="Use Cases">❌</to>
    <to layer="Repos/Services">❌</to>
    <to layer="DS Contracts">✅</to>
    <to layer="DS Impls">❌</to>
  </row>
  <row from="DS Impls">
    <to layer="Presentation">❌</to>
    <to layer="Use Cases">❌</to>
    <to layer="Repos/Services">❌</to>
    <to layer="DS Contracts">✅ (impl)</to>
    <to layer="DS Impls">✅</to>
  </row>
</dependencyMatrix>

```

**Note**: Domain Models are dependency-free and usable by all layers.