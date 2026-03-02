# Android Patterns (Kotlin)

## Business Types
```kotlin
data class UserBO(val id: String, val name: String)
sealed class AuthException(message: String? = null): Exception(message) {
    object NotAuthenticated: AuthException("User is not authenticated")
}

```

## Data Layer

**File**: `data_sources/impl/dtos/UserDto.kt` 

```kotlin
data class UserDto(val id: String, val name: String) {
    fun toBusinessObject() = UserBO(id = id, name = name)
}

```

**File**: `data_sources/impl/RetrofitAuthRemoteDataSource.kt` 

```kotlin
class RetrofitAuthRemoteDataSource(private val api: AuthApi): AuthRemoteDataSource {
    override suspend fun fetchCurrentUser(): UserBO? {
        return api.getMe()?.toBusinessObject()
    }
}

```

Use Case 

```kotlin
class GetCurrentUserUseCase(private val repo: AuthRepository) {
    suspend operator fun invoke(): UserBO {
        return repo.getCurrentUser() ?: throw AuthException.NotAuthenticated
    }
}

```

UI Layer (ViewModel) 

```kotlin
class ProfileViewModel(
    private val getCurrentUser: GetCurrentUserUseCase
): ViewModel() {
    fun load() = viewModelScope.launch {
        try {
            val user = getCurrentUser()
            _state.value = UiState.Loaded(user)
        } catch (t: Throwable) {
            _state.value = UiState.Error(t)
        }
    }
}

```