class CategoryEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final int productCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.productCount = 0,
  });
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? productCount,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      productCount: productCount ?? this.productCount,
    );
  }
}
