import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class DeleteInventoryItem {
  final InventoryRepository repository;

  DeleteInventoryItem(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    if (id.isEmpty) {
      print("empty: ${id.isEmpty}");
      return left(ServerFailure('Invalid item ID'));
    }

    // Verify item exists before deleting
    //final existingItems = await repository.getItems();

    // return existingItems.fold(
    //   (failure) => left(failure),
    //   (items) async {
    //     if (!items.any((i) => i.id == id)) {
    //       return left(ServerFailure('Item not found'));
    //     }

    //     return await repository.deleteItem(id);
    //   },
    // );
    return await repository.deleteItem(id);
  }
}
