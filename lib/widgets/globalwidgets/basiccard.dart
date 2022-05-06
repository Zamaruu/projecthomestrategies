import 'package:flutter/material.dart';

class BasicCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? padding;
  final EdgeInsets margin;

  const BasicCard({
    Key? key,
    required this.child,
    this.height,
    this.padding,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding != null ? EdgeInsets.all(padding!) : null,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: child,
    );
  }
}
