import 'package:flutter/material.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';

class OrderListWidget extends StatelessWidget {
  final List<OrderEntity> orders;

  const OrderListWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    // print("orders: ${orders}");
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text(order.customerName),
          subtitle: Text('Total: \$${order.price.toStringAsFixed(2)}'),
          trailing:
              Text(order.date.toLocal().toIso8601String().split('T').first),
        );
      },
    );
  }
}
