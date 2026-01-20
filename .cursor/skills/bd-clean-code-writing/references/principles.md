# SOLID Principles & Design Patterns

## Application Guidelines

### Single Responsibility (SRP)
* **Rule**: Group by reason for change, not technical layer.
* **Refactor**:
    * *Before*: `UserManager` handles validation, persistence, and formatting.
    * *After*: `UserValidator`, `UserRepository`, `UserFormatter`.

### Open/Closed (OCP)
* **Rule**: Use composition/DI over inheritance. Design extension points.
* **Refactor**:
    * *Before*: `if type == "stripe"` checks.
    * *After*: `PaymentGateway` interface with `StripeGateway` implementation.

### Liskov Substitution (LSP)
* **Rule**: Subtypes must honor base contracts. Do not override methods to throw exceptions.
* **Refactor**:
    * *Violation*: `Square` extends `Rectangle` (breaks setWidth).
    * *Correction*: Both implement `Shape` independently.

### Interface Segregation (ISP)
* **Rule**: Split interfaces by client needs.
* **Refactor**:
    * *Before*: Giant `Printer` interface.
    * *After*: `Printable`, `Scannable`, `Faxable`.

### Dependency Inversion (DIP)
* **Rule**: High-level modules must not depend on low-level modules. Inject dependencies.
* **Refactor**:
    * *Before*: `OrderService` news up `StripeClient`.
    * *After*: `OrderService` takes `PaymentGateway` in constructor.