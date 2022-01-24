import 'package:flutter/material.dart';

class ErrorPageHandler extends StatelessWidget {
  final String error;

  const ErrorPageHandler({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Fehlerbehandlung"),
      // ),
      body: Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(),
        ),
      ),
    );
  }
}
