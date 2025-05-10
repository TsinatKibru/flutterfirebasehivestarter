import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onEdit;

  const OrderDetailsPage({
    super.key,
    required this.order,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStock = order.type == 'stock';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Order Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Type + Date + Edit Button Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isStock ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isStock ? Colors.green : Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('yyyy-MM-dd – HH:mm').format(order.date),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Edit"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            isStock ? Colors.green : Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: isStock ? Colors.green : Colors.deepOrange,
                          ),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Product Image + Name + Category
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InventoryImage(
                  imageUrl: order.productImageUrl,
                  height: 100,
                  width: 120,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.category,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                      if (order.productWarehouse != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "Warehouse: ${order.productWarehouse!}",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quantity
            Text(
              "${isStock ? "+" : "-"}${order.quantity} (${order.type.toUpperCase()})",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isStock ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 32),

            // Barcode section
            Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2,
                          size: 100, color: Colors.black54),
                      const SizedBox(height: 12),
                      Text(
                        order.productSku,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Price and Customer
            Text(
              "Price: \$${order.price.toStringAsFixed(2)}",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (order.customerName.isNotEmpty)
              Text(
                "Customer: ${order.customerName}",
                style: theme.textTheme.titleMedium,
              ),

            const SizedBox(height: 24),

            // Note
            if (order.note?.isNotEmpty ?? false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Note",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.note!,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Stocked Status
            Row(
              children: [
                Icon(
                  order.isStocked ? Icons.check_circle : Icons.access_time,
                  size: 24,
                  color: order.isStocked ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  order.isStocked ? 'Stocked' : 'Pending',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: order.isStocked ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
