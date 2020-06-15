import 'package:flutter/material.dart';
import 'package:syncfusion_features/candle/candle_chart.dart';
import 'package:syncfusion_features/line/line_live_update.dart';


class SyncFusion extends StatefulWidget {

  @override
  _SyncFusionState createState() => _SyncFusionState();

}

class _SyncFusionState extends State<SyncFusion> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Line Chart'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LineLiveUpdate()
            )),
          ),
          ListTile(
            title: Text('OHLC, Candle'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CandleChart()
            )),
          ),
        ],
      ),
    );
  }

}
