import 'package:stockpro/features/order/domain/entities/order_entity.dart';

abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

class AddNewOrder extends OrderEvent {
  final OrderEntity order;

  AddNewOrder(this.order);
}

class UpdateExistingOrder extends OrderEvent {
  final OrderEntity order;
  UpdateExistingOrder(this.order);
}

class DeleteExistingOrder extends OrderEvent {
  final String id;
  DeleteExistingOrder(this.id);
}

class StockSingleOrder extends OrderEvent {
  final OrderEntity order;
  StockSingleOrder(this.order);
}

class StockAllOrders extends OrderEvent {
  final List<OrderEntity> orders;
  StockAllOrders(this.orders);
}
