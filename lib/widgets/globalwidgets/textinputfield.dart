import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String helperText;
  final TextInputType type;
  final IconData? suffixIcon;
  final int? maxChars;
  final FocusNode focusNode;
  final bool enabled;
  final double borderWidth;
  final int? maxLines;
  final Function? onTap;
  final double verticalMargin;
  final double horizontalMargin;
  final List<TextInputFormatter>? inputFormatters;
  final bool readonly;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.helperText,
    required this.type,
    required this.focusNode,
    this.maxChars,
    this.suffixIcon,
    this.borderWidth = 2.0,
    this.onTap,
    this.maxLines,
    this.verticalMargin = 0.0,
    this.horizontalMargin = 0.0,
    this.inputFormatters,
    this.readonly = false,
    this.enabled = true,
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
            ? widget.readonly
                ? Colors.grey.shade600
                : Theme.of(context).primaryColor
            : Colors.grey[600],
        fontWeight: hasFocus || widget.controller.text.isNotEmpty
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: widget.controller.text.isNotEmpty
                ? widget.readonly
                    ? Colors.grey
                    : Theme.of(context).primaryColor
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
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.verticalMargin,
        horizontal: widget.horizontalMargin,
      ),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        maxLines:
            widget.type == TextInputType.visiblePassword ? 1 : widget.maxLines,
        onTap: widget.onTap != null && !widget.readonly
            ? () => widget.onTap!()
            : null,
        readOnly: widget.readonly,
        enabled: widget.enabled,
        controller: widget.controller,
        keyboardType: widget.type,
        obscureText: widget.type == TextInputType.visiblePassword,
        maxLength: widget.maxChars,
        decoration: _buildInputDecoration(),
      ),
    );
  }
}
