import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  const PrimaryButton({ Key? key, required this.onPressed, required this.text, required this.icon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onPressed(), 
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor
      ),
      icon: Icon(icon), 
      label: Text(text),
    );
  }
}