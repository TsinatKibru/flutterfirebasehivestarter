import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/core/common/models/user_model.dart';
import '../../../../core/common/entities/user_entity.dart';

/// Interface for Firestore-based user operations
abstract class UserRemoteDataSource {
  /// Creates a new user document in Firestore
  Future createUser(UserModel user);

  /// Retrieves a user document by [id]
  Future getUser(String id);

  /// Updates an existing user document
  Future updateUser(UserModel user);

  /// Deletes a user document by [id]
  Future deleteUser(String id);

  Future<void> clearCache();
}

/// Implementation of [UserRemoteDataSource] using Firebase Firestore
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String _collection = 'users';

  UserRemoteDataSourceImpl({required this.firestore});

  // @override
  // Future createUser(UserModel user) async {
  //   try {
  //     await firestore.collection(_collection).doc(user.id).set(user.toMap());
  //   } on FirebaseException catch (e) {
  //     throw ServerException(e.message ?? 'Failed to create user');
  //   }
  // }
  @override
  Future createUser(UserModel user) async {
    try {
      final userData = user.toMap();
      final existingRole = userData['role'];

      if (existingRole == null ||
          existingRole.isEmpty ||
          (existingRole != 'staff' &&
              existingRole != 'admin' &&
              existingRole != 'manage')) {
        userData['role'] = 'staff'; // Default to 'staff' if no valid role
      }
      await firestore.collection(_collection).doc(user.id).set(userData);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create user');
    }
  }

  @override
  Future getUser(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw ServerException('User not found');
      }
      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch user');
    }
  }

  @override
  Future updateUser(UserModel user) async {
    try {
      await firestore.collection(_collection).doc(user.id).update(user.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update user');
    }
  }

  @override
  Future deleteUser(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete user');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await firestore.terminate();
      await firestore.clearPersistence();
    } on FirebaseException catch (e) {
      print("dkvbj:");
      throw ServerException('Failed to clear Firestore cache: ${e.message}');
    } catch (e) {
      print("kvbkjeghvrherv");
      throw ServerException('Unexpected error while clearing Firestore cache');
    }
  }
}

// Extend UserModel to support Firestore serialization
extension UserModelFirestoreX on UserModel {
  /// Convert [UserModel] to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  /// Create [UserModel] from a Firestore document map
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      lastLogin: DateTime.parse(map['lastLogin'] as String),
      companyId: map['companyId'] as String,
    );
  }
}
