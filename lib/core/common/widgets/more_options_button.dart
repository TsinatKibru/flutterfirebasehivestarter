import 'package:flutter/material.dart';

class MoreOptionsButton extends StatelessWidget {
  final List<PopupMenuEntry> menuItems;

  const MoreOptionsButton({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => menuItems,
    );
  }
}
