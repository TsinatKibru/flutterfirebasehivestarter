import 'package:flutter/material.dart';

class InventoryImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double? width;
  final double borderRadius;

  const InventoryImage({
    super.key,
    required this.imageUrl,
    this.height = 100,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidImage = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        !imageUrl!.startsWith('file://');

    return Container(
      height: height,
      width: width ?? double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.blueGrey[100],
        image: hasValidImage
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasValidImage
          ? const Icon(Icons.inventory_2, size: 36, color: Colors.blueGrey)
          : null,
    );
  }
}
