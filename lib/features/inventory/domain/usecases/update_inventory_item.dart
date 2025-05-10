import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class UpdateInventoryItem {
  final InventoryRepository repository;

  UpdateInventoryItem(this.repository);

  Future<Either<Failure, InventoryItemEntity>> call(
      InventoryItemEntity item) async {
    // Validate required fields
    if (item.name.isEmpty) {
      return left(ServerFailure('Item name cannot be empty'));
    }
    if (item.quantity < 0) {
      return left(ServerFailure('Quantity cannot be negative'));
    }

    // Check if item exists
    final existingItems = await repository.getItems();
    return existingItems.fold(
      (failure) => left(failure),
      (items) async {
        if (!items.any((i) => i.id == item.id)) {
          return left(ServerFailure('Item not found'));
        }

        // Check for name conflict with other items
        if (items.any((i) => i.id != item.id && i.name == item.name)) {
          return left(
              ServerFailure('Another item with this name already exists'));
        }

        // Update timestamp

        return await repository.updateItem(item);
      },
    );
  }
}
