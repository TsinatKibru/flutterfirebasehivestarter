import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/core/common/models/user_model.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/features/users/data/datasources/user_remote_data_source.dart';
import 'package:stockpro/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addUser(UserEntity user) async {
    try {
      String? uploadedImageUrl;

      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(user.photoUrl);
      } catch (e) {
        print("⚠️ PhotoUrl upload failed: $e");
        uploadedImageUrl = null;
      }
      final updateduser = user.copyWith(photoUrl: uploadedImageUrl);
      final UserModel model = UserModel.fromEntity(updateduser);
      await remoteDataSource.addUser(model);
    } on ServerException catch (e) {
      print("Error adding user: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
    } on ServerException catch (e) {
      print("Error deleting user: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Stream<List<UserEntity>> getUsers() {
    return remoteDataSource.getUsers().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      String? uploadedImageUrl;

      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(user.photoUrl);
      } catch (e) {
        print("⚠️ Image upload failed: $e");
        uploadedImageUrl = null;
      }
      final updateduser = user.copyWith(photoUrl: uploadedImageUrl);
      final UserModel model = UserModel.fromEntity(updateduser);
      await remoteDataSource.updateUser(model);
    } on ServerException catch (e) {
      print("Error updating user: ${e.toString()}");
      rethrow;
    }
  }
}
