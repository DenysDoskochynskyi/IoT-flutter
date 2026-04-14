import 'package:my_project/data/local/user_local_data_source.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/domain/repositories/user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required UserLocalDataSource local})
    : _local = local;

  final UserLocalDataSource _local;

  @override
  Future<User?> readUser() => _local.readUser();

  @override
  Future<void> saveUser(User user) => _local.saveUser(user);

  @override
  Future<void> deleteUser() => _local.deleteUser();
}
