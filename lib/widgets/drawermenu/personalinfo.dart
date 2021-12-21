import 'package:flutter/material.dart';

class PersonalInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String familyGroup;

  const PersonalInfo({ Key? key, required this.firstName, required this.lastName, required this.familyGroup }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$firstName $lastName",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            familyGroup,
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}