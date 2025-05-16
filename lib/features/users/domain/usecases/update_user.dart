// lib/features/category/domain/usecases/update_category.dart
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/users/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
