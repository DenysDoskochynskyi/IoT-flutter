import 'dart:convert';

final class User {
  const User({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  User copyWith({String? name, String? email, String? password}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'email': email,
    'password': password,
  };

  static User fromJson(Map<String, Object?> json) {
    return User(
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      password: (json['password'] as String?) ?? '',
    );
  }

  String toStorageString() => jsonEncode(toJson());

  static User? fromStorageString(String? value) {
    if (value == null || value.isEmpty) return null;

    final dynamic decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic>) return null;

    return User.fromJson(decoded.cast<String, Object?>());
  }
}
