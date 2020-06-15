import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/common/tick/ohlc.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_base.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history_subscription.dart';
import 'package:flutter_deriv_api/basic_api/generated/ticks_history_send.dart';

import 'custom_candle_chart.dart';
import 'model.dart';

class CandleChartFrame extends StatefulWidget {
  @override
  _CandleChartFrameState createState() => _CandleChartFrameState();
}

class _CandleChartFrameState extends State<CandleChartFrame> {
  final List<ChartSampleData> _chartData = <ChartSampleData>[];

  final Random random = Random();

  @override
  void initState() {
    super.initState();

    _getTickStream();
  }

  void _getMockedLiveData() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      ChartSampleData last = _chartData.removeLast();

      double newClose = random.nextBool()
          ? (last.close + random.nextInt(10) + random.nextDouble())
          : (last.close - random.nextInt(10) + random.nextDouble());
      ChartSampleData newLast = ChartSampleData(
          epoch: last.epoch,
          open: last.open,
          high: newClose > last.high ? newClose : last.high,
          low: newClose < last.low ? newClose : last.low,
          close: newClose);
      _chartData.add(newLast);
      if (!zooming) {
        setState(() {});
      }
    });
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
        print(
            'open: ${ohlc.open}, low: ${ohlc.low}, high: ${ohlc.high}, close: ${ohlc.close}');

        setState(() {
          final double newTickOpen = double.tryParse(ohlc.open);
          final double newTickLow = double.tryParse(ohlc.low);
          final double newTickHigh = double.tryParse(ohlc.high);
          final double newTickClose = double.tryParse(ohlc.close);

          if (_chartData.isNotEmpty &&
              ohlc.openTime == _chartData.last.openTime) {
            _chartData.removeLast();
          }
          _chartData.add(ChartSampleData(
            epoch: ohlc.epoch,
            low: newTickLow,
            high: newTickHigh,
            open: newTickOpen,
            close: newTickClose,
            openTime: ohlc.openTime,
          ));
        });
      }
    });
  }

  bool zooming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _chartData.isEmpty
          ? Center(
              child: Text('Connecting to WS...'),
            )
          : CustomCandleChart(
              chartData: _chartData,
              onZoomStart: () => zooming = true,
              onZoomEnd: () => zooming = false,
            ),
    );
  }
}
