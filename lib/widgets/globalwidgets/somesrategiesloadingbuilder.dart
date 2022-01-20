import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';

class HomeStrategiesLoadingBuilder extends StatelessWidget {
  final bool isLoading;
  final bool isDialog;
  final Widget child;
  late List<Widget> progressStack;

  HomeStrategiesLoadingBuilder({
    Key? key,
    required this.child,
    required this.isLoading,
    this.isDialog = false,
  }) : super(key: key) {
    progressStack = <Widget>[];
    progressStack.add(child);

    if (isLoading && !isDialog) {
      progressStack.add(const LoadingProcess());
    } else if (isLoading && isDialog) {
      progressStack.add(const DialogLoadingProgress());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: progressStack,
    );
  }
}

class DialogLoadingProgress extends StatelessWidget {
  const DialogLoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
