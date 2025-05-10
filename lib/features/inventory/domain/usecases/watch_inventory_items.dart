import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class WatchInventoryItems {
  final InventoryRepository repository;

  WatchInventoryItems(this.repository);

  Stream<Either<Failure, List<InventoryItemEntity>>> call() {
    return repository.watchItems();
  }
}
