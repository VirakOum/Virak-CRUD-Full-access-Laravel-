# virak

`virak` is a Flutter package that provides utilities and widgets for easy CRUD operations with REST APIs and Usefull with CRUD Laravel.  
It is designed to simplify API integration, handle tokens automatically, and work with user-defined models and endpoints.

---

## Advantages of This Package

- **Works for both public and secured APIs**: Handles endpoints that require authentication or are open.  
- **Optional token support**: Tokens are only used if set, allowing flexible API usage.  
- **Automatic token handling for CRUD requests**: Tokens are automatically included in all create, read, update, and delete requests.  
- **Flexible user-defined models and endpoints**: Easily adapt to any project by passing custom data models and API endpoints.  

---

## Getting Started

Add `virak` to your `pubspec.yaml`:

```yaml
dependencies:
  virak: ^0.0.1
```

Run:

```bash
flutter pub get
```

---

## Setup

Before making requests, configure the base URL and optionally set an authentication token.

```dart
import 'package:virak/virak.dart';

void main() {
  setBaseUrl("https://api.example.com");
  setAuthToken("your_token_here");
}
```

---

## Usage

### GET request (no model)

```dart
void fetchItems() async {
  try {
    final items = await getData<List<dynamic>>(endpoint: "items");
    print(items);
  } catch (e) {
    print("Error: $e");
  }
}
```

---

### GET request with model mapping

```dart
class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
    );
  }
}

void fetchUser() async {
  try {
    final user = await getData<User>(
      endpoint: "users/1",
      fromJson: (json) => User.fromJson(json),
    );
    print("User: ${user.name}");
  } catch (e) {
    print("Error: $e");
  }
}
```

---

### POST request

```dart
void createUser() async {
  try {
    final result = await postData<Map<String, dynamic>>(
      endpoint: "users",
      body: {"name": "John Doe", "email": "john@example.com"},
    );
    print(result);
  } catch (e) {
    print("Error: $e");
  }
}
```

---

### PUT request

```dart
void updateUser() async {
  try {
    final result = await putData<Map<String, dynamic>>(
      endpoint: "users/1",
      body: {"name": "Jane Doe"},
    );
    print(result);
  } catch (e) {
    print("Error: $e");
  }
}
```

---

### DELETE request

```dart
void deleteUser() async {
  try {
    await deleteData(endpoint: "users/1");
    print("User deleted");
  } catch (e) {
    print("Error: $e");
  }
}
```

---

## Notes

- You **must** call `setBaseUrl()` before making any request.  
- Tokens are optional — if not set, requests are sent without authentication.  
- Use `fromJson` to convert API responses into your own model classes.  
