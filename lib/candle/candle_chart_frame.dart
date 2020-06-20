import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/common/models/candle_model.dart';
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

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _getTickStream();
  }

  TickBase _lastTick;
  String type = 'candle';

  void _getMockedLiveData() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      ChartSampleData last = _chartData.removeLast();

      double newClose = _random.nextBool()
          ? (last.close + _random.nextInt(10) + _random.nextDouble())
          : (last.close - _random.nextInt(10) + _random.nextDouble());
      ChartSampleData newLast = ChartSampleData(
        epoch: last.epoch,
        open: last.open,
        high: newClose > last.high ? newClose : last.high,
        low: newClose < last.low ? newClose : last.low,
        close: newClose,
        isMarked: _random.nextBool(),
      );
      _chartData.add(newLast);
      if (!zooming) {
        setState(() {});
      }
    });
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

    setState(() {
      for (final CandleModel c in subscription.tickHistory.candles) {
        _chartData.add(ChartSampleData(
          open: c.open,
          low: c.low,
          high: c.high,
          close: c.close,
          epoch: c.epoch,
          isMarked: _random.nextBool(),
        ));
      }
    });

    subscription.tickStream.listen((TickBase tick) {
      final OHLC ohlc = tick;
      _lastTick = ohlc;
      if (ohlc != null) {
        final double newTickOpen = double.tryParse(ohlc.open);
        final double newTickLow = double.tryParse(ohlc.low);
        final double newTickHigh = double.tryParse(ohlc.high);
        final double newTickClose = double.tryParse(ohlc.close);

        if (_chartData.isNotEmpty && newTickOpen == _chartData.last.open) {
          _chartData.removeLast();
        }

        setState(() {
          _chartData.add(ChartSampleData(
            epoch: ohlc.openTime,
            low: newTickLow,
            high: newTickHigh,
            open: newTickOpen,
            close: newTickClose,
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
      body: Stack(
        children: <Widget>[
          _chartData.isEmpty
              ? Center(
                  child: Text('Connecting to WS...'),
                )
              : CustomCandleChart(
                  chartData: _chartData,
                  onZoomStart: () => zooming = true,
                  onZoomEnd: () => zooming = false,
                  type: type,
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  FlatButton(
//                    child: Icon(Icons.show_chart),
//                    onPressed: () {},
//                    color: Colors.white10,
//                  ),
                  FlatButton(
                    child: Icon(Icons.equalizer),
                    onPressed: () {
                      setState(() {
                        type = 'candle';
                      });
                    },
                    color: Colors.white10,
                  ),
                  FlatButton(
                    child: Icon(Icons.swap_vert),
                    onPressed: () {
                      setState(() {
                        type = 'ohlc';
                      });
                    },
                    color: Colors.white10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() async {
    await _lastTick?.unsubscribe();
    super.dispose();
  }
}
