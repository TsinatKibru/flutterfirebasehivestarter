import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';

abstract class WarehouseRepository {
  Stream<List<WarehouseEntity>> getWarehouses();
  Future<void> addWarehouse(WarehouseEntity warehouse);
  Future<void> updateWarehouse(WarehouseEntity warehouse);
  Future<void> deleteWarehouse(String id);
}
