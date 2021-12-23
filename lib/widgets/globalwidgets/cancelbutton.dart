import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function onCancel;
  
  const CancelButton({ Key? key, required this.onCancel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => onCancel(),
      style: TextButton.styleFrom(
        primary: Colors.grey.shade700
      ), 
      icon: Icon(
        Icons.arrow_back, 
        color: Colors.grey.shade700,
      ), 
      label: Text(
        "Abbrechen",
        style: TextStyle(
          color: Colors.grey.shade700
        ), 
      ),
    );
  }
}