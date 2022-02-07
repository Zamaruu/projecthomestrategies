import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  late String? firstLetter;
  late String? lastLetter;
  final double avatarRadius;
  final double fontSize;
  final Color color;
  final Image? image;

  UserAvatar({
    Key? key,
    this.firstLetter,
    this.lastLetter,
    this.avatarRadius = 125.0,
    this.fontSize = 45.0,
    this.color = Colors.blue,
    this.image,
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
    if (image != null) {
      return Container(
        height: avatarRadius,
        width: avatarRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: image!.image,
          ),
        ),
        alignment: Alignment.center,
      );
    } else {
      return Container(
        height: avatarRadius,
        width: avatarRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          "$firstLetter$lastLetter",
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      );
    }
  }
}
