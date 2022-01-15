import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubmitFAB extends StatelessWidget {
  final Function onPressed;
  final String tooltip;
  final IconData icon;

  const SubmitFAB({ Key? key, required this.onPressed, required this.tooltip, required this.icon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(),
      child: FaIcon(icon, color: Colors.white, size: 25,),
      tooltip: tooltip,
    );
  }
}