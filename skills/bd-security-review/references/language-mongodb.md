# Security Review — MongoDB

## Language security profile

- **Query model**: BSON document-based with MongoDB Query Language (MQL), aggregation pipelines, and server-side JavaScript (`$where`, `$function`, `$accumulator` — deprecated/disabled by default in MongoDB 7.0+). Queries accept JSON-like objects, making operator injection the primary attack vector when user input is deserialized directly into query objects
- **Concurrency model**: WiredTiger storage engine with document-level locking and MVCC. Optimistic concurrency control — concurrent writes to different documents do not block each other
- **Ecosystem risks**: MongoDB drivers exist for all major languages (Node.js, Python, Java, Go, C#). npm ecosystem for Node.js drivers has experienced dependency vulnerabilities. Community-contributed ODMs (Mongoose, Motor, MongoEngine) add their own attack surface. Atlas marketplace add-ons introduce third-party trust
- **Execution contexts**: Web backends (MEAN/MERN stack), microservices, IoT and time-series data, content management systems, real-time analytics, mobile backends (Realm/Atlas Device Sync), geospatial applications (PostGIS equivalent via 2dsphere)

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | NoSQL injection via operator injection ($ne, $gt, $regex, $where) | CWE-943 | A3 |
| 2 | JavaScript injection via $where / $function / $accumulator | CWE-94 | A3 |
| 3 | Authentication bypass via operator injection on login queries | CWE-287 | A1 |
| 4 | Missing or disabled authentication (no --auth flag) | CWE-306 | A1 |
| 5 | Unencrypted client-server connections (TLS not enforced) | CWE-319 | A4 |
| 6 | Excessive role privileges (root/dbOwner for application accounts) | CWE-250 | A2 |
| 7 | Credential exposure in connection strings, logs, and environment variables | CWE-798 | A4 |
| 8 | SSRF via user-controlled MongoDB connection URI | CWE-918 | A3 |
| 9 | Missing audit logging (no auditLog configured) | CWE-778 | O1 |
| 10 | Unvalidated user input in aggregation pipeline stages | CWE-943 | A3 |

## Threat model context

Why each vulnerability matters in MongoDB's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | NoSQL injection via operator injection | MongoDB queries are JSON objects. If user input from HTTP request bodies is deserialized directly into a query (e.g., `req.body` in Express), an attacker can inject MongoDB operators like `{"$ne": null}` or `{"$gt": ""}` to modify query logic. Unlike SQL injection, no special characters are needed — the attack uses valid JSON |
| 2 | JavaScript injection via $where | `$where` evaluates arbitrary JavaScript on the server for every document in the collection. User input in a `$where` string enables code execution, data exfiltration, and denial of service (`while(true){}`). `$function` and `$accumulator` in aggregation pipelines carry the same risk |
| 3 | Authentication bypass via operator injection | Login queries that pass `req.body.username` and `req.body.password` directly into `findOne()` are vulnerable. An attacker sends `{"username": {"$ne": null}, "password": {"$ne": null}}` to match any user document, bypassing authentication entirely |
| 4 | Missing authentication | MongoDB can run without authentication (`--noauth` or no `--auth` flag). Any client that can reach the network port has full read/write access to all databases. Internet-exposed MongoDB instances without auth have been the target of mass ransomware campaigns |
| 5 | Unencrypted connections | Without TLS, MongoDB transmits queries, results, and credentials in plaintext. On shared networks or cloud VPCs without encryption, passive sniffing captures all database traffic including authentication credentials |
| 6 | Excessive role privileges | Application service accounts with `root` or `dbOwner` bypass all access controls. Any application vulnerability (injection, SSRF) that reaches the database has full administrative access — can drop databases, create users, read all collections |
| 7 | Credential exposure | MongoDB connection URIs (`mongodb://user:password@host/db`) frequently appear in application configs, `.env` files, CI/CD logs, error stack traces, and `process.env` dumps. Credentials in connection strings are the most common MongoDB credential leak vector |
| 8 | SSRF via MongoDB URI | Applications that accept user-provided database connection strings (e.g., admin panels, data import tools) and pass them to the MongoDB driver can be tricked into connecting to internal services or exfiltrating data to attacker-controlled servers |
| 9 | Missing audit logging | Without audit logging (Enterprise/Atlas feature), there is no record of who accessed or modified data. Compliance audits fail, security incidents cannot be investigated, and insider threats go undetected. Community edition has no built-in audit logging |
| 10 | Aggregation pipeline injection | Aggregation pipelines accept complex nested objects. User input passed directly into `$match`, `$project`, `$addFields`, or custom `$function` stages can inject operators that modify the pipeline logic, extract unauthorized data, or execute arbitrary JavaScript |

## Secure coding checklist

- [ ] Never pass `req.body`, `req.query`, or `req.params` directly into MongoDB queries — always validate and explicitly extract expected fields
- [ ] Use `express-mongo-sanitize` middleware (or equivalent) to strip `$` and `.` characters from user input before it reaches query construction
- [ ] Wrap user-provided values in `{$eq: userValue}` to prevent operator injection — `{username: {$eq: userInput}}` instead of `{username: userInput}`
- [ ] Use a typed ODM (Mongoose with schema definitions, Prisma, TypeORM) that enforces field types — converts `{"$ne": null}` to a string automatically
- [ ] Set `security.javascriptEnabled: false` in `mongod.conf` to disable `$where`, `$function`, `$accumulator`, and `mapReduce` — eliminates server-side JavaScript injection entirely
- [ ] Enable authentication: set `security.authorization: enabled` in `mongod.conf` — never run MongoDB without `--auth` in any network-accessible environment
- [ ] Use SCRAM-SHA-256 for client authentication (default since MongoDB 4.0) — SCRAM-SHA-1 is deprecated
- [ ] Enforce TLS: set `net.tls.mode: requireTLS` and use `hostssl` equivalent in connection strings (`tls=true&tlsCAFile=...`)
- [ ] Create application-specific roles with minimum required privileges — never use `root`, `dbOwner`, or `readWriteAnyDatabase` for application service accounts
- [ ] Store connection credentials in a secrets manager (Vault, AWS Secrets Manager, K8s Secrets) — never in application code, `.env` files committed to git, or plaintext config
- [ ] Enable CSFLE (Client-Side Field Level Encryption) or Queryable Encryption for PII, financial data, and health records — ensures the database server never sees plaintext
- [ ] Configure audit logging (Enterprise/Atlas): set `auditDestination` and `auditFilter` to log authentication events, DDL operations, and sensitive DML
- [ ] Bind `mongod` to private interfaces only (`net.bindIp`) — never expose port 27017 to the public internet
- [ ] Use x.509 certificates for internal member authentication (replica set / sharded cluster) — more secure than keyfile authentication

## Common misconfigurations

- **Authentication**: `--noauth` or `security.authorization: disabled` (unauthenticated access), SCRAM-SHA-1 instead of SCRAM-SHA-256, keyfile with weak shared secret, keyfile with world-readable permissions
- **Roles & Access Control**: Application service account with `root` or `dbOwner` role, `readWriteAnyDatabase` for single-database applications, no custom roles (using only built-in roles with excessive scope), missing `authenticationRestrictions` for IP-based access control
- **Network & TLS**: `net.tls.mode: disabled` or `allowTLS` instead of `requireTLS`, self-signed certificates without CA validation, MongoDB port 27017 exposed to public internet, `net.bindIp: 0.0.0.0` without firewall rules
- **Encryption**: No encryption at rest (WiredTiger stores data unencrypted by default on Community edition), no CSFLE for sensitive fields, backup files (`mongodump` output) stored unencrypted on network-accessible storage
- **Audit & Logging**: No audit logging configured (Community edition lacks built-in audit), `auditAuthorizationSuccess: false` (only failures logged — misses data access by authorized but compromised accounts), `setParameter.quiet: true` suppressing operational logging

## Security tooling

- **SAST**: Semgrep (MongoDB/NoSQL injection rules), ESLint security plugins (eslint-plugin-security), Mongoose schema validation (type enforcement as injection prevention), SonarQube (NoSQL injection detection)
- **SCA**: npm audit / yarn audit (driver vulnerabilities), Snyk, Dependabot, Socket.dev (supply chain analysis for MongoDB driver dependencies)
- **DAST**: NoSQLMap (automated NoSQL injection testing), Burp Suite (with MongoDB-aware extensions), OWASP ZAP (request fuzzing with MongoDB operator payloads), mongosh manual testing
- **Runtime**: MongoDB audit log (Enterprise/Atlas — structured JSON audit events), `db.adminCommand({getLog: "global"})` (Community — basic operational logging), CSFLE / Queryable Encryption (field-level encryption at rest and in transit), `db.currentOp()` (detect suspicious long-running operations), MongoDB Atlas alerts (authentication failures, unusual access patterns)

## Code examples

### Vulnerable: NoSQL operator injection

```javascript
// VULNERABLE: req.body passed directly into MongoDB query
app.post('/login', async (req, res) => {
  const user = await db.collection('users').findOne({
    username: req.body.username,
    password: req.body.password
  });
  if (user) return res.json({ token: generateToken(user) });
  res.status(401).json({ error: 'Invalid credentials' });
});
// Attacker sends: {"username": {"$ne": null}, "password": {"$ne": null}}
// Query becomes: findOne({username: {$ne: null}, password: {$ne: null}})
// Returns the first user document — authentication bypassed
```

### Secure: Input validation with $eq and sanitization

```javascript
// SECURE: Explicit field extraction + $eq wrapping + sanitization
const mongoSanitize = require('express-mongo-sanitize');
app.use(mongoSanitize()); // Strips $ and . from req.body/query/params

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  if (typeof username !== 'string' || typeof password !== 'string') {
    return res.status(400).json({ error: 'Invalid input' });
  }
  const hashedPassword = await bcrypt.hash(password); // Never store plaintext
  const user = await db.collection('users').findOne({
    username: { $eq: username },  // $eq prevents operator injection
    password: { $eq: hashedPassword }
  });
  // ...
});
```

### Vulnerable: JavaScript injection via $where

```javascript
// VULNERABLE: User input in $where JavaScript string
app.get('/search', async (req, res) => {
  const results = await db.collection('products').find({
    $where: `this.name.includes('${req.query.q}')`
  }).toArray();
  res.json(results);
});
// Attacker sends: q='); return true; //
// $where becomes: this.name.includes(''); return true; //')
// Returns ALL documents in the collection
// Attacker sends: q='); while(true){}; //
// Causes infinite loop — denial of service on the MongoDB server
```

### Secure: Aggregation with $expr instead of $where

```javascript
// SECURE: Use $regex or $text instead of $where — no JS execution
app.get('/search', async (req, res) => {
  const query = String(req.query.q || '').slice(0, 100); // Type + length limit
  const results = await db.collection('products').find({
    name: { $regex: escapeRegex(query), $options: 'i' }
  }).limit(50).toArray();
  res.json(results);
});

function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // Escape regex specials
}
// Also: set security.javascriptEnabled: false in mongod.conf
// to disable $where, $function, $accumulator entirely
```

### Vulnerable: Credential exposure in connection string

```javascript
// VULNERABLE: Credentials hardcoded in source code
const { MongoClient } = require('mongodb');
const client = new MongoClient(
  'mongodb://admin:SuperSecret123@prod-db.example.com:27017/myapp?authSource=admin'
);
// Credentials in: source control, error stack traces, process.env dumps,
// CI/CD logs, container image layers, npm package if published
```

### Secure: Credentials from secrets manager

```javascript
// SECURE: Credentials loaded from secrets manager at runtime
const { MongoClient } = require('mongodb');
const { SecretsManager } = require('@aws-sdk/client-secrets-manager');

async function getMongoClient() {
  const sm = new SecretsManager({ region: 'us-east-1' });
  const secret = await sm.getSecretValue({ SecretId: 'prod/mongodb' });
  const { username, password, host, database } = JSON.parse(secret.SecretString);
  const uri = `mongodb://${encodeURIComponent(username)}:${encodeURIComponent(password)}@${host}/${database}?authSource=admin&tls=true`;
  return new MongoClient(uri);
}
// Credentials never in source code, rotatable without deployment,
// audit trail via AWS CloudTrail
```

### Vulnerable: Unvalidated input in aggregation pipeline

```javascript
// VULNERABLE: User input used directly in aggregation $match
app.get('/reports', async (req, res) => {
  const pipeline = [
    { $match: req.query.filter ? JSON.parse(req.query.filter) : {} },
    { $group: { _id: '$category', total: { $sum: '$amount' } } }
  ];
  const results = await db.collection('transactions').aggregate(pipeline).toArray();
  res.json(results);
});
// Attacker sends: filter={"amount":{"$gt":0},"$where":"sleep(5000)"}
// Injects $where into the match stage — server-side JS execution
// Attacker sends: filter={"tenant_id":{"$ne":"attacker_tenant"}}
// Bypasses tenant isolation — reads all tenants' data
```

### Secure: Schema-validated aggregation input

```javascript
// SECURE: Validate and whitelist aggregation filter fields
const Joi = require('joi');

const filterSchema = Joi.object({
  category: Joi.string().max(50).optional(),
  minAmount: Joi.number().min(0).optional(),
  maxAmount: Joi.number().min(0).optional(),
}).unknown(false); // Reject any fields not in schema

app.get('/reports', async (req, res) => {
  const { error, value } = filterSchema.validate(req.query);
  if (error) return res.status(400).json({ error: error.message });

  const match = { tenant_id: req.user.tenantId }; // Always enforce tenant
  if (value.category) match.category = { $eq: value.category };
  if (value.minAmount != null) match.amount = { ...match.amount, $gte: value.minAmount };
  if (value.maxAmount != null) match.amount = { ...match.amount, $lte: value.maxAmount };

  const pipeline = [
    { $match: match },
    { $group: { _id: '$category', total: { $sum: '$amount' } } }
  ];
  const results = await db.collection('transactions').aggregate(pipeline).toArray();
  res.json(results);
});
// User input never enters query objects directly — only validated scalars
// Tenant isolation enforced server-side, not from client input
```
