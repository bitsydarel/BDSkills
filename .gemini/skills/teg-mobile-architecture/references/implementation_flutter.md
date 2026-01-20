# Flutter Patterns (Dart)

## Business Types
**File**: `business_objects/user_bo.dart`
```dart
class UserBO {
  final String id;
  final String name;
  const UserBO({required this.id, required this.name});
}

```

## Data Layer

**File**: `data_sources/impl/dtos/user_dto.dart` 
*DTOs must map to Business Objects.*

```dart
class UserDto {
  final String id;
  // ...
  UserBO toBusinessObject() => UserBO(id: id, name: name);
}

```

**File**: `data_sources/impl/http_auth_remote_data_source.dart` 
*Catch vendor errors here and translate to feature Exceptions.*

```dart
class HttpAuthRemoteDataSource implements AuthRemoteDataSource {
  final Dio _dio;
  @override
  Future<UserBO?> fetchCurrentUser() async {
    final res = await _dio.get('/me');
    if (res.statusCode == 204) return null;
    return UserDto.fromJson(res.data).toBusinessObject();
  }
}

```

## Use Case

**File**: `use_cases/get_current_user_use_case.dart` 

```dart
class GetCurrentUserUseCase {
  final AuthRepository _repo;
  const GetCurrentUserUseCase(this._repo);

  Future<UserBO> call() async {
    final user = await _repo.getCurrentUser();
    if (user == null) throw const NotAuthenticatedException();
    return user;
  }
}

```

## UI Layer (Cubit)

**File**: `cubits/profile_cubit.dart` 
*Never import Repositories here.*

```dart
class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase _getCurrentUser;
  // ...
  Future<void> load() async {
    try {
      final user = await _getCurrentUser();
      emit(state.loaded(user));
    } on AuthException catch (e) {
      emit(state.failed(e));
    }
  }
}

```


