import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/auth/initialize_user.dart';
import 'package:projecthomestrategies/widgets/homepage/notification_loader.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Global.getToken(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          return TokenProvider(
            tokenBuilder: (token) {
              debugPrint("Firebase JWT: $token");
              return InitializeUser(
                token: token,
                child: NotificationLoader(token: token),
              );
            },
          );
        }
      },
    );
  }
}
