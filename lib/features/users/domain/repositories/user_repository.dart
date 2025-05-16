import 'package:stockpro/core/common/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> addUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String userId);
  Stream<List<UserEntity>> getUsers();
  //Future<UserEntity> getUser(int id);
}
