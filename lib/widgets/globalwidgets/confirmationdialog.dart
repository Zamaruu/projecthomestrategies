import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final String confirmText;
  final String? abortText;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    this.icon = Icons.done,
    required this.confirmText,
    this.abortText = "Abbrechen",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CancelButton(
          onCancel: () => Navigator.pop(context, false),
        ),
        PrimaryButton(
          onPressed: () => Navigator.pop(context, true),
          text: confirmText,
          icon: icon,
        ),
      ],
    );
  }
}
