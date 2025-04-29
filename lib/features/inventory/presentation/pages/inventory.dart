import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  // Sample data for inventory items
  final List<InventoryItem> _inventoryItems = [
    InventoryItem(name: 'Laptop', quantity: 15, unitPrice: 1200.00),
    InventoryItem(name: 'Mouse', quantity: 50, unitPrice: 25.50),
    InventoryItem(name: 'Keyboard', quantity: 30, unitPrice: 75.00),
    InventoryItem(name: 'Monitor', quantity: 20, unitPrice: 300.00),
    InventoryItem(name: 'Webcam', quantity: 40, unitPrice: 50.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sign Out',
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
          ),
          const SizedBox(width: 8), // Add some spacing
        ],
      ),
      body: _inventoryItems.isEmpty
          ? const Center(
              child: Text('Your inventory is currently empty.',
                  style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: _inventoryItems.length,
              itemBuilder: (context, index) {
                final item = _inventoryItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity: ${item.quantity}'),
                            Text(
                                'Price: \$${item.unitPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Total Value: \$${(item.quantity * item.unitPrice).toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new item functionality here
          print('Add new item');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InventoryItem {
  final String name;
  final int quantity;
  final double unitPrice;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}
