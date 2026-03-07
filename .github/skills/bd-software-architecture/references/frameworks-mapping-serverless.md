# Architecture Style Mapping: Serverless / FaaS

Maps evaluation criteria to serverless equivalents (AWS Lambda, Azure Functions, Google Cloud Functions, Vercel). Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D4, D5, S1-S4, B2, B4, Q2-Q4) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally. The handler IS the framework in serverless. Business logic must be separable from the cloud runtime just as it must be separable from any framework.

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule + SRP**: Handler → Business Logic → Infrastructure Calls. The handler parses the cloud-specific event (SRP: one responsibility), invokes business logic with plain data, and formats the cloud-specific response. Business logic must not know it runs on Lambda (Dependency Rule: business logic does not depend on infrastructure).

**Violation**: Business logic references `event['Records'][0]['s3']['bucket']['name']` — cloud event structure leaks into domain (Dependency Rule violation). A single function parses events, applies rules, and calls SDKs (SRP violation).

## D2: Abstraction at Boundaries

**DIP**: Wrapper modules/functions around SDK clients (DynamoDB, S3, SQS) ARE the abstraction. They allow substitution for testing. Environment-variable-driven configuration replaces DI container bindings. The principle is the same: depend on abstractions, not concretions.

**Violation**: Business logic calls `boto3.client('dynamodb').put_item()` directly. Changing from DynamoDB to PostgreSQL requires rewriting business logic (DIP violation).

## D3: Framework Independence

**Independence**: Can business logic run without the Lambda/Azure/GCF runtime? The handler IS the framework adapter. Business logic should be importable and callable as plain functions with zero cloud runtime imports.

- **Score 5**: Business logic in separate modules with zero runtime imports. Handler is a thin adapter.
- **Score 3**: Business logic mostly separate but references cloud event structures or SDK types.
- **Score 1**: Business logic embedded in handler — event parsing, rules, and SDK calls interleaved.

## C1: Single Responsibility & Cohesion

**SRP**: One function = one business operation. Each function handles one event type and performs one action. A function that changes when business rules change AND when event format changes has two reasons to change.

**Violation**: "God Lambda" that routes internally via if/switch on event type. Multiple unrelated operations behind one function (SRP violation).

## B1: Data Flow Traceability

**Separation of Concerns**: Event → Handler (parse) → Business Logic (decide) → Side Effects (persist/publish). Each step distinct and traceable. Event-driven chains (Lambda → SQS → Lambda) documented and followable.

**Violation**: Functions that perform side effects mid-logic. No separation between "understand the event," "apply the rule," and "persist the result" (Separation of Concerns violation).

## B3: Error Translation & Propagation

**Separation of Concerns + DIP**: SDK errors (AWS exceptions, timeout errors, throttling) caught and translated at the handler/wrapper boundary into domain-meaningful results. Dead letter queues for unprocessable events. Business logic raises domain errors, never catches `ClientError`.

**Violation**: Business logic catches `botocore.exceptions.ClientError` and makes decisions based on AWS-specific error codes (DIP violation — domain depends on infrastructure details).

## Q1: Testability

**Consequence of all three principles + DIP**: Business logic tested as plain functions with plain inputs/outputs. Handler tested with synthetic events. SDK wrappers mocked at the module boundary. The decoupling mechanism is module-level separation.

- **Score 5**: Business logic tested with pure unit tests — no cloud emulators needed. Handler tested with synthetic event fixtures. SDK calls mocked at wrapper boundaries.
- **Score 3**: Tests use local emulators (LocalStack, SAM local). Business logic partially testable without emulators.
- **Score 1**: Can only test by deploying to the cloud. Business logic inseparable from runtime.
