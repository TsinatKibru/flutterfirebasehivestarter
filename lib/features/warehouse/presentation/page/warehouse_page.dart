import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/core/common/widgets/common_header.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_app_bar.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_filter_bar.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_state.dart';
import 'package:stockpro/features/warehouse/presentation/widget/add_warehouse_widget.dart';
import 'package:stockpro/features/warehouse/presentation/widget/warehouse_list_widget.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  get onSortChanged => null;
  String searchQuery = '';
  String? sortOrder;
  Future<void> _warehousemanageBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WarehouseBloc>()),
          BlocProvider.value(value: context.read<InventoryBloc>()),
        ],
        child: AddWarehousePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(),
      drawer: Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Common Header
            CommonHeader(
              title: 'Warehouses',
              buttonLabel: 'Add Warehouse',
              onAdd: () {
                _warehousemanageBottomSheet();
              },
            ),
            InventoryFilterBar(
              onSearchChanged: (value) => setState(() => searchQuery = value),
              onSortChanged: (value) => setState(() => sortOrder = value),
            ),

            // Map Placeholder with max height of 300
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: ConstrainedBox(
            //     constraints: const BoxConstraints(maxHeight: 200),
            //     child: Container(
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         color: const Color.fromARGB(255, 239, 238, 238),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       alignment: Alignment.center,
            //       child: const Text(
            //         'Map Area (Placeholder)',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.black54,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: InventoryImage(
                  width: double.infinity,
                  height: 150,
                  imageUrl:
                      "https://res.cloudinary.com/dbcuyckat/image/upload/v1746881545/image_hizbmb.png"),
            ),
            // Expanded list area
            Expanded(
              child: BlocBuilder<WarehouseBloc, WarehouseState>(
                builder: (context, state) {
                  if (state is WarehouseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WarehouseLoaded) {
                    return WarehouseListWidget(warehouses: state.warehouses);
                  } else if (state is WarehouseError) {
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
