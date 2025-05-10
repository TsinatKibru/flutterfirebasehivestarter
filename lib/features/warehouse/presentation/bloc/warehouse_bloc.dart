import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/domain/usecases/get_all_warehouses.dart';
import 'package:stockpro/features/warehouse/domain/usecases/add_warehouse.dart';
import 'package:stockpro/features/warehouse/domain/usecases/update_warehouse.dart';
import 'package:stockpro/features/warehouse/domain/usecases/delete_warehouse.dart';
import 'warehouse_event.dart';
import 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final GetAllWarehouses getAllWarehouses;
  final AddWarehouse addWarehouse;
  final UpdateWarehouse updateWarehouse;
  final DeleteWarehouse deleteWarehouse;

  WarehouseBloc({
    required this.getAllWarehouses,
    required this.addWarehouse,
    required this.updateWarehouse,
    required this.deleteWarehouse,
  }) : super(WarehouseInitial()) {
    on<LoadWarehouses>(_onLoadWarehouses);
    on<AddNewWarehouse>(_onAddWarehouse);
    on<UpdateExistingWarehouse>(_onUpdateWarehouse);
    on<DeleteWarehouseById>(_onDeleteWarehouse);
  }

  Future<void> _onLoadWarehouses(
    LoadWarehouses event,
    Emitter<WarehouseState> emit,
  ) async {
    emit(WarehouseLoading());
    try {
      final stream = await getAllWarehouses();
      await emit.forEach<List<WarehouseEntity>>(
        stream,
        onData: (data) {
          return WarehouseLoaded(data);
        },
        onError: (e, _) => WarehouseError(e.toString()),
      );
    } catch (e) {
      emit(WarehouseError(e.toString()));
    }
  }

  Future<void> _onAddWarehouse(
    AddNewWarehouse event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      await addWarehouse(event.warehouse);
      add(LoadWarehouses()); // Refresh list
    } catch (e) {
      emit(WarehouseError(e.toString()));
    }
  }

  Future<void> _onUpdateWarehouse(
    UpdateExistingWarehouse event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      await updateWarehouse(event.warehouse);
      add(LoadWarehouses());
    } catch (e) {
      emit(WarehouseError(e.toString()));
    }
  }

  Future<void> _onDeleteWarehouse(
    DeleteWarehouseById event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      await deleteWarehouse(event.id);
      add(LoadWarehouses());
    } catch (e) {
      emit(WarehouseError(e.toString()));
    }
  }
}
