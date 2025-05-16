import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/widgets/app_bottom_sheet.dart';
import 'package:stockpro/core/common/widgets/common_header.dart';
import 'package:stockpro/core/utils/loading_page.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart'; // You might not need this
import 'package:stockpro/features/inventory/presentation/widgets/inventory_app_bar.dart'; // Adjust if needed
import 'package:stockpro/features/inventory/presentation/widgets/inventory_drawer.dart';
import 'package:stockpro/features/inventory/presentation/widgets/inventory_filter_bar.dart'; // Adjust if needed
import 'package:stockpro/features/users/presentation/bloc/user_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_state.dart';
import 'package:stockpro/features/users/presentation/widget/add_user_dialog.dart';
import 'package:stockpro/features/users/presentation/widget/user_list_shimmer.dart';
import 'package:stockpro/features/users/presentation/widget/user_list_widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  get onSortChanged => null; // Adjust if you want sorting
  String searchQuery = ''; // Implement search if needed
  String? sortOrder; // Implement sorting if needed

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AuthBloc>().add(CheckAuthenticationStatus());
  // }

  Future<void> _userManageBottomSheet() async {
    await BottomSheetUtils.showCustomBottomSheet(
      context: context,
      heightFactor: 0.7, // Adjust height as needed
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<UserBloc>()),
          // You might not need InventoryBloc here
          // BlocProvider.value(value: context.read<InventoryBloc>()),
        ],
        child: const AddUserDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InventoryAppBar(),
      drawer: const InventoryDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: 'Users',
              buttonLabel: 'Add User',
              onAdd: () {
                // _userManageBottomSheet();
              },
            ),
            InventoryFilterBar(
              hint: "Search Users...",
              onSearchChanged: (value) => setState(() => searchQuery = value),
              onSortChanged: (value) => setState(() => sortOrder = value),
            ),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: UserListShimmer());
                  } else if (state is UserLoaded) {
                    return UserListWidget(users: state.users);
                  } else if (state is UserError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No users'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
