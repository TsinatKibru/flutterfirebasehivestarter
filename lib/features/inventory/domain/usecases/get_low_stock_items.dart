import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class GetLowStockItems {
  final InventoryRepository repository;

  GetLowStockItems(this.repository);

  Future<Either<Failure, List<InventoryItemEntity>>> call(int threshold) async {
    if (threshold < 0) {
      return left(ServerFailure('Threshold cannot be negative'));
    }

    return await repository.getItems().then(
          (either) => either.map(
            (items) =>
                items.where((item) => item.quantity <= threshold).toList(),
          ),
        );
  }
}
