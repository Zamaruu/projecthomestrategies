import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/widgets/billspage/analysis/chartpointmodalsheet.dart';
import 'package:projecthomestrategies/widgets/homepage/panelheading.dart';

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;
  final BillModel bill;

  TimeSeriesSales(this.time, this.sales, this.bill);
}

// ignore: must_be_immutable
class BillRetrospect extends StatelessWidget {
  late List<BillModel> bills;
  late List<charts.Series<dynamic, DateTime>> seriesList;

  List<BillModel> getLastThirtyDays(List<BillModel> bills) {
    bills = sortBillsAfterDate(bills);
    var now_1w = DateTime.now().subtract(const Duration(days: 30));
    return bills.where((element) => now_1w.isBefore(element.date!)).toList();
  }

  List<BillModel> sortBillsAfterDate(List<BillModel> bills) {
    bills.sort((a, b) {
      var adate = a.date!; //before -> var adate = a.expiry;
      var bdate = b.date!; //before -> var bdate = b.expiry;
      return bdate.compareTo(
        adate,
      ); //to get the order other way just switch `adate & bdate`
    });
    return bills;
  }

  BillRetrospect({
    Key? key,
    required this.bills,
  }) : super(key: key) {
    bills = getLastThirtyDays(bills);
    seriesList = _createData();
  }

  /// Creates a [TimeSeriesChart] with sample data and no transition.

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSales, DateTime>> _createData() {
    final data = List.generate(
      bills.length,
      (index) => TimeSeriesSales(
        bills[index].date!,
        bills[index].amount!,
        bills[index],
      ),
    );

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  final domainAxisStyle = const charts.DateTimeAxisSpec(
    renderSpec: charts.SmallTickRendererSpec(
      lineStyle: charts.LineStyleSpec(
        color: charts.MaterialPalette.white,
      ),
      labelStyle: charts.TextStyleSpec(
        color: charts.MaterialPalette.white,
      ),
    ),
  );

  final primaryAxisStyle = const charts.NumericAxisSpec(
    renderSpec: charts.GridlineRendererSpec(
      lineStyle: charts.LineStyleSpec(
        color: charts.MaterialPalette.white,
        thickness: 0,
      ),
      labelStyle: charts.TextStyleSpec(
        color: charts.MaterialPalette.white,
      ),
    ),
  );

  void showChartPointDetails(BuildContext ctx, List<BillModel> bill) {
    showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return ChartPointModalSheet(bills: bill);
      },
    );
  }

  List<BillModel> getBillsFromChartPoint(
    List<charts.SeriesDatum<DateTime>> pointObjects,
  ) {
    List<BillModel> bills = <BillModel>[];

    for (var chartPoint in pointObjects) {
      var tsObject = chartPoint.datum as TimeSeriesSales;
      bills.add(tsObject.bill);
    }

    return bills;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeading(
            heading: "30-Tage Rückblick",
            textColor: Colors.white,
          ),
          SizedBox(
            height: 200,
            child: charts.TimeSeriesChart(
              seriesList,
              animate: true,
              domainAxis: domainAxisStyle,
              primaryMeasureAxis: primaryAxisStyle,
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel<DateTime> model) {
                    if (model.hasDatumSelection) {
                      showChartPointDetails(
                        context,
                        getBillsFromChartPoint(model.selectedDatum),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
