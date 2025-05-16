import 'package:equatable/equatable.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class AddNewUser extends UserEvent {
  final UserEntity user;

  const AddNewUser(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final UserEntity user;

  const UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final String userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
