import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get_it/get_it.dart';
import 'package:stockpro/core/constants/secrets.dart';
import 'package:stockpro/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:stockpro/features/category/data/datasources/category_remote_data_source.dart';
import 'package:stockpro/features/category/data/repositories/category_repository_impl.dart';
import 'package:stockpro/features/category/domain/repositories/category_repository.dart';
import 'package:stockpro/features/category/domain/usecases/add_category.dart';
import 'package:stockpro/features/category/domain/usecases/delete_category.dart';
import 'package:stockpro/features/category/domain/usecases/get_all_categories.dart';
import 'package:stockpro/features/category/domain/usecases/update_category.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_event.dart';
import 'package:stockpro/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:stockpro/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:stockpro/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:stockpro/features/inventory/domain/usecases/add_inventory_item.dart';
import 'package:stockpro/features/inventory/domain/usecases/adjust_inventory_quantity.dart';
import 'package:stockpro/features/inventory/domain/usecases/delete_inventory_item.dart';
import 'package:stockpro/features/inventory/domain/usecases/get_inventory_items.dart';
import 'package:stockpro/features/inventory/domain/usecases/get_low_stock_items.dart';
import 'package:stockpro/features/inventory/domain/usecases/update_inventory_item.dart';
import 'package:stockpro/features/inventory/domain/usecases/watch_inventory_items.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/order/data/datasources/order_remote_data_source.dart';
import 'package:stockpro/features/order/data/repositories/order_repository_impl.dart';
import 'package:stockpro/features/order/domain/repositories/order_repository.dart';
import 'package:stockpro/features/order/domain/usecases/add_order.dart';
import 'package:stockpro/features/order/domain/usecases/bulk_stock_orders.dart';
import 'package:stockpro/features/order/domain/usecases/delete_order.dart';
import 'package:stockpro/features/order/domain/usecases/get_all_orders.dart';
import 'package:stockpro/features/order/domain/usecases/mark_order_as_stocked.dart';
import 'package:stockpro/features/order/domain/usecases/update_order.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';
import 'package:stockpro/features/warehouse/data/datasources/warehouse_remote_data_source.dart';
import 'package:stockpro/features/warehouse/data/repositories/warehouse_repository_impl.dart';
import 'package:stockpro/features/warehouse/domain/repositories/warehouse_repository.dart';
import 'package:stockpro/features/warehouse/domain/usecases/add_warehouse.dart';
import 'package:stockpro/features/warehouse/domain/usecases/delete_warehouse.dart';
import 'package:stockpro/features/warehouse/domain/usecases/get_all_warehouses.dart';
import 'package:stockpro/features/warehouse/domain/usecases/update_warehouse.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_event.dart';

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
  _initInventory();
  _initCategory();
  _initWarehouse();
  _initOrder();
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
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

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

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(),
        sl<AuthLocalDataSource>(), sl<UserRemoteDataSource>()),
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

void _initInventory() {
  // Data Sources
  sl.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      remoteDataSource: sl<InventoryRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetItems(sl<InventoryRepository>()));
  sl.registerLazySingleton(() => AddInventoryItem(sl<InventoryRepository>()));
  sl.registerLazySingleton(
      () => UpdateInventoryItem(sl<InventoryRepository>()));
  sl.registerLazySingleton(
      () => DeleteInventoryItem(sl<InventoryRepository>()));
  sl.registerLazySingleton(
      () => AdjustInventoryQuantity(sl<InventoryRepository>()));
  sl.registerLazySingleton(() => GetLowStockItems(sl<InventoryRepository>()));

  sl.registerLazySingleton(
      () => WatchInventoryItems(sl<InventoryRepository>()));

  // Bloc
  sl.registerFactory(
    () => InventoryBloc(
        getItems: sl<GetItems>(),
        addItem: sl<AddInventoryItem>(),
        updateItem: sl<UpdateInventoryItem>(),
        deleteItem: sl<DeleteInventoryItem>(),
        adjustQuantity: sl<AdjustInventoryQuantity>(),
        getLowStockItems: sl<GetLowStockItems>(),
        watchInventoryItems: sl()),
  );
}

void _initCategory() {
  // Category Data Source
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );

// Category Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );

// Category Use Case
  sl.registerLazySingleton(() => GetAllCategories(sl()));

  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));

// Category Bloc
  sl.registerFactory(() => CategoryBloc(
      getAllCategories: sl(),
      addCategory: sl(),
      updateCategory: sl(),
      deleteCategory: sl()));
}

void _initWarehouse() {
  sl.registerLazySingleton<WarehouseRemoteDataSource>(
    () => WarehouseRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetAllWarehouses(sl()));
  sl.registerLazySingleton(() => AddWarehouse(sl()));
  sl.registerLazySingleton(() => UpdateWarehouse(sl()));
  sl.registerLazySingleton(() => DeleteWarehouse(sl()));

  sl.registerFactory(() => WarehouseBloc(
      getAllWarehouses: sl(),
      addWarehouse: sl(),
      updateWarehouse: sl(),
      deleteWarehouse: sl()));
}

void _initOrder() {
  // Data source
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllOrders(sl()));
  sl.registerLazySingleton(() => AddOrder(sl()));
  sl.registerLazySingleton(() => UpdateOrder(sl()));
  sl.registerLazySingleton(() => DeleteOrder(sl()));
  sl.registerLazySingleton(() => MarkOrderAsStocked(sl()));
  sl.registerLazySingleton(() => BulkStockOrders(sl()));

  // BLoC
  sl.registerFactory(() => OrderBloc(
        getAllOrders: sl(),
        addOrder: sl(),
        updateOrder: sl(),
        deleteOrder: sl(),
        markOrderAsStocked: sl(),
        bulkStockOrders: sl(),
      ));
}

List<BlocProvider> getBlocProviders() {
  return [
    BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>()..add(CheckAuthenticationStatus())),
    BlocProvider<InventoryBloc>(
      create: (context) => sl<InventoryBloc>()..add(WatchInventoryItemsEvent()),
    ),
    BlocProvider<CategoryBloc>(
        create: (context) => sl<CategoryBloc>()..add(LoadCategories())),
    BlocProvider<WarehouseBloc>(
        create: (context) => sl<WarehouseBloc>()..add(LoadWarehouses())),
    BlocProvider<OrderBloc>(
        create: (context) => sl<OrderBloc>()..add(LoadOrders())),
  ];
}
