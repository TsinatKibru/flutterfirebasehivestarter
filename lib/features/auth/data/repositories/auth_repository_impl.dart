import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:stockpro/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:stockpro/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:stockpro/core/common/models/user_model.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.userRemoteDataSource);

  @override
  Future<Either<Failure, UserEntity?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Sign in using remote source
      await authRemoteDataSource.signIn(email, password);

      final userId = await authRemoteDataSource.getUserId();

      if (userId == null) {
        return left(AuthFailure('User ID could not be retrieved.'));
      }

      // Try fetching existing user
      UserModel existingUser = await userRemoteDataSource.getUser(userId);

      if (existingUser != null) {
        // Update last login timestamp

        return right(existingUser.toEntity());
      } else {
        final newUser = UserModel(
          id: userId,
          email: email,
          lastLogin: DateTime.now(),
          companyId: '',
        );

        await userRemoteDataSource.createUser(newUser);

        return right(newUser.toEntity());
      }

      // User doesn't exist yet — create it
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await authRemoteDataSource.signUp(email, password);
      final userId = await authRemoteDataSource.getUserId();
      if (userId != null) {
        final userModel = UserModel(
            id: userId,
            email: email,
            lastLogin: DateTime.now(),
            companyId: '',
            role: "staff");

        // Register to Firestore (if not exists)
        await userRemoteDataSource.createUser(userModel);

        return right(userModel.toEntity());
      }

      return right(UserEntity(
          id: "", email: email, lastLogin: DateTime.now(), companyId: ''));
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<void> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await userRemoteDataSource.clearCache();
      await authRemoteDataSource.signOut();

      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      try {
        await authRemoteDataSource.isSignedIn();
        return right(true);
      } on AuthException {
        return right(false);
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getUserId() async {
    try {
      try {
        final userId = await authRemoteDataSource.getUserId();
        return right(userId);
      } on AuthException {
        return right(null);
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      try {
        final remoteUser = await authRemoteDataSource.getUser();

        if (remoteUser != null) {
          final userId = remoteUser.uid;
          UserModel userModel = await userRemoteDataSource.getUser(userId);
          return right(UserEntity(
              id: remoteUser.uid,
              name: userModel.name,
              photoUrl: userModel.photoUrl,
              role: userModel.role,
              email: remoteUser.email ?? "",
              lastLogin: DateTime.now(),
              companyId: userModel.companyId));
        } else {
          return right(null);
        }
      } on AuthException {
        return right(null);
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
