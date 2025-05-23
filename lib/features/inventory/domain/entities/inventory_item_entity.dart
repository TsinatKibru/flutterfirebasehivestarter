class InventoryItemEntity {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? description;
  final String categoryId;
  final String warehouseId;
  final String? imageUrl;
  final String? barcode;
  final int? threshold;
  final String? companyId; // Added companyId
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.description,
    required this.categoryId,
    required this.warehouseId,
    this.imageUrl,
    this.barcode,
    this.threshold,
    this.companyId, // Initialize companyId
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory InventoryItemEntity.empty() => InventoryItemEntity(
        id: '',
        name: '',
        quantity: 0,
        price: 0.0,
        categoryId: '',
        warehouseId: '',
        companyId: '', // Initialize companyId in empty factory
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
      );

  InventoryItemEntity copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? description,
    String? categoryId,
    String? warehouseId,
    String? imageUrl,
    String? barcode,
    int? threshold,
    String? companyId, // Add companyId to copyWith
    DateTime? updatedAt,
  }) {
    return InventoryItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      warehouseId: warehouseId ?? this.warehouseId,
      imageUrl: imageUrl ?? this.imageUrl,
      barcode: barcode ?? this.barcode,
      threshold: threshold ?? this.threshold,
      companyId: companyId ?? this.companyId, // Assign companyId in copyWith
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isEmpty => this == InventoryItemEntity.empty();

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is InventoryItemEntity &&
  //         runtimeType == other.runtimeType &&
  //         id == other.id &&
  //         name == other.name &&
  //         quantity == other.quantity &&
  //         price == other.price &&
  //         description == other.description &&
  //         categoryId == other.categoryId &&
  //         warehouseId == other.warehouseId &&
  //         imageUrl == other.imageUrl &&
  //         barcode == other.barcode &&
  //         threshold == other.threshold &&
  //         companyId == other.companyId && // Compare companyId
  //         createdAt == other.createdAt &&
  //         updatedAt == other.updatedAt;

  // @override
  // int get hashCode => Object.hashAll([
  //       id,
  //       name,
  //       quantity,
  //       price,
  //       description,
  //       categoryId,
  //       warehouseId,
  //       imageUrl,
  //       barcode,
  //       threshold,
  //       companyId, // Include companyId in hashCode
  //       createdAt,
  //       updatedAt,
  //     ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'InventoryItemEntity{id: $id, name: $name, quantity: $quantity, price: $price, description: $description, categoryId: $categoryId, warehouseId: $warehouseId, imageUrl: $imageUrl, barcode: $barcode, threshold: $threshold, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
