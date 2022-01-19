import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class NavigateBackButton extends StatelessWidget {
  const NavigateBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: Global.splashRadius,
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }
}
