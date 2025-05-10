import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isRequired;
  final double? height;
  final int? maxLength;
  final double borderRadius;
  final String? placeholder; // Optional placeholder parameter
  final IconButton? leading; // Optional leading IconButton
  final IconButton? trailing; // Optional trailing IconButton

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isRequired = false,
    this.height,
    this.maxLength,
    this.borderRadius = 8.0,
    this.placeholder, // Initialize the placeholder parameter
    this.leading, // Initialize the leading IconButton
    this.trailing, // Initialize the trailing IconButton
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (maxLines > 1 ? null : 60),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: placeholder, // Set the placeholder text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
          prefixIcon: leading, // Set the leading icon
          suffixIcon: trailing, // Set the trailing icon
        ),
        validator: validator ??
            (isRequired ? (v) => v!.isEmpty ? 'Required' : null : null),
      ),
    );
  }
}
