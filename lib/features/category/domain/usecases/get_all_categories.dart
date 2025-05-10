// lib/features/category/domain/usecases/get_all_categories.dart

import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<Stream<List<CategoryEntity>>> call() async {
    return repository.getCategories();
  }
}
