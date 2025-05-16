import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:stockpro/core/common/entities/user_entity.dart';

import 'package:stockpro/core/common/widgets/app_text_form_field.dart';
import 'package:stockpro/core/utils/multi_source_image_picker_.dart';
import 'package:stockpro/core/utils/permission_util.dart';
import 'package:stockpro/core/utils/section_divider.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';
import 'package:stockpro/features/inventory/domain/entities/inventory_item_entity.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_state.dart';

class AddEditInventoryPage extends StatefulWidget {
  final InventoryItemEntity? item;

  const AddEditInventoryPage({super.key, this.item});

  @override
  State<AddEditInventoryPage> createState() => _AddEditInventoryPageState();
}

class _AddEditInventoryPageState extends State<AddEditInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _skuController;

  String? _selectedCategoryId;
  String? _selectedWarehouseId;
  File? _pickedImage;
  Company? company;
  UserEntity? currentUser;

  @override
  void initState() {
    super.initState();

    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController =
        TextEditingController(text: item?.quantity.toString() ?? '0');
    _priceController =
        TextEditingController(text: item?.price.toStringAsFixed(2) ?? '0.00');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _skuController = TextEditingController(text: item?.barcode ?? '');

    _selectedCategoryId = item?.categoryId;
    _selectedWarehouseId = item?.warehouseId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await MultiSourceImagePicker.pickImage(context);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  void _submitForm() {
    if (!PermissionUtil.isAdmin(currentUser)) {
      PermissionUtil.showNoPermissionMessage(context);
      return; // Exit the function if not admin
    }

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null || _selectedWarehouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category and warehouse')),
      );
      return;
    }

    final item = InventoryItemEntity(
        id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        warehouseId: _selectedWarehouseId!,
        barcode: _skuController.text.trim(),
        companyId: company?.id,
        imageUrl: _pickedImage?.uri.toString() ?? widget.item?.imageUrl);

    final bloc = context.read<InventoryBloc>();
    widget.item == null
        ? bloc.add(AddInventoryItemEvent(item))
        : bloc.add(UpdateInventoryItemEvent(item));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    final authState = context.watch<AuthBloc>().state;
    currentUser = authState is Authenticated ? authState.user : null;
    final companyState = context.watch<CompanyBloc>().state;
    print("ocmpanyState: ${companyState}");
    company = (companyState is CompanyCreated)
        ? companyState.company
        : (companyState is CompanyBySecretLoaded)
            ? companyState.company
            : (companyState is CompanyLoaded)
                ? companyState.company
                : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add Item'),
        leading: IconButton(
          icon: Icon(widget.item != null ? Icons.arrow_back_ios : Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventoryLoaded) {
            Navigator.pop(context);
          } else if (state is InventoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is InventoryLoading;

          return Stack(
            children: [
              AbsorbPointer(
                absorbing: isLoading,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SectionDivider(label: "Basic Information"),
                        AppTextFormField(
                          controller: _nameController,
                          label: 'Name *',
                          placeholder: "Product name",
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),
                        AppTextFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          placeholder: "Add description",
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _pickedImage != null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.file(_pickedImage!,
                                          fit: BoxFit.cover),
                                      Expanded(
                                          child: Text(
                                        p.basename(_pickedImage!.path),
                                        maxLines: 1,
                                      )),
                                      IconButton(
                                        onPressed: () =>
                                            setState(() => _pickedImage = null),
                                        icon: const Icon(Icons.close),
                                      )
                                    ],
                                  )
                                : widget.item?.imageUrl != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InventoryImage(
                                            imageUrl: widget.item?.imageUrl,
                                            height: 40,
                                            width: 50,
                                          ),
                                          Text("Product Image"),
                                          Icon((Icons.sync))
                                        ],
                                      )
                                    : const Row(
                                        children: [
                                          Icon(Icons.image_outlined,
                                              color: Colors.grey),
                                          Text("Tap to select image")
                                        ],
                                      ),
                          ),
                        ),
                        const SectionDivider(label: "Stock & Pricing"),
                        AppTextFormField(
                          controller: _quantityController,
                          label: 'Quantity *',
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || int.tryParse(v) == null)
                                  ? 'Required'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        AppTextFormField(
                          controller: _priceController,
                          label: 'Price *',
                          placeholder: 'Enter price',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) =>
                              (v == null || double.tryParse(v) == null)
                                  ? 'Required'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        AppTextFormField(
                          controller: _quantityController,
                          label: 'Min. Stock Level *',
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || int.tryParse(v) == null)
                                  ? 'Required'
                                  : null,
                        ),
                        const SectionDivider(label: "Identification"),
                        AppTextFormField(
                          controller: _skuController,
                          placeholder: "Enter barcode",
                          label: 'SKU *',
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SectionDivider(label: "Categorization & Storage"),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (_, state) {
                            if (state is CategoryLoaded) {
                              return DropdownButtonFormField<String>(
                                value: _selectedCategoryId,
                                decoration: const InputDecoration(
                                  hintText: "Choose Category",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  isDense: true,
                                  labelText: 'Category *',
                                  border: OutlineInputBorder(),
                                ),
                                items: state.categories
                                    .map((cat) => DropdownMenuItem(
                                          value: cat.id,
                                          child: Text(cat.name),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _selectedCategoryId = value),
                                validator: (value) =>
                                    value == null ? 'Required' : null,
                              );
                            } else if (state is CategoryLoading) {
                              return const LinearProgressIndicator();
                            } else {
                              return const Text('Failed to load categories');
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<WarehouseBloc, WarehouseState>(
                          builder: (_, state) {
                            if (state is WarehouseLoaded) {
                              return DropdownButtonFormField<String>(
                                value: _selectedWarehouseId,
                                decoration: const InputDecoration(
                                  hintText: "Choose Warehouse",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  isDense: true,
                                  labelText: 'Warehouse *',
                                  border: OutlineInputBorder(),
                                ),
                                items: state.warehouses
                                    .map((wh) => DropdownMenuItem(
                                          value: wh.id,
                                          child: Text(wh.name),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(
                                    () => _selectedWarehouseId = value),
                                validator: (value) =>
                                    value == null ? 'Required' : null,
                              );
                            } else if (state is WarehouseLoading) {
                              return const LinearProgressIndicator();
                            } else {
                              return const Text('Failed to load warehouses');
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
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
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(isEditing ? 'Update' : 'Submit'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
