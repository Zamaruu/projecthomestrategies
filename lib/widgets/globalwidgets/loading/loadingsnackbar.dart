import 'package:flutter/material.dart';

class LoadingSnackbar {
  final BuildContext context;

  LoadingSnackbar(this.context);

  void showLoadingSnackbar({String text = "Bitte warte einen Augenblick :)"}) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void dismissSnackbar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
