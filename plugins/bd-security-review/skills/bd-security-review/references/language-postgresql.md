# Security Review — PostgreSQL

## Language security profile

- **Query model**: SQL-based with support for dynamic SQL in PL/pgSQL functions, prepared statements, and parameterized queries via client libraries. Dynamic SQL is the primary injection vector
- **Concurrency model**: MVCC (Multi-Version Concurrency Control) — readers never block writers and vice versa. Isolation level choice affects visibility of concurrent modifications and serialization failure behavior
- **Ecosystem risks**: Extension ecosystem includes trusted and untrusted languages. Untrusted procedural languages (`plpythonu`, `plperlu`) execute arbitrary code with OS-level access. Extensions install from source or PGXN without cryptographic verification by default
- **Execution contexts**: OLTP backends, analytics/data warehousing, embedded databases, microservice data stores, multi-tenant SaaS platforms, geospatial (PostGIS), full-text search

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | SQL injection via dynamic SQL in PL/pgSQL or application code | CWE-89 | A3 |
| 2 | Privilege escalation via SECURITY DEFINER functions | CWE-269 | A2 |
| 3 | `trust` authentication in pg_hba.conf | CWE-306 | A1 |
| 4 | Unencrypted client-server connections | CWE-319 | A4 |
| 5 | Row-Level Security (RLS) bypass via superuser or table owner | CWE-863 | A2 |
| 6 | Untrusted extension execution (plpythonu, plperlu) | CWE-94 | A6 |
| 7 | Excessive superuser role grants | CWE-250 | A2 |
| 8 | Missing or insufficient audit logging | CWE-778 | O1 |
| 9 | Unencrypted backups with sensitive data | CWE-312 | A4 |
| 10 | Credential exposure in connection strings and logs | CWE-798 | A4 |

## Threat model context

Why each vulnerability matters in PostgreSQL's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | SQL injection via dynamic SQL | PL/pgSQL's `EXECUTE` with string concatenation creates injection paths inside the database itself. Even if the application uses parameterized queries, a vulnerable function called by the application re-introduces injection at the database layer |
| 2 | Privilege escalation via SECURITY DEFINER | Functions marked `SECURITY DEFINER` run with the privileges of the function owner (often a superuser). A non-privileged user calling such a function can perform actions far beyond their granted permissions, including reading other users' data or modifying schema |
| 3 | `trust` authentication | `trust` in pg_hba.conf allows any connection from the matching host without a password. A single `trust` entry for `0.0.0.0/0` grants unauthenticated access to the entire database from any network address |
| 4 | Unencrypted connections | PostgreSQL transmits queries and results in plaintext by default. On shared networks, an attacker can capture credentials, query results, and sensitive data with passive network sniffing |
| 5 | RLS bypass | Row-Level Security policies do not apply to table owners or superusers. If the application connects as the table owner, RLS provides zero protection — it is only effective when application users connect with restricted roles |
| 6 | Untrusted extension execution | Untrusted procedural languages (`plpythonu`, `plperlu`, `plsh`) can execute arbitrary operating system commands. A function written in `plpythonu` has full access to the file system, network, and processes of the PostgreSQL server host |
| 7 | Excessive superuser roles | Superuser bypasses all permission checks, RLS, and security barriers. Granting superuser to application service accounts means any SQL injection or application compromise grants full database and OS-level access |
| 8 | Missing audit logging | Without `pgaudit` or equivalent, there is no record of who accessed or modified data. Security incidents cannot be investigated, compliance audits fail, and insider threats go undetected |
| 9 | Unencrypted backups | `pg_dump` and `pg_basebackup` produce unencrypted output by default. Backups stored on S3, shared storage, or transferred over networks expose all database contents including credentials stored in tables |
| 10 | Credential exposure | Connection strings containing passwords appear in application configs, environment variables, process listings (`ps aux`), and PostgreSQL logs (`log_connections = on` logs usernames). `log_statement = 'all'` can log passwords in `ALTER ROLE` statements |

## Secure coding checklist

- [ ] Use parameterized queries (`$1`, `$2`) in all application code — never concatenate user input into SQL strings
- [ ] In PL/pgSQL, use `EXECUTE ... USING` with parameter placeholders — never `EXECUTE 'SELECT ' || user_input`
- [ ] Use `format()` with `%I` (identifiers) and `%L` (literals) when dynamic SQL requires non-parameterizable elements (table/column names)
- [ ] Set `pg_hba.conf` to `scram-sha-256` for all entries — never `trust` or `md5`
- [ ] Require TLS: set `ssl = on` in `postgresql.conf`, use `hostssl` entries in `pg_hba.conf`, connect with `sslmode=verify-full`
- [ ] Use `SECURITY INVOKER` (default) for functions unless `SECURITY DEFINER` is explicitly required — and always set `search_path = ''` on SECURITY DEFINER functions
- [ ] Enable Row-Level Security with `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` and `FORCE ROW LEVEL SECURITY` — ensure the application connects with restricted roles, not the table owner
- [ ] Install and configure `pgaudit` for DDL and DML audit logging in production
- [ ] Grant minimum privileges: use `GRANT SELECT` / `GRANT INSERT` on specific tables — never grant `ALL PRIVILEGES` or `SUPERUSER` to application roles
- [ ] Create separate database roles for application read, application write, migration, and admin operations
- [ ] Encrypt backups: use pgBackRest with encryption enabled, or encrypt `pg_dump` output before storage
- [ ] Store connection credentials in a secrets manager (Vault, AWS Secrets Manager, K8s Secrets) — never in application code or plaintext config files
- [ ] Set `log_statement = 'ddl'` at minimum and `log_min_duration_statement` to an appropriate threshold — avoid `log_statement = 'all'` in environments where sensitive data appears in queries
- [ ] Restrict `CREATE EXTENSION` to superusers and audit all installed extensions with `SELECT * FROM pg_available_extensions WHERE installed_version IS NOT NULL`

