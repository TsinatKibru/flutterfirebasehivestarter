import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/core/utils/multi_source_image_picker_.dart';
import 'package:stockpro/core/utils/permission_util.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_event.dart';

class AddUserDialog extends StatefulWidget {
  final UserEntity? user;

  const AddUserDialog({super.key, this.user});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;
  File? _pickedImage;
  String _selectedRole = 'staff';
  UserEntity? currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _emailController.text = widget.user!.email;
      _nameController.text = widget.user!.name ?? '';
      _selectedRole = widget.user!.role!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
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
    // print(currentUser);
    // return;
    if (!PermissionUtil.isAdmin(currentUser) &&
        (widget.user == null || widget.user?.id != currentUser?.id)) {
      PermissionUtil.showNoPermissionMessage(context);
      return; // Exit the function if not admin
    }

    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty) return;

    setState(() => _isSubmitting = true);

    final user = UserEntity(
      id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name.isNotEmpty ? name : null,
      lastLogin: widget.user?.lastLogin ?? DateTime.now(),
      photoUrl: _pickedImage?.uri.toString() ?? widget.user?.photoUrl,
      companyId: widget.user?.companyId,
      role: _selectedRole,
    );

    final bloc = context.read<UserBloc>();
    if (widget.user == null) {
      bloc.add(AddNewUser(user));
    } else {
      bloc.add(UpdateUserEvent(user));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    currentUser = authState is Authenticated ? authState.user : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
        leading: IconButton(
          icon: Icon(widget.user != null ? Icons.arrow_back_ios : Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Picker
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
                                _pickedImage!.path.split('/').last,
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
                      : widget.user?.photoUrl != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.user!.photoUrl!),
                                  radius: 25,
                                ),
                                const Text("Tap to change image"),
                                const Icon(Icons.sync),
                              ],
                            )
                          : const Row(
                              children: [
                                Icon(Icons.image_outlined, color: Colors.grey),
                                SizedBox(width: 8),
                                Text("Tap to select profile photo"),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                readOnly: true,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name (Optional)',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),

              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'staff', child: Text('Staff')),
                  DropdownMenuItem(value: 'manager', child: Text('Manager')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: PermissionUtil.isAdmin(currentUser)
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                      }
                    : null, // Disables the dropdown if not admin
                // Optional: you can still show current value even if disabled
                disabledHint: Text(
                  _selectedRole[0].toUpperCase() + _selectedRole.substring(1),
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(widget.user == null ? 'Add User' : 'Update User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
