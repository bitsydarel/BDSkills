# Component Decision Guide

## Repository vs Service

**Rule of Thumb**: If it acts like a collection of data → Repository. If it performs an action → Service.

```xml
<components>
  <component>
    <name>Repository</name>
    <focus>Data</focus>
    <exampleResponsibilities>CRUD, caching, queries, pagination</exampleResponsibilities>
  </component>
  <component>
    <name>Service</name>
    <focus>Capabilities</focus>
    <exampleResponsibilities>3rd Party APIs, device features, auth, payments</exampleResponsibilities>
  </component>
</components>

```

## Data Source Architecture

1. **Contract (Interface)**: Defines *what* is needed.
2. **Implementation**: Defines *how* it works. Maps DTOs → Domain Models before returning.

```text
                  Dependency Direction
Repository ─────────────────────────────────> Data Source Contract
                                                      ^
                                                      │ (implements)
                                              Data Source Impl

```

## Use Case Guidelines

**Composition Rules:**

* Only compose when called use case represents a **standalone business intention**.
* Keep composition shallow (1-2 levels).
* No loops allowed.

**Valid Use Cases:** Business intentions ("Login", "ProcessPayment") or Reusable guards ("EnsureAuthenticated").
**Invalid Use Cases:** Formatting helpers, DTO transformations, Shared implementation details.
