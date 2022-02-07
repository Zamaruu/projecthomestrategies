import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Einstellungen",
      body: Center(
        child: TextButton(
          onPressed: () {
            print(Colors.blue.value);
          },
          child: const Text("Farbe"),
        ),
      ),
    );
  }
}
