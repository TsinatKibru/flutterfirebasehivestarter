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
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isEmpty => this == InventoryItemEntity.empty();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          quantity == other.quantity &&
          price == other.price &&
          description == other.description &&
          categoryId == other.categoryId &&
          warehouseId == other.warehouseId &&
          imageUrl == other.imageUrl &&
          barcode == other.barcode &&
          threshold == other.threshold &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        quantity,
        price,
        description,
        categoryId,
        warehouseId,
        imageUrl,
        barcode,
        threshold,
        createdAt,
        updatedAt,
      ]);

  @override
  String toString() {
    return 'InventoryItemEntity{id: $id, name: $name, quantity: $quantity, price: $price, description: $description, categoryId: $categoryId, warehouseId: $warehouseId, imageUrl: $imageUrl, barcode: $barcode, threshold: $threshold, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
