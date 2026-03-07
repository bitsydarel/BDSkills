# Calibration: Data Flow & Boundaries (Lens 3)

Weak/adequate/strong examples for criteria B1-B4. Use when uncertain about a score boundary. For full scoring criteria, see [evaluation-data-flow-boundaries.md](evaluation-data-flow-boundaries.md).

---

## B1: Data Flow Traceability

### Weak (Score 1-2)

```python
# Presentation calls data source directly — skipping use case and repository
class UserController:
    def get_profile(self, user_id):
        db = PostgresDB()
        row = db.query("SELECT * FROM users WHERE id = %s", user_id)
        return {"name": row["name"], "email": row["email"]}
```

**Why weak**: No layer separation in data flow. Presentation → Database directly. No use case, no repository, no data source abstraction. Impossible to trace the flow through layers because there are no layers.

### Adequate (Score 3)

```python
# Mostly follows the flow but some shortcuts exist
class UserController:
    def get_profile(self, user_id):
        user = self.get_profile_use_case.execute(user_id)  # Standard flow
        return self.format_profile(user)

    def get_quick_stats(self, user_id):
        stats = self.user_repo.get_stats(user_id)  # Shortcut: skips use case
        return stats
```

**Why adequate**: Primary flow goes through use cases, but some secondary flows skip layers. Tracing is possible for main operations but shortcuts create inconsistency.

### Strong (Score 4-5)

```python
# Every operation follows the standard flow
class UserController:
    def get_profile(self, user_id):
        user = self.get_profile_use_case.execute(user_id)
        return ProfileViewModel.from_domain(user)

    def get_stats(self, user_id):
        stats = self.get_user_stats_use_case.execute(user_id)
        return StatsViewModel.from_domain(stats)
```

**Why strong**: Every path goes Controller → UseCase → Repository → DataSource. Flow is consistent, predictable, and traceable.

---

## B2: Boundary-Appropriate Data Transformation

### Weak (Score 1-2)

```python
# Repository returns DTO — leaks data source details to use case
class UserRepository:
    def get(self, id):
        return self.api_data_source.fetch_user(id)  # Returns UserApiResponse DTO

class GetProfileUseCase:
    def execute(self, user_id):
        dto = self.user_repo.get(user_id)  # Receives DTO, not domain model
        return {
            "name": dto.data["attributes"]["name"],  # Knows API response structure
            "email": dto.data["attributes"]["email"],
        }
```

**Why weak**: Use case parses API response format. Changing the API response structure breaks use case code. DTO has escaped the data source boundary.

### Adequate (Score 3)

```python
# Repository returns domain model but mapping is incomplete
class UserRepository:
    def get(self, id):
        dto = self.api_data_source.fetch_user(id)
        return User(
            name=dto.name,
            email=dto.email,
            raw_metadata=dto.metadata  # Unmapped DTO field passed through
        )
```

**Why adequate**: Most transformation at boundary, but `raw_metadata` is a passthrough of the DTO structure — partially leaking.

### Strong (Score 4-5)

```python
# Data source implementation maps DTO → domain model completely
class ApiUserDataSource(UserDataSourceContract):
    def fetch_user(self, id) -> User:
        response = self.http_client.get(f"/users/{id}")
        dto = UserApiResponse.from_json(response.body)
        return dto.to_domain()  # Full mapping to domain model

class UserApiResponse:  # DTO — private to data source
    def to_domain(self) -> User:
        return User(
            name=self.data["attributes"]["name"],
            email=self.data["attributes"]["email"],
            metadata=UserMetadata.from_raw(self.data.get("meta", {}))
        )
```

**Why strong**: DTO is private to data source. Domain model returned from data source. API format change stays in this file only.

---

## B3: Error Translation & Propagation

### Weak (Score 1-2)

```python
# Use case catches vendor-specific exception
class GetProfileUseCase:
    def execute(self, user_id):
        try:
            return self.user_repo.get(user_id)
        except HttpException as e:          # Vendor exception in use case!
            if e.status_code == 404:
                raise Exception("User not found")
            elif e.status_code == 503:
                raise Exception("Service unavailable")
```

**Why weak**: Use case knows about HTTP status codes. Switching from REST to GraphQL would break this use case. Error semantics are infrastructure-specific, not business-specific.

### Adequate (Score 3)

```python
# Data source translates some errors but not all
class ApiUserDataSource(UserDataSourceContract):
    def fetch_user(self, id) -> User:
        try:
            response = self.http_client.get(f"/users/{id}")
            return self._map_to_domain(response)
        except HttpException as e:
            if e.status_code == 404:
                raise UserNotFoundException(id)  # Translated
            raise  # Other HTTP errors propagate untranslated!
```

**Why adequate**: Common cases translated (404 → UserNotFoundException), but uncommon errors (500, 429, timeout) propagate as raw HTTP exceptions.

### Strong (Score 4-5)

```python
class ApiUserDataSource(UserDataSourceContract):
    def fetch_user(self, id) -> User:
        try:
            response = self.http_client.get(f"/users/{id}")
            return self._map_to_domain(response)
        except HttpException as e:
            if e.status_code == 404:
                raise UserNotFoundException(id)
            elif e.status_code in (500, 502, 503):
                raise ServiceUnavailableException("user-api")
            else:
                raise UnexpectedDataSourceException(str(e))
        except SocketException:
            raise NetworkFailureException()
```

**Why strong**: Every vendor error path translates to a domain exception. Use cases never see HTTP, socket, or database exceptions. Switching vendors requires only this file.

---

## B4: Feature Module Isolation

### Weak (Score 1-2)

```python
# Feature A imports Feature B's internal data source
from features.user.data_sources.impl.postgres_user_db import PostgresUserDB
from features.user.repositories.user_repository_impl import UserRepositoryImpl

class OrderUseCase:
    def __init__(self):
        self.user_db = PostgresUserDB()  # Deep import into user feature internals
```

**Why weak**: Order feature depends on user feature's implementation details. Refactoring user's database layer breaks order feature. No encapsulation boundary.

### Adequate (Score 3)

```python
# Imports from feature barrel but also some internal paths
from features.user import User, UserNotFoundException  # Public API — good
from features.user.repositories.user_repository import UserRepository  # Internal path — leak
```

### Strong (Score 4-5)

```python
# All cross-feature imports through public API only
from features.user import User, UserNotFoundException, get_user_service

class OrderUseCase:
    def __init__(self, user_service: UserService):  # Interface from user's public API
        self.user_service = user_service
```

**Why strong**: Order feature knows nothing about user feature's internals. Refactoring user feature's internal structure has zero effect on order feature. Lint rule enforces: "imports from features/X/ must resolve to features/X/__init__.py".

---

## Quick decision table

| Criterion | Score 2 → 3 boundary | Score 3 → 4 boundary |
|-----------|----------------------|----------------------|
| B1 | Primary flows follow layers; secondary flows skip | All flows follow layers consistently |
| B2 | DTOs mapped at boundary but with passthrough fields | Complete mapping, DTOs fully private to data source |
| B3 | Common errors translated; edge cases propagate raw | All error paths translate to domain exceptions |
| B4 | Barrel files exist but internal imports still present | All cross-feature imports through barrel files, enforced by tooling |
