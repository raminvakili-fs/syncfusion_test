import 'package:flutter/material.dart';
import 'package:syncfusion_features/candle/custom_candle_chart.dart';

class CandleChart extends StatefulWidget {
  @override
  _CandleChartState createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCandleChart(),
    );
  }
}
