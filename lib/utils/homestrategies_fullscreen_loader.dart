import 'package:flutter/material.dart';

class HomestrategiesFullscreenLoader extends StatelessWidget {
  final String loaderLabel;

  const HomestrategiesFullscreenLoader({Key? key, required this.loaderLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loaderLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
