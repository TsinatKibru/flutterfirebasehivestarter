import 'package:stockpro/features/order/data/datasources/order_remote_data_source.dart';
import 'package:stockpro/features/order/data/models/order_model.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<OrderEntity>> getOrders() {
    return remoteDataSource.getOrders();
  }

  @override
  Future<void> addOrder(OrderEntity order) {
    final model = OrderModel.fromEntity(order);

    return remoteDataSource.addOrder(model);
  }

  @override
  Future<void> updateOrder(OrderEntity order) {
    final model = OrderModel.fromEntity(order);

    return remoteDataSource.updateOrder(model);
  }

  @override
  Future<void> deleteOrder(String id) {
    return remoteDataSource.deleteOrder(id);
  }
}
