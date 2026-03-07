# Security Review — Distributed Systems

## Domain context

Distributed systems (microservices, service mesh, message queues, event-driven architectures) multiply security complexity through their number of inter-service communication paths, independent deployment units, and eventual consistency models. Each microservice is a potential attack surface. The network between services is hostile — lateral movement is the primary post-compromise strategy. Service-to-service authentication, distributed authorization, and observability across hundreds of services are the core challenges. There is no single OWASP list for this domain; security guidance comes from microservices security patterns, service mesh security, and distributed systems security research.

## Framework mapping

| Framework/Standard | Relevance | Mapped Criteria |
|-------------------|-----------|----------------|
| NIST SP 800-204 (Microservices Security) | Primary reference | T3, A1, A2, O1 |
| NIST SP 800-204A (Service Mesh) | Service mesh hardening | T3, A4, O3 |
| Zero Trust Architecture (NIST SP 800-207) | Inter-service trust model | T3, A1, A2 |
| OWASP API Security Top 10 | Each service exposes APIs | A1-A3 |
| CIS Kubernetes Benchmarks | Common orchestrator | O3 |

## Criterion interpretation for distributed systems

| Criterion | Distributed Systems-Specific Interpretation |
|-----------|---------------------------------------------|
| T1 | Map all services, their APIs, message queues, event buses, gRPC endpoints, health checks, admin ports. Internal services are attack surface |
| T2 | STRIDE per inter-service call: can Service A spoof requests to Service B? Can messages be tampered with in the queue? Can a compromised service escalate? |
| T3 | Every service boundary is a trust boundary. Service mesh enforces mTLS. API gateway is the external trust boundary. Message queues are trust crossings |
| T4 | Compromised single service as threat model. Lateral movement via east-west traffic. Insider with access to service mesh control plane |
| A1 | Service-to-service authentication: mTLS via service mesh, JWT token propagation, SPIFFE/SPIRE identity. No shared secrets between services |
| A2 | Distributed authorization: OPA/Cedar per service, token-based authz propagation, scope-limited service accounts. No God service with admin access to all |
| A3 | Input validation at every service boundary — do not trust internal services. Schema validation for messages. Deserialization safety for queue payloads |
| A4 | mTLS for all inter-service communication. Encryption for message queue payloads. No plaintext internal traffic. Certificate rotation automation |
| A5 | Per-service dependency management. Shared library version coordination. Service version compatibility matrix. Breaking change detection |
| A6 | Circuit breakers, retry budgets, timeouts per service call. Bulkhead isolation. Backpressure on message queues. Resource limits per service |
| A7 | Cascading failure protection: one service failure should not bring down others. Health check endpoints should not leak internal state |
| O1 | Distributed tracing (OpenTelemetry) with security event correlation. Request ID propagation across services. Centralized log aggregation |
| O2 | Service mesh observability for anomaly detection. Unusual inter-service traffic patterns. Request rate anomalies. Error rate spikes |
| O3 | Service mesh hardening (Istio, Linkerd security config). Network policies per service. Sidecar proxy security. Control plane access restriction |
| O4 | Graceful degradation per service. Saga pattern for distributed transaction rollback. Event replay for recovery. Multi-region failover |
| G4 | Distributed audit trail reconstruction across services. Correlation IDs for end-to-end request tracing. Event sourcing for accountability |

## Top 5 distributed systems-specific anti-patterns

### 1. Implicit Trust Between Services

**Signs**: Services call each other over plaintext HTTP. No service-to-service authentication — any pod that can reach a service can call it. Shared database accessed by multiple services without access control. "It is internal, so it is trusted."

**Impact**: A single compromised service has unlimited lateral movement. Attacker moves from low-value to high-value services freely. Data theft from any service that shares a database.

**Fix**: Zero trust between services: mTLS for all communication (service mesh), per-service identity (SPIFFE/SPIRE), authorization on every call. No shared databases — each service owns its data.

---

### 2. Cascading Failure Amplification

