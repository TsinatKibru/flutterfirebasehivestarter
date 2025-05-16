import 'package:flutter/material.dart';

class InventoryFilterBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSortChanged;
  final double height;
  final String hint;

  const InventoryFilterBar(
      {super.key,
      required this.onSearchChanged,
      required this.onSortChanged,
      this.height = 54.0,
      this.hint = "Search products..."});

  @override
  State<InventoryFilterBar> createState() => _InventoryFilterBarState();
}

class _InventoryFilterBarState extends State<InventoryFilterBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: widget.onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: PopupMenuButton<String>(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.filter_list,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                tooltip: 'Filter',
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'asc',
                    child: Text(
                      'Price: Low to High',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'desc',
                    child: Text(
                      'Price: High to Low',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
                onSelected: widget.onSortChanged,
                constraints: const BoxConstraints(minWidth: 80),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
