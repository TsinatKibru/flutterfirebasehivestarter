import 'package:flutter/material.dart';

typedef PopoverActionCallback = void Function();

class EditDeletePopover extends StatelessWidget {
  final PopoverActionCallback onEdit;
  final PopoverActionCallback onDelete;

  const EditDeletePopover({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PopoverAction>(
      icon: const Icon(Icons.more_horiz),
      onSelected: (action) {
        switch (action) {
          case _PopoverAction.edit:
            onEdit();
            break;
          case _PopoverAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _PopoverAction.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: _PopoverAction.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}

enum _PopoverAction { edit, delete }
