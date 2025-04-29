import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/auth/presentation/pages/login_screen.dart';
import 'package:stockpro/features/inventory/presentation/pages/inventory.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print("state from RootScreen: $state");
        if (state is Authenticated) {
          print("state: ${state.user.toString()}");
          return const Inventory();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
