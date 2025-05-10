import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/pages/inventory_details_page.dart';
import 'package:stockpro/features/inventory/presentation/widgets/category_product_list.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_item_card.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<InventoryItemEntity> products;

  const CategorySection({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductList(
                        category: category,
                        products: products,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.right_chevron,
                      size: 18,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final item = products[index];
              return InventoryItemCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InventoryDetailsPage(
                        item: item,
                        categoryname: category,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 10),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
