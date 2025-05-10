// lib/features/category/presentation/bloc/category_bloc.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/usecases/delete_category.dart';
import 'package:stockpro/features/category/domain/usecases/get_all_categories.dart';
import 'package:stockpro/features/category/domain/usecases/add_category.dart';
import 'package:stockpro/features/category/domain/usecases/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getAllCategories,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddNewCategory>(_onAddNewCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  StreamSubscription<List<CategoryEntity>>? _categorySubscription;

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    print('[CategoryBloc] Loading categories...');
    emit(CategoryLoading());

    try {
      final stream = await getAllCategories();
      await emit.forEach<List<CategoryEntity>>(
        stream,
        onData: (categories) {
          print('[CategoryBloc] Received ${categories.length} categories');
          print(categories);
          return CategoryLoaded(categories);
        },
        onError: (error, stackTrace) {
          print('[CategoryBloc] Error loading categories: $error');
          return CategoryError(error.toString());
        },
      );
    } catch (e, stackTrace) {
      print('[CategoryBloc] Unexpected error: $e');
      print('[CategoryBloc] StackTrace:\n$stackTrace');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAddNewCategory(
      AddNewCategory event, Emitter<CategoryState> emit) async {
    try {
      await addCategory(event.category);
      add(LoadCategories()); // Refresh after adding
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await updateCategory(event.category);
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await deleteCategory(event.categoryId);
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _categorySubscription?.cancel();
    return super.close();
  }
}
