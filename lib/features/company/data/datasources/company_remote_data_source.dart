import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/core/constants/secrets.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/features/company/data/models/company_model.dart';

abstract class CompanyRemoteDataSource {
  Future<void> createCompany(CompanyModel company);
  Stream<CompanyModel> getCompanyById(String id);
  Future<CompanyModel?> getCompanyBySecret(String secret);
  Future<void> updateCompany(CompanyModel company);
  Future<String?> uploadImageAndGetUrl(String? localImagePath);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final FirebaseFirestore firestore;

  CompanyRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createCompany(CompanyModel company) async {
    await firestore
        .collection('companies')
        .doc(company.id)
        .set(company.toMap());
  }

  // @override
  // Future<CompanyModel> getCompanyById(String id) async {
  //   final doc = await firestore.collection('companies').doc(id).get();
  //   return CompanyModel.fromFirestore(doc);
  // }
  @override
  Stream<CompanyModel> getCompanyById(String id) {
    return firestore
        .collection('companies')
        .doc(id)
        .snapshots()
        .map((doc) => CompanyModel.fromFirestore(doc));
  }

  // @override
  // Future<CompanyModel?> getCompanyBySecret(String secret) async {
  //   final query = await firestore
  //       .collection('companies')
  //       .where('secret', isEqualTo: secret)
  //       .limit(1)
  //       .get();

  //   if (query.docs.isEmpty) return null;
  //   return CompanyModel.fromFirestore(query.docs.first);
  // }
  @override
  Future<CompanyModel?> getCompanyBySecret(String secret) async {
    final query = await firestore
        .collection('companies')
        .where('secret', isEqualTo: secret)
        .limit(2) // Fetch up to 2 to check for duplicates
        .get();

    if (query.docs.isEmpty) return null;

    if (query.docs.length > 1) {
      // Internal log, alerting, or analytics hook here
      print('Warning: Multiple companies found for secret "$secret"');

      // Optionally, send this to error monitoring:
      // FirebaseCrashlytics.instance.log(...);

      return null; // or decide which one to return, but silently
    }

    return CompanyModel.fromFirestore(query.docs.first);
  }

  @override
  Future<void> updateCompany(CompanyModel company) async {
    final imageUrl = await uploadImageAndGetUrl(company.imageUrl);
    final updatedCompanyMap = company.toMap();
    if (imageUrl != null) {
      updatedCompanyMap['imageUrl'] = imageUrl;
    }
    await firestore
        .collection('companies')
        .doc(company.id)
        .update(updatedCompanyMap);
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
