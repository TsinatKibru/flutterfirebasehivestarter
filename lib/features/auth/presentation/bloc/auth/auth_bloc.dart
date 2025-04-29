import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/errors/failure.dart';
import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
import 'package:stockpro/features/auth/domain/usecases/is_signed_in.dart';
import 'package:stockpro/features/auth/domain/usecases/sign_in.dart';
import 'package:stockpro/features/auth/domain/usecases/sign_out.dart';
import 'package:stockpro/features/auth/domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
  final IsSignedIn isSignedIn;
  final SignOut signOut;

  AuthBloc({
    required this.signInWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
    required this.isSignedIn,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result =
        await signInWithEmailAndPassword(event.email, event.password);

    result.match(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) {
        if (user != null) {
          emit(Authenticated(
            user: user,
          ));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result =
        await signUpWithEmailAndPassword(event.email, event.password);

    result.match(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) {
        if (user != null) {
          emit(Authenticated(
            user: user,
          ));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await isSignedIn();

    result.match(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) {
        if (user != null) {
          emit(Authenticated(
            user: user,
          ));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOut();

    result.match(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(Unauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return 'Cache Error: ${failure.message}';
    } else {
      return 'Unexpected error';
    }
  }

  // Future<void> _isSignedIn(
  //   CheckAuthenticationStatus event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     final isLoggedIn = await isSignedIn();
  //     if (isLoggedIn) {
  //       emit(Authenticated(
  //           user: UserEntity(
  //         id: '',
  //         email: '',
  //         lastLogin: DateTime.now(),
  //       ))); // Ideally fetch real user details
  //     } else {
  //       emit(Unauthenticated());
  //     }
  //   } catch (e) {
  //     emit(AuthError(message: e.toString()));
  //   }
  // }
}
