import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/category_section.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_filter_bar.dart';
import 'package:stockpro/features/inventory/presentation/widgets/loading_error_widget.dart';
import 'package:stockpro/features/inventory/presentation/widgets/product_header.dart';

class InventoryItemList extends StatelessWidget {
  final CategoryState categoryState;
  final String searchQuery;
  final String? sortOrder;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onRefresh;
  final VoidCallback onAddProduct;

  const InventoryItemList({
    super.key,
    required this.categoryState,
    required this.searchQuery,
    required this.sortOrder,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onRefresh,
    required this.onAddProduct,
  });

  String _getCategoryDisplayName(
      String? categoryId, List<CategoryEntity> categories) {
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () =>
          const CategoryEntity(id: 'Uncategorized', name: 'Uncategorized'),
    );
    return category.name.toUpperCase() ?? 'Uncategorized';
  }

  List<InventoryItemEntity> _filterAndSortItems(
      List<InventoryItemEntity> items, List<CategoryEntity> categories) {
    var filteredItems = items;

    // Apply search
    if (searchQuery.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Apply sorting
    if (sortOrder == 'asc') {
      filteredItems.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOrder == 'desc') {
      filteredItems.sort((a, b) => b.price.compareTo(a.price));
    }

    return filteredItems;
  }

  Map<String, List<InventoryItemEntity>> _groupByCategory(
      List<InventoryItemEntity> items, List<CategoryEntity> categories) {
    final Map<String, List<InventoryItemEntity>> categorized = {};
    for (var item in items) {
      final categoryName = _getCategoryDisplayName(item.categoryId, categories);
      categorized.putIfAbsent(categoryName, () => []).add(item);
    }
    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    if (categoryState is CategoryLoading) {
      return const LoadingErrorWidget(
        isLoading: true,
      );
    } else if (categoryState is CategoryError) {
      return LoadingErrorWidget(
        message: (categoryState as CategoryError).message,
      );
    } else if (categoryState is CategoryLoaded) {
      final categories = (categoryState as CategoryLoaded).categories;

      return BlocBuilder<InventoryBloc, InventoryState>(
        buildWhen: (previous, current) {
          return current is InventoryLoading ||
              current is InventoryError ||
              current is InventoryLoaded;
        },
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const LoadingErrorWidget(
              isLoading: true,
            );
          } else if (state is InventoryError) {
            return LoadingErrorWidget(
              message: state.message,
              isError: true,
            );
          } else if (state is InventoryLoaded) {
            final filteredItems = _filterAndSortItems(state.items, categories);
            final categorizedItems =
                _groupByCategory(filteredItems, categories);

            if (filteredItems.isEmpty) {
              return const LoadingErrorWidget(
                icon: Icons.inbox,
                message: 'No items found',
              );
            }

            return Column(
              children: [
                ProductHeader(onAddProduct: onAddProduct),
                InventoryFilterBar(
                  onSearchChanged: onSearchChanged,
                  onSortChanged: onSortChanged,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => onRefresh(),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: categorizedItems.entries
                          .map((entry) => CategorySection(
                                category: entry.key,
                                products: entry.value,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          }

          //  context.read<InventoryBloc>().add(WatchInventoryItemsEvent());
          return const LoadingErrorWidget(
            isLoading: true,
          );
        },
      );
    }

    return const LoadingErrorWidget(
      isLoading: true,
    );
  }
}
