import 'package:my_project/data/local/key_value_storage.dart';
import 'package:my_project/domain/models/user.dart';

abstract interface class UserLocalDataSource {
  Future<User?> readUser();
  Future<void> saveUser(User user);
  Future<void> deleteUser();
}

final class UserLocalDataSourceImpl implements UserLocalDataSource {
  const UserLocalDataSourceImpl({required KeyValueStorage storage})
    : _storage = storage;

  final KeyValueStorage _storage;

  static const String _kUser = 'user';

  @override
  Future<User?> readUser() async {
    final value = await _storage.readString(_kUser);
    return User.fromStorageString(value);
  }

  @override
  Future<void> saveUser(User user) async {
    await _storage.writeString(_kUser, user.toStorageString());
  }

  @override
  Future<void> deleteUser() async {
    await _storage.remove(_kUser);
  }
}
