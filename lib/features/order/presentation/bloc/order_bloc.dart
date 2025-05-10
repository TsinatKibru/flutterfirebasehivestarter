import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/order/domain/usecases/bulk_stock_orders.dart';
import 'package:stockpro/features/order/domain/usecases/delete_order.dart';
import 'package:stockpro/features/order/domain/usecases/get_all_orders.dart';
import 'package:stockpro/features/order/domain/usecases/add_order.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/domain/usecases/mark_order_as_stocked.dart';
import 'package:stockpro/features/order/domain/usecases/update_order.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetAllOrders getAllOrders;
  final AddOrder addOrder;
  final UpdateOrder updateOrder;
  final DeleteOrder deleteOrder;
  final MarkOrderAsStocked markOrderAsStocked;
  final BulkStockOrders bulkStockOrders;

  OrderBloc({
    required this.getAllOrders,
    required this.addOrder,
    required this.updateOrder,
    required this.deleteOrder,
    required this.markOrderAsStocked,
    required this.bulkStockOrders,
  }) : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<AddNewOrder>(_onAddNewOrder);
    on<UpdateExistingOrder>(_onUpdateOrder);
    on<DeleteExistingOrder>(_onDeleteOrder);
    on<StockSingleOrder>(_onStockSingleOrder);
    on<StockAllOrders>(_onStockAllOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    // emit(OrderLoading());
    try {
      final stream = await getAllOrders();
      await emit.forEach<List<OrderEntity>>(
        stream,
        onData: (orders) => OrderLoaded(orders),
        onError: (e, _) => OrderError(e.toString()),
      );
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onAddNewOrder(
    AddNewOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await addOrder(event.order);
      emit(OrderAdded(event.order));
      add(LoadOrders()); // Refresh after adding
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onUpdateOrder(
    UpdateExistingOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await updateOrder(event.order);
      emit(OrderUpdated(event.order));
      add(LoadOrders());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onDeleteOrder(
    DeleteExistingOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await deleteOrder(event.id);
      emit(OrderDeleted(event.id));
      add(LoadOrders());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onStockSingleOrder(
    StockSingleOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await markOrderAsStocked(event.order);
      emit(OrderStocked(event.order.id));
      add(LoadOrders());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onStockAllOrders(
    StockAllOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await bulkStockOrders(event.orders);
      emit(OrderAllStocked());
      add(LoadOrders());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
