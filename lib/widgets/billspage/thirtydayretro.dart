import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:projecthomestrategies/bloc/bill_model.dart';
import 'package:projecthomestrategies/widgets/homepage/panelheading.dart';

class BillRetrospect extends StatelessWidget {
  final List<BillModel> bills;
  late List<charts.Series<dynamic, DateTime>> seriesList;

  BillRetrospect({
    Key? key,
    required this.bills,
  }) : super(key: key) {
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
      ),
    );

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeading(heading: "14-tage Rückblick"),
          SizedBox(
            height: 200,
            child: charts.TimeSeriesChart(
              seriesList,
              animate: true,
              // Optionally pass in a [DateTimeFactory] used by the chart. The factory
              // should create the same type of [DateTime] as the data provided. If none
              // specified, the default creates local date time.
              // dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
