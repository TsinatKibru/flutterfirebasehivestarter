import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/utils/user_utils.dart';
import 'package:stockpro/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Stream<List<OrderModel>> getOrders();
  Future<void> addOrder(OrderModel order);
  Future<void> updateOrder(OrderModel order);
  Future<void> deleteOrder(String id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl(this.firestore);

  // Stream<List<OrderModel>> getOrders() {

  //   return firestore
  //       .collection('orders')
  //       .snapshots()
  //       .asyncMap((snapshot) async {
  //     final orders =
  //         snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

  //     // Get all unique product IDs
  //     final productIds = orders
  //         .map((o) => o.productId)
  //         .where((id) => id.isNotEmpty) // <-- Important fix
  //         .toSet()
  //         .toList();

  //     if (productIds.isEmpty) {
  //       print("⚠️ No product IDs found. Returning raw orders.");
  //       return orders;
  //     }

  //     // Fetch all products in one batch
  //     final productsQuery = await firestore
  //         .collection('inventory')
  //         .where(FieldPath.documentId, whereIn: productIds)
  //         .get();

  //     final productMap = {
  //       for (var doc in productsQuery.docs) doc.id: doc.data()
  //     };

  //     // Merge product data into orders
  //     final enrichedOrders = orders.map((order) {
  //       final productData = productMap[order.productId];
  //       if (productData == null) {
  //         // print(
  //         //     "❌ No product data found for order with productId: ${order.productId}");
  //       } else {
  //         // print(
  //         //     "🔗 Enriching order ${order.id} with product '${productData['name']}'");
  //       }
  //       return order.copyWith(
  //           productName: productData?['name'],
  //           productSku: productData?['barcode'],
  //           category: productData?['category'],
  //           productImageUrl: productData?['imageUrl'],
  //           productWarehouse: productData?['warehouseId']
  //           // Add other fields as needed
  //           );
  //     }).toList();
  //     enrichedOrders.sort((a, b) => b.date.compareTo(a.date));
  //     print("enrichedorders: ${enrichedOrders}");
  //     return enrichedOrders;
  //   });
  // }
  @override
  Stream<List<OrderModel>> getOrders() async* {
    final companyId = await getCurrentUserCompanyId();

    if (companyId == null) {
      print("⚠️ Cannot stream orders without companyId.");
      yield [];
      return;
    }

    yield* firestore
        .collection('orders')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .asyncMap((snapshot) async {
      final orders =
          snapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

      final productIds = orders
          .map((o) => o.productId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (productIds.isEmpty) {
        return orders;
      }

      final productsQuery = await firestore
          .collection('inventory')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      final productMap = {
        for (var doc in productsQuery.docs) doc.id: doc.data()
      };

      final enrichedOrders = orders.map((order) {
        final productData = productMap[order.productId];
        return order.copyWith(
          productName: productData?['name'],
          productSku: productData?['barcode'],
          category: productData?['category'],
          productImageUrl: productData?['imageUrl'],
          productWarehouse: productData?['warehouseId'],
        );
      }).toList();

      enrichedOrders.sort((a, b) => b.date.compareTo(a.date));
      return enrichedOrders;
    });
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    await firestore.collection('orders').add(order.toDocument());
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    await firestore
        .collection('orders')
        .doc(order.id)
        .update(order.toDocument());
  }

  @override
  Future<void> deleteOrder(String id) async {
    await firestore.collection('orders').doc(id).delete();
  }
}
