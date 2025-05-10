import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/features/category/data/datasources/category_remote_data_source.dart';
import 'package:stockpro/features/category/data/models/category_model.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addCategory(CategoryEntity category) async {
    try {
      String? uploadedImageUrl;

      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(category.imageUrl);
      } catch (e) {
        print("⚠️ Image upload failed: $e");
        uploadedImageUrl = null;
      }
      final updatedCategory = category.copyWith(imageUrl: uploadedImageUrl);
      final CategoryModel model = CategoryModel.fromEntity(updatedCategory);
      await remoteDataSource.addCategory(model);
    } on ServerException catch (e) {
      print("error: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) =>
      remoteDataSource.deleteCategory(categoryId);

  @override
  Stream<List<CategoryEntity>> getCategories() {
    return remoteDataSource.getCategories().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    String? uploadedImageUrl;

    try {
      uploadedImageUrl =
          await remoteDataSource.uploadImageAndGetUrl(category.imageUrl);
    } catch (e) {
      print("⚠️ Image upload failed: $e");
      uploadedImageUrl = null;
    }
    final updatedCategory = category.copyWith(imageUrl: uploadedImageUrl);
    final CategoryModel model = CategoryModel.fromEntity(updatedCategory);
    await remoteDataSource.updateCategory(model);
  }
}
