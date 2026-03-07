# Anti-patterns: Input Validation & Insecure Deserialization

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of insecure deserialization, where untrusted data is deserialized using formats that support code execution during the parsing process. Deserialization is deeply language-specific with completely different attack vectors per ecosystem. The key insight: code execution happens DURING deserialization, not after — so type-checking the result is too late.

## Trust the Client — Critical

**Signs**: Authorization checks performed only in the frontend. Price or quantity validated in JavaScript before sending to the server. Hidden form fields or disabled buttons used as security controls. JWT tokens decoded but not verified server-side. Admin functionality hidden behind UI routing but accessible via direct API calls.

**Impact**: Any attacker with a browser's developer tools or a proxy (Burp Suite, mitmproxy) bypasses all controls. Price manipulation in e-commerce. Privilege escalation via direct API calls. Data exfiltration by modifying client-side queries. This is the #1 pattern behind IDOR vulnerabilities.

**Fix**: Enforce all security decisions server-side. Client-side validation is for UX only — never for security. Every API endpoint must independently verify authentication, authorization, and input validity. Assume the client is fully compromised. Test by calling APIs directly without the UI.

**Detection**:
- *Code patterns*: Authorization logic only in frontend components (React/Vue guards without API middleware); price/quantity/discount fields accepted from client without server recalculation; JWT decoded but not verified (`jwt.decode` without `verify=True`)
- *Review questions*: If I call the API directly (bypassing the UI), does every security check still apply? Are business rules (pricing, limits) enforced server-side?
- *Test methods*: Call every API endpoint directly with curl/Postman, bypassing the UI. Modify client-side values (prices, user IDs, roles) and verify the server rejects invalid values

---

## Input Validation Theater — Major

**Signs**: Frontend validation with corresponding `if` statement in backend that only checks one condition. Allowlisting file extensions but not validating file content (MIME type, magic bytes). SQL parameterized queries for some endpoints but raw string concatenation for "internal" ones. Regex-based XSS filtering instead of proper output encoding.

**Impact**: Bypassed validation is often worse than no validation because it gives false confidence. Incomplete injection prevention means attackers simply find the endpoint that was missed. File upload validation on extension only allows polyglot file attacks.

**Fix**: Validate all inputs server-side with a centralized validation framework. Use parameterized queries for ALL database access — no exceptions. Apply context-specific output encoding (HTML entities, URL encoding, JS string escaping). Validate file uploads by content type, magic bytes, and size — not just extension.

**Detection**:
- *Code patterns*: Regex-based XSS filtering (blocklist) instead of output encoding; some endpoints use parameterized queries while others use string concatenation; file upload checks `.endsWith('.jpg')` without magic byte validation
- *Review questions*: Is input validation centralized or per-endpoint? Are there any raw SQL queries? Does file upload validation check content type or just extension?
- *Test methods*: Search for raw SQL concatenation across the codebase. Test file upload with renamed extensions (`.php` renamed to `.jpg`). Test XSS with encoding variations that bypass regex filters

---

## Error Message Oracle — Major

**Signs**: Stack traces in production error responses. Different error messages for "user not found" vs "wrong password." Database error messages exposing table/column names. API responses that reveal internal service names, versions, or file paths. Verbose error details in 4xx/5xx responses.

**Impact**: Attackers use differentiated error messages to enumerate valid usernames, map internal architecture, identify technology stack, and craft targeted attacks. Stack traces reveal file paths, dependency versions, and code structure. This information turns a blind attacker into an informed one.

**Fix**: Return generic error messages to clients ("Invalid credentials," "An error occurred"). Log detailed errors server-side with correlation IDs. Never expose stack traces, internal paths, or database errors to external users. Use identical response timing and messages for auth failures (prevents username enumeration).

**Detection**:
- *Code patterns*: Different error messages for "user not found" vs "wrong password"; exception details in HTTP response body; stack traces in catch blocks sent to client; database column names in error responses
- *Review questions*: Do authentication failure responses differ based on whether the username exists? Can error responses reveal internal architecture?
- *Test methods*: Compare error responses for valid-user-wrong-password vs invalid-user. Trigger server errors and check for stack traces. Measure response timing differences for auth failures (timing oracle)

---

## Oversharing APIs — Minor

**Signs**: API responses include all database fields, not just those needed by the client. User profile endpoints return email, phone, address even when only the name is needed. List endpoints return full objects instead of summaries. Internal IDs (auto-increment) exposed in responses.

