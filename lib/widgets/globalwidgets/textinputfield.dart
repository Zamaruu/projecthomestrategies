import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String helperText;
  final TextInputType type;
  final IconData? suffixIcon;
  final int? maxChars;
  final FocusNode focusNode;
  final double borderWidth;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.helperText,
    required this.type,
    required this.focusNode,
    this.maxChars,
    this.suffixIcon,
    this.borderWidth = 2.0,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final Color backgroundColor = Colors.grey.withOpacity(0.15);
  late bool hasFocus;

  @override
  void initState() {
    super.initState();
    hasFocus = false;
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  Padding _buildSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        widget.suffixIcon,
        color: hasFocus || widget.controller.text.isNotEmpty
            ? Theme.of(context).primaryColor
            : Colors.grey,
        size: 24,
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: widget.helperText,
      suffixIcon: widget.suffixIcon != null ? _buildSuffixIcon() : null,
      suffixIconConstraints: const BoxConstraints(maxHeight: 25),
      isDense: true,
      contentPadding: const EdgeInsets.all(11),
      filled: true,
      fillColor: backgroundColor,
      labelStyle: TextStyle(
        color: hasFocus || widget.controller.text.isNotEmpty
            ? Theme.of(context).primaryColor
            : Colors.grey[600],
        fontWeight: hasFocus || widget.controller.text.isNotEmpty
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: widget.controller.text.isNotEmpty
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: widget.borderWidth),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.type,
      obscureText: widget.type == TextInputType.visiblePassword,
      maxLength: widget.maxChars,
      decoration: _buildInputDecoration(),
    );
  }
}
