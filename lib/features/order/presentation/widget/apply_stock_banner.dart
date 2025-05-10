import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';

class ApplyStockBanner extends StatefulWidget {
  final List<OrderEntity> orders;

  const ApplyStockBanner({super.key, required this.orders});

  @override
  State<ApplyStockBanner> createState() => _ApplyStockBannerState();
}

class _ApplyStockBannerState extends State<ApplyStockBanner> {
  bool _applied = false;

  void _applyStockUpdates() {
    final unstockedOrders = widget.orders.where((o) => !o.isStocked).toList();
    final inventoryBloc = context.read<InventoryBloc>();
    final orderBloc = context.read<OrderBloc>();

    // Step 1: Update Inventory
    for (final order in unstockedOrders) {
      final adjustedQuantity =
          order.type == "sell" ? -order.quantity : order.quantity;
      inventoryBloc.add(
        AdjustInventoryQuantityEvent(order.productId, adjustedQuantity),
      );
    }

    // Step 2: Mark Orders as Stocked
    if (unstockedOrders.isNotEmpty) {
      orderBloc.add(StockAllOrders(unstockedOrders));
    }

    setState(() => _applied = true);

    // Auto-dismiss the success banner after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _applied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unstockedCount = widget.orders.where((o) => !o.isStocked).length;

    if (_applied) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Stock updated for all orders.',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    if (unstockedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Apply stock updates to $unstockedCount order(s)?',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: _applyStockUpdates,
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
