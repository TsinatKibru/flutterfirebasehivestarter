import 'package:equatable/equatable.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';

abstract class WarehouseState extends Equatable {
  const WarehouseState();

  @override
  List<Object?> get props => [];
}

class WarehouseInitial extends WarehouseState {}

class WarehouseLoading extends WarehouseState {}

class WarehouseLoaded extends WarehouseState {
  final List<WarehouseEntity> warehouses;

  const WarehouseLoaded(this.warehouses);

  @override
  List<Object?> get props => [warehouses];
}

class WarehouseError extends WarehouseState {
  final String message;

  const WarehouseError(this.message);

  @override
  List<Object?> get props => [message];
}