## Common misconfigurations

**pg_hba.conf**:
- `trust` authentication for any entry (unauthenticated access)
- `host all all 0.0.0.0/0 md5` (MD5 is deprecated — use `scram-sha-256`)
- Missing `hostssl` enforcement (allows plaintext connections)
- Overly broad CIDR ranges in host entries (e.g., `/0` instead of specific subnets)

**Roles & Privileges**:
- Application service account with `SUPERUSER` or `CREATEDB` privilege
- `GRANT ALL ON ALL TABLES` to the application role
- `SECURITY DEFINER` functions without `search_path = ''` (search path injection)
- `ALTER DEFAULT PRIVILEGES` granting excessive permissions to `PUBLIC` role
- RLS enabled but application connecting as table owner (bypasses all policies)

**Extensions**:
- Untrusted languages installed (`plpythonu`, `plperlu`) without operational justification
- Extensions installed from unverified sources without code review
- `dblink` or `postgres_fdw` configured with hardcoded credentials in foreign server definitions

**Backup & Recovery**:
- Unencrypted backups stored on network-accessible storage (S3 public buckets, NFS shares)
- No backup restore testing — backup integrity unknown
- WAL archiving to unencrypted destinations

**Network & TLS**:
- `ssl = off` in `postgresql.conf` (plaintext connections accepted)
- Self-signed certificates without CA validation (`sslmode=require` without `verify-full`)
- PostgreSQL port (5432) exposed to the public internet without firewall rules
- `listen_addresses = '*'` without corresponding `pg_hba.conf` restrictions

## Security tooling

- **SAST**: pganalyze (query analysis and anomaly detection), Semgrep (custom PG rules for SQL injection in PL/pgSQL), sqlfluff (SQL linting with security rules)
- **SCA**: `pg_available_extensions` audit (list all installed extensions and versions), extension CVE tracking via PostgreSQL security mailing list
- **DAST**: sqlmap (PostgreSQL-specific injection testing), pgTAP (database unit testing including security assertions)
- **Runtime**: pgaudit (structured audit logging), pgcrypto (column-level encryption), pg_stat_ssl (monitor TLS connection status), pg_stat_activity (detect suspicious sessions), pgsodium (libsodium-based encryption)

## Code examples

### Vulnerable: SQL injection via dynamic SQL in PL/pgSQL

```sql
-- VULNERABLE: String concatenation in EXECUTE
CREATE FUNCTION get_user_data(username TEXT) RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY EXECUTE 'SELECT * FROM users WHERE name = ''' || username || '''';
END;
$$ LANGUAGE plpgsql;
-- Attacker sends: ' OR '1'='1' --
-- Resulting query: SELECT * FROM users WHERE name = '' OR '1'='1' --'
```

### Secure: Parameterized dynamic SQL

```sql
-- SECURE: EXECUTE ... USING with parameter placeholder
CREATE FUNCTION get_user_data(username TEXT) RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY EXECUTE 'SELECT * FROM users WHERE name = $1' USING username;
END;
$$ LANGUAGE plpgsql;
-- $1 is bound as a parameter — injection is impossible
```

### Vulnerable: SECURITY DEFINER without search_path

```sql
-- VULNERABLE: SECURITY DEFINER with unset search_path
CREATE FUNCTION admin_get_all_users() RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY SELECT * FROM users;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- Attacker creates a schema with a malicious 'users' table/function
-- and manipulates search_path to hijack the query
```

### Secure: SECURITY DEFINER with restricted search_path

```sql
-- SECURE: Explicit search_path prevents schema injection
CREATE FUNCTION admin_get_all_users() RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY SELECT * FROM public.users;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';
-- Empty search_path forces fully qualified names
-- Function runs with definer privileges but cannot be hijacked via search_path
```

### Vulnerable: RLS enabled but bypassed by table owner

```sql
-- VULNERABLE: RLS policy exists but application connects as table owner
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
    USING (tenant_id = current_setting('app.tenant_id')::int);
-- If the application connects as the table owner, this policy is NEVER enforced
```

### Secure: RLS with FORCE and restricted application role

```sql
-- SECURE: FORCE RLS + application uses a non-owner role
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;  -- Applies to table owner too
CREATE POLICY tenant_isolation ON orders
    USING (tenant_id = current_setting('app.tenant_id')::int);

-- Application connects as 'app_reader' role (not the table owner)
GRANT SELECT ON orders TO app_reader;
-- RLS is enforced for all roles including the owner due to FORCE
```
