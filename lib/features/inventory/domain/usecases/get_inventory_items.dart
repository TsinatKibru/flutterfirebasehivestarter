import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class GetItems {
  final InventoryRepository repository;

  GetItems(this.repository);

  Future<Either<Failure, List<InventoryItemEntity>>> call() async {
    return await repository.getItems().then(
          (either) => either.map(
            (items) => items.toList(),
          ),
        );
  }
}
