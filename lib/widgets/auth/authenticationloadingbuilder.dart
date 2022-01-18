import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';

class AuthenticationLoadingBuilder extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  late List<Widget> progressStack;

  AuthenticationLoadingBuilder(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key) {
    progressStack = <Widget>[];
    progressStack.add(child);

    if (isLoading) {
      progressStack.add(const LoadingProcess());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: progressStack,
    );
  }
}