**Impact**: Excessive data exposure (OWASP API3:2023). PII leaked to clients that do not need it. Internal IDs enable enumeration attacks. Larger attack surface for data breaches — more data exposed per compromised request.

**Fix**: Return only the fields the client needs (response filtering / DTO pattern). Use UUIDs instead of sequential IDs in API responses. Implement field-level access control for sensitive fields. Review API responses in integration tests for data minimization.

**Detection**:
- *Code patterns*: `SELECT *` or full model serialization without field filtering; auto-increment IDs in API responses; user endpoint returning email/phone when only name is needed
- *Review questions*: Does each API endpoint return only the fields the client needs? Are internal IDs (auto-increment) exposed in responses?
- *Test methods*: Compare API response fields against what the UI actually uses. Check for sequential IDs that enable enumeration. Verify sensitive fields (email, phone) are omitted from list endpoints

---

## Native Serialization of Untrusted Data — Critical

**Signs**: Application accepts serialized data from external sources (user input, APIs, message queues, cookies) and deserializes it using language-native serialization. Java: ObjectInputStream reading from network/user input. Python: loading untrusted data with language-native serializers. PHP: unserializing user-controlled strings. .NET: using BinaryFormatter or ObjectStateFormatter on external input. Ruby: Marshal.load on untrusted data. YAML: loading untrusted YAML with full constructor support.

**Impact**: Arbitrary code execution on the server. The attacker crafts a serialized payload that executes code during the deserialization process — before any application logic runs. In Java, this means Remote Code Execution via gadget chains. In Python, arbitrary function calls via reduction protocols. In PHP, magic method execution chains. This is consistently rated as one of the most severe vulnerability classes.

**Fix**: Never deserialize untrusted data using language-native serialization. Use data-only formats for external input: JSON, Protocol Buffers, MessagePack, or FlatBuffers. If native serialization is unavoidable (legacy systems), use allowlist-based type filtering BEFORE deserialization begins. Java: configure ObjectInputFilter (JEP 290). .NET: use SerializationBinder with a strict type allowlist.

**Detection**:
- *Code patterns*: ObjectInputStream, readObject(), readUnshared() on untrusted input; native serialization loading functions used on external data; BinaryFormatter, ObjectStateFormatter in .NET; Marshal.load in Ruby; YAML full-loader on user input
- *Review questions*: Does the application deserialize data from external sources? What serialization format is used? Is there a type allowlist?
- *Test methods*: Identify all deserialization entry points. Test with known gadget chain payloads (ysoserial for Java). Check if type filtering is enforced

---

## Gadget Chain Blindness — Critical

**Signs**: Security review assumes the application code itself must contain the exploit. No audit of third-party libraries for known gadget chain classes. Classpath/dependency tree not reviewed for deserialization-exploitable libraries. Assumption that "we do not use dangerous classes."

**Impact**: Gadget chains exist in common libraries already on the classpath. Apache Commons Collections (InvokerTransformer chain), Spring Framework (MethodInvokeTypeProvider), Jackson (polymorphic type handling with default typing), SnakeYAML (arbitrary constructor invocation). The attacker does not need to find exploitable code in the application — they exploit the libraries the application already depends on.

**Fix**: Audit the classpath for known gadget chain libraries using tools like ysoserial, marshalsec, or GadgetInspector. Remove unnecessary transitive dependencies that introduce gadget classes. Use deserialization filters (Java JEP 290) to restrict allowed types. Keep all libraries updated — gadget chain fixes are frequently released.

**Detection**:
- *Code patterns*: Dependencies including commons-collections < 3.2.2, commons-beanutils, spring-core with deserialization paths, Jackson with default typing enabled
- *Review questions*: Has the classpath been audited for known gadget chain classes? Are deserialization filters (JEP 290) configured? Are there unnecessary transitive dependencies?
- *Test methods*: Run ysoserial or GadgetInspector against the application classpath. Test deserialization endpoints with known gadget chain payloads. Verify type filters catch gadget chain types

---

## Type-Only Deserialization Guards — Major

**Signs**: Deserialization code that checks the type of the resulting object AFTER deserialization completes. Pattern: deserialize the data, then check if the result is an instance of the expected type, rejecting unexpected types. The malicious code has already executed during the deserialization process.

**Impact**: False sense of security. The type check passes or fails, but the damage is already done. In Java, constructors, readObject(), readResolve(), and finalize() methods execute during deserialization. In Python, the __reduce__ method executes during deserialization. In PHP, __wakeup() and __destruct() execute during deserialization. The type check only catches the result — it does not prevent execution during the process.

