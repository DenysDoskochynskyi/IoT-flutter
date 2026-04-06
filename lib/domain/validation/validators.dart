import 'package:my_project/domain/common/result.dart';

final class AuthValidators {
  const AuthValidators();

  static final RegExp _hasDigit = RegExp(r'\d');
  static final RegExp _emailLike = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Result<void> validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return const Err<void>(Failure('Name is required.'));
    if (_hasDigit.hasMatch(trimmed)) {
      return const Err<void>(Failure('Name must not contain digits.'));
    }
    return const Ok<void>(null);
  }

  Result<void> validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return const Err<void>(Failure('Email is required.'));
    if (!_emailLike.hasMatch(trimmed)) {
      return const Err<void>(
        Failure('Email looks invalid (missing @ or domain).'),
      );
    }
    return const Ok<void>(null);
  }

  Result<void> validatePassword(String password) {
    if (password.isEmpty) {
      return const Err<void>(Failure('Password is required.'));
    }
    if (password.length < 6) {
      return const Err<void>(
        Failure('Password must be at least 6 characters.'),
      );
    }
    return const Ok<void>(null);
  }

  Result<void> validateRegister({
    required String name,
    required String email,
    required String password,
  }) {
    final r1 = validateName(name);
    if (r1 is Err<void>) return r1;

    final r2 = validateEmail(email);
    if (r2 is Err<void>) return r2;

    final r3 = validatePassword(password);
    if (r3 is Err<void>) return r3;

    return const Ok<void>(null);
  }

  Result<void> validateLogin({
    required String email,
    required String password,
  }) {
    final r1 = validateEmail(email);
    if (r1 is Err<void>) return r1;

    final r2 = validatePassword(password);
    if (r2 is Err<void>) return r2;

    return const Ok<void>(null);
  }
}
