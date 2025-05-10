import 'package:stockpro/features/category/domain/entities/category_entity.dart';

class CategoryUtils {
  static String getCategoryNameById(
      String? categoryId, List<CategoryEntity> categories) {
    if (categoryId == null) return 'UNCATEGORIZED';

    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => CategoryEntity(id: 'uncategorized', name: 'Uncategorized'),
    );

    return category.name.toUpperCase();
  }
}
