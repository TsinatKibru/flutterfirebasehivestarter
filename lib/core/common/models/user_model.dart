import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    String? name,
    String? photoUrl,
    required DateTime lastLogin,
    String? companyId, // Made optional here as well
    String? role,
  }) : super(
          id: id,
          email: email,
          name: name,
          photoUrl: photoUrl,
          lastLogin: lastLogin,
          companyId: companyId,
          role: role,
        );

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? lastLogin,
    String? companyId,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      lastLogin: lastLogin ?? this.lastLogin,
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
    );
  }

  /// From Firestore or Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final raw = map['lastLogin'];
    DateTime parsedDate;
    if (raw is Timestamp) {
      parsedDate = raw.toDate();
    } else if (raw is String) {
      parsedDate = DateTime.parse(raw);
    } else {
      throw FormatException('Unsupported lastLogin format: $raw');
    }

    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      lastLogin: parsedDate,
      companyId: map['companyId'] as String?, // Now handles potential null
      role: map['role'] as String? ?? '',
    );
  }

  /// To Firestore or Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'lastLogin': Timestamp.fromDate(lastLogin),
      'companyId': companyId, // Can be null now
      'role': role,
    };
  }

  /// From domain entity to model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      lastLogin: entity.lastLogin,
      companyId: entity.companyId, // Passes the potentially null value
      role: entity.role,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      lastLogin: lastLogin,
      companyId: companyId,
      role: role,
    );
  }
}
