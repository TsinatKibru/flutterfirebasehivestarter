import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class BulkStockOrders {
  final OrderRepository repository;

  BulkStockOrders(this.repository);

  Future<void> call(List<OrderEntity> orders) async {
    for (final order in orders) {
      if (!order.isStocked) {
        final updated = order.copyWith(isStocked: true);
        await repository.updateOrder(updated);
      }
    }
  }
}
