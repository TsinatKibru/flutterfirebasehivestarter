import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:stockpro/core/errors/app_error.dart';
import 'package:stockpro/features/auth/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> isUserCached();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl(this.userBox);

  @override
  Future<Either<AppError, void>> cacheUser(UserModel user) async {
    try {
      await userBox.put('current_user', user);
      return const Right(null);
    } catch (e) {
      return Left(CacheError('Failed to cache user'));
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return userBox.get('current_user');
  }

  @override
  Future<void> clearCache() async {
    await userBox.clear();
  }

  @override
  Future<bool> isUserCached() async {
    return userBox.containsKey('current_user');
  }
}
