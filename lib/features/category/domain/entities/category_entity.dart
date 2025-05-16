class CategoryEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final int productCount;
  final String? companyId; // Added companyId here

  const CategoryEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.productCount = 0,
    this.companyId, // Added companyId to the constructor
  });
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? productCount,
    String? companyId, // Added companyId to copyWith
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      productCount: productCount ?? this.productCount,
      companyId: companyId ?? this.companyId, // Assigned companyId
    );
  }
}
