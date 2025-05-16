import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/users/domain/usecases/add_user.dart';
import 'package:stockpro/features/users/domain/usecases/delete_user.dart';
import 'package:stockpro/features/users/domain/usecases/get_all_users.dart';
import 'package:stockpro/features/users/domain/usecases/update_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUsers getAllUsers;
  final AddUser addUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  UserBloc({
    required this.getAllUsers,
    required this.addUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddNewUser>(_onAddNewUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  StreamSubscription<List<UserEntity>>? _userSubscription;

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserState> emit,
  ) async {
    print('[UserBloc] Loading users...');
    emit(UserLoading());

    try {
      final stream = await getAllUsers();
      await emit.forEach<List<UserEntity>>(
        stream,
        onData: (users) {
          print('[UserBloc] Received ${users.length} users');
          print(users);
          return UserLoaded(users);
        },
        onError: (error, stackTrace) {
          print('[UserBloc] Error loading users: $error');
          return UserError(error.toString());
        },
      );
    } catch (e, stackTrace) {
      print('[UserBloc] Unexpected error: $e');
      print('[UserBloc] StackTrace:\n$stackTrace');
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddNewUser(AddNewUser event, Emitter<UserState> emit) async {
    try {
      await addUser(event.user);
      add(LoadUsers()); // Refresh after adding
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await updateUser(event.user);
      emit(UserUpdated(event.user));
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await deleteUser(event.userId);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
