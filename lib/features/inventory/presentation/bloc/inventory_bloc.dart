import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/usecases/get_inventory_items.dart';
import 'package:stockpro/features/inventory/domain/usecases/watch_inventory_items.dart';
import '../../domain/entities/inventory_item_entity.dart';
import '../../domain/usecases/add_inventory_item.dart';
import '../../domain/usecases/adjust_inventory_quantity.dart';
import '../../domain/usecases/delete_inventory_item.dart';
import '../../domain/usecases/get_low_stock_items.dart';
import '../../domain/usecases/update_inventory_item.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetItems getItems;
  final AddInventoryItem addItem;
  final UpdateInventoryItem updateItem;
  final DeleteInventoryItem deleteItem;
  final AdjustInventoryQuantity adjustQuantity;
  final GetLowStockItems getLowStockItems;
  final WatchInventoryItems watchInventoryItems;

  StreamSubscription<Either<Failure, List<InventoryItemEntity>>>?
      _watchSubscription;

  InventoryBloc({
    required this.getItems,
    required this.addItem,
    required this.updateItem,
    required this.deleteItem,
    required this.adjustQuantity,
    required this.getLowStockItems,
    required this.watchInventoryItems,
  }) : super(InventoryInitial()) {
    on<LoadInventoryItems>(_onLoadItems);
    on<AddInventoryItemEvent>(_onAddItem);
    on<UpdateInventoryItemEvent>(_onUpdateItem);
    on<DeleteInventoryItemEvent>(_onDeleteItem);
    on<AdjustInventoryQuantityEvent>(_onAdjustQuantity);
    on<LoadLowStockItemsEvent>(_onLowStockItems);
    on<WatchInventoryItemsEvent>(_onWatchInventoryItems);
    on<_EmitLoadedStateEvent>(
        (event, emit) => emit(InventoryLoaded(event.items)));
    on<_EmitErrorStateEvent>(
        (event, emit) => emit(InventoryError(event.message)));
  }

  Future<void> _onLoadItems(
      LoadInventoryItems event, Emitter<InventoryState> emit) async {
    //emit(InventoryLoading());
    final result = await getItems();
    result.fold(
      (failure) => emit(InventoryError(failure.message)),
      (items) => emit(InventoryLoaded(items)),
    );
  }

  Future<void> _onAddItem(
      AddInventoryItemEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await addItem.call(event.item);
    result.fold(
      (failure) => emit(InventoryError(failure.message)),
      (item) => emit(InventoryOperationSuccess(item)),
    );
  }

  Future<void> _onUpdateItem(
      UpdateInventoryItemEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await updateItem.call(event.item);
    result.fold(
      (failure) => emit(InventoryError(failure.message)),
      (item) {
        emit(InventoryOperationSuccess(item));
        add(WatchInventoryItemsEvent());
      },
    );
  }

  Future<void> _onDeleteItem(
      DeleteInventoryItemEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());

    final result = await deleteItem.call(event.id);

    result.fold(
      (failure) {
        emit(InventoryError(failure.message));
      },
      (_) {
        emit(InventoryDeleted());
      },
    );
  }

  Future<void> _onAdjustQuantity(
      AdjustInventoryQuantityEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await adjustQuantity.call(event.id, event.adjustment);
    result.fold(
      (failure) => emit(InventoryAdjustmentError(failure.message)),
      // (item) => emit(InventoryOperationSuccess(item)),
      (item) {
        emit(InventoryOperationSuccess(item));
        add(WatchInventoryItemsEvent());
      },
    );
  }

  Future<void> _onLowStockItems(
      LoadLowStockItemsEvent event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    final result = await getLowStockItems.call(event.threshold);
    result.fold(
      (failure) => emit(InventoryError(failure.message)),
      (items) => emit(InventoryLoaded(items)),
    );
  }

  Future<void> _onWatchInventoryItems(
      WatchInventoryItemsEvent event, Emitter<InventoryState> emit) async {
    print("watch clicked: ");
    emit(InventoryLoading());
    _watchSubscription?.cancel();

    _watchSubscription = watchInventoryItems().listen((result) {
      result.fold(
        (failure) => add(_EmitErrorStateEvent(failure.message)),
        (items) => add(_EmitLoadedStateEvent(items)),
      );
    });
  }

  @override
  Future<void> close() async {
    _watchSubscription?.cancel();
    return super.close();
  }
}
