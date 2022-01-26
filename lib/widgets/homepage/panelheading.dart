import 'package:flutter/material.dart';

class PanelHeading extends StatelessWidget {
  final String heading;
  final Color textColor;

  const PanelHeading(
      {Key? key, required this.heading, this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 17,
          color: textColor,
        ),
      ),
    );
  }
}
