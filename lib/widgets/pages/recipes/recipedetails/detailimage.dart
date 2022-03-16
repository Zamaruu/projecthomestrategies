import 'dart:typed_data';

import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String heroTag;
  final Uint8List image;
  final double borderRadius;

  const RecipeImage({
    this.borderRadius = 15,
    Key? key,
    required this.heroTag,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
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
      ),
    );
  }
}
