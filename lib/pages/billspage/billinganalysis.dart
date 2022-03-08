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
          backgroundColor: Colors.transparent,
          body: state.bills.isEmpty
              ? const Center(
                  child: Text("Keine Rechnungen vorhanden"),
                )
              : ListView(
                  children: [
                    BillRetrospect(
                      graphColor: Theme.of(context).primaryColor,
                      bills: state.bills,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
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
                                  horizontal: 10.0,
                                ),
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
