import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:provider/provider.dart';

class BillingsAnalysis extends StatelessWidget {
  const BillingsAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (ctx, value, child) {
        return const Scaffold(
          body: Center(
            child: Text("Im Aufbau"),
          ),
        );
      },
    );
  }
}
