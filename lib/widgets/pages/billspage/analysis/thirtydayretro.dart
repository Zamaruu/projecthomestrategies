import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/analysis/chartpointmodalsheet.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  late double sales;
  final List<BillModel> bills;

  TimeSeriesSales(this.time, this.sales, this.bills);
}

// ignore: must_be_immutable
class BillRetrospect extends StatelessWidget {
  final Color graphColor;
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
    required this.graphColor,
  }) : super(key: key) {
    bills = getLastThirtyDays(bills);
    seriesList = _createData();
  }

  List<DateTime> getDoubleDates(List<BillModel> bills) {
    var temp = <DateTime>[];
    var doubles = <DateTime>[];

    //Cut time from datetime objects
    for (var bill in bills) {
      bill.date = Global.cutTimeFromDate(bill.date!);
    }

    for (var bill in bills) {
      if (!temp.contains(bill.date)) {
        temp.add(bill.date!);
      } else {
        doubles.add(bill.date!);
      }
    }

    return doubles;
  }

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSales, DateTime>> _createData() {
    var doubleDates = getDoubleDates(bills);

    var data = <TimeSeriesSales>[];
    for (var bill in bills) {
      if (doubleDates.contains(bill.date)) {
        var index = data.indexWhere((element) => element.time == bill.date);
        if (index == -1) {
          data.add(TimeSeriesSales(
            bill.date!,
            bill.amount!,
            [bill],
          ));
        } else {
          data[index].sales += bill.amount!;
          data[index].bills.add(bill);
        }
      } else {
        data.add(TimeSeriesSales(
          bill.date!,
          bill.amount!,
          [bill],
        ));
      }
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(graphColor),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  final domainAxisStyle = const charts.DateTimeAxisSpec(
    renderSpec: charts.SmallTickRendererSpec(
      lineStyle: charts.LineStyleSpec(
        color: charts.MaterialPalette.black,
      ),
      labelStyle: charts.TextStyleSpec(
        color: charts.MaterialPalette.black,
      ),
    ),
  );

  final primaryAxisStyle = const charts.NumericAxisSpec(
    renderSpec: charts.GridlineRendererSpec(
      lineStyle: charts.LineStyleSpec(
        color: charts.MaterialPalette.black,
        thickness: 0,
      ),
      labelStyle: charts.TextStyleSpec(
        color: charts.MaterialPalette.black,
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
    var chartPoint = pointObjects.first;
    var tsObject = chartPoint.datum as TimeSeriesSales;
    return tsObject.bills;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
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
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
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
              defaultRenderer: charts.LineRendererConfig(includePoints: true),
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
