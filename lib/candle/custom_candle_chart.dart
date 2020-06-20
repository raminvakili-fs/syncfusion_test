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
      series: widget.type == 'candle' ? getCandleSeries() : getOHLCSeries(),
      trackballBehavior: TrackballBehavior(
          enable: true, activationMode: ActivationMode.longPress),
      onZoomStart: (_) => widget.onZoomStart(),
      onZoomEnd: (_) => widget.onZoomEnd(),
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      crosshairBehavior: CrosshairBehavior(
          enable: true,
          // Displays the crosshair on single tap
          activationMode: ActivationMode.longPress),
    );
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

  List<TechnicalIndicators<ChartSampleData, dynamic>> _buildIndicators() {
    return <TechnicalIndicators<ChartSampleData, dynamic>>[
      SmaIndicator<ChartSampleData, dynamic>(seriesName: 'AAPL', period: 10),
      TmaIndicator<ChartSampleData, dynamic>(seriesName: 'AAPL', period: 10)
    ];
  }

  NumericAxis _buildPrimaryYAxis() {
    return NumericAxis(
        minimum: 220,
        maximum: 240,
        interval: 5,
        labelFormat: '\${value}',
        axisLine: AxisLine(width: 0));
  }

  DateTimeAxis _buildPrimaryXAxis() {
    return DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        dateFormat: DateFormat.ms(),
        interval: 3,
        intervalType: DateTimeIntervalType.months,
        minimum:
            widget.chartData.first.epoch.subtract(const Duration(minutes: 4)),
        maximum: widget.chartData.last.epoch.add(const Duration(minutes: 4)));
  }

  SfCartesianChart _buildMACDChart() {
    return SfCartesianChart(
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        MacdIndicator<ChartSampleData, DateTime>(
            isVisible: true,
            longPeriod: 14,
            shortPeriod: 5,
            seriesName: 'HiloOpenClose')
      ],
      primaryXAxis: _buildPrimaryXAxis(),
      primaryYAxis: _buildPrimaryYAxis(),
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
            animationDuration: 300,
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
            dataLabelSettings: _buildDataLabelSetting())
      ];

  List<HiloOpenCloseSeries<ChartSampleData, DateTime>> getOHLCSeries({
    bool isVisible = true,
  }) =>
      <HiloOpenCloseSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            animationDuration: 300,
            isVisible: isVisible,
            enableTooltip: true,
            dataSource: widget.chartData,
            name: 'AAPL',
            xValueMapper: (ChartSampleData sales, _) => sales.epoch,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            dataLabelSettings: _buildDataLabelSetting())
      ];

  DataLabelSettings _buildDataLabelSetting() => DataLabelSettings(
      isVisible: true,
      // Templating the data label
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final ChartSampleData chartData = data;
        return chartData.isMarked
            ? Icon(
                Icons.flag,
                size: 300,
              )
            : SizedBox.shrink();
      });
}
