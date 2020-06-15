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

  final List<ChartSampleData> _chartData = [];

  @override
  void initState() {
    super.initState();

    _getTickStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCandleChart(
      ),
    );
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
            x: ohlc.epoch,
            y: double.tryParse(ohlc.low),
            yValue: double.tryParse(ohlc.high),
            open: double.tryParse(ohlc.open),
            close: double.tryParse(ohlc.close),
          ));
        });
      }
    });
  }
}

/*
{
  "ticks_history": "R_50",
  "adjust_start_time": 1,
  "count": 10,
  "end": "latest",
  "start": 1,
  "style": "ticks"
}
 */
