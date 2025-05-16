import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/widgets/analytics_page.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_event.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/inventory/presentation/pages/add_edit_inventory_page.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_app_bar.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_drawer.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_item_list.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  late final InventoryBloc _inventoryBloc;
  String searchQuery = '';
  String? sortOrder;

  @override
  void initState() {
    super.initState();
    _inventoryBloc = context.read<InventoryBloc>();
    _inventoryBloc.add(WatchInventoryItemsEvent());
    context.read<CategoryBloc>().add(LoadCategories());
  }

  Future<void> _showAddEditBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _inventoryBloc),
          BlocProvider.value(value: context.read<CategoryBloc>()),
        ],
        child: const AddEditInventoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(),
      drawer: InventoryDrawer(),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          return InventoryItemList(
            categoryState: categoryState,
            searchQuery: searchQuery,
            sortOrder: sortOrder,
            onSearchChanged: (value) => setState(() => searchQuery = value),
            onSortChanged: (value) => setState(() => sortOrder = value),
            onRefresh: () => _inventoryBloc.add(WatchInventoryItemsEvent()),
            onAddProduct: _showAddEditBottomSheet,
          );
        },
      ),
    );
  }
}
