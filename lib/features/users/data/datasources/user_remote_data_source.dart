import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/common/models/user_model.dart';
import 'package:stockpro/core/constants/secrets.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/utils/user_utils.dart';
import 'package:http/http.dart' as http;

abstract class UsersRemoteDataSource {
  Future<void> addUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Stream<List<UserModel>> getUsers();
  Future<String?> uploadImageAndGetUrl(String? localImagePath);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final FirebaseFirestore firestore;
  final userCollection = 'users';

  UsersRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addUser(UserModel user) async {
    await firestore.collection(userCollection).doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await firestore
        .collection(userCollection)
        .doc(user.id)
        .update(user.toMap());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await firestore.collection(userCollection).doc(userId).delete();
  }

  // @override
  // Stream<List<UserModel>> getUsers() {
  //   return firestore.collection(userCollection).snapshots().map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) =>
  //                 UserModel.fromMap(doc.data() as Map<String, dynamic>))
  //             .toList(),
  //       );
  // }
  @override
  Stream<List<UserModel>> getUsers() async* {
    final companyId = await getCurrentUserCompanyId();

    if (companyId == null) {
      print("⚠️ Cannot stream users without companyId.");
      yield [];
      return;
    }

    yield* firestore
        .collection(userCollection)
        .where('companyId', isEqualTo: companyId) // Add companyId filter
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  UserModel.fromMap(doc.data() as Map<String, dynamic>))
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
