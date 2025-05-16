import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/company/presentation/bloc/company_bloc.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InventoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        BlocBuilder<CompanyBloc, CompanyState>(
          builder: (context, state) {
            if (state is CompanyLoaded ||
                state is CompanyCreated ||
                state is CompanyBySecretLoaded) {
              final company = (state as dynamic).company;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (company.imageUrl != null)
                      CircleAvatar(
                        backgroundImage: company.imageUrl!.startsWith('file://')
                            ? FileImage(File(Uri.parse(company.imageUrl!).path))
                            : NetworkImage(company.imageUrl!) as ImageProvider,
                        radius: 18,
                      )
                    else
                      const CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.business, size: 16),
                      ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _truncateName(company.name),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text('StockPro'),
              );
            }
          },
        )
      ],
    );
  }

  String _truncateName(String name) {
    return name.length > 10 ? '${name.substring(0, 10)}…' : name;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
