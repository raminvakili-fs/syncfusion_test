import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'model.dart';

class CustomCandleChart extends StatefulWidget {
  CustomCandleChart({
    Key key,
    this.chartData,
    this.onZoomStart,
    this.onZoomEnd,
  }) : super(key: key);

  final List<ChartSampleData> chartData;
  final VoidCallback onZoomStart;
  final VoidCallback onZoomEnd;

  @override
  _CustomCandleChartState createState() => _CustomCandleChartState();
}

class _CustomCandleChartState extends State<CustomCandleChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.ms(),
          interval: 10,
          intervalType: DateTimeIntervalType.auto,
          minimum: widget.chartData.first.epoch.subtract(const Duration(minutes: 2)),
          maximum: widget.chartData.first.epoch.add(const Duration(minutes: 20)),
          majorGridLines: MajorGridLines(width: 1)),
      primaryYAxis: NumericAxis(
//          minimum: 2000,
//          maximum: 0,
          interval: 1,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      series: getCandleSeries(),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
      ),
      onZoomStart: (_) {
        widget.onZoomStart();
      },
      onZoomEnd: (_) {
        widget.onZoomEnd();
      },
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
    );
  }

  List<CandleSeries<ChartSampleData, DateTime>> getCandleSeries() {
    print('Number of candles: ${widget.chartData.length}');
    return <CandleSeries<ChartSampleData, DateTime>>[
      CandleSeries<ChartSampleData, DateTime>(
          enableTooltip: true,
          enableSolidCandles: true,
          dataSource: widget.chartData,
          name: 'AAPL',
          animationDuration: 300,
          xValueMapper: (ChartSampleData sales, _) => sales.epoch,
          lowValueMapper: (ChartSampleData sales, _) => sales.low,
          highValueMapper: (ChartSampleData sales, _) => sales.high,
          openValueMapper: (ChartSampleData sales, _) => sales.open,
          closeValueMapper: (ChartSampleData sales, _) => sales.close,
          dataLabelSettings: DataLabelSettings(isVisible: false))
    ];
  }
}
