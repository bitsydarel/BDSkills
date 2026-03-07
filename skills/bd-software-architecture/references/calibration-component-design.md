# Calibration: Component Design (Lens 2)

Weak/adequate/strong examples for criteria C1-C5. Use when uncertain about a score boundary. For full scoring criteria, see [evaluation-component-design.md](evaluation-component-design.md).

---

## C1: Single Responsibility & Cohesion

### Weak (Score 1-2)

```python
class UserManager:
    def get_user(self, id): ...          # Data access
    def validate_email(self, email): ... # Business validation
    def format_name(self, user): ...     # Display formatting
    def send_welcome_email(self, user): ... # Side effect / notification
    def calculate_subscription_price(self, user): ... # Pricing logic
    def export_to_csv(self, users): ...  # Reporting
```

**Why weak**: Six unrelated responsibilities. Changes to email formatting, pricing logic, or CSV export all modify this one class. Name "Manager" hides the lack of focus.

### Adequate (Score 3)

```python
class UserRepository:
    def get_user(self, id): ...
    def save_user(self, user): ...
    def find_by_email(self, email): ...
    def validate_unique_email(self, email): ...  # Business rule leaked into repository
```

**Why adequate**: Mostly focused on data access, but `validate_unique_email` is a business rule that belongs in a use case. The repository has a primary responsibility but has accumulated one secondary concern.

### Strong (Score 4-5)

```python
class UserRepository:
    def get(self, id: UserId) -> User: ...
    def save(self, user: User) -> None: ...
    def find_by_email(self, email: str) -> Optional[User]: ...

class RegisterUserUseCase:
    def execute(self, email: str, name: str) -> User:
        existing = self.user_repo.find_by_email(email)
        if existing:
            raise EmailAlreadyExistsException()
        user = User.create(email, name)
        self.user_repo.save(user)
        self.notification_service.send_welcome(user)
        return user
```

**Why strong**: Repository does data access only. Business rules (uniqueness check) in use case. Notifications delegated to a service. Each component changeable for one reason.

---

## C2: Repository vs Service Clarity

### Weak (Score 1-2)

```
DataManager        — Does it manage data? Perform actions? Both?
AppService         — Which app capability? Everything?
UserHelper         — Helps with what exactly?
NotificationUtils  — Utility functions? A service? A repository?
```

### Strong (Score 4-5)

```
UserRepository          — Data: CRUD, caching, query aggregation for users
PaymentService          — Capability: processes payments via Stripe
NotificationService     — Capability: sends push/email/SMS notifications
OrderRepository         — Data: CRUD, caching for orders
AuthenticationService   — Capability: manages auth flows, token generation
```

**Boundary**: Score 3 has mostly clear names but 1-2 "Manager" or "Helper" classes that straddle the line. Score 4 has consistent naming with clear data vs capability distinction.

---

## C3: Use Case Design & Composition

### Weak (Score 1-2)

```python
class FormatCurrencyUseCase:    # Not a business intention — formatting
    def execute(self, amount): return f"${amount:.2f}"

class ValidateEmailUseCase:     # Not a standalone intention — validation utility
    def execute(self, email): return '@' in email

class ProcessOrderUseCase(BaseOrderUseCase):  # Shared base class with implementation
    def execute(self, order):
        self._validate(order)     # Inherited from base — shared implementation detail
        self._calculate_total(order)  # Inherited
        self._save(order)         # Inherited
```

### Strong (Score 4-5)

```python
class PlaceOrderUseCase:  # Clear business intention
    def __init__(self, order_repo, payment_service, ensure_authenticated):
        self.order_repo = order_repo
        self.payment_service = payment_service
        self.ensure_auth = ensure_authenticated  # Composed use case — standalone intention

    def execute(self, user_id, items):
        self.ensure_auth.execute(user_id)  # Composition: independently meaningful
        order = Order.create(user_id, items)
        self.payment_service.charge(order.total)
        self.order_repo.save(order)
        return order
```

---

## C4: Public API & Encapsulation

### Weak (Score 1-2)

```python
# Other features import internal paths freely
from features.user.data_sources.impl.postgres_user_db import PostgresUserDB
from features.user.repositories.user_repository_impl import UserRepositoryImpl
from features.user.use_cases.internal_validate import InternalValidateHelper
```

### Strong (Score 4-5)

```python
# features/user/__init__.py (barrel file — public API)
from .domain.user import User
from .domain.exceptions import UserNotFoundException
from .di import register_user_feature

# All other files are internal — not importable by other features
# Lint rule: "imports from features/user/ must resolve to features/user/__init__.py"
```

---

## C5: Domain Model Purity

### Weak (Score 1-2)

```python
from django.db import models
from rest_framework import serializers

class User(models.Model):           # ORM base class
    email = models.EmailField()
    name = models.CharField(max_length=100)

    def to_json(self):               # Serialization in domain
        return serializers.UserSerializer(self).data
```

### Strong (Score 4-5)

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    id: UserId
    email: str
    name: str

    def change_email(self, new_email: str) -> 'User':
        if not self._is_valid_email(new_email):
            raise InvalidEmailException(new_email)
        return User(id=self.id, email=new_email, name=self.name)
```

**Boundary**: Score 3 has domain models that are mostly pure but carry 1-2 framework annotations (e.g., `@JsonSerializable` in Dart). The model logic itself is pure but there is a compile-time dependency on the framework. Score 4-5 has zero framework presence.