**Fix**: Use allowlist-based deserialization filters that restrict types BEFORE instantiation. Java: ObjectInputFilter (JEP 290) configured with a strict allowlist. .NET: SerializationBinder that rejects unknown types before they are instantiated. Do not rely on post-deserialization type checking. Prefer data-only formats that do not support type instantiation.

**Detection**:
- *Code patterns*: instanceof/type checks after deserialization calls; try/catch wrapping deserialization that catches ClassCastException; no ObjectInputFilter or SerializationBinder configured
- *Review questions*: Is type filtering performed before or after deserialization? Are deserialization filters (JEP 290, SerializationBinder) configured? Does the type check prevent code execution or only check the result?
- *Test methods*: Send a deserialization payload that executes code but returns an unexpected type. Verify whether the code executed despite the type check failing

---

## Format Confusion — Major

**Signs**: Data formats configured with type annotation features enabled. YAML loaded with full constructor support (ConstructYamlObject). JSON parsed with polymorphic type handling enabled (Jackson DefaultTyping, Fastjson autotype, Newtonsoft TypeNameHandling). XML parsed with typed attributes. These features turn safe data parsers into code execution vectors.

**Impact**: Attacker embeds type annotations in seemingly safe data formats. YAML: using constructor annotations to instantiate arbitrary Python objects. Jackson: using @type or class hints to instantiate arbitrary Java classes when DefaultTyping is enabled. Fastjson: using @type to trigger autoType class loading. .NET Newtonsoft: using $type with TypeNameHandling.Auto or TypeNameHandling.All to instantiate arbitrary .NET types. The parser instantiates the specified class during parsing.

**Fix**: Disable type handling features in data parsers. YAML: use safe_load() or SafeLoader instead of load() or FullLoader. Jackson: never enable DefaultTyping globally; use @JsonTypeInfo on specific fields with a strict allowlist. Fastjson: disable autoType or use a strict safeMode. Newtonsoft: use TypeNameHandling.None (default). For all formats, treat type annotations in untrusted data as a code execution vector.

**Detection**:
- *Code patterns*: YAML load with FullLoader or Loader instead of SafeLoader; Jackson ObjectMapper with enableDefaultTyping(); Fastjson without safeMode; Newtonsoft with TypeNameHandling other than None
- *Review questions*: Does the application parse YAML, JSON, or XML with type annotation support enabled? Are type hints accepted from untrusted input?
- *Test methods*: Send data with type annotations targeting known exploitable classes. Test YAML with constructor annotations. Test JSON with polymorphic type hints

---

## Signed-But-Not-Encrypted Payloads — Major

**Signs**: Serialized data (session cookies, viewstate, JWT claims with complex objects, API tokens) signed for integrity but not encrypted. Signature algorithm and format visible by decoding the payload. Signing keys stored in configuration files, default framework keys, or derived from predictable values.

**Impact**: Attackers can decode signed payloads to study the serialization format, field names, and data types. If signing keys are discovered through key management weakness, side channel, configuration leak, or default keys, attackers craft valid signed malicious payloads. ASP.NET ViewState attacks exploit this: known machine keys allow crafting ViewState payloads that execute code during deserialization. JWT tokens with serialized complex claims can be forged if the secret is compromised.

**Fix**: Encrypt then sign (not sign then encrypt) for sensitive serialized data. Never use default signing keys — generate cryptographically random keys. Rotate keys on a schedule. Monitor for key exposure. Consider using data-only formats (JSON) instead of language-native serialization in signed payloads. For JWT: keep claims simple (strings, numbers) and never embed serialized objects.

**Detection**:
- *Code patterns*: Signed but not encrypted cookies or tokens; framework using default machine keys or signing secrets; JWT claims containing serialized objects; ViewState without encryption
- *Review questions*: Are serialized payloads (cookies, tokens, viewstate) encrypted or only signed? Are signing keys unique and securely managed? Do JWT claims contain complex serialized objects?
- *Test methods*: Decode signed payloads (base64) to check if contents are readable. Check for default or weak signing keys. Attempt to craft payloads with discovered keys

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Native Serialization of Untrusted Data | Critical | A3: Input Validation | Both |
| Gadget Chain Blindness | Critical | A3: Input Validation, A5: Supply Chain | Both |
| Type-Only Deserialization Guards | Major | A3: Input Validation | Implementation |
| Format Confusion | Major | A3: Input Validation | Both |
| Signed-But-Not-Encrypted Payloads | Major | A4: Data Protection | Both |
