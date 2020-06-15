import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/common/tick/ohlc.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_base.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history_subscription.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:syncfusion_features/candle/custom_candle_chart.dart';
import 'package:syncfusion_features/candle/model.dart';

class CandleChart extends StatefulWidget {
  @override
  _CandleChartState createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  final List<ChartSampleData> _chartData = [
    ChartSampleData(
      epoch: DateTime(2016, 01, 11),
      open: 98.97,
      high: 101.19,
      low: 95.36,
      close: 97.13,
    )
  ];

  Timer _timer;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _getMockedLiveData();
    _getTickStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCandleChart(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _getTickStream() async {
    await Future.delayed(const Duration(seconds: 2));
    final TickHistorySubscription subscription =
        await TickHistory.fetchTicksAndSubscribe(
      TicksHistoryRequest(
        ticksHistory: 'R_50',
        adjustStartTime: 1,
        count: 10,
        end: 'latest',
        start: 1,
        style: 'candles',
      ),
    );

    subscription.tickStream.listen((TickBase tick) {
      final OHLC ohlc = tick;
      if (ohlc != null) {
        setState(() {
          _chartData.add(ChartSampleData(
            epoch: ohlc.epoch,
            low: double.tryParse(ohlc.low),
            high: double.tryParse(ohlc.high),
            open: double.tryParse(ohlc.open),
            close: double.tryParse(ohlc.close),
          ));
        });
      }
    });
  }

  void _getMockedLiveData() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _chartData.add(
          ChartSampleData(
            epoch: _chartData?.last?.epoch?.add(const Duration(days: 2)),
            open: _chartData.last.open + _getRandomValue(),
            high: _chartData.last.high + _getRandomValue(),
            low: _chartData.last.low + _getRandomValue(),
            close: _chartData.last.close + _getRandomValue(),
          ),
        );
      });
    });
  }

  double _getRandomValue() {
    return _random.nextBool()
        ? _random.nextInt(10) + _random.nextDouble()
        : -(_random.nextInt(10) + _random.nextDouble());
  }
}
