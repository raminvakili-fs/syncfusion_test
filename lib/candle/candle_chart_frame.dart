import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_candle_chart.dart';
import 'model.dart';

class CandleChartFrame extends StatefulWidget {
  @override
  _CandleChartFrameState createState() => _CandleChartFrameState();
}

class _CandleChartFrameState extends State<CandleChartFrame> {
  final List<ChartSampleData> _chartData = <ChartSampleData>[
    ChartSampleData(
        x: DateTime(2016, 06, 27),
        open: 93,
        yValue: 96.465,
        y: 91.5,
        close: 95.89),
    ChartSampleData(
        x: DateTime(2016, 07, 04),
        open: 95.39,
        yValue: 96.89,
        y: 94.37,
        close: 96.68),
    ChartSampleData(
        x: DateTime(2016, 07, 11),
        open: 96.75,
        yValue: 99.3,
        y: 96.73,
        close: 98.78),
    ChartSampleData(
        x: DateTime(2016, 07, 18),
        open: 98.7,
        yValue: 101,
        y: 98.31,
        close: 98.66),
    ChartSampleData(
        x: DateTime(2016, 07, 25),
        open: 98.25,
        yValue: 104.55,
        y: 96.42,
        close: 104.21),
    ChartSampleData(
        x: DateTime(2016, 08, 01),
        open: 104.41,
        yValue: 107.65,
        y: 104,
        close: 107.48),
    ChartSampleData(
        x: DateTime(2016, 08, 08),
        open: 107.52,
        yValue: 108.94,
        y: 107.16,
        close: 108.18),
    ChartSampleData(
        x: DateTime(2016, 08, 15),
        open: 108.14,
        yValue: 110.23,
        y: 108.08,
        close: 109.36),
    ChartSampleData(
        x: DateTime(2016, 08, 22),
        open: 108.86,
        yValue: 109.32,
        y: 106.31,
        close: 106.94),
    ChartSampleData(
        x: DateTime(2016, 08, 29),
        open: 106.62,
        yValue: 108,
        y: 105.5,
        close: 107.73),
    ChartSampleData(
        x: DateTime(2016, 09, 05),
        open: 107.9,
        yValue: 108.76,
        y: 103.13,
        close: 103.13),
    ChartSampleData(
        x: DateTime(2016, 09, 12),
        open: 102.65,
        yValue: 116.13,
        y: 102.53,
        close: 114.92),
    ChartSampleData(
        x: DateTime(2016, 09, 19),
        open: 115.19,
        yValue: 116.18,
        y: 111.55,
        close: 112.71),
    ChartSampleData(
        x: DateTime(2016, 09, 26),
        open: 111.64,
        yValue: 114.64,
        y: 111.55,
        close: 113.05),
  ];

  final Random random = Random();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      ChartSampleData last = _chartData.removeLast();

      double newClose = random.nextBool()
          ? (last.close + random.nextInt(10) + random.nextDouble())
          : (last.close - random.nextInt(10) + random.nextDouble());
      ChartSampleData newLast = ChartSampleData(
          x: last.x,
          open: last.open,
          yValue: newClose > last.yValue ? newClose : last.yValue,
          y: newClose < last.y ? newClose : last.y,
          close: newClose);
      _chartData.add(newLast);
      if (!zooming) {
        setState(() {});
      }
    });
  }

  bool zooming = false;

  @override
  Widget build(BuildContext context) {
    print('rebuilding with newLast: ${_chartData.last.close}');
    return Scaffold(
      body: CustomCandleChart(
        chartData: _chartData,
        onZoomStart: () => zooming = true,
        onZoomEnd: () => zooming = false,
      ),
    );
  }
}
