import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasource/auth_remote_data_source.dart';
import 'features/auth/data/datasource/auth_local_data_source.dart';
import 'features/auth/data/model/user_model.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/is_signed_in.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await _initCore();
  _initAuth();
}

Future<void> _initCore() async {
  // Database
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('user_box');

  // Firebase
  await Firebase.initializeApp();
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Network
  sl.registerSingleton<Dio>(Dio());
}

void _initAuth() {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(Hive.box<UserModel>('user_box')),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        sl<AuthRemoteDataSource>(), sl<AuthLocalDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(
      () => SignInWithEmailAndPassword(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => SignUpWithEmailAndPassword(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsSignedIn(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmailAndPassword: sl<SignInWithEmailAndPassword>(),
      signUpWithEmailAndPassword: sl<SignUpWithEmailAndPassword>(),
      isSignedIn: sl<IsSignedIn>(),
      signOut: sl<SignOut>(),
    ),
  );
}

List<BlocProvider> getBlocProviders() {
  return [
    BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>()..add(CheckAuthenticationStatus())),
  ];
}
