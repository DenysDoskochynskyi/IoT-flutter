import 'package:my_project/data/local/key_value_storage.dart';

abstract interface class SessionStorage {
  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
  Future<void> logout();
}

final class SessionStorageImpl implements SessionStorage {
  const SessionStorageImpl({required KeyValueStorage storage})
    : _storage = storage;

  final KeyValueStorage _storage;

  static const String _kIsLoggedIn = 'is_logged_in';

  @override
  Future<bool> isLoggedIn() async {
    return await _storage.readBool(_kIsLoggedIn) ?? false;
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _storage.writeBool(_kIsLoggedIn, value);
  }

  @override
  Future<void> logout() async {
    await setLoggedIn(false);
  }
}
