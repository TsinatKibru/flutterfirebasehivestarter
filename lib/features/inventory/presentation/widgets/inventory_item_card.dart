import 'package:flutter/material.dart';
import 'package:stockpro/core/common/enums/inventory_item_variant.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/pages/add_edit_inventory_page.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';

class InventoryItemCard extends StatelessWidget {
  final String? categoryname;
  final InventoryItemEntity item;
  final VoidCallback? onTap;
  final InventoryItemCardVariant variant;
  final double height;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.variant = InventoryItemCardVariant.compact,
    this.categoryname,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case InventoryItemCardVariant.detailed:
        return _buildDetailed(context);
      case InventoryItemCardVariant.compact:
      default:
        return _buildCompact(context);
    }
  }

  Widget _buildCompact(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.33,
      height: height,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_buildImage(context, height: height - 115),
                InventoryImage(
                  imageUrl: item.imageUrl,
                  height: height - 115,
                ),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _InfoChip(label: 'Qty', value: '${item.quantity}'),
                      const SizedBox(width: 8),
                      _InfoChip(
                          label: '\$', value: item.price.toStringAsFixed(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (item.description != null && item.description!.isNotEmpty)
                  Expanded(
                    child: Text(
                      item.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailed(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_buildImage(context, width: 110, height: 120),
            InventoryImage(
              imageUrl: item.imageUrl,
              height: 120,
              width: 110,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${categoryname ?? item.categoryId}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontStyle: theme.textTheme.bodySmall?.fontStyle),
                  ),
                  Text(item.name, style: theme.textTheme.headlineSmall),
                  Text('SKU: ${item.barcode}',
                      style: theme.textTheme.bodyMedium),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(
                        2), // Space for "double" border effect
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditInventoryPage(item: item),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
