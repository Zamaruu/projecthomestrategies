import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/analysis_state.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PieSummaryLabelChart extends StatelessWidget {
  final List<BillModel> bills;
  final List<BillCategoryModel> categoryModels;

  const PieSummaryLabelChart(
      {Key? key, required this.bills, required this.categoryModels})
      : super(key: key);

  List<String> getCategoriesAsStrings() {
    var categories = <String>[];
    for (var model in categoryModels) {
      categories.add(model.billCategoryName!);
    }
    return categories;
  }

  double getTotalAmountOfCategory(String category, List<BillModel> bills) {
    double total = 0;

    var filtredBills =
        bills.where((bill) => bill.category!.billCategoryName! == category);

    for (var bill in filtredBills) {
      total += bill.amount!;
    }

    return total;
  }

  List<BillModel> filterBillsWithDates(
    DateTime start,
    DateTime end,
  ) {
    return bills
        .where((bill) => bill.date!.isAfter(start) && bill.date!.isBefore(end))
        .toList();
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalBills, String>> _createData(
    DateTime start,
    DateTime end,
    BuildContext ctx,
  ) {
    var categories = getCategoriesAsStrings();

    List<OrdinalBills> data = <OrdinalBills>[];

    var dateFilteredBills = filterBillsWithDates(start, end);

    for (var category in categories) {
      var amount = getTotalAmountOfCategory(category, dateFilteredBills);
      if (amount > 0) {
        data.add(
          OrdinalBills(
            category,
            amount,
          ),
        );
      }
    }

    data.sort((a, b) => b.sales.compareTo(a.sales));

    return [
      charts.Series<OrdinalBills, String>(
        id: 'Sales',
        domainFn: (OrdinalBills bill, _) => bill.title,
        measureFn: (OrdinalBills bill, _) => bill.sales,
        data: data,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (OrdinalBills sales, _) =>
            '${sales.title}:\n${sales.sales.toStringAsFixed(2)} €',
        colorFn: (_, index) {
          return charts.MaterialPalette.blue.makeShades(data.length)[index!];
        },
      ),
    ];
  }

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit and the
  // area outside of the bar is larger than the bar, it will draw outside of the
  // bar. Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisState>(
      builder: (context, state, _) {
        return charts.PieChart<String>(
          _createData(state.startDate, state.endDate, context),
          animate: true,
          // Add an [ArcLabelDecorator] configured to render labels outside of the
          // arc with a leader line.
          //
          // Text style for inside / outside can be controlled independently by
          // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
          //
          // Example configuring different styles for inside/outside:
          //       new charts.ArcLabelDecorator(
          //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
          //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
          defaultRenderer: charts.ArcRendererConfig(
            arcRendererDecorators: [charts.ArcLabelDecorator()],
          ),
        );
      },
    );
  }
}

/// Sample ordinal data type.
class OrdinalBills {
  final String title;
  final double sales;

  OrdinalBills(this.title, this.sales);
}
