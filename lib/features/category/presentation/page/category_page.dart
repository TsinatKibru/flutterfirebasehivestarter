import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/widgets/analytics_page.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/core/common/widgets/common_header.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/category/presentation/widget/add_category_dialog.dart';
import 'package:stockpro/features/category/presentation/widget/category_list_widget.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_app_bar.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_drawer.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_filter_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  get onSortChanged => null;
  String searchQuery = '';
  String? sortOrder;
  Future<void> _categorymanageBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CategoryBloc>()),
          BlocProvider.value(value: context.read<InventoryBloc>()),
        ],
        child: const AddCategoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(),
      drawer: InventoryDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: 'Categories',
              buttonLabel: 'Add Category',
              onAdd: () {
                _categorymanageBottomSheet();
              },
            ),
            InventoryFilterBar(
              hint: "Search Categories...",
              onSearchChanged: (value) => setState(() => searchQuery = value),
              onSortOrFilterChanged: (value) =>
                  setState(() => sortOrder = value),
              filterOptions: const [
                PopupMenuItem(
                    value: 'productCount_asc',
                    child: Text('Product Count: Low to High')),
                PopupMenuItem(
                    value: 'productCount_desc',
                    child: Text('Product Count: High to Low')),
                PopupMenuItem(value: 'name_asc', child: Text('Name: A-Z')),
                PopupMenuItem(value: 'name_desc', child: Text('Name: Z-A')),
              ],
            ),
            Expanded(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoryLoaded) {
                    final filteredCategories = state.categories
                        .where((category) => category.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    switch (sortOrder) {
                      case 'productCount_asc':
                        filteredCategories.sort(
                            (a, b) => a.productCount.compareTo(b.productCount));
                        break;
                      case 'productCount_desc':
                        filteredCategories.sort(
                            (a, b) => b.productCount.compareTo(a.productCount));
                        break;
                      case 'name_asc':
                        filteredCategories
                            .sort((a, b) => a.name.compareTo(b.name));
                        break;
                      case 'name_desc':
                        filteredCategories
                            .sort((a, b) => b.name.compareTo(a.name));
                        break;
                    }

                    return CategoryListWidget(categories: filteredCategories);

                    //return CategoryListWidget(categories: state.categories);
                  } else if (state is CategoryError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No data'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
