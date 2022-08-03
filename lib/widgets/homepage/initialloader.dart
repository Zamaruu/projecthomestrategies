import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/auth/initialize_user.dart';
import 'package:projecthomestrategies/widgets/homepage/notification_loader.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
