# Test Design Heuristics

## CORRECT Heuristic
Use for edge cases and data validation.

```xml

<heuristics>
    <item>
        <letter>C</letter>
        <meaning>Conformance</meaning>
        <whatToTest>Format/structure matching</whatToTest>
    </item>
    <item>
        <letter>O</letter>
        <meaning>Ordering</meaning>
        <whatToTest>Sorted vs unsorted inputs</whatToTest>
    </item>
    <item>
        <letter>R</letter>
        <meaning>Range</meaning>
        <whatToTest>Min, max, and outside values</whatToTest>
    </item>
    <item>
        <letter>R</letter>
        <meaning>Reference</meaning>
        <whatToTest>Null, empty, circular references</whatToTest>
    </item>
    <item>
        <letter>E</letter>
        <meaning>Existence</meaning>
        <whatToTest>Missing files, nulls, empty sets</whatToTest>
    </item>
    <item>
        <letter>C</letter>
        <meaning>Cardinality</meaning>
        <whatToTest>0, 1, many (fences post error)</whatToTest>
    </item>
    <item>
        <letter>T</letter>
        <meaning>Time</meaning>
        <whatToTest>Timeout, concurrency, race conditions</whatToTest>
    </item>
</heuristics>

```

## Right-BICEP
Use for verifying test completeness.

```xml

<right-bicep>
    <item>
        <letter>Right</letter>
        <meaning>Right results</meaning>
        <whatToVerify>Valid input = correct output</whatToVerify>
    </item>
    <item>
        <letter>B</letter>
        <meaning>Boundary</meaning>
        <whatToVerify>All boundaries checked</whatToVerify>
    </item>
    <item>
        <letter>I</letter>
        <meaning>Inverse</meaning>
        <whatToVerify>Verify by reversing (decode(encode))</whatToVerify>
    </item>
    <item>
        <letter>C</letter>
        <meaning>Cross-check</meaning>
        <whatToVerify>Verify via different method</whatToVerify>
    </item>
    <item>
        <letter>E</letter>
        <meaning>Error conditions</meaning>
        <whatToVerify>Exceptions handled correctly</whatToVerify>
    </item>
    <item>
        <letter>P</letter>
        <meaning>Performance</meaning>
        <whatToVerify>Speed/Memory constraints met</whatToVerify>
    </item>
</right-bicep>

```

## Zero-One-Many
Use for collections, loops, and recursion.
1. **Zero**: Empty list/string/file.
2. **One**: Single item.
3. **Many**: Multiple items (and max limit).
