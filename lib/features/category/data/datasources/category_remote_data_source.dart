import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/constants/secrets.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/features/category/data/models/category_model.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRemoteDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId);
  Stream<List<CategoryModel>> getCategories();
  Future<String?> uploadImageAndGetUrl(String? localImagePath);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final categoryCollection = 'categories';

  CategoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addCategory(CategoryModel category) async {
    print("category: ${category}");
    await firestore
        .collection(categoryCollection)
        .doc(category.id)
        .set(category.toMap());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await firestore
        .collection(categoryCollection)
        .doc(category.id)
        .update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await firestore.collection(categoryCollection).doc(categoryId).delete();
  }

  @override
  Stream<List<CategoryModel>> getCategories() {
    return firestore.collection(categoryCollection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
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
