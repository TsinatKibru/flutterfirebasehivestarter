class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime lastLogin;
  final String? companyId;
  final String? role;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.lastLogin,
    this.companyId,
    this.role,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? lastLogin,
    String? companyId,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      lastLogin: lastLogin ?? this.lastLogin,
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, lastLogin: $lastLogin, companyId: $companyId, role: $role)';
  }
}
