import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class AddOrder {
  final OrderRepository repository;

  AddOrder(this.repository);

  Future<void> call(OrderEntity order) async {
    return repository.addOrder(order);
  }
}
