import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StaySignedInCheckBox extends StatefulWidget {
  late bool staySignedIn;

  StaySignedInCheckBox({ Key? key, required this.staySignedIn}) : super(key: key);

  @override
  _StaySignedInCheckBoxState createState() => _StaySignedInCheckBoxState();
}

class _StaySignedInCheckBoxState extends State<StaySignedInCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Theme.of(context).primaryColor,
      value: widget.staySignedIn, 
      onChanged: (newValue){
        setState(() {
          widget.staySignedIn = !widget.staySignedIn;
        });
      },
    );
  }
}