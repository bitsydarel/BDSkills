# Debugging & Investigation Guide

## Root Cause Analysis (RCA)

### The 5 Whys
Keep asking "why" (typically 5 levels) until the root cause is found.
* *Example*: Server crashed -> Memory exhausted -> Leak in image processing -> Images not released -> Missing cleanup code.

### Debugging Steps
1.  **Reproduce**: Reliably trigger the issue.
2.  **Isolate**: Create a minimal reproduction case.
3.  **Hypothesize**: Formulate a theory for the cause.
4.  **Test**: Validate or eliminate the hypothesis.
5.  **Fix**: Address the root cause.
6.  **Verify**: Confirm fix and check for regressions.

---

## Performance Investigation

1.  **Measure**: Profile to establish a baseline. **Do not guess.**
2.  **Identify**: Pinpoint the specific bottleneck (CPU, Memory, I/O).
3.  **Analyze**: Determine *why* it is a bottleneck (e.g., N+1 query, loop complexity).
4.  **Optimize**: Fix the specific issue.
5.  **Verify**: Measure improvement against baseline.

### Common Issues
* **N+1 Queries**: Check DB query counts per request.
* **Memory Leaks**: Monitor allocation over time.
* **Blocking I/O**: Look for synchronous network/disk calls.
* **Missing Indexes**: Analyze query execution plans.

---

## Platform-Specific Tools

### Mobile (iOS/Android)
* **UI**: Layout Inspector, View Hierarchy Debugger.
* **Memory**: Xcode Instruments, Android Memory Profiler.
* **Network**: Charles Proxy, Network Inspector.

### Web (Frontend)
* **Rendering**: React/Vue DevTools, DOM Inspector.
* **Network**: Browser Network Tab.
* **Performance**: Lighthouse, Web Vitals.

### Backend (API/Services)
* **Flow**: Distributed Tracing (Jaeger, Zipkin).
* **Logs**: Structured logging, Aggregation.
* **Errors**: Sentry, Bugsnag.
