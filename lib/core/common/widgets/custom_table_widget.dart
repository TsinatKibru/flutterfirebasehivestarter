import 'package:flutter/material.dart';

class CustomListTableWidget extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final List<TextAlign>? columnAlignments;
  final void Function(int rowIndex)? onRowTap;
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;
  final bool showBorder;
  final Color borderColor;

  const CustomListTableWidget({
    super.key,
    required this.headers,
    required this.rows,
    this.columnAlignments,
    this.onRowTap,
    this.headerStyle,
    this.cellStyle,
    this.showBorder = true,
    this.borderColor = const Color.fromARGB(255, 242, 239, 239), // subtle gray
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            headers
                .asMap()
                .entries
                .map((entry) => Text(
                      entry.value,
                      textAlign: columnAlignments?[entry.key] ?? TextAlign.left,
                      style: headerStyle ??
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ))
                .toList(),
            isHeader: true,
          ),
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return InkWell(
              onTap: onRowTap != null ? () => onRowTap!(index) : null,
              child: _buildRow(row),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRow(List<Widget> row, {bool isHeader = false}) {
    final bgColor = isHeader ? Colors.white : Colors.white;
    final paddinglength = isHeader ? 10.0 : 4.0;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: showBorder
            ? Border(
                bottom: BorderSide(color: borderColor),
                top:
                    isHeader ? BorderSide(color: borderColor) : BorderSide.none,
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(vertical: paddinglength), // reduced height
      child: Row(
        children: row.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;

          // Adjust width for image column
          final cellWidth = index == 0
              ? 50.0
              : index == 1
                  ? 75.0
                  : index == 3
                      ? 200.0
                      : 120.0;

          return Container(
            width: cellWidth,
            constraints: BoxConstraints(
              maxWidth: cellWidth,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: _getAlignment(columnAlignments?[index]),
            child: DefaultTextStyle.merge(
              style: (isHeader ? headerStyle : cellStyle) ??
                  const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
              child: widget,
            ),
          );
        }).toList(),
      ),
    );
  }

  Alignment _getAlignment(TextAlign? align) {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.left:
      default:
        return Alignment.centerLeft;
    }
  }
}
