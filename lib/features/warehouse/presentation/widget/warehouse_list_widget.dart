import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_event.dart';
import 'package:stockpro/features/warehouse/presentation/widget/add_warehouse_widget.dart';

class WarehouseListWidget extends StatelessWidget {
  final List<WarehouseEntity> warehouses;

  const WarehouseListWidget({super.key, required this.warehouses});

  void _showManageBottomSheet(BuildContext context, WarehouseEntity warehouse) {
    BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<WarehouseBloc>()),
          BlocProvider.value(value: context.read<InventoryBloc>()),
        ],
        child: AddWarehousePage(existingWarehouse: warehouse),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WarehouseEntity wh) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Warehouse'),
        content: const Text('Are you sure you want to delete this warehouse?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WarehouseBloc>().add(DeleteWarehouseById(wh.id));
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (warehouses.isEmpty) {
      return const Center(
        child: Text(
          'No warehouses found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: warehouses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final wh = warehouses[index];
        return _WarehouseTile(
          warehouse: wh,
          onEdit: () => _showManageBottomSheet(context, wh),
          onDelete: () => _showDeleteDialog(context, wh),
        );
      },
    );
  }
}

class _WarehouseTile extends StatelessWidget {
  final WarehouseEntity warehouse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WarehouseTile({
    required this.warehouse,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warehouse.name.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  warehouse.location.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
