import 'package:flutter/material.dart';

class NextCookingStepDivider extends StatelessWidget {
  const NextCookingStepDivider({Key? key}) : super(key: key);

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
          const Icon(Icons.arrow_downward),
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
