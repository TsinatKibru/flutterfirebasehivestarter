import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final VoidCallback onAddProduct;

  const ProductHeader({
    super.key,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 2, 16, 8), // Tighter vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Products',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: onAddProduct,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(
                horizontal: 12, // Reduced horizontal padding
                vertical: 6, // Reduced vertical padding
              ),
              minimumSize: Size.zero, // Allows button to shrink
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.add, size: 18), // Smaller icon
            label: const Text(
              'Add Product',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16, // Smaller font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
