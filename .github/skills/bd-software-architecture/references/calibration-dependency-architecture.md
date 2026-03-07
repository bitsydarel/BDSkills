# Calibration: Dependency Architecture (Lens 1)

Weak/adequate/strong examples for criteria D1-D5. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-dependency-architecture.md](evaluation-dependency-architecture.md).

---

## D1: Layer Separation & Dependency Direction

### Weak (Score 1-2)

```python
# use_case/login.py — directly imports data source implementation
from data_sources.impl.postgres_user_db import PostgresUserDB

class LoginUseCase:
    def execute(self, email, password):
        db = PostgresUserDB()  # Direct instantiation of implementation
        user_row = db.query("SELECT * FROM users WHERE email = %s", email)
        if user_row and check_password(password, user_row['hash']):
            return user_row  # Returns raw DB row, not domain model
```

**Why weak**: Use case depends directly on a data source implementation (Postgres-specific). Creates, instantiates, and returns infrastructure types. Reverse dependency — inner layer knows about outer layer.

### Adequate (Score 3)

```python
# use_case/login.py — uses interface but has minor leaks
from repositories.user_repository import UserRepository  # Contract

class LoginUseCase:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    def execute(self, email: str, password: str) -> User:
        user = self.user_repo.find_by_email(email)
        if user and user.verify_password(password):
            return user
        raise InvalidCredentialsException()
```

**Why adequate**: Uses interface, DI present. But `UserRepository` may still import a framework type in its contract definition (e.g., `from sqlalchemy import Session` in the abstract class).

### Strong (Score 4-5)

```python
# use_case/login.py — pure business logic, zero infrastructure awareness
from domain.user import User
from domain.exceptions import InvalidCredentialsException
from repositories.contracts.user_repository import UserRepository  # Pure interface

class LoginUseCase:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    def execute(self, email: str, password: str) -> User:
        user = self.user_repo.find_by_email(email)
        if not user or not user.verify_password(password):
            raise InvalidCredentialsException()
        return user
```

**Why strong**: Zero infrastructure imports. Depends on pure interface. Returns domain model. Testable with a simple fake repository. Automated CI check confirms no infrastructure imports in use_cases/.

### Boundary decision

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Does the use case import infrastructure packages? | Yes, multiple | One or two minor ones | None |
| Can the use case run without a database? | No | Partially (needs mock setup) | Yes, with simple fakes |
| Does the dependency direction follow the rule? | Mostly violated | Mostly followed with exceptions | Consistently followed |

---

## D2: Abstraction at Boundaries

### Weak (Score 1-2)

```python
class OrderUseCase:
    def __init__(self):
        self.db = PostgresOrderDB("postgres://localhost/orders")  # Concrete + hardcoded
        self.payment = StripePaymentClient("sk_live_xxx")          # Concrete + secrets
```

### Adequate (Score 3)

```python
class OrderUseCase:
    def __init__(self, db: PostgresOrderDB, payment: StripePaymentClient):
        self.db = db          # Injected but concrete types
        self.payment = payment
```

### Strong (Score 4-5)

```python
class OrderUseCase:
    def __init__(self, order_repo: OrderRepository, payment_service: PaymentService):
        self.order_repo = order_repo      # Interface
        self.payment_service = payment_service  # Interface
```

**Boundary**: Score 3 has DI but uses concrete types. Score 4 has DI with interfaces. The key question: "Can you swap the implementation without changing this file?"

---

## D3: Framework Independence

### Weak (Score 1-2)

```python
# domain/user.py
from django.db import models

class User(models.Model):  # Domain IS the ORM model
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'users'
```

### Adequate (Score 3)

```python
# domain/user.py
from dataclasses import dataclass
from pydantic import BaseModel  # Minor framework leak

@dataclass
class User(BaseModel):  # Pydantic for validation — framework annotation but logic is pure
    email: str
    name: str
    created_at: datetime
```

### Strong (Score 4-5)

```python
# domain/user.py — zero imports beyond standard library
from dataclasses import dataclass
from datetime import datetime

@dataclass(frozen=True)
class User:
    email: str
    name: str
    created_at: datetime
```

**Boundary**: The question is whether removing the framework would require changing domain files. Score 3 carries a framework dependency (Pydantic) but the business logic itself is pure. Score 4-5 has zero framework presence.

---

## D4: Dependency Graph Acyclicity

### Weak (Score 1-2)

```
feature_auth/ imports from feature_user/internal/user_repository.py
feature_user/ imports from feature_auth/internal/auth_service.py
  → Cycle: auth ↔ user
```

### Strong (Score 4-5)

```
feature_auth/ imports from feature_user/public_api.py (User model only)
feature_user/ has NO imports from feature_auth/
shared/auth_contracts/ defines AuthService interface used by both
  → DAG: auth → user (one direction), auth → shared/auth_contracts (no cycle)
```

**Boundary**: Score 3 has no explicit cycles but implicit coupling through shared mutable state or event ordering assumptions. Score 4 has clean DAG confirmed manually. Score 5 has DAG enforced by automated tooling.

---

## D5: External Dependency Management

### Weak (Score 1-2)

```python
# use_case/send_notification.py
import firebase_admin  # Third-party directly in use case
from firebase_admin import messaging

class SendNotificationUseCase:
    def execute(self, user_id: str, message: str):
        msg = messaging.Message(data={'body': message}, topic=user_id)
        messaging.send(msg)  # Firebase API called directly from use case
```

### Strong (Score 4-5)

```python
# use_case/send_notification.py
from services.contracts.notification_service import NotificationService

class SendNotificationUseCase:
    def __init__(self, notification_service: NotificationService):
        self.notification_service = notification_service

    def execute(self, user_id: str, message: str):
        self.notification_service.send(user_id, message)  # Project-owned interface
```

```python
# services/impl/firebase_notification_service.py — Firebase contained here
import firebase_admin
from firebase_admin import messaging
from services.contracts.notification_service import NotificationService

class FirebaseNotificationService(NotificationService):
    def send(self, user_id: str, message: str):
        msg = messaging.Message(data={'body': message}, topic=user_id)
        messaging.send(msg)
```

**Boundary**: Score 2-3 wraps the library but the interface is shaped by the library's API (leaky abstraction). Score 4-5 wraps it behind a domain-relevant interface shaped by the application's needs.
