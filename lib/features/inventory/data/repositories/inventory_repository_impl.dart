import 'package:fpdart/fpdart.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:stockpro/features/inventory/data/models/inventory_item_model.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<Either<Failure, InventoryItemEntity>> addItem(
  //     InventoryItemEntity item) async {
  //   try {
  //     final InventoryItemModel model = InventoryItemModel.fromEntity(item);
  //     final addedItem = await remoteDataSource.addItem(model);
  //     return Right(addedItem.toEntity());
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, InventoryItemEntity>> addItem(
      InventoryItemEntity item) async {
    try {
      String? uploadedImageUrl;
      // final uploadedImageUrl =
      //     await remoteDataSource.uploadImageAndGetUrl(item.imageUrl);
      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(item.imageUrl);
      } catch (e) {
        print("⚠️ Image upload failed: $e");
        uploadedImageUrl = null;
      }
      final updatedItem = item.copyWith(imageUrl: uploadedImageUrl);

      final model = InventoryItemModel.fromEntity(updatedItem);
      final addedItem = await remoteDataSource.addItem(model);

      return Right(addedItem.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InventoryItemEntity>>> getItems() async {
    try {
      final itemList = await remoteDataSource.getItems();
      return Right(itemList.map((item) => item.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, InventoryItemEntity>> updateItem(
  //     InventoryItemEntity item) async {
  //   try {
  //     final InventoryItemModel model = InventoryItemModel.fromEntity(item);
  //     final updatedItem = await remoteDataSource.updateItem(model);
  //     return Right(updatedItem.toEntity());
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   }
  // }
  @override
  Future<Either<Failure, InventoryItemEntity>> updateItem(
      InventoryItemEntity item) async {
    try {
      final uploadedImageUrl =
          await remoteDataSource.uploadImageAndGetUrl(item.imageUrl);
      final updatedItem = item.copyWith(imageUrl: uploadedImageUrl);

      final model = InventoryItemModel.fromEntity(updatedItem);
      final result = await remoteDataSource.updateItem(model);

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      await remoteDataSource.deleteItem(id);
      return Right(unit); // Successful deletion, no return data
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<InventoryItemEntity>>> watchItems() async* {
    try {
      await for (final snapshot in remoteDataSource.watchItems()) {
        yield Right(snapshot.map((item) => item.toEntity()).toList());
      }
    } catch (e) {
      yield Left(ServerFailure('Failed to stream inventory items: $e'));
    }
  }
}
