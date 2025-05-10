import 'package:flutter/material.dart';

class InventoryDrawer extends StatelessWidget {
  const InventoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('My App',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          // Add more drawer items here as needed
        ],
      ),
    );
  }
}
