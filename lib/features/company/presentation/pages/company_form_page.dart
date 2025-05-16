import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/core/utils/multi_source_image_picker_.dart';
import 'package:stockpro/core/utils/permission_util.dart';
import 'package:stockpro/core/utils/unique_id_util.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';

class CompanyFormPage extends StatefulWidget {
  final Company? company;
  final UserEntity? currentUser;

  const CompanyFormPage({super.key, this.company, this.currentUser});

  @override
  State<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends State<CompanyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  File? _pickedImage;

  bool get isEditMode => widget.company != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.company!.name;
      _secretController.text = widget.company!.secret;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
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

  String generateUniqueSecret(String companyName) {
    final normalized = companyName.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    final prefix =
        normalized.length > 20 ? normalized.substring(0, 20) : normalized;
    final randSuffix = UniqueIdUtil.generateRandomSuffix(8);
    return '$prefix-$randSuffix';
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    // final secret = _secretController.text.trim();
    final secret = generateUniqueSecret(_secretController.text.trim());

    if (isEditMode) {
      if (!PermissionUtil.isAdmin(widget.currentUser)) {
        PermissionUtil.showNoPermissionMessage(context);
        return; // Exit the function if not admin
      }
      final updatedCompany = widget.company!.copyWith(
        name: name,
        secret: secret,
        imageUrl: _pickedImage?.uri.toString() ?? widget.company!.imageUrl,
      );
      context.read<CompanyBloc>().add(UpdateCompanyEvent(updatedCompany));
      _showSnack('Company updated successfully!');
    } else {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final newCompany = Company(
          id: UniqueIdUtil.generateSimpleId(),
          name: name,
          secret: secret,
          adminUid: authState.user.id,
          createdAt: DateTime.now(),
          imageUrl: _pickedImage?.uri.toString(),
          settings: {},
        );
        context.read<CompanyBloc>().add(CreateCompanyEvent(newCompany));
        _showSnack('Company created successfully!');
      }
    }

    Navigator.of(context).pop();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 $message'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.company;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditMode ? 'Edit Company' : 'Create Company'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    isEditMode ? 'Edit Company' : 'Start Your Company',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  /// Image Picker
                  GestureDetector(
                    onTap: () => _pickImage(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  child: Image.file(
                                    _pickedImage!,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _pickedImage!.path.split('/').last,
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
                          : company?.imageUrl != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(company!.imageUrl!),
                                      radius: 25,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Tap to change image",
                                      style: TextStyle(fontSize: 12),
                                    )),
                                    const Icon(Icons.sync),
                                  ],
                                )
                              : const Row(
                                  children: [
                                    Icon(Icons.image_outlined,
                                        color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text("Tap to select logo"),
                                  ],
                                ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter a company name'
                        : null,
                  ),

                  const SizedBox(height: 16),

                  /// Secret
                  TextFormField(
                    controller: _secretController,
                    decoration: const InputDecoration(
                      labelText: 'Company Secret',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter a secret salt'
                        : null,
                  ),

                  const SizedBox(height: 24),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(isEditMode
                          ? Icons.save_alt_outlined
                          : Icons.check_circle_outline),
                      label: Text(
                          isEditMode ? 'Update Company' : 'Create Company'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
