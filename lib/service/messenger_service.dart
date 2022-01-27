import 'package:flutter/material.dart';

class InAppMessengerService {
  final BuildContext context;
  final String message;
  final Color backgroundColor;

  InAppMessengerService(
    this.context, {
    required this.message,
    required this.backgroundColor,
  });

  void showSnackbar() {
    var snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
