import 'package:stockpro/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.productCount,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl'],
      productCount: map['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'productCount': productCount,
    };
  }

  // Added fromEntity method
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      productCount: entity.productCount,
    );
  }

  // Added toEntity method
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      productCount: productCount,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, imageUrl: $imageUrl, productCount: $productCount)';
  }
}
