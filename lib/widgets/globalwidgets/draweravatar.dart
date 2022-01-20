import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  late String? firstLetter;
  late String? lastLetter;
  final double avatarRadius;
  final double fontSize;

  UserAvatar({
    Key? key,
    this.firstLetter,
    this.lastLetter,
    this.avatarRadius = 125.0,
    this.fontSize = 45.0,
  }) : super(key: key) {
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
      height: avatarRadius,
      width: avatarRadius,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      alignment: Alignment.center,
      child: Text(
        "$firstLetter$lastLetter",
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
  }
}
