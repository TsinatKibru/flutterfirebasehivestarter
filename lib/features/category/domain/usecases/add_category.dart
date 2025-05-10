// lib/features/category/domain/usecases/add_category.dart

import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(CategoryEntity category) async {
    return await repository.addCategory(category);
  }
}
