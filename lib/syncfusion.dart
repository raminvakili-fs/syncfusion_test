import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/base_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/services/dependency_injector/injector.dart';
import 'package:flutter_deriv_api/services/dependency_injector/module_container.dart';
import 'package:syncfusion_features/candle/charts_page.dart';
import 'package:syncfusion_features/line/line_chart.dart';

class SyncFusion extends StatefulWidget {
  @override
  _SyncFusionState createState() => _SyncFusionState();
}

class _SyncFusionState extends State<SyncFusion> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();

    _connectToAPI();
  }

  void _connectToAPI() async {
    ModuleContainer().initialize(Injector.getInjector());
    await Injector.getInjector().get<BaseAPI>().connect(ConnectionInformation(
        appId: '1089', brand: 'binary', endpoint: 'frontend.binaryws.com'));
    setState(() {
      _connected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connected
        ? ChartsPage()
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Line Chart'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LineChart())),
        ),
        ListTile(
          title: Text('Charts page'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChartsPage())),
        ),
      ],
    );
  }
}
