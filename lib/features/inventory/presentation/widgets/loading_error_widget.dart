import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:stockpro/features/inventory/presentation/widgets/product_shimmer_grid.dart';

class LoadingErrorWidget extends StatefulWidget {
  final bool isLoading;
  final bool isError;
  final String? message;
  final IconData? icon;
  final Color color;

  const LoadingErrorWidget({
    super.key,
    this.isLoading = false,
    this.isError = false,
    this.message,
    this.icon,
    this.color = Colors.grey,
  });

  @override
  State<LoadingErrorWidget> createState() => _LoadingErrorWidgetState();
}

class _LoadingErrorWidgetState extends State<LoadingErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.isLoading)
              // const CircularProgressIndicator()
              const ProductShimmerGrid()
            else ...[
              Icon(
                widget.icon ??
                    (widget.isError ? Icons.error_outline : Icons.inbox),
                size: 48,
                color: widget.color,
              ),
              if (widget.message != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.message!,
                  style: TextStyle(fontSize: 16, color: widget.color),
                  textAlign: TextAlign.center,
                ),
              ],
              if (widget.isError) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<InventoryBloc>()
                        .add(WatchInventoryItemsEvent());
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text(
                    "Retry",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
