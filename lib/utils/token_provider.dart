import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

typedef TokenBuilder = Widget Function(String token);

class TokenProvider extends StatelessWidget {
  final TokenBuilder tokenBuilder;
  const TokenProvider({Key? key, required this.tokenBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Global.getToken(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          return tokenBuilder(snapshot.data!);
        }
      },
    );
  }
}
