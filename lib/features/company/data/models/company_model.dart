import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';

class CompanyModel extends Company {
  CompanyModel({
    required String id,
    required String name,
    required String adminUid,
    required String secret,
    required DateTime createdAt,
    String? imageUrl, // Added optional imageUrl
    Map<String, dynamic>? settings,
  }) : super(
          id: id,
          name: name,
          adminUid: adminUid,
          secret: secret,
          createdAt: createdAt,
          imageUrl: imageUrl, // Pass imageUrl to the superclass
          settings: settings,
        );

  factory CompanyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CompanyModel(
      id: doc.id,
      name: data['name'],
      adminUid: data['adminUid'],
      secret: data['secret'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'], // Retrieve imageUrl from Firestore
      settings: data['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'adminUid': adminUid,
      'secret': secret,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl, // Include imageUrl in the map
      'settings': settings,
    };
  }

  factory CompanyModel.fromEntity(Company entity) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      adminUid: entity.adminUid,
      secret: entity.secret,
      createdAt: entity.createdAt,
      imageUrl: entity.imageUrl, // Retrieve imageUrl from the entity
      settings: entity.settings,
    );
  }

  Company toEntity() {
    return Company(
      id: id,
      name: name,
      adminUid: adminUid,
      secret: secret,
      createdAt: createdAt,
      imageUrl: imageUrl, // Pass imageUrl to the entity
      settings: settings,
    );
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? adminUid,
    String? secret,
    DateTime? createdAt,
    String? imageUrl, // Added imageUrl to copyWith
    Map<String, dynamic>? settings,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      adminUid: adminUid ?? this.adminUid,
      secret: secret ?? this.secret,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl, // Update imageUrl in copyWith
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() {
    return 'CompanyModel(id: $id, name: $name, adminUid: $adminUid, secret: $secret, createdAt: $createdAt, imageUrl: $imageUrl, settings: $settings)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          adminUid == other.adminUid &&
          secret == other.secret &&
          createdAt == other.createdAt &&
          imageUrl == other.imageUrl && // Compare imageUrl
          settings == other.settings;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      adminUid.hashCode ^
      secret.hashCode ^
      createdAt.hashCode ^
      imageUrl.hashCode ^ // Include imageUrl in hashCode
      settings.hashCode;
}
