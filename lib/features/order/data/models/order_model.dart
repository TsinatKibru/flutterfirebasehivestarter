import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.customerName,
    required super.productId,
    required super.productSku,
    required super.productName,
    required super.quantity,
    required super.category,
    super.date,
    required super.price,
    super.note,
    required super.type,
    required super.isStocked,
    super.productImageUrl,
    super.productWarehouse, // Include the new optional field in the constructor
    super.companyId, // Include the new optional field in the constructor
  });

  OrderModel copyWith({
    String? id,
    String? customerName,
    String? productId,
    String? productSku,
    String? productName,
    int? quantity,
    String? category,
    DateTime? date,
    double? price,
    String? note,
    String? type,
    bool? isStocked,
    String? productImageUrl,
    String? productWarehouse, // Include the new optional field in copyWith
    String? companyId, // Include the new optional field in copyWith
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productId: productId ?? this.productId,
      productSku: productSku ?? this.productSku,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      date: date ?? this.date,
      price: price ?? this.price,
      note: note ?? this.note,
      type: type ?? this.type,
      isStocked: isStocked ?? this.isStocked,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productWarehouse:
          productWarehouse ?? this.productWarehouse, // Assign the new field
      companyId: companyId ?? this.companyId, // Assign the new field
    );
  }

  // Factory constructor to create OrderModel from OrderEntity
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      customerName: entity.customerName,
      productId: entity.productId,
      productSku: entity.productSku,
      productName: entity.productName,
      quantity: entity.quantity,
      category: entity.category,
      date: entity.date,
      price: entity.price,
      note: entity.note,
      type: entity.type,
      isStocked: entity.isStocked,
      productImageUrl: entity.productImageUrl,
      productWarehouse: entity.productWarehouse, // Map the new field
      companyId: entity.companyId, // Map the new field
    );
  }

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return OrderModel(
        id: doc.id,
        customerName: '',
        productId: '',
        productSku: '',
        productName: '',
        quantity: 0,
        category: '',
        price: 0.0,
        type: '',
        isStocked: false,
      );
    }
    return OrderModel(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      productId: data['productId'] ?? '',
      productSku: data['productSku'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      note: data['note'],
      type: data['type'] ?? '',
      isStocked: data['isStocked'] ?? false,
      productImageUrl: data['productImageUrl'],
      productWarehouse:
          data['productWarehouse'], // Retrieve the new field from Firestore
      companyId: data['companyId'], // Retrieve the new field from Firestore
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'customerName': customerName,
      'productId': productId,
      'productSku': productSku,
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'price': price,
      'note': note,
      'type': type,
      'isStocked': isStocked,
      'productImageUrl': productImageUrl,
      'productWarehouse':
          productWarehouse, // Include the new field in Firestore document
      'companyId': companyId, // Include the new field in Firestore document
    };
  }

  // Helper method to convert OrderModel back to OrderEntity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      customerName: customerName,
      productId: productId,
      productSku: productSku,
      productName: productName,
      quantity: quantity,
      category: category,
      date: date,
      price: price,
      note: note,
      type: type,
      isStocked: isStocked,
      productImageUrl: productImageUrl,
      productWarehouse:
          productWarehouse, // Map the new field back to the entity
      companyId: companyId, // Map the new field back to the entity
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, customerName: $customerName, productId: $productId, productSku: $productSku, productName: $productName, quantity: $quantity, category: $category, date: $date, price: $price, note: $note, type: $type, isStocked: $isStocked, productImageUrl: $productImageUrl, productWarehouse: $productWarehouse, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.customerName == customerName &&
        other.productId == productId &&
        other.productSku == productSku &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.category == category &&
        other.date == date &&
        other.price == price &&
        other.note == note &&
        other.type == type &&
        other.isStocked == isStocked &&
        other.productImageUrl == productImageUrl &&
        other.productWarehouse == productWarehouse && // Compare the new field
        other.companyId == companyId; // Compare the new field
  }

  @override
  int get hashCode =>
      id.hashCode ^
      customerName.hashCode ^
      productId.hashCode ^
      productSku.hashCode ^
      productName.hashCode ^
      quantity.hashCode ^
      category.hashCode ^
      date.hashCode ^
      price.hashCode ^
      note.hashCode ^
      type.hashCode ^
      isStocked.hashCode ^
      productImageUrl.hashCode ^
      productWarehouse.hashCode ^ // Include the new field in hashCode
      companyId.hashCode; // Include the new field in hashCode
}
