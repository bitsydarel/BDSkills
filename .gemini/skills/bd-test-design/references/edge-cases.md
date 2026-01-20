# Edge Case Checklist

## Required Categories
- **Empty/Null**: Empty strings, collections, nulls.
- **Invalid Types**: Malformed JSON, wrong types.
- **Boundaries**: Maxint, Minint, off-by-one.
- **Environment**: Network timeout, disk full, timezone shifts (DST).
- **Strings**: Unicode, Emojis, Injection payloads.

## Path Analysis

```xml
<Paths>
  <Path>
    <Type>Happy</Type>
    <Description>Normal flow</Description>
    <Example>User logs in successfully</Example>
  </Path>
  <Path>
    <Type>Sad</Type>
    <Description>Expected error</Description>
    <Example>Password incorrect -&gt; Error Msg</Example>
  </Path>
  <Path>
    <Type>Ugly</Type>
    <Description>Unexpected/System</Description>
    <Example>Database down, 500 error</Example>
  </Path>
</Paths>

```
