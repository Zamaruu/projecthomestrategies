import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/basescaffold/basescaffold.dart';
import 'package:projecthomestrategies/widgets/pages/settings/usersettings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Einstellungen",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          UserSettings(),
        ],
      ),
    );
  }
}
