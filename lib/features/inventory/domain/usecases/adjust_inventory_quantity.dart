import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class AdjustInventoryQuantity {
  final InventoryRepository repository;

  AdjustInventoryQuantity(this.repository);

  Future<Either<Failure, InventoryItemEntity>> call(
    String itemId,
    int adjustment,
  ) async {
    // Get the item first
    final itemsResult = await repository.getItems();
    return itemsResult.fold(
      (failure) => left(failure),
      (items) async {
        final item = items.firstWhere(
          (i) => i.id == itemId,
          orElse: () => InventoryItemEntity.empty(),
        );

        if (item.id.isEmpty) {
          return left(ServerFailure('Item not found'));
        }

        final newQuantity = item.quantity + adjustment;
        if (newQuantity < 0) {
          return left(ServerFailure('Resulting quantity cannot be negative'));
        }

        final updatedItem = item.copyWith(
          quantity: newQuantity,
        );

        return await repository.updateItem(updatedItem);
      },
    );
  }
}
