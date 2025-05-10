import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, InventoryItemEntity>> addItem(
      InventoryItemEntity item);
  Future<Either<Failure, List<InventoryItemEntity>>> getItems();
  Future<Either<Failure, InventoryItemEntity>> updateItem(
      InventoryItemEntity item);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Stream<Either<Failure, List<InventoryItemEntity>>> watchItems();
}
