import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';
import 'package:stockpro/features/users/presentation/bloc/user_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_event.dart';
import 'package:stockpro/features/users/presentation/widget/add_user_dialog.dart';
import 'package:stockpro/core/utils/permission_util.dart'; // Assuming this is the correct import path

class UserListWidget extends StatelessWidget {
  final List<UserEntity> users;

  const UserListWidget({super.key, required this.users});

  void _editUser(BuildContext context, UserEntity user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddUserDialog(user: user),
    ));
  }

  void _deleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserBloc>().add(DeleteUserEvent(userId));
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users available'),
      );
    }

    final List<UserEntity> adminUsers =
        users.where((user) => PermissionUtil.isAdmin(user)).toList();
    final List<UserEntity> staffUsers =
        users.where((user) => !PermissionUtil.isAdmin(user)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (adminUsers.isNotEmpty) ...[
          const Text(
            'Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...adminUsers.map((user) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child:
                        user.photoUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(user.name ?? user.email),
                  subtitle: Text(user.email),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editUser(context, user);
                      } else if (value == 'delete') {
                        _deleteUser(context, user.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (staffUsers.isNotEmpty) ...[
          const Text(
            'Staff',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...staffUsers.map((user) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child:
                        user.photoUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(user.name ?? user.email),
                  subtitle: Text(user.email),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editUser(context, user);
                      } else if (value == 'delete') {
                        _deleteUser(context, user.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
