import 'package:my_project/domain/models/user.dart';

abstract interface class UserRepository {
  Future<User?> readUser();
  Future<void> saveUser(User user);
  Future<void> deleteUser();
}
