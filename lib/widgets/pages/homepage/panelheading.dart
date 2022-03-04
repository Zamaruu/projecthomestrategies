import 'package:flutter/material.dart';

class PanelHeading extends StatelessWidget {
  final String heading;
  final Color textColor;
  final double padding;
  final Widget? trailing;

  const PanelHeading({
    Key? key,
    required this.heading,
    this.textColor = Colors.black,
    this.padding = 4.0,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 17,
              color: textColor,
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
