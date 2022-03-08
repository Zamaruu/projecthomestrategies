import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class NavigateBackButton extends StatelessWidget {
  final Color color;

  const NavigateBackButton({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      splashRadius: Global.splashRadius,
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }
}
