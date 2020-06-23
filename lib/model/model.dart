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

  DateTime epoch;
  num low;
  DateTime openTime;
  num high;
  num yValue2;
  num yValue3;
  Color pointColor;
  num size;
  String text;
  num open;
  num close;
  bool isMarked;

  void update(ChartSampleData newData) {
    epoch = newData.epoch;
    openTime = newData.openTime;
    open = newData.open;
    close = newData.close;
    high = newData.high;
    low = newData.low;
    isMarked = newData.isMarked;
  }

  @override
  String toString() => 'epoch: $epoch, close: $close';
}
