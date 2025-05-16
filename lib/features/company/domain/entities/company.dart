class Company {
  final String id;
  final String name;
  final String adminUid;
  final String secret;
  final DateTime createdAt;
  final String? imageUrl; // Added optional imageUrl
  final Map<String, dynamic>? settings;

  Company({
    required this.id,
    required this.name,
    required this.adminUid,
    required this.secret,
    required this.createdAt,
    this.imageUrl, // Initialize imageUrl in the constructor
    this.settings,
  });

  Company copyWith({
    String? id,
    String? name,
    String? adminUid,
    String? secret,
    DateTime? createdAt,
    String? imageUrl, // Added imageUrl to copyWith
    Map<String, dynamic>? settings,
  }) {
    return Company(
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
    return 'Company(id: $id, name: $name, adminUid: $adminUid, secret: $secret, createdAt: $createdAt, imageUrl: $imageUrl, settings: $settings)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company &&
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
