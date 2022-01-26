import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';
import 'package:provider/provider.dart';

class BillingsAnalysis extends StatelessWidget {
  const BillingsAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (ctx, state, child) {
        return Scaffold(
          body: ListView(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: BillRetrospect(
                  bills: state.bills,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
