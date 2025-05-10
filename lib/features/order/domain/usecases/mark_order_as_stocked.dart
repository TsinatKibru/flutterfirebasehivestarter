import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class MarkOrderAsStocked {
  final OrderRepository repository;

  MarkOrderAsStocked(this.repository);

  Future<void> call(OrderEntity order) async {
    final updatedOrder = order.copyWith(isStocked: true);
    return repository.updateOrder(updatedOrder);
  }
}
