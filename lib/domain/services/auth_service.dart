import 'package:my_project/app/session_storage.dart';
import 'package:my_project/domain/common/result.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/domain/repositories/user_repository.dart';
import 'package:my_project/domain/validation/validators.dart';

abstract interface class AuthService {
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> login({required String email, required String password});

  Future<void> logout();
}

final class AuthServiceImpl implements AuthService {
  const AuthServiceImpl({
    required AuthValidators validators,
    required UserRepository userRepository,
    required SessionStorage sessionStorage,
  }) : _validators = validators,
       _userRepository = userRepository,
       _sessionStorage = sessionStorage;

  final AuthValidators _validators;
  final UserRepository _userRepository;
  final SessionStorage _sessionStorage;

  @override
  Future<Result<void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final validation = _validators.validateRegister(
      name: name,
      email: email,
      password: password,
    );
    if (validation is Err<void>) return validation;

    final user = User(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );

    await _userRepository.saveUser(user);
    await _sessionStorage.setLoggedIn(true);
    return const Ok<void>(null);
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    final validation = _validators.validateLogin(
      email: email,
      password: password,
    );
    if (validation is Err<void>) return validation;

    final stored = await _userRepository.readUser();
    if (stored == null) {
      return const Err<void>(Failure('No user found. Please register first.'));
    }

    final normalizedEmail = email.trim();
    if (stored.email != normalizedEmail || stored.password != password) {
      return const Err<void>(Failure('Invalid email or password.'));
    }

    await _sessionStorage.setLoggedIn(true);
    return const Ok<void>(null);
  }

  @override
  Future<void> logout() async {
    await _sessionStorage.logout();
  }
}
