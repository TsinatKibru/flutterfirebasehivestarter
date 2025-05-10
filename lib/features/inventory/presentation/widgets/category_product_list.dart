import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/pages/add_edit_inventory_page.dart';
import 'package:stockpro/features/inventory/presentation/pages/inventory_details_page.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_item_card.dart';

class CategoryProductList extends StatelessWidget {
  final String category;
  final List<InventoryItemEntity> products;

  const CategoryProductList({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        automaticallyImplyLeading: false, // Prevent default back button
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back_ios_new_rounded), // Use the iOS-style back arrow icon
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return InventoryItemCard(
            height: 250,
            categoryname: category,
            item: item,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InventoryDetailsPage(item: item),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}
