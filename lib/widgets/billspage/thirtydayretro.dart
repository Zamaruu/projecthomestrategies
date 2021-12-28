import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:projecthomestrategies/widgets/homepage/panelheading.dart';

class BillRetrospect extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;

  const BillRetrospect({ Key? key, required this.seriesList }) : super(key: key);

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory BillRetrospect.withSampleData() {
    return BillRetrospect(
      seriesList: _createSampleData(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime(2017, 9, 19), 5),
      TimeSeriesSales(DateTime(2017, 9, 26), 25),
      TimeSeriesSales(DateTime(2017, 10, 3), 100),
      TimeSeriesSales(DateTime(2017, 10, 10), 75),
      TimeSeriesSales(DateTime(2017, 10, 18), 54),
      TimeSeriesSales(DateTime(2017, 11, 2), 78),
      TimeSeriesSales(DateTime(2017, 11, 7), 78),
      TimeSeriesSales(DateTime(2017, 11, 13), 5),
      TimeSeriesSales(DateTime(2017, 11, 24), 25),
      TimeSeriesSales(DateTime(2017, 12, 3), 34),
      TimeSeriesSales(DateTime(2017, 12, 10), 23),
      TimeSeriesSales(DateTime(2017, 12, 18), 92),
      TimeSeriesSales(DateTime(2017, 12, 23), 34),
      TimeSeriesSales(DateTime(2018, 1, 2), 78),
    ];

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
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}