import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/enums/inventory_item_variant.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';
import 'package:stockpro/features/order/presentation/page/stock_products_page.dart';

class InventoryDetailsPage extends StatefulWidget {
  final String? categoryname;
  final InventoryItemEntity item;

  const InventoryDetailsPage(
      {super.key, required this.item, this.categoryname});

  @override
  State<InventoryDetailsPage> createState() => _InventoryDetailsPageState();
}

class _InventoryDetailsPageState extends State<InventoryDetailsPage> {
  InventoryItemEntity? item;
  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<void> _showStockingBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<InventoryBloc>()),
          BlocProvider.value(value: context.read<OrderBloc>()),
        ],
        child: StockProductsPage(
          orderType: "stock",
          product: widget.item,
        ),
      ),
    );
  }

  Future<void> _showSellingBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<InventoryBloc>()),
          BlocProvider.value(value: context.read<OrderBloc>()),
        ],
        child: StockProductsPage(
          orderType: "sell",
          product: widget.item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (item == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentItem = item!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<InventoryBloc, InventoryState>(
              listener: (context, state) {
                if (state is InventoryOperationSuccess) {
                  setState(() {
                    item = state.item;
                  });
                }
              },
              child: const SizedBox.shrink(),
            ),

            InventoryItemCard(
              categoryname: widget.categoryname,
              item: currentItem,
              onTap: () => {},
              variant: InventoryItemCardVariant.detailed,
            ),
            const SizedBox(height: 20),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.restore,
                  label: 'Restore Item',
                  onPressed: () {
                    _showStockingBottomSheet();
                  },
                ),
                _ActionButton(
                  icon: Icons.point_of_sale,
                  label: 'Register Sale',
                  onPressed: () {
                    _showSellingBottomSheet();
                  },
                ),
              ],
            ),
            const SizedBox(height: 44),

            // INVENTORY & STOCK INFO BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoBox(
                      label: 'Current Inventory',
                      value: '${currentItem.quantity}'),
                  _InfoBox(
                      label: 'Min Stock Level',
                      value: '${currentItem.threshold ?? "__"}'),
                  const SizedBox(
                    height: 42,
                  ),
                  _DetailsRow(
                      label: 'Category',
                      value: widget.categoryname ?? currentItem.categoryId),
                  _DetailsRow(
                      label: 'SKU', value: currentItem.barcode ?? "000000"),
                  _DetailsRow(
                      label: 'Price',
                      value: '\$${currentItem.price.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 20,
                  ),
                  if (currentItem.description != null &&
                      currentItem.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            fill: 0,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            currentItem.description!,
                            style: theme.textTheme.bodyLarge,
                            maxLines: 4,
                          ))
                        ],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Center the barcode and text
                    children: [
                      Container(
                        width: 200,
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.qr_code_2,
                            size: 64, color: Colors.grey),
                      ),
                      const SizedBox(height: 8), // Add some spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the icon and text horizontally
                        children: [
                          const Icon(Icons.copy, size: 16), // Copy icon
                          const SizedBox(
                              width: 4), // Small space between icon and text
                          Text(
                            'Copy SKU',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            // BARCODE IMAGE PLACEHOLDER
          ],
        ),
      ),
    );
  }
}

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey[100],
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       onPressed: onPressed,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: theme.colorScheme.primary,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                   color: Colors.black87,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "units",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: Text('$label:',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16))),
              Expanded(child: Text(value)),
            ],
          ),
          if (label != "Price")
            Divider(
              height: 10,
              color: Colors.grey[300],
            ),
        ],
      ),
    );
  }
}
