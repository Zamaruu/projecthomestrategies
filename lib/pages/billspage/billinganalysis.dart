import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/analysis_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/barchartcategorysummary.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/piechartcategorysummary.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/resetanalysistimefilter.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/setfilterdates.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/thirtydayretro.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

class BillingsAnalysis extends StatelessWidget {
  const BillingsAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingState>(
      builder: (ctx, state, child) {
        return Scaffold(
          body: state.bills.isEmpty
              ? const Center(
                  child: Text("Keine Rechnungen vorhanden"),
                )
              : ListView(
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ChangeNotifierProvider<AnalysisState>(
                        create: (context) => AnalysisState(
                          state.getOldestDate(),
                          state.getNewestDate(),
                        ),
                        child: Builder(builder: (BuildContext context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: Row(
                                  children: const [
                                    PanelHeading(
                                      heading: "Kosten nach Kategorien",
                                    ),
                                    Spacer(),
                                    ResetAnalysisFilter(),
                                  ],
                                ),
                              ),
                              const AnalysisFilter(),
                              SizedBox(
                                height: 250,
                                child: HorizontalBarLabelChart(
                                  bills: state.bills,
                                  categoryModels: state.billCategories,
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                height: 250,
                                child: PieSummaryLabelChart(
                                  bills: state.bills,
                                  categoryModels: state.billCategories,
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
