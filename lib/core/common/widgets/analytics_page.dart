import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_state.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';
import 'package:stockpro/features/company/presentation/pages/company_form_page.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_bloc.dart';
import 'package:stockpro/features/order/presentation/bloc/order_state.dart';
import 'package:stockpro/features/users/presentation/bloc/user_state.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:stockpro/features/category/presentation/bloc/category_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/warehouse/presentation/bloc/warehouse_state.dart';

class AnalyticsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthBloc>().state is Authenticated
        ? (context.watch<AuthBloc>().state as Authenticated).user
        : null;

    final currentCompany = context.watch<CompanyBloc>().state
            is CompanyBySecretLoaded
        ? (context.watch<CompanyBloc>().state as CompanyBySecretLoaded).company
        : context.watch<CompanyBloc>().state is CompanyLoaded
            ? (context.watch<CompanyBloc>().state as CompanyLoaded).company
            : null;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        // Try to get updated current user from UserBloc
        UserEntity? updatedUser = currentUser;

        if (userState is UserLoaded && currentUser != null) {
          final match = userState.users.firstWhere(
            (u) => u.id == currentUser.id,
            orElse: () => currentUser,
          );
          updatedUser = match;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (updatedUser != null && currentCompany != null)
                _buildUserProfileCard(updatedUser, currentCompany, context),
              const SizedBox(height: 18),
              Text(
                "Quick Metrics",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              _buildMetricSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserProfileCard(
      UserEntity user, Company company, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            backgroundColor: Colors.grey[300],
            child: user.photoUrl == null
                ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user.name ?? "No Name",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.role ?? "Unknown",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            company.name,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanyFormPage(
                    company: company,
                    currentUser: user,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSection(BuildContext context) {
    return Column(
      children: [
        _buildInventoryMetrics(context),
        _buildOrderMetrics(context),
        _buildWarehouseMetrics(context),
        _buildCategoryMetrics(context),
        _buildUserMetrics(context),
        const SizedBox(height: 24),
        _buildSignOutButton(context),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required dynamic state,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            value ?? "-",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryMetrics(BuildContext context) =>
      BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) => _buildMetricTile(
          title: "Inventory",
          state: state,
          value:
              (state is InventoryLoaded) ? state.items.length.toString() : null,
        ),
      );

  Widget _buildOrderMetrics(BuildContext context) =>
      BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) => _buildMetricTile(
          title: "Orders",
          state: state,
          value: (state is OrderLoaded) ? state.orders.length.toString() : null,
        ),
      );

  Widget _buildWarehouseMetrics(BuildContext context) =>
      BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (context, state) => _buildMetricTile(
          title: "Warehouses",
          state: state,
          value: (state is WarehouseLoaded)
              ? state.warehouses.length.toString()
              : null,
        ),
      );

  Widget _buildCategoryMetrics(BuildContext context) =>
      BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) => _buildMetricTile(
          title: "Categories",
          state: state,
          value: (state is CategoryLoaded)
              ? state.categories.length.toString()
              : null,
        ),
      );

  Widget _buildUserMetrics(BuildContext context) =>
      BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => _buildMetricTile(
          title: "Users",
          state: state,
          value: (state is UserLoaded) ? state.users.length.toString() : null,
        ),
      );

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(SignOutEvent());
        },
        icon: Icon(Icons.logout),
        label: Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent),
          foregroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
