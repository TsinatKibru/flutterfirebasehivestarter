import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';

class AddWarehouse {
  final WarehouseRepository repository;

  AddWarehouse(this.repository);

  Future<void> call(WarehouseEntity warehouse) async {
    await repository.addWarehouse(warehouse);
  }
}
