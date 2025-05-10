import 'package:stockpro/features/order/domain/entities/order_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  OrderLoaded(this.orders);
}

class OrderAdded extends OrderState {
  final OrderEntity order;

  OrderAdded(this.order);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

class OrderUpdated extends OrderState {
  final OrderEntity order;
  OrderUpdated(this.order);
}

class OrderDeleted extends OrderState {
  final String id;
  OrderDeleted(this.id);
}

class OrderStocked extends OrderState {
  final String orderId;
  OrderStocked(this.orderId);
}

class OrderAllStocked extends OrderState {}
