import 'package:flutter/material.dart';

class DrawerAvatar extends StatelessWidget {
  final double _avatarRadius = 125.0;
  final double _fontSize = 45.0;

  const DrawerAvatar({ Key? key }) : super(key: key);

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
        "MD",
        style: TextStyle(
          fontSize: _fontSize,
          color: Colors.white
        ),  
      ),
    );
  }
}