import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/core/utils/multi_source_image_picker_.dart';
import 'package:stockpro/core/utils/permission_util.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/category/domain/entities/category_entity.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_event.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/image_inventory.dart';

class AddCategoryPage extends StatefulWidget {
  final CategoryEntity? item;

  const AddCategoryPage({super.key, this.item});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;
  File? _pickedImage;
  Company? company;
  UserEntity? currentUser;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _controller.text = widget.item!.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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

  void _submit() {
    if (!PermissionUtil.isAdmin(currentUser)) {
      PermissionUtil.showNoPermissionMessage(context);
      return; // Exit the function if not admin
    }

    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSubmitting = true);

    final category = CategoryEntity(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imageUrl: _pickedImage?.uri.toString() ?? widget.item?.imageUrl,
      companyId: company?.id,
    );

    final bloc = context.read<CategoryBloc>();
    if (widget.item == null) {
      bloc.add(AddNewCategory(category));
    } else {
      bloc.add(UpdateCategoryEvent(category));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final companyState = context.watch<CompanyBloc>().state;
    final authState = context.watch<AuthBloc>().state;
    currentUser = authState is Authenticated ? authState.user : null;

    company = (companyState is CompanyCreated)
        ? companyState.company
        : (companyState is CompanyBySecretLoaded)
            ? companyState.company
            : (companyState is CompanyLoaded)
                ? companyState.company
                : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Category' : 'Edit Category'),
        leading: IconButton(
          icon: Icon(widget.item != null ? Icons.arrow_back_ios : Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _pickedImage != null
                    ? Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_pickedImage!,
                                height: 50, width: 50, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.basename(_pickedImage!.path),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _pickedImage = null),
                          ),
                        ],
                      )
                    : widget.item?.imageUrl != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InventoryImage(
                                imageUrl: widget.item!.imageUrl,
                                height: 50,
                                width: 50,
                              ),
                              const Text("Tap to change image"),
                              const Icon(Icons.sync),
                            ],
                          )
                        : const Row(
                            children: [
                              Icon(Icons.image_outlined, color: Colors.grey),
                              SizedBox(width: 8),
                              Text("Tap to select image"),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Text(widget.item == null ? 'Add Category' : 'Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
