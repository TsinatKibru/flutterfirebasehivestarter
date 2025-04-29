class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime lastLogin;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.lastLogin,
  });

  // Add equality comparison and other domain methods
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
    return 'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, lastLogin: $lastLogin)';
  }
}
