import 'package:flutter/material.dart';

class TextStepDivider extends StatelessWidget {
  final String text;

  const TextStepDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 1,
            color: Colors.grey,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
