import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_event.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_state.dart';

class AddWarehousePage extends StatefulWidget {
  final WarehouseEntity? existingWarehouse;

  const AddWarehousePage({super.key, this.existingWarehouse});

  @override
  _AddWarehousePageState createState() => _AddWarehousePageState();
}

class _AddWarehousePageState extends State<AddWarehousePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingWarehouse != null) {
      _nameController.text = widget.existingWarehouse!.name;
      final location = widget.existingWarehouse!.location;
      final splitIndex = location.lastIndexOf(' ');
      if (splitIndex != -1) {
        _addressController.text = location.substring(0, splitIndex).trim();
        _cityController.text = location.substring(splitIndex + 1).trim();
      } else {
        _addressController.text = location;
        _cityController.text = '';
      }
    }
  }

  void _submitForm(bool isEditing, WarehouseBloc bloc) {
    if (_formKey.currentState?.validate() ?? false) {
      final newWarehouse = WarehouseEntity(
        id: isEditing
            ? widget.existingWarehouse!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        location:
            '${_addressController.text.trim()} ${_cityController.text.trim()}',
      );

      bloc.add(isEditing
          ? UpdateExistingWarehouse(newWarehouse)
          : AddNewWarehouse(newWarehouse));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingWarehouse != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditing ? 'Edit Warehouse' : 'Add Warehouse'),
      ),
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      isEditing ? 'Warehouse updated' : 'Warehouse added')),
            );
            Navigator.of(context).pop();
          } else if (state is WarehouseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<WarehouseBloc>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Warehouse Name',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter address'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter city'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state is WarehouseLoading
                          ? null
                          : () => _submitForm(isEditing, bloc),
                      icon: Icon(isEditing ? Icons.save : Icons.add_business),
                      label: Text(
                          isEditing ? 'Update Warehouse' : 'Add Warehouse'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  if (state is WarehouseLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: validator,
    );
  }
}
