import 'dart:async';
import 'dart:math';
import 'package:flutter_deriv_api/api/common/models/candle_model.dart';
import 'package:flutter_deriv_api/api/common/tick/ohlc.dart';
import 'package:flutter_deriv_api/api/common/tick/tick.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_base.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history_subscription.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_features/model/model.dart';
import 'package:syncfusion_features/line/custom_line_series.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  _LineChartState();

  final List<ChartSampleData> _chartData = <ChartSampleData>[];
  final List<ChartSampleData> _markedData = <ChartSampleData>[];

  final Random _random = Random();

  StreamSubscription _streamSubscription;

  double _maxPrice = 200;
  double _minPrice = 200;

  TickBase _lastTick;
  String type = 'candle';
  int _numOfTicks = 0;

  void _addAsMarkerIfAnyChance(ChartSampleData newData) {
    if (_random.nextInt(10) > 8) {
      _markedData.add(newData);
    }
  }

  void _updatePriceRanges(double low, double high) {
    _maxPrice = max(_maxPrice, high);
    _minPrice = max(_maxPrice, low);
  }

  bool zooming = false;

  @override
  void initState() {
    super.initState();
    _getTickStream();
  }

  void _getTickStream() async {
    final TickHistorySubscription subscription =
        await TickHistory.fetchTicksAndSubscribe(
      TicksHistoryRequest(
        ticksHistory: 'R_50',
        adjustStartTime: 1,
        count: 20,
        end: 'latest',
        start: 1,
        style: 'candles',
        granularity: 60,
      ),
    );
    _numOfTicks = 0;
    _numOfTicks += subscription.tickHistory.candles.length;
    setState(() {
      for (final CandleModel c in subscription.tickHistory.candles) {
        _updatePriceRanges(c.low, c.high);
        final ChartSampleData newData = ChartSampleData(
          open: c.open,
          low: c.low,
          high: c.high,
          close: c.close,
          epoch: c.epoch,
          isMarked: _random.nextBool(),
        );
        _addAsMarkerIfAnyChance(newData);
        _chartData.add(newData);
      }
    });

    _streamSubscription = subscription.tickStream.listen((TickBase tick) {
      final OHLC ohlc = tick;
      _lastTick = ohlc;
      if (ohlc != null) {
        _numOfTicks++;
        final double newTickOpen = ohlc.open;
        final double newTickLow = ohlc.low;
        final double newTickHigh = ohlc.high;
        final double newTickClose = ohlc.close;

        _updatePriceRanges(newTickLow, newTickHigh);

        final ChartSampleData newData = ChartSampleData(
          epoch: ohlc.openTime,
          low: newTickLow,
          high: newTickHigh,
          open: newTickOpen,
          close: newTickClose,
        );

        if (_chartData.isNotEmpty && newTickOpen == _chartData.last.open) {
          _chartData.last.update(newData);
        } else {
          _addAsMarkerIfAnyChance(newData);
          _chartData.add(newData);
        }
        if (!zooming) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() async {
    await _lastTick.unsubscribe();
    await _streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Line Chart!'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text('Features: Scroll, Pan&Zoom, tooltip, Crosshair'),
              SizedBox(height: 10.0),
              Text('Ticks: $_numOfTicks'),
              Expanded(flex: 1, child: Center(child: _getLineChart())),
            ],
          ),
        ));
  }

  SfCartesianChart _getLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.Hms(),
          intervalType: DateTimeIntervalType.seconds,
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getLineSeries(),
      zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      crosshairBehavior: CrosshairBehavior(
          enable: true,
          lineWidth: 1,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: true,
          lineType: CrosshairLineType.both),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          canShowMarker: true,
          format: 'point.x / point.y'),
    );
  }

  List<ChartSeries<ChartSampleData, DateTime>> getLineSeries() {
    return <ChartSeries<ChartSampleData, DateTime>>[
      CustomLineSeries<ChartSampleData, DateTime>(
        animationDuration: 300,
        color: Colors.white,
        dataSource: _chartData,
//        gradient: LinearGradient(
//          colors: [const Color(0x008CA4A4), const Color(0xFF8CA4A4)],
//          stops: [0, 1],
//        ),
        xValueMapper: (ChartSampleData sales, _) => sales.epoch,
        yValueMapper: (ChartSampleData sales, _) => (sales.high + sales.low + sales.open + sales.close)/ 4,
      ),
    ];
  }
}
