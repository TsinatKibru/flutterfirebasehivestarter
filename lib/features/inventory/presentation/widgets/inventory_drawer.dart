import 'package:flutter/material.dart';
import 'package:stockpro/core/common/widgets/analytics_page.dart';

class InventoryDrawer extends StatelessWidget {
  const InventoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16), // Rounded top corners
          bottom: Radius.zero, // No curvature at the bottom
        ),
      ),
      child: SafeArea(
        child: AnalyticsContent(), // Your existing content here
      ),
    );
  }
}
