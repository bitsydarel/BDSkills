# Property-Based Testing (PBT)

Define invariants that hold true for *all* valid inputs, rather than specific examples.

## When to Use
- **Serialization**: `deserialize(serialize(x)) == x`
- **Sorting**: Output is ordered, length matches input
- **Math**: Associativity, commutativity
- **Parsers**: Valid input always produces valid output

## Common Patterns
1. **Round-trip**: Encode -> Decode -> Original
2. **Idempotence**: `f(f(x)) == f(x)`
3. **Invariant**: Property never changes (e.g., list size)
4. **Oracle**: Compare output against a known-good (but slow) implementation

## Tools
- **Python**: Hypothesis
- **JS/TS**: fast-check
- **Java/Kotlin**: Kotest / Jqwik
- **Go**: gopter
- **Rust**: proptest
