import 'package:flutter/material.dart';

class LoadingProcess extends StatelessWidget {
  const LoadingProcess({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}