// lib/features/category/domain/usecases/delete_category.dart
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(String categoryId) {
    return repository.deleteCategory(categoryId);
  }
}
