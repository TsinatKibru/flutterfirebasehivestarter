// lib/features/category/domain/usecases/get_all_categories.dart

import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/users/domain/repositories/user_repository.dart';

class GetAllUsers {
  final UserRepository repository;

  GetAllUsers(this.repository);

  Future<Stream<List<UserEntity>>> call() async {
    return repository.getUsers();
  }
}
