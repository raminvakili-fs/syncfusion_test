import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'model.dart';

class CustomCandleChart extends StatefulWidget {
  const CustomCandleChart({
    Key key,
    this.chartData,
  }) : super(key: key);

  final List<ChartSampleData> chartData;

  @override
  _CustomCandleChartState createState() => _CustomCandleChartState();
}

class _CustomCandleChartState extends State<CustomCandleChart>{

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.MMM(),
          interval: 3,
          intervalType: DateTimeIntervalType.months,
          minimum: widget?.chartData?.first?.x ?? DateTime(2016, 01, 01),
          maximum: widget?.chartData?.last?.x ?? DateTime(2016, 10, 01),
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 140,
          maximum: 60,
          interval: 20,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      series: getCandleSeries(),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
      ),
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
    );
  }

  List<CandleSeries<ChartSampleData, DateTime>> getCandleSeries() {

    return <CandleSeries<ChartSampleData, DateTime>>[
      CandleSeries<ChartSampleData, DateTime>(
          enableTooltip: true,
          enableSolidCandles: true,
          dataSource: widget.chartData,
          name: 'AAPL',
          animationDuration: 300,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          lowValueMapper: (ChartSampleData sales, _) => sales.y,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue,
          openValueMapper: (ChartSampleData sales, _) => sales.open,
          closeValueMapper: (ChartSampleData sales, _) => sales.close,
          dataLabelSettings: DataLabelSettings(isVisible: false))
    ];
  }
}
