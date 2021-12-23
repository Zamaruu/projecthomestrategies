import 'package:flutter/material.dart';

class HomepageListContainer extends StatelessWidget {
  final double padding;
  final Widget child;

  const HomepageListContainer({ Key? key, required this.child, this.padding = 8.0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(bottom: padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: child,
    );
  }
}