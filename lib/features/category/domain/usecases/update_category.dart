// lib/features/category/domain/usecases/update_category.dart
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(CategoryEntity category) {
    return repository.updateCategory(category);
  }
}
