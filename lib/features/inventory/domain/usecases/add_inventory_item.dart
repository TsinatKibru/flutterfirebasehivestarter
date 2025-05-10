import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class AddInventoryItem {
  final InventoryRepository repository;

  AddInventoryItem(this.repository);

  Future<Either<Failure, InventoryItemEntity>> call(
      InventoryItemEntity item) async {
    // Validate required fields
    if (item.name.isEmpty) {
      return left(ServerFailure('Item name cannot be empty'));
    }
    if (item.quantity < 0) {
      return left(ServerFailure('Quantity cannot be negative'));
    }

    // Check for existing item with same name
    final existingItems = await repository.getItems();
    return existingItems.fold(
      (failure) => left(failure),
      (items) async {
        if (items.any((i) => i.name == item.name)) {
          return left(ServerFailure('Item with this name already exists'));
        }

        // Add timestamps

        return await repository.addItem(item);
      },
    );
  }
}
