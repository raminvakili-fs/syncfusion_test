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
    this.type,
  }) : super(key: key);

  final List<ChartSampleData> chartData;
  final String type;
  final VoidCallback onZoomStart;
  final VoidCallback onZoomEnd;

  @override
  _CustomCandleChartState createState() => _CustomCandleChartState();
}

class _CustomCandleChartState extends State<CustomCandleChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Tooltip: click oh point, CrossHair: Long press'),
        Expanded(flex: 3, child: _buildMainChart()),
        Expanded(flex: 1, child: _buildMACDChart()),
      ],
    );
  }

  SfCartesianChart _buildMainChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'AAPL - 2016'),
        indicators: _buildIndicators(),
        primaryXAxis: _buildPrimaryXAxis(),
        primaryYAxis: _buildPrimaryYAxis(),
        axes: _buildAdditionalAxes(),
        series: widget.type == 'candle' ? getCandleSeries() : getOHLCSeries(),
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
        tooltipBehavior: TooltipBehavior(
            enable: true
        ),
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            // Displays the crosshair on single tap
            activationMode: ActivationMode.longPress));
  }

  List<ChartAxis> _buildAdditionalAxes() {
    return <ChartAxis>[
      NumericAxis(
//          minimum: 2000,
//          maximum: 0,
          interval: 1,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      ];
  }

  List<TechnicalIndicators<ChartSampleData, DateTime>> _buildIndicators() {
    return <TechnicalIndicators<ChartSampleData, DateTime>>[
        SmaIndicator<ChartSampleData, DateTime>(
            seriesName: 'SMA', period: 2, valueField: 'close'),
        AtrIndicator<ChartSampleData, DateTime>(period: 3, seriesName: 'ATR')
      ];
  }

  NumericAxis _buildPrimaryYAxis() {
    return NumericAxis(
//          minimum: 2000,
//          maximum: 0,
          interval: 1,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0));
  }

  DateTimeAxis _buildPrimaryXAxis() {
    return DateTimeAxis(
          dateFormat: DateFormat.ms(),
          interval: 10,
          intervalType: DateTimeIntervalType.auto,
          minimum: widget.chartData.first.epoch
              .subtract(const Duration(minutes: 2)),
          maximum:
              widget.chartData.first.epoch.add(const Duration(minutes: 40)),
          majorGridLines: MajorGridLines(width: 1));
  }

  SfCartesianChart _buildMACDChart() {
    return SfCartesianChart(
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        MacdIndicator<ChartSampleData, DateTime>(
            longPeriod: 2, shortPeriod: 1, seriesName: 'HiloOpenClose')
      ],
//      primaryXAxis: DateTimeAxis(
//          dateFormat: DateFormat.ms(),
//          interval: 10,
//          intervalType: DateTimeIntervalType.auto,
//          minimum:
//              widget.chartData.first.epoch.subtract(const Duration(minutes: 2)),
//          maximum:
//              widget.chartData.first.epoch.add(const Duration(minutes: 20)),
//          majorGridLines: MajorGridLines(width: 1)),
//      primaryYAxis: NumericAxis(
////          minimum: 2000,
////          maximum: 0,
//          interval: 1,
//          labelFormat: '\${value}',
//          axisLine: AxisLine(width: 0)),
      series: getCandleSeries(isVisible: false),
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
    );
  }

  List<CandleSeries<ChartSampleData, DateTime>> getCandleSeries({
    bool isVisible = true,
  }) =>
      <CandleSeries<ChartSampleData, DateTime>>[
        CandleSeries<ChartSampleData, DateTime>(
            isVisible: isVisible,
            enableTooltip: true,
            enableSolidCandles: true,
            dataSource: widget.chartData,
            name: 'AAPL',
            xValueMapper: (ChartSampleData sales, _) => sales.epoch,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            dataLabelSettings: DataLabelSettings(isVisible: false))
      ];

  List<HiloOpenCloseSeries<ChartSampleData, DateTime>> getOHLCSeries({
    bool isVisible = true,
  }) =>
      <HiloOpenCloseSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            isVisible: isVisible,
            enableTooltip: true,
            dataSource: widget.chartData,
            name: 'AAPL',
            xValueMapper: (ChartSampleData sales, _) => sales.epoch,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            dataLabelSettings: DataLabelSettings(isVisible: false))
      ];
}
