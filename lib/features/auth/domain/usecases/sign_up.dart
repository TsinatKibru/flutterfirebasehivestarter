import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailAndPassword {
  final AuthRepository repository;

  SignUpWithEmailAndPassword(this.repository);

  Future<Either<Failure, UserEntity?>> call(String email, String password) {
    return repository.signUpWithEmailAndPassword(email, password);
  }
}
