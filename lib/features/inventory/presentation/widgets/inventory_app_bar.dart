import 'package:flutter/material.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSignOut;

  const InventoryAppBar({
    super.key,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //title: const Text('StockPro'),
      toolbarHeight: 45,
      foregroundColor: Colors.white,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.exit_to_app),
        //   tooltip: 'Sign Out',
        //   onPressed: onSignOut,
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
