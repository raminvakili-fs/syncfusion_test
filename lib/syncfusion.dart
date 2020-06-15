import 'package:flutter/material.dart';
import 'package:syncfusion_features/line_chart.dart';
import 'package:syncfusion_features/line_live_update.dart';
import 'package:syncfusion_features/live_update.dart';

class SyncFusion extends StatefulWidget {

  @override
  _SyncFusionState createState() => _SyncFusionState();

}

class _SyncFusionState extends State<SyncFusion> {

  @override
  Widget build(BuildContext context) {
    return LineLiveUpdate();
  }

}
