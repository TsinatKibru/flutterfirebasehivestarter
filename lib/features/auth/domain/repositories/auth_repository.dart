import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/app_error.dart';
import 'package:stockpro/core/errors/failure.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity?>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> isSignedIn();
}
