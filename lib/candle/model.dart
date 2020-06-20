import 'package:flutter/material.dart';

class ChartSampleData {
  ChartSampleData({
    this.epoch,
    this.low,
    this.openTime,
    this.high,
    this.yValue2,
    this.yValue3,
    this.pointColor,
    this.size,
    this.text,
    this.open,
    this.close,
    this.isMarked = false,
  });

  final dynamic epoch;
  final num low;
  final dynamic openTime;
  final num high;
  final num yValue2;
  final num yValue3;
  final Color pointColor;
  final num size;
  final String text;
  final num open;
  final num close;
  final bool isMarked;

  @override
  String toString() => 'epoch: $epoch, close: $close';
}
