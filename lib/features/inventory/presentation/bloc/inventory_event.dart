part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventoryItems extends InventoryEvent {}

class AddInventoryItemEvent extends InventoryEvent {
  final InventoryItemEntity item;

  const AddInventoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateInventoryItemEvent extends InventoryEvent {
  final InventoryItemEntity item;

  const UpdateInventoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteInventoryItemEvent extends InventoryEvent {
  final String id;

  const DeleteInventoryItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AdjustInventoryQuantityEvent extends InventoryEvent {
  final String id;
  final int adjustment;

  const AdjustInventoryQuantityEvent(this.id, this.adjustment);

  @override
  List<Object?> get props => [id, adjustment];
}

class LoadLowStockItemsEvent extends InventoryEvent {
  final int threshold;

  const LoadLowStockItemsEvent(this.threshold);

  @override
  List<Object?> get props => [threshold];
}

class WatchInventoryItemsEvent extends InventoryEvent {}

class _EmitLoadedStateEvent extends InventoryEvent {
  final List<InventoryItemEntity> items;

  _EmitLoadedStateEvent(this.items);
}

class _EmitErrorStateEvent extends InventoryEvent {
  final String message;

  _EmitErrorStateEvent(this.message);
}
