import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/common/models/candle_model.dart';
import 'package:flutter_deriv_api/api/common/tick/ohlc.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_base.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history.dart';
import 'package:flutter_deriv_api/api/common/tick/tick_history_subscription.dart';
import 'package:flutter_deriv_api/basic_api/generated/ticks_history_send.dart';

import 'charts.dart';
import '../model/model.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final List<ChartSampleData> _chartData = <ChartSampleData>[];
  final List<ChartSampleData> _markedData = <ChartSampleData>[];

  final Random _random = Random();

  StreamSubscription _streamSubscription;

  double _maxPrice = 200;
  double _minPrice = 200;

  @override
  void initState() {
    super.initState();
    _getTickStream();
  }

  TickBase _lastTick;
  String type = 'candle';
  int _numOfTicks = 0;

  void _getTickStream() async {
    final TickHistorySubscription subscription =
        await TickHistory.fetchTicksAndSubscribe(
      TicksHistoryRequest(
        ticksHistory: 'R_50',
        adjustStartTime: 1,
        count: 200,
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
  Widget build(BuildContext context) {
    print('$_numOfTicks ticks');
    return Scaffold(
      appBar: AppBar(title: Text('Number of ticks: $_numOfTicks'),),
      body: Stack(
        children: <Widget>[
          _chartData.isEmpty
              ? Center(
                  child: Text('Connecting to WS...'),
                )
              : Charts(
                  chartData: _chartData,
                  onZoomStart: () => zooming = true,
                  onZoomEnd: () => zooming = false,
                  type: type,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  markedData: _markedData,
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.show_chart),
                    onPressed: () {
                      setState(() {
                        type = 'line';
                      });
                    },
                    color: Colors.white10,
                  ),
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
    await _streamSubscription?.cancel();
    super.dispose();
  }
}
