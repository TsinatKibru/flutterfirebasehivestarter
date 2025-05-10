import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class DeleteOrder {
  final OrderRepository repository;

  DeleteOrder(this.repository);

  Future<void> call(String id) async {
    return repository.deleteOrder(id);
  }
}
