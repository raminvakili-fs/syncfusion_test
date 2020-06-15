import 'package:flutter/material.dart';
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
  final List<ChartSampleData> _chartData = <ChartSampleData>[];

  @override
  void initState() {
    super.initState();

    _getTickStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCandleChart(
        chartData: _chartData,
      ),
    );
  }

  void _getTickStream() async {
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
