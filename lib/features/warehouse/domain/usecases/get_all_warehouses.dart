import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';

class GetAllWarehouses {
  final WarehouseRepository repository;

  GetAllWarehouses(this.repository);

  Future<Stream<List<WarehouseEntity>>> call() async {
    return repository.getWarehouses();
  }
}
