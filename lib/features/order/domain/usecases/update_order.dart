import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class UpdateOrder {
  final OrderRepository repository;

  UpdateOrder(this.repository);

  Future<void> call(OrderEntity order) async {
    return repository.updateOrder(order);
  }
}
