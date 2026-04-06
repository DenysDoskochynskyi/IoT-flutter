import 'package:my_project/app/session_storage.dart';
import 'package:my_project/data/local/shared_prefs_storage.dart';
import 'package:my_project/data/local/user_local_data_source.dart';
import 'package:my_project/data/repositories/user_repository_impl.dart';
import 'package:my_project/domain/repositories/user_repository.dart';
import 'package:my_project/domain/services/auth_service.dart';
import 'package:my_project/domain/validation/validators.dart';

final class AppDi {
  AppDi._();

  static const SharedPrefsStorage _storage = SharedPrefsStorage();

  static const AuthValidators validators = AuthValidators();

  static const SessionStorage sessionStorage = SessionStorageImpl(
    storage: _storage,
  );

  static const UserLocalDataSource _userLocal = UserLocalDataSourceImpl(
    storage: _storage,
  );

  static const UserRepository userRepository = UserRepositoryImpl(
    local: _userLocal,
  );

  static const AuthService authService = AuthServiceImpl(
    validators: validators,
    userRepository: userRepository,
    sessionStorage: sessionStorage,
  );
}
