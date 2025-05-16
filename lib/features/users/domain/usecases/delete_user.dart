// lib/features/category/domain/usecases/delete_category.dart
import 'package:stockpro/features/users/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String userId) {
    return repository.deleteUser(userId);
  }
}
