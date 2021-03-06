import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StaySignedInCheckBox extends StatefulWidget {
  late bool staySignedIn;
  late Function setSignedIn;

  StaySignedInCheckBox(
      {Key? key, required this.staySignedIn, required this.setSignedIn})
      : super(key: key);

  @override
  _StaySignedInCheckBoxState createState() => _StaySignedInCheckBoxState();
}

class _StaySignedInCheckBoxState extends State<StaySignedInCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: widget.staySignedIn,
          onChanged: (newValue) => widget.setSignedIn(newValue),
        ),
        GestureDetector(
          onTap: () => widget.setSignedIn(!widget.staySignedIn),
          child: const Text("Angemeldet bleiben?"),
        ),
      ],
    );
  }
}
