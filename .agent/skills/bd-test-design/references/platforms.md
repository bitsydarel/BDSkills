# Platform-Specific Testing Strategies

## Mobile (iOS/Android/Flutter)
- **Scope**: Rotation, background/foreground, memory pressure, network loss.
- **Tools**:
    - *iOS*: XCTest, XCUITest, swift-snapshot-testing
    - *Android*: JUnit, Espresso
    - *Flutter*: flutter_test

## Web (React/Vue/Angular)
- **Scope**: Responsive breakpoints, browser compatibility, A11y.
- **Tools**:
    - *Unit*: Jest, Vitest
    - *Component*: Testing Library
    - *E2E*: Playwright, Cypress

## Backend (API/Services)
- **Scope**: Auth/AuthZ, Rate limits, DB transactions, Idempotency.
- **Tools**:
    - *Python*: pytest
    - *Go*: go test
    - *Contract*: Pact

## AI/ML Models
- **Scope**: Data validation (schema/distribution), Model accuracy, Drift detection.
