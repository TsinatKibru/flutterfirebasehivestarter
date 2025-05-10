import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  final String label;
  final IconData? icon;

  const SectionDivider({
    Key? key,
    required this.label,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.grey[400];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: color, thickness: 1.2)),
          const SizedBox(width: 8),
          if (icon != null) Icon(icon, color: color, size: 18),
          if (icon != null) const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color, thickness: 1.2)),
        ],
      ),
    );
  }
}
