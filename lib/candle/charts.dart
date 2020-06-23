import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_features/line/custom_line_series.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/model.dart';

class Charts extends StatefulWidget {
  Charts({
    Key key,
    this.chartData,
    this.markedData,
    this.onZoomStart,
    this.onZoomEnd,
    this.type,
    this.minPrice,
    this.maxPrice,
  }) : super(key: key);

  final List<ChartSampleData> chartData;
  final List<ChartSampleData> markedData;

  final String type;
  final VoidCallback onZoomStart;
  final VoidCallback onZoomEnd;

  final double minPrice;
  final double maxPrice;

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  ZoomPanArgs _zoomPanArgs = ZoomPanArgs();

  @override
  void initState() {
    super.initState();
  }

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

  Widget _buildMainChart() => SfCartesianChart(
        annotations: <CartesianChartAnnotation>[_buildATestFlagAnnotation()],
        plotAreaBorderWidth: 0,
        title:
            ChartTitle(text: 'R_50', textStyle: ChartTextStyle(fontSize: 10)),
        indicators: _buildMAIndicators(),
        primaryXAxis: _buildPrimaryXAxis(),
        primaryYAxis: _buildPrimaryYAxis(),
        series: <ChartSeries<ChartSampleData, dynamic>>[
          widget.type == 'candle'
              ? _getCandleSeries()
              : widget.type == 'ohlc' ? _getOHLCSeries() : _getLineSeries(),
          _buildMarkerSeries()
        ],
        trackballBehavior: TrackballBehavior(
            enable: true, activationMode: ActivationMode.longPress),
        onZoomStart: (args) {
          widget.onZoomStart();
          setState(() {
            _zoomPanArgs = args;
          });
        },
        onZoomEnd: (args) {
          widget.onZoomEnd();
          setState(() {
            _zoomPanArgs = args;
          });
        },
        zoomPanBehavior:
            ZoomPanBehavior(enablePinching: true, enablePanning: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        crosshairBehavior: CrosshairBehavior(
            enable: true, activationMode: ActivationMode.longPress),
      );

  CartesianChartAnnotation _buildATestFlagAnnotation() {
    return CartesianChartAnnotation(
      widget: Icon(
        Icons.flag,
        color: Colors.white,
      ),
      coordinateUnit: CoordinateUnit.point,
      region: AnnotationRegion.chart,
      y: widget.chartData.first.high,
      x: widget.chartData.first.epoch,
    );
  }

  ChartSeries<ChartSampleData, dynamic> _buildMarkerSeries() =>
      ScatterSeries<ChartSampleData, dynamic>(
        color: Colors.transparent,
        dataLabelSettings: DataLabelSettings(
            builder: (data, point, series, pointIndex, seriesIndex) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Marker\n ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top),
        dataSource: widget.markedData,
        xValueMapper: (ChartSampleData datum, int index) => datum.epoch,
        yValueMapper: (ChartSampleData datum, int index) => datum.high,
      );

  List<TechnicalIndicators<ChartSampleData, dynamic>> _buildMAIndicators() =>
      <TechnicalIndicators<ChartSampleData, dynamic>>[
        SmaIndicator<ChartSampleData, dynamic>(
            seriesName: 'AAPL',
            period: 10,
            signalLineColor: Colors.orangeAccent),
        TmaIndicator<ChartSampleData, dynamic>(
            seriesName: 'AAPL', period: 10, signalLineColor: Colors.indigo),
      ];

  NumericAxis _buildPrimaryYAxis() => NumericAxis(
      minimum: widget.minPrice - 5,
      maximum: widget.maxPrice + 5,
      interval: 5,
      labelFormat: '\${value}',
      axisLine: AxisLine(width: 0));

  DateTimeAxis _buildPrimaryXAxis() => DateTimeAxis(
      majorGridLines: MajorGridLines(width: 0),
      dateFormat: DateFormat.ms(),
      zoomFactor: _zoomPanArgs.currentZoomFactor,
      zoomPosition: _zoomPanArgs.currentZoomPosition,
      interval: 3,
      intervalType: DateTimeIntervalType.months,
      minimum:
          widget.chartData.first.epoch.subtract(const Duration(minutes: 4)),
      maximum: widget.chartData.last.epoch.add(const Duration(minutes: 4)));

  Widget _buildMACDChart() => SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: _buildPrimaryXAxis(),
          axes: _buildIndicatorsAxes(),
          zoomPanBehavior:
              ZoomPanBehavior(enablePanning: true, enablePinching: true),
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
          series: <ChartSeries<ChartSampleData, dynamic>>[
            _getCandleSeries(isVisible: false)
          ]);

  ChartSeries<ChartSampleData, DateTime> _getCandleSeries({
    bool isVisible = true,
  }) =>
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
          dataLabelSettings: _buildDataLabelSetting());

  ChartSeries<ChartSampleData, DateTime> _getOHLCSeries({
    bool isVisible = true,
  }) =>
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
          dataLabelSettings: _buildDataLabelSetting());

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

  Widget _buildRSIChart() => SfCartesianChart(
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
          series: <ChartSeries<ChartSampleData, dynamic>>[
            _getCandleSeries(isVisible: false)
          ]);

  List<ChartAxis> _buildIndicatorsAxes() => <ChartAxis>[
        NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            opposedPosition: true,
            name: 'yaxes',
            minimum: 10,
            maximum: 110,
            interval: 20,
            axisLine: AxisLine(width: 0))
      ];

  ChartSeries<ChartSampleData, DateTime> _getLineSeries() =>
      CustomLineSeries<ChartSampleData, DateTime>(
        animationDuration: 300,
        color: Colors.white,
        dataSource: widget.chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.epoch,
        yValueMapper: (ChartSampleData sales, _) =>
            (sales.high + sales.low + sales.open + sales.close) / 4,
      );
}
