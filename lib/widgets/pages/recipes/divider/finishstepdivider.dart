import 'package:flutter/material.dart';

class FinishStepDivider extends StatelessWidget {
  const FinishStepDivider({Key? key}) : super(key: key);

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
          const Text(
            "Fertig",
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
