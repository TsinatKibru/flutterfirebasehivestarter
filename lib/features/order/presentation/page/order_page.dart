import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/core/common/widgets/custom_table_widget.dart';
import 'package:stockpro/core/common/widgets/more_options_button.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/category/presentation/widget/category_utils.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_app_bar.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_drawer.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_filter_bar.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';
import 'package:stockpro/features/order/presentation/bloc/order_state.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';
import 'package:stockpro/features/order/presentation/page/stock_products_page.dart';
import 'package:stockpro/features/order/presentation/widget/apply_stock_banner.dart';
import 'package:stockpro/features/order/presentation/widget/order_details.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  static List<CategoryEntity> _categories = [];
  @override
  void initState() {
    super.initState();
  }

  String _searchText = '';
  Future<void> _showAddEditBottomSheet(String type,
      [OrderEntity? order]) async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<InventoryBloc>()),
          BlocProvider.value(value: context.read<OrderBloc>()),
        ],
        child: StockProductsPage(
          orderType: type,
          order: order,
        ),
      ),
    );
  }

  Future<void> _showDetailsSheet(OrderEntity order) async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.82,
      child: MultiBlocProvider(
        providers: [
          // BlocProvider.value(value: context.read<Produc>()),
          BlocProvider.value(value: context.read<OrderBloc>()),
        ],
        child: OrderDetailsPage(
          order: order,
          onEdit: () {
            _showAddEditBottomSheet(order.type, order);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: InventoryAppBar(),
      drawer: InventoryDrawer(),
      body: Column(
        children: [
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded) {
                _categories = state.categories;
              }
              return const SizedBox.shrink(); // Renders nothing
            },
          ),

          // Restock and Menu Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => _showAddEditBottomSheet("stock"),
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
                  icon: const Icon(Icons.sync, size: 24), // Smaller icon
                  label: const Text(
                    'ReStock',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16, // Smaller font size
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "sell",
                      child: Text("Sell/Withdraw"),
                    ),
                    const PopupMenuItem(
                      value: "filter",
                      child: Text("Filter by Date"),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == "sell") {
                      _showAddEditBottomSheet("sell");
                    }
                  },
                ),
              ],
            ),
          ),

          InventoryFilterBar(
            hint: "Search Orders...",
            height: 55,
            onSearchChanged: (value) =>
                setState(() => _searchText = value.toLowerCase()),
            onSortChanged: (value) => setState(() {}),
          ),

          // Orders Table
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              buildWhen: (previous, current) {
                return current is OrderLoading ||
                    current is OrderError ||
                    current is OrderLoaded;
              },
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OrderLoaded) {
                  final filteredOrders = state.orders.where((order) {
                    return order.productSku
                            .toLowerCase()
                            .contains(_searchText) ||
                        order.category.toLowerCase().contains(_searchText);
                  }).toList();

                  if (filteredOrders.isEmpty) {
                    return const Center(child: Text('No orders found.'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<OrderBloc>().add(LoadOrders()),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 350,
                                  child:
                                      ApplyStockBanner(orders: filteredOrders)),
                              CustomListTableWidget(
                                headers: const [
                                  '', // Image
                                  "Stocked",
                                  'Product SKU',
                                  'Product NAME',
                                  'Quantity',
                                  'Category',
                                  'Date and Time',
                                  'Adjust',
                                ],
                                rows: filteredOrders.map((order) {
                                  return [
                                    SizedBox(
                                      width: 40,
                                      height: 30,
                                      child: InventoryImage(
                                          imageUrl:
                                              order.productImageUrl ?? ''),
                                    ),
                                    Icon(
                                      order.isStocked
                                          ? Icons.check
                                          : Icons.pending,
                                      color: order.isStocked
                                          ? Colors.green
                                          : Colors.redAccent,
                                      size: 20,
                                    ),
                                    Text(order.productSku.toUpperCase()),
                                    Text(order.productName.toUpperCase()),
                                    Text(
                                      "${order.type == "stock" ? "+" : "-"}${order.quantity} (${order.type.toUpperCase()})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: order.type == "stock"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    Text(CategoryUtils.getCategoryNameById(
                                        order.category, _categories)),
                                    Text(DateFormat('MM/dd HH:mm')
                                        .format(order.date)),
                                    EditDeletePopover(
                                      onEdit: () {
                                        _showAddEditBottomSheet(
                                            order.type, order);
                                      },
                                      onDelete: () {},
                                    )
                                  ];
                                }).toList(),
                                columnAlignments: const [
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.left,
                                  TextAlign.left,
                                  TextAlign.center,
                                  TextAlign.left,
                                  TextAlign.left,
                                  TextAlign.center,
                                ],
                                onRowTap: (index) {
                                  final selectedOrder = filteredOrders[index];
                                  _showDetailsSheet(selectedOrder);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