**Signs**: No circuit breakers between services. Retry logic without exponential backoff or jitter. No timeout on downstream calls. Health checks that include downstream dependency checks (cascade-down health). No bulkhead isolation.

**Impact**: One slow or failing service causes timeout accumulation across the call chain. Thread pool exhaustion propagates. The entire system becomes unavailable from a single point of failure. This is both an availability and security issue (DoS from internal failure).

**Fix**: Circuit breakers with configurable thresholds. Exponential backoff with jitter for retries. Timeouts on every downstream call. Bulkhead isolation (separate thread pools per dependency). Health checks should only report local health.

---

### 3. Secret Fan-Out

**Signs**: Each service independently manages its secrets. Multiple services share the same database credentials. Secrets passed between services in request headers or message payloads. No centralized secrets management.

**Impact**: Secrets replicated across N services mean N potential exposure points. Rotation requires coordinating across all services simultaneously. Compromised service reveals secrets for other services.

**Fix**: Centralized secrets management (Vault) with per-service, per-environment credentials. Secrets injected at runtime, not passed between services. Automated rotation. Service mesh handles mTLS credentials.

---

### 4. Distributed Authorization Bypass

**Signs**: Authorization checked only at the API gateway, not within individual services. Internal services assume requests are pre-authorized. Token not propagated or validated at each hop. Different services have different authorization models.

**Impact**: Compromised or malicious internal service bypasses all authorization checks. Gateway bypass (internal network access) skips all security. Confused deputy attacks between services.

**Fix**: Authorization at every service boundary. Propagate user context (JWT claims, SPIFFE ID) across the call chain. Each service independently validates authorization. Use OPA or Cedar for consistent policy evaluation.

---

### 5. Observability Gaps

**Signs**: Logs from each service are isolated. No distributed tracing. No correlation IDs. Error investigation requires accessing each service individually. Security events in one service not correlated with events in another.

**Impact**: Attack detection is impossible when visibility is per-service. Lateral movement goes undetected because no single system sees the full attack path. Incident response is slow when investigators must reconstruct the request path manually.

**Fix**: Implement distributed tracing (OpenTelemetry) with correlation ID propagation. Centralized log aggregation (ELK, Datadog). Security event correlation across services. Service mesh telemetry for inter-service traffic analysis.

---

## Key controls checklist

- [ ] mTLS for all inter-service communication (service mesh)
- [ ] Per-service identity with SPIFFE/SPIRE or equivalent
- [ ] Authorization checks at every service boundary, not just gateway
- [ ] Circuit breakers, timeouts, and retry budgets on all downstream calls
- [ ] Distributed tracing with correlation ID propagation
- [ ] Centralized log aggregation with security event correlation
- [ ] Network policies restricting which services can communicate
- [ ] Per-service secrets management — no shared credentials
- [ ] Schema validation for all inter-service messages and events
- [ ] Graceful degradation — service failure should not cascade
- [ ] Service mesh control plane access restricted and audited
- [ ] Each service owns its data — no shared databases

## Company practices

- **Google**: gRPC with per-call authentication, Application Layer Transport Security (ALTS), BeyondCorp for service-to-service trust
- **Netflix**: Zuul gateway with security filters, Eureka for service discovery, Hystrix circuit breakers (now Resilience4j), chaos engineering for resilience
- **Spotify**: Envoy-based service mesh, centralized auth service with token propagation, automated canary deployments with security checks
- **Microsoft**: Dapr for distributed application security, Azure Service Fabric with mTLS, Azure Event Grid with RBAC per topic

## Tools and standards

- **Service Mesh**: Istio, Linkerd, Consul Connect (mTLS, policy enforcement, observability)
- **Policy**: OPA (Open Policy Agent), Cedar (Amazon), Styra DAS
- **Identity**: SPIFFE/SPIRE (service identity), cert-manager (certificate lifecycle)
- **Observability**: OpenTelemetry, Jaeger, Grafana Tempo, Datadog APM
- **Standards**: NIST SP 800-204/204A/204B, Zero Trust Architecture (NIST SP 800-207)
