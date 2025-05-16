import 'package:fpdart/src/either.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

class IsSignedIn {
  final AuthRepository repository;

  IsSignedIn(this.repository);

  Future<Either<Failure, UserEntity?>> call() {
    return repository.getCurrentUser();
  }
}
