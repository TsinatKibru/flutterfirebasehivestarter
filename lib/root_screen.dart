import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/utils/loading_page.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/auth/presentation/pages/login_screen.dart';
import 'package:stockpro/features/category/presentation/page/category_page.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';
import 'package:stockpro/features/company/presentation/pages/company_selection_page.dart';
import 'package:stockpro/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:stockpro/features/order/presentation/page/order_page.dart';
import 'package:stockpro/features/users/presentation/page/users_page.dart';
import 'package:stockpro/features/warehouse/presentation/page/warehouse_page.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          context
              .read<CompanyBloc>()
              .add(GetCompanyByIdEvent(state.user.companyId ?? ""));
          if (state.user.companyId == null || state.user.companyId == "") {
            return CompanySelectionPage(userId: state.user.id);
          }
          return _MainNavigationWrapper(user: state.user);
        } else if (state is AuthInitial || state is AuthLoading) {
          return LoadingPage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class _MainNavigationWrapper extends StatefulWidget {
  final dynamic user; // Replace with your User model

  const _MainNavigationWrapper({required this.user});

  @override
  State<_MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<_MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const InventoryListPage(), // Products feature
    const OrdersListPage(),

    const WarehousePage(), // Warehouses feature
    const CategoryPage(), // Categories feature
    const UsersPage(), // Users feature
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor, // Set primary color as background
      body: Container(
        decoration: BoxDecoration(
          color: theme
              .scaffoldBackgroundColor, // Use scaffold background for the content area
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.primaryColor,
            selectedItemColor: theme.colorScheme.onPrimary,
            unselectedItemColor: theme.colorScheme.onPrimary.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sync),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Warehouses',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.widgets_outlined,
                  fill: 0,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                label: 'Users',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
