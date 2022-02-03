import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/main.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';
import 'package:provider/provider.dart';

class ReSignInDialog extends StatelessWidget {
  const ReSignInDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Danke das Sie einen Haushalt erstellt haben. Um alle Funktionen dieser App nutzen zu können melden Sie sich bitte erneut an!",
                textAlign: TextAlign.center,
              ),
            ),
            PrimaryButton(
              onPressed: () {
                context.read<AuthenticationState>().signOut();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  "/auth",
                  (route) => false,
                );
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HomeStrategies(),
                //   ),
                //   (route) => false,
                // );
              },
              text: "Anmelden",
              icon: Icons.login,
            ),
          ],
        ),
      ),
    );
  }
}
