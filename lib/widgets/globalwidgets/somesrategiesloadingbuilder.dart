import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loadingprocessor.dart';

class HomeStrategiesLoadingBuilder extends StatelessWidget {
  final bool isLoading;
  final bool isDialog;
  final Widget child;
  final double height;
  late List<Widget> progressStack;

  HomeStrategiesLoadingBuilder({
    Key? key,
    required this.child,
    required this.isLoading,
    this.isDialog = false,
    this.height = 150,
  }) : super(key: key) {
    progressStack = <Widget>[];
    progressStack.add(child);

    if (isLoading && !isDialog) {
      progressStack.add(const LoadingProcess());
    } else if (isLoading && isDialog) {
      progressStack.add(
        DialogLoadingProgress(
          height: height,
        ),
      );
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
  final double height;
  const DialogLoadingProgress({Key? key, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
