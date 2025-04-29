import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:stockpro/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:stockpro/features/auth/data/model/user_model.dart';
import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, UserEntity?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await remoteDataSource.signIn(email, password);
      final userId = await remoteDataSource.getUserId();
      if (userId != null) {
        await localDataSource.cacheUser(
          UserModel(id: userId, email: email, lastLogin: DateTime.now()),
        );
        return right(
            UserEntity(id: userId, email: email, lastLogin: DateTime.now()));
      }

      return right(UserEntity(id: "", email: email, lastLogin: DateTime.now()));
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await remoteDataSource.signUp(email, password);
      final userId = await remoteDataSource.getUserId();
      if (userId != null) {
        await localDataSource.cacheUser(
          UserModel(id: userId, email: email, lastLogin: DateTime.now()),
        );
        return right(
            UserEntity(id: userId, email: email, lastLogin: DateTime.now()));
      }

      return right(UserEntity(id: "", email: email, lastLogin: DateTime.now()));
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
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final isCached = await localDataSource.isUserCached();
      if (!isCached) {
        return right(false);
      }

      try {
        await remoteDataSource.isSignedIn();
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
      final cachedUser = await localDataSource.getCachedUser();

      if (cachedUser?.id != null) {
        return right(cachedUser!.id);
      }

      try {
        final userId = await remoteDataSource.getUserId();
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
      final cachedUser = await localDataSource.getCachedUser();
      print("cachedUser: ${cachedUser}");

      if (cachedUser != null) {
        print("cachedUser: ${cachedUser.toString()}");
        return right(cachedUser.toEntity());
      }

      try {
        final remoteUser = await remoteDataSource.getUser();
        if (remoteUser != null) {
          await localDataSource.cacheUser(
            UserModel(
                id: remoteUser.uid,
                email: remoteUser.email ?? "",
                lastLogin: DateTime.now()),
          );
          return right(UserEntity(
              id: remoteUser.uid,
              email: remoteUser.email ?? "",
              lastLogin: DateTime.now()));
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
