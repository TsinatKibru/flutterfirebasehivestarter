import 'package:equatable/equatable.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserUpdated extends UserState {
  final UserEntity user;

  const UserUpdated(this.user);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
