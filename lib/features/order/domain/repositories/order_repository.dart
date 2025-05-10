import 'package:stockpro/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Stream<List<OrderEntity>> getOrders();
  Future<void> addOrder(OrderEntity order);
  Future<void> updateOrder(OrderEntity order);
  Future<void> deleteOrder(String id);
}
