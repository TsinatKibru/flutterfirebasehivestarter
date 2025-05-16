import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/constants/secrets.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/utils/user_utils.dart';
import 'package:stockpro/features/inventory/data/models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  Future<InventoryItemModel> addItem(InventoryItemModel item);
  Future<List<InventoryItemModel>> getItems();
  Future<InventoryItemModel> updateItem(InventoryItemModel item);
  Future<void> deleteItem(String id);
  Stream<List<InventoryItemModel>>
      watchItems(); // Changed from Future to Stream
  Future<String?> uploadImageAndGetUrl(String? localImagePath);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore firestore;

  InventoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<InventoryItemModel> addItem(InventoryItemModel item) async {
    try {
      final docRef = await firestore.collection('inventory').add(item.toMap());
      final doc = await docRef.get();
      return InventoryItemModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to add inventory item: $e');
    }
  }

  @override
  Future<List<InventoryItemModel>> getItems() async {
    try {
      final snapshot = await firestore.collection('inventory').get();
      return snapshot.docs
          .map((doc) => InventoryItemModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch inventory items: $e');
    }
  }

  @override
  Future<InventoryItemModel> updateItem(InventoryItemModel item) async {
    try {
      await firestore.collection('inventory').doc(item.id).update(item.toMap());
      final updatedDoc =
          await firestore.collection('inventory').doc(item.id).get();
      return InventoryItemModel.fromMap(updatedDoc.data()!, updatedDoc.id);
    } catch (e) {
      throw ServerException('Failed to update inventory item: $e');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await firestore.collection('inventory').doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete inventory item: $e');
    }
  }

  // @override
  // Stream<List<InventoryItemModel>> watchItems() {
  //   try {
  //     return firestore
  //         .collection('inventory')
  //         .orderBy('createdAt', descending: true)
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs
  //           .map((doc) => InventoryItemModel.fromMap(doc.data(), doc.id))
  //           .toList();
  //     });
  //   } catch (e) {
  //     throw ServerException('Failed to stream inventory items: $e');
  //   }
  // }
  Stream<List<InventoryItemModel>> watchItems() async* {
    final companyId = await getCurrentUserCompanyId();

    if (companyId == null) {
      print('⚠️ Cannot stream items without companyId.');
      yield [];
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('inventory')
        .where('companyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('📦 Inventory snapshot with ${snapshot.docs.length} items');
      return snapshot.docs
          .map((doc) => InventoryItemModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String?> uploadImageAndGetUrl(String? localImagePath) async {
    if (localImagePath == null || !localImagePath.startsWith('file://')) {
      return localImagePath; // Already a remote URL or null
    }

    final String cloudName = Secrets.cloudinaryCloudName;
    final String uploadPreset = Secrets.cloudinaryuploadpreset;

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;

    final File imageFile = File(localImagePath.replaceFirst('file://', ''));

    if (!await imageFile.exists()) {
      throw ServerException(
          'Image file does not exist at path: $localImagePath');
    }

    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);
      final publicId = jsonMap['public_id'];
      return 'https://res.cloudinary.com/$cloudName/image/upload/$publicId';
    } else {
      throw ServerException(
          'Image upload failed with status ${response.statusCode}');
    }
  }
}
