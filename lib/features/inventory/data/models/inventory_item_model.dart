import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';

class InventoryItemModel extends InventoryItemEntity {
  InventoryItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
    super.description,
    required super.categoryId,
    required super.warehouseId,
    super.imageUrl,
    super.barcode,
    super.threshold,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InventoryItemModel.fromEntity(InventoryItemEntity entity) {
    return InventoryItemModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
      description: entity.description,
      categoryId: entity.categoryId,
      warehouseId: entity.warehouseId,
      imageUrl: entity.imageUrl,
      barcode: entity.barcode,
      threshold: entity.threshold,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory InventoryItemModel.fromMap(Map<String, dynamic> map, String id) {
    return InventoryItemModel(
      id: id,
      name: map['name'],
      quantity: map['quantity'],
      price: (map['price'] as num).toDouble(),
      description: map['description'],
      categoryId: map['categoryId'],
      warehouseId: map['warehouseId'],
      imageUrl: map['imageUrl'],
      barcode: map['barcode'],
      threshold: map['threshold'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  InventoryItemEntity toEntity() => this;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'warehouseId': warehouseId,
      'imageUrl': imageUrl,
      'barcode': barcode,
      'threshold': threshold,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
