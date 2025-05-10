import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';

class DeleteWarehouse {
  final WarehouseRepository repository;

  DeleteWarehouse(this.repository);

  Future<void> call(String id) async {
    await repository.deleteWarehouse(id);
  }
}
