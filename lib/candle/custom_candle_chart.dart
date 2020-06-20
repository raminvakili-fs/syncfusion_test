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
    this.minPrice,
    this.maxPrice,
  }) : super(key: key);

  final List<ChartSampleData> chartData;
  final String type;
  final VoidCallback onZoomStart;
  final VoidCallback onZoomEnd;

  final double minPrice;
  final double maxPrice;

  @override
  _CustomCandleChartState createState() => _CustomCandleChartState();
}

class _CustomCandleChartState extends State<CustomCandleChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Tooltip: click oh point, CrossHair: Long press'),
        Expanded(flex: 2, child: _buildMainChart()),
        Expanded(flex: 1, child: _buildMACDChart()),
        Expanded(flex: 1, child: _buildRSIChart()),
      ],
    );
  }

  SfCartesianChart _buildMainChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'R_50', textStyle: ChartTextStyle(fontSize: 10)),
      indicators: _buildMAIndicators(),
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

  List<TechnicalIndicators<ChartSampleData, dynamic>> _buildMAIndicators() {
    return <TechnicalIndicators<ChartSampleData, dynamic>>[
      SmaIndicator<ChartSampleData, dynamic>(
          seriesName: 'AAPL', period: 10, signalLineColor: Colors.orangeAccent),
      TmaIndicator<ChartSampleData, dynamic>(
          seriesName: 'AAPL', period: 10, signalLineColor: Colors.indigo),
    ];
  }

  NumericAxis _buildPrimaryYAxis() {
    return NumericAxis(
        minimum: widget.minPrice - 5,
        maximum: widget.maxPrice + 5,
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

  SfCartesianChart _buildMACDChart() => SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: _buildPrimaryXAxis(),
      axes: _buildIndicatorsAxes(),
      tooltipBehavior: TooltipBehavior(enable: true),
      indicators: <TechnicalIndicators<ChartSampleData, dynamic>>[
        MacdIndicator<ChartSampleData, dynamic>(
            period: 14,
            longPeriod: 5,
            shortPeriod: 2,
            signalLineWidth: 2,
            macdType: MacdType.both,
            histogramNegativeColor: Colors.blueGrey,
            seriesName: 'AAPL',
            yAxisName: 'agybrd')
      ],
      series: getCandleSeries(isVisible: false));

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
            ? Icon(Icons.flag, size: 300)
            : SizedBox.shrink();
      });

  _buildRSIChart() => SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: _buildPrimaryXAxis(),
      axes: _buildIndicatorsAxes(),
      tooltipBehavior: TooltipBehavior(enable: true),
      indicators: <TechnicalIndicators<ChartSampleData, dynamic>>[
        RsiIndicator<ChartSampleData, dynamic>(
            seriesName: 'AAPL',
            yAxisName: 'yaxes',
            overbought: 80,
            oversold: 20,
            showZones: true,
            period: 14),
      ],
      series: getCandleSeries(isVisible: false));

  List<ChartAxis> _buildIndicatorsAxes() {
    return <ChartAxis>[
      NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yaxes',
          minimum: 10,
          maximum: 110,
          interval: 20,
          axisLine: AxisLine(width: 0))
    ];
  }
}
