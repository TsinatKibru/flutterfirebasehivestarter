import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class GetAllOrders {
  final OrderRepository repository;

  GetAllOrders(this.repository);

  Future<Stream<List<OrderEntity>>> call() async {
    return repository.getOrders();
  }
}
