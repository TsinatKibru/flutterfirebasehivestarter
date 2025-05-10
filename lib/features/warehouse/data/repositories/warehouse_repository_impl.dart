import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';
import 'package:stockpro/features/warehouse/data/datasources/warehouse_remote_data_source.dart';
import 'package:stockpro/features/warehouse/data/models/warehouse_model.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseRemoteDataSource remoteDataSource;

  WarehouseRepositoryImpl(this.remoteDataSource);
  @override
  Stream<List<WarehouseEntity>> getWarehouses() {
    return remoteDataSource.getWarehouses().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> addWarehouse(WarehouseEntity warehouse) {
    final WarehouseModel model = WarehouseModel.fromEntity(warehouse);

    return remoteDataSource.addWarehouse(model);
  }

  @override
  Future<void> updateWarehouse(WarehouseEntity warehouse) {
    final WarehouseModel model = WarehouseModel.fromEntity(warehouse);
    return remoteDataSource.updateWarehouse(model);
  }

  @override
  Future<void> deleteWarehouse(String id) {
    return remoteDataSource.deleteWarehouse(id);
  }
}
