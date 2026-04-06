import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.obscure = false,
    this.controller,
    super.key,
  });

  final String label;
  final String? hint;
  final bool obscure;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
