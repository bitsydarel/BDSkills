# iOS Patterns (Swift)

## Business Types
```swift
struct UserBO: Equatable {
    let id: String
    let name: String
}
enum AuthError: Error {
    case notAuthenticated
}

```

## Data Layer

**File**: `DataSources/Impl/DTOs/UserDTO.swift` 

```swift
struct UserDTO: Decodable {
    let id: String
    func toBusinessObject() -> UserBO { UserBO(id: id, name: name) }
}

```

**File**: `DataSources/Impl/HttpAuthRemoteDataSourceImpl.swift` 

```swift
final class HttpAuthRemoteDataSourceImpl: AuthRemoteDataSource {
    private let client: HTTPClient
    func fetchCurrentUser() async throws -> UserBO? {
        let (data, response) = try await client.get(path: "/me")
        guard response.statusCode != 204 else { return nil }
        return try JSONDecoder().decode(UserDTO.self, from: data).toBusinessObject()
    }
}

```

Use Case 

```swift
final class GetCurrentUserUseCase {
    private let repo: AuthRepository
    func call() async throws -> UserBO {
        let user = try await repo.getCurrentUser()
        guard let user else { throw AuthError.notAuthenticated }
        return user
    }
}

```

UI Layer (ViewModel) 

```swift
@MainActor
final class ProfileViewModel: ObservableObject {
    private let getCurrentUser: GetCurrentUserUseCase
    func load() {
        Task {
            do {
                let user = try await getCurrentUser.call()
                state = .loaded(user)
            } catch {
                state = .error(error)
            }
        }
    }
}

```