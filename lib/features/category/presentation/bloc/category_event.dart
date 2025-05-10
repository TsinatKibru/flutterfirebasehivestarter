// lib/features/category/presentation/bloc/category_event.dart

import 'package:equatable/equatable.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddNewCategory extends CategoryEvent {
  final CategoryEntity category;

  const AddNewCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryEntity category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String categoryId;

  const DeleteCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
