// import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';

// class InventoryItemModel extends InventoryItemEntity {
//   InventoryItemModel({
//     required super.id,
//     required super.name,
//     required super.quantity,
//     required super.price,
//     super.description,
//     required super.categoryId,
//     required super.warehouseId,
//     super.imageUrl,
//     super.barcode,
//     super.threshold,
//     required super.createdAt,
//     required super.updatedAt,
//   });

//   factory InventoryItemModel.fromEntity(InventoryItemEntity entity) {
//     return InventoryItemModel(
//       id: entity.id,
//       name: entity.name,
//       quantity: entity.quantity,
//       price: entity.price,
//       description: entity.description,
//       categoryId: entity.categoryId,
//       warehouseId: entity.warehouseId,
//       imageUrl: entity.imageUrl,
//       barcode: entity.barcode,
//       threshold: entity.threshold,
//       createdAt: entity.createdAt,
//       updatedAt: entity.updatedAt,
//     );
//   }

//   factory InventoryItemModel.fromMap(Map<String, dynamic> map, String id) {
//     return InventoryItemModel(
//       id: id,
//       name: map['name'],
//       quantity: map['quantity'],
//       price: (map['price'] as num).toDouble(),
//       description: map['description'],
//       categoryId: map['categoryId'],
//       warehouseId: map['warehouseId'],
//       imageUrl: map['imageUrl'],
//       barcode: map['barcode'],
//       threshold: map['threshold'],
//       createdAt: DateTime.parse(map['createdAt']),
//       updatedAt: DateTime.parse(map['updatedAt']),
//     );
//   }

//   InventoryItemEntity toEntity() => this;

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'quantity': quantity,
//       'price': price,
//       'description': description,
//       'categoryId': categoryId,
//       'warehouseId': warehouseId,
//       'imageUrl': imageUrl,
//       'barcode': barcode,
//       'threshold': threshold,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
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
    required super.companyId, // Include companyId in constructor
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
      companyId: entity.companyId, // Access companyId from entity
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
      companyId: map['companyId'], // Get companyId from map
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  @override
  InventoryItemEntity toEntity() => InventoryItemEntity(
        // Update toEntity
        id: id,
        name: name,
        quantity: quantity,
        price: price,
        description: description,
        categoryId: categoryId,
        warehouseId: warehouseId,
        imageUrl: imageUrl,
        barcode: barcode,
        threshold: threshold,
        companyId: companyId, // Pass companyId to entity
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
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
      'companyId': companyId, // Include companyId in toMap
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
