import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/domain/usecases/delete_category.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_event.dart';
import 'package:stockpro/features/category/presentation/widget/add_category_dialog.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';

class CategoryListWidget extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryListWidget({super.key, required this.categories});

  void _editCategory(BuildContext context, CategoryEntity category) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddCategoryPage(item: category),
    ));
  }

  void _deleteCategory(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CategoryBloc>().add(DeleteCategoryEvent(categoryId));
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text('No categories available'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InventoryImage(
                      imageUrl: cat.imageUrl,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                      right: 4,
                      top: 4,
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: Material(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editCategory(context, cat);
                              } else if (value == 'delete') {
                                _deleteCategory(context, cat.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            icon: const Icon(
                              Icons.more_horiz,
                              size: 16,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                            elevation: 4,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                cat.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Products: ${cat.productCount ?? 0}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
