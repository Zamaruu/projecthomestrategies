import 'package:flutter/material.dart';

class PanelHeading extends StatelessWidget {
  final String heading;

  const PanelHeading({ Key? key, required this.heading }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}