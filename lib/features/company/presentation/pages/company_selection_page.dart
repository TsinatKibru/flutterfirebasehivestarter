import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';
import 'package:stockpro/features/company/presentation/pages/company_form_page.dart';
import 'package:stockpro/features/users/presentation/bloc/user_bloc.dart';
import 'package:stockpro/features/users/presentation/bloc/user_event.dart';
import 'package:stockpro/features/users/presentation/bloc/user_state.dart';
import 'package:stockpro/root_screen.dart';

class CompanySelectionPage extends StatefulWidget {
  final String userId;

  const CompanySelectionPage({super.key, required this.userId});

  @override
  State<CompanySelectionPage> createState() => _CompanySelectionPageState();
}

class _CompanySelectionPageState extends State<CompanySelectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _secretController = TextEditingController();

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final theme = Theme.of(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          context.read<AuthBloc>().add(CheckAuthenticationStatus());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RootScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Company'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome to StockPro!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose how you want to get started',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_business_outlined),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CompanyFormPage(),
                            ),
                          );
                        },
                        label: const Text('Create a New Company'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _secretController,
                        decoration: const InputDecoration(
                          labelText: 'Join with Company Secret',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company secret';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final secret = _secretController.text.trim();
                            context
                                .read<CompanyBloc>()
                                .add(GetCompanyBySecretEvent(secret));
                          }
                        },
                        label: const Text('Join an Existing Company'),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<CompanyBloc, CompanyState>(
                        builder: (context, state) {
                          if (state is CompanyLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is CompanyBySecretLoaded ||
                              state is CompanyCreated) {
                            final company = (state is CompanyBySecretLoaded)
                                ? state.company
                                : (state as CompanyCreated).company;

                            if (company != null && user != null) {
                              final isCreator =
                                  widget.userId == company.adminUid;
                              context.read<UserBloc>().add(
                                    UpdateUserEvent(
                                      user.copyWith(
                                        companyId: company.id,
                                        role: isCreator ? "admin" : user.role,
                                      ),
                                    ),
                                  );

                              return const Text(
                                '✅ Successfully joined the company!',
                                style: TextStyle(color: Colors.green),
                              );
                            } else {
                              return const Text(
                                'Company not found or user not authenticated.',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                          } else if (state is CompanyError) {
                            return Text(
                              '${state.message}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
