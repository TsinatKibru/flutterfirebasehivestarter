part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItemEntity> items;

  const InventoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class InventoryOperationSuccess extends InventoryState {
  final InventoryItemEntity item;

  const InventoryOperationSuccess(this.item);

  @override
  List<Object?> get props => [item];
}

class InventoryDeleted extends InventoryState {}

class InventoryAdjustmentError extends InventoryState {
  final String message;

  const InventoryAdjustmentError(this.message);

  @override
  List<Object?> get props => [message];
}
