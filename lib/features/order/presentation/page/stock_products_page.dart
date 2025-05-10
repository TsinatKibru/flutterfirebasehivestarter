import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stockpro/core/common/widgets/app_text_form_field.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';
import 'package:stockpro/features/order/presentation/bloc/order_state.dart';

class StockProductsPage extends StatefulWidget {
  final String orderType;
  final InventoryItemEntity? product;

  const StockProductsPage({super.key, required this.orderType, this.product});

  @override
  State<StockProductsPage> createState() => _StockProductsPageState();
}

class _StockProductsPageState extends State<StockProductsPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();

  InventoryItemEntity? _selectedProduct;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _selectedProduct = widget.product;
    }
    _dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Products'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // BlocBuilder<InventoryBloc, InventoryState>(
        // buildWhen: (previous, current) {
        //   return current is InventoryLoading ||
        //       current is InventoryError ||
        //       current is InventoryLoaded;
        // },
        // builder: (context, state) {

        child: BlocBuilder<InventoryBloc, InventoryState>(
          buildWhen: (previous, current) {
            // Rebuild only if the state is InventoryLoading, InventoryError, or InventoryLoaded
            return current is InventoryLoading ||
                current is InventoryError ||
                current is InventoryLoaded;
          },
          builder: (context, state) {
            print("InventoryBloc state: ${state}");
            final List<InventoryItemEntity> products =
                state is InventoryLoaded ? state.items : [];

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Order Type: ${widget.orderType}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date Field
                    GestureDetector(
                      onTap: () => _selectDateAndTime(context),
                      child: AbsorbPointer(
                        child: AppTextFormField(
                          leading: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.calendar_month)),
                          trailing: IconButton(
                              onPressed: () {}, icon: Icon(Icons.close)),
                          controller: _dateController,
                          label: 'Date and Time',
                          isRequired: true,
                          placeholder: "Select Date and Time",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product Dropdown with scroll constraint
                    DropdownButtonFormField<InventoryItemEntity>(
                      value: _selectedProduct,
                      onChanged: (newValue) =>
                          setState(() => _selectedProduct = newValue),
                      items: products
                          .map(
                            (product) => DropdownMenuItem(
                              value: product,
                              child: Row(
                                children: [
                                  InventoryImage(
                                    imageUrl: product.imageUrl,
                                    width: 40,
                                    height: 30,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${product.name}-${product.categoryId}",
                                    maxLines: 1,
                                  )),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Select Product *',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select a product' : null,
                      isExpanded: true,
                      menuMaxHeight: 250, // Limits dropdown height
                    ),
                    const SizedBox(height: 16),

                    AppTextFormField(
                      controller: _quantityController,
                      label: 'Quantity',
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter quantity';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Invalid quantity';
                        }
                        return null;
                      },
                      isRequired: true,
                      placeholder: "Enter quantity",
                    ),
                    const SizedBox(height: 20),

                    // Note Input
                    AppTextFormField(
                      controller: _noteController,
                      label: 'Note',
                      placeholder: "Enter note",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 100),

                    BlocConsumer<OrderBloc, OrderState>(
                      listener: (context, state) {
                        if (state is OrderAdded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Order submitted successfully')),
                          );

                          if (widget.product != null) {
                            if (widget.orderType == "sell") {
                              context.read<InventoryBloc>().add(
                                    AdjustInventoryQuantityEvent(
                                      widget.product!.id,
                                      -int.parse(_quantityController.text),
                                    ),
                                  );
                            } else {
                              context.read<InventoryBloc>().add(
                                    AdjustInventoryQuantityEvent(
                                      widget.product!.id,
                                      int.parse(_quantityController.text),
                                    ),
                                  );
                            }
                          }
                          _formKey.currentState!.reset();

                          _noteController.clear();
                          setState(() {
                            _selectedProduct = null;
                            _selectedDate = DateTime.now();
                            _dateController.text =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(_selectedDate);
                          });
                          Navigator.pop(context);
                        } else if (state is OrderError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${state.message}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is OrderLoading;
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Submit'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final orderItem = OrderEntity(
      id: '', // Will be assigned by Firestore/DB
      customerName: "",
      productId: _selectedProduct!.id,
      productName: _selectedProduct!.name,
      quantity: int.parse(_quantityController.text),
      date: _selectedDate,
      note: _noteController.text,
      type: widget.orderType, // 'in' or 'out'
      isStocked: widget.product == null ? false : true,
      productSku: _selectedProduct?.barcode ?? "",
      category: _selectedProduct?.categoryId ?? "",
      price: double.parse(_quantityController.text),
      // Add any other required fields from your InventoryItemEntity
    );

    // Dispatch the event to your bloc/cubit
    context.read<OrderBloc>().add(AddNewOrder(orderItem));

    setState(() {
      if (widget.product == null) {
        _selectedProduct = null;
      }
      _selectedDate = DateTime.now();
      _dateController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
    });
  }
}
