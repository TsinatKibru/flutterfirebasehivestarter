import 'package:stockpro/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
  Stream<List<CategoryEntity>> getCategories();
}
