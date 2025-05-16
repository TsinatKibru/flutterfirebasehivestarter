import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/config/theme/app_themes.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/root_screen.dart';
import 'package:stockpro/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    MultiBlocProvider(
      providers: getBlocProviders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior:
            const MaterialScrollBehavior().copyWith(overscroll: false),
        debugShowCheckedModeBanner: false,
        theme: theme(),
        title: 'Daily News',
        // onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: RootScreen());
  }

  void _triggerInitialEvents(BuildContext context) {
    context.read<AuthBloc>().add(CheckAuthenticationStatus());
  }
}
