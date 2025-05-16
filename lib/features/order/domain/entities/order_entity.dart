class OrderEntity {
  final String id;
  final String customerName;
  final String productId;
  final String productSku;
  final String productName;
  final int quantity;
  final String category;
  final DateTime date;
  final double price;
  final String? note;
  final String type; // "stock" or "sell"
  final bool isStocked;
  final String? productImageUrl; // Optional product image URL
  final String? productWarehouse; // New optional field for product warehouse
  final String? companyId; // New optional field for company ID

  OrderEntity({
    required this.id,
    required this.customerName,
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.quantity,
    required this.category,
    DateTime? date,
    required this.price,
    this.note,
    required this.type,
    required this.isStocked,
    this.productImageUrl,
    this.productWarehouse, // Initialize the new optional field
    this.companyId, // Initialize the new optional field
  }) : date = date ?? DateTime.now();

  OrderEntity copyWith({
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
    String? productWarehouse,
    String? companyId, // Include the new optional field in copyWith
  }) {
    return OrderEntity(
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
      productWarehouse: productWarehouse ?? this.productWarehouse,
      companyId: companyId ?? this.companyId, // Assign the new field
    );
  }

  @override
  String toString() {
    return 'OrderEntity{'
        'id: $id, '
        'customerName: $customerName, '
        'productId: $productId, '
        'productSku: $productSku, '
        'productName: $productName, '
        'quantity: $quantity, '
        'category: $category, '
        'date: $date, '
        'price: $price, '
        'note: $note, '
        'type: $type, '
        'isStocked: $isStocked, '
        'productImageUrl: $productImageUrl, '
        'productWarehouse: $productWarehouse, ' // Include the new field in toString
        'companyId: $companyId' // Include the new field in toString
        '}';
  }
}
