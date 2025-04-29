import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final DateTime lastLogin;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.lastLogin,
  });

  // Convert from Entity to Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      lastLogin: entity.lastLogin,
    );
  }

  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      lastLogin: lastLogin,
    );
  }
}
