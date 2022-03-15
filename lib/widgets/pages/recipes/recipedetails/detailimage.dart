import 'dart:typed_data';

import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final Uint8List image;
  final double borderRadius;

  const RecipeImage({
    Key? key,
    required this.image,
    this.borderRadius = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        image: DecorationImage(
          image: MemoryImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
