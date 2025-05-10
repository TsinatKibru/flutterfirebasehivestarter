import 'package:equatable/equatable.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';

abstract class WarehouseEvent extends Equatable {
  const WarehouseEvent();

  @override
  List<Object?> get props => [];
}

class LoadWarehouses extends WarehouseEvent {}

class AddNewWarehouse extends WarehouseEvent {
  final WarehouseEntity warehouse;

  const AddNewWarehouse(this.warehouse);

  @override
  List<Object?> get props => [warehouse];
}

class UpdateExistingWarehouse extends WarehouseEvent {
  final WarehouseEntity warehouse;

  const UpdateExistingWarehouse(this.warehouse);

  @override
  List<Object?> get props => [warehouse];
}

class DeleteWarehouseById extends WarehouseEvent {
  final String id;

  const DeleteWarehouseById(this.id);

  @override
  List<Object?> get props => [id];
}
