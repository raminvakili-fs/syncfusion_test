import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/base_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/services/dependency_injector/injector.dart';
import 'package:flutter_deriv_api/services/dependency_injector/module_container.dart';
import 'package:syncfusion_features/candle/candle_chart.dart';
import 'package:syncfusion_features/line/line_live_update.dart';


class SyncFusion extends StatefulWidget {

  @override
  _SyncFusionState createState() => _SyncFusionState();

}

class _SyncFusionState extends State<SyncFusion> {

  @override
  void initState() {
    super.initState();

    ModuleContainer().initialize(Injector.getInjector());
    Injector.getInjector().get<BaseAPI>().connect(ConnectionInformation(
      appId: '1089',
      brand: 'binary',
      endpoint: 'frontend.binaryws.com'
    ));
  }

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
