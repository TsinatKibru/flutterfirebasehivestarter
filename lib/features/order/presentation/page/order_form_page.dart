import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/core/utils/permission_util.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/order/domain/entities/order_entity.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_event.dart';

class OrderFormPage extends StatefulWidget {
  const OrderFormPage({super.key});

  @override
  State<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  UserEntity? currentUser;

  void _submit() {
    if (!PermissionUtil.isAdmin(currentUser)) {
      PermissionUtil.showNoPermissionMessage(context);
      return; // Exit the function if not admin
    }

    if (_formKey.currentState!.validate()) {
      final order = OrderEntity(
        id: '', // Firestore/DB will assign this
        customerName: _customerNameController.text,
        price: double.parse(_totalAmountController.text),
        date: DateTime.now(), productId: '', productSku: '', productName: '',
        quantity: 0, category: '', type: '', isStocked: false,
      );

      context.read<OrderBloc>().add(AddNewOrder(order));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    currentUser = authState is Authenticated ? authState.user : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Enter a valid number'
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
