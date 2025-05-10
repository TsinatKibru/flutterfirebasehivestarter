import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';

class UpdateWarehouse {
  final WarehouseRepository repository;

  UpdateWarehouse(this.repository);

  Future<void> call(WarehouseEntity warehouse) async {
    await repository.updateWarehouse(warehouse);
  }
}
