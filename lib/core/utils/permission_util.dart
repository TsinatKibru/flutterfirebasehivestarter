import 'package:flutter/material.dart';
import 'package:stockpro/core/common/entities/user_entity.dart';

class PermissionUtil {
  static bool isAdmin(UserEntity? user) {
    return user?.role == 'admin';
  }

  static void showNoPermissionMessage(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message ?? 'You need admin privileges to perform this action'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static bool checkAdminWithMessage(BuildContext context, UserEntity? user,
      {String? message}) {
    if (!isAdmin(user)) {
      showNoPermissionMessage(context, message: message);
      return false;
    }
    return true;
  }
}
