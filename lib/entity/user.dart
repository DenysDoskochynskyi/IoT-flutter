class User {
  final String id;
  final String email;
  final String password;

  User(this.id, this.email, this.password);

  static User fromJson(Map<String, dynamic> userJson) {
    return User(
      userJson['id'] as String,
      userJson['email'] as String,
      userJson['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
  }) {
    return User(
      id ?? this.id,
      email ?? this.email,
      password ?? this.password,
    );
  }
}
