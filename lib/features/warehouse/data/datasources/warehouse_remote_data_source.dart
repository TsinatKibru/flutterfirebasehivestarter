import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/utils/user_utils.dart';
import 'package:stockpro/features/warehouse/data/models/warehouse_model.dart';

abstract class WarehouseRemoteDataSource {
  Stream<List<WarehouseModel>> getWarehouses();
  Future<void> addWarehouse(WarehouseModel warehouse);
  Future<void> updateWarehouse(WarehouseModel warehouse);
  Future<void> deleteWarehouse(String id);
}

class WarehouseRemoteDataSourceImpl implements WarehouseRemoteDataSource {
  final FirebaseFirestore firestore;

  WarehouseRemoteDataSourceImpl(this.firestore);

  // @override
  // Stream<List<WarehouseModel>> getWarehouses() {
  //   return firestore.collection('warehouses').snapshots().map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => WarehouseModel.fromDocument(doc))
  //             .toList(),
  //       );
  // }
  @override
  Stream<List<WarehouseModel>> getWarehouses() async* {
    final companyId = await getCurrentUserCompanyId();

    if (companyId == null) {
      print('⚠️ Cannot stream warehouses without companyId.');
      yield [];
      return;
    }

    yield* firestore
        .collection('warehouses')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WarehouseModel.fromDocument(doc))
              .toList(),
        );
  }

  @override
  Future<void> addWarehouse(WarehouseModel warehouse) {
    return firestore.collection('warehouses').add(warehouse.toDocument());
  }

  @override
  Future<void> updateWarehouse(WarehouseModel warehouse) {
    return firestore
        .collection('warehouses')
        .doc(warehouse.id)
        .update(warehouse.toDocument());
  }

  @override
  Future<void> deleteWarehouse(String id) {
    return firestore.collection('warehouses').doc(id).delete();
  }
}
