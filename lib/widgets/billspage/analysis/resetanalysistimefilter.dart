import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/analysis_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class ResetAnalysisFilter extends StatelessWidget {
  const ResetAnalysisFilter({Key? key}) : super(key: key);

  void resetFilter(BuildContext context) {
    var normalStart = context.read<BillingState>().getOldestDate();
    var normalEnd = context.read<BillingState>().getNewestDate();
    context.read<AnalysisState>().setStartDate(normalStart);
    context.read<AnalysisState>().setEndDate(normalEnd);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: Global.splashRadius,
      onPressed: () => resetFilter(context),
      icon: Icon(
        Icons.refresh,
        size: 21,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
