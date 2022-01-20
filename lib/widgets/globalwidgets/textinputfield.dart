import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String helperText;
  final TextInputType type;
  final int? maxChars;

  const TextInputField(
      {Key? key,
      required this.controller,
      required this.helperText,
      required this.type,
      this.maxChars})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: type == TextInputType.visiblePassword,
      maxLength: maxChars,
      decoration: InputDecoration(
        labelText: helperText,
      ),
    );
  }
}
