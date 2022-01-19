import 'package:flutter/material.dart';

class DrawerAvatar extends StatelessWidget {
  late String? firstLetter;
  late String? lastLetter;
  final double _avatarRadius = 125.0;
  final double _fontSize = 45.0;

  DrawerAvatar({Key? key, this.firstLetter, this.lastLetter})
      : super(key: key) {
    if (firstLetter == null) {
      firstLetter = "";
    } else {
      firstLetter = firstLetter!.toUpperCase();
    }

    if (lastLetter == null) {
      lastLetter = "";
    } else {
      lastLetter = lastLetter!.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _avatarRadius,
      width: _avatarRadius,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      alignment: Alignment.center,
      child: Text(
        "$firstLetter$lastLetter",
        style: TextStyle(fontSize: _fontSize, color: Colors.white),
      ),
    );
  }
}
