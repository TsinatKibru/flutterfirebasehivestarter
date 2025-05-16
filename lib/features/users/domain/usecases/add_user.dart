// lib/features/category/domain/usecases/add_category.dart

import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/users/domain/repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.addUser(user);
  }
}
