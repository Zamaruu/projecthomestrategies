import 'package:flutter/material.dart';

class HomepageListContainer extends StatelessWidget {
  final double padding;
  final double topMargin;
  final Widget child;

  const HomepageListContainer({ Key? key, required this.child, this.padding = 8.0, this.topMargin = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(top: topMargin, bottom: padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: child,
    );
  }
}