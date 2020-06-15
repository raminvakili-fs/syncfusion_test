import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class AreaChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AreaChart({Key key}) : super(key: key);

  @override
  _AreaChartState createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {

  Timer timer;
  List<OrdinalSales> chartData;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        chartData = getChartData();
      });
    });
    final List <Color> color = <Color>[];
    color.add(Color.fromRGBO(53, 92, 125, 0.9));
    color.add(Color.fromRGBO(53, 92, 125, 0.7));
    color.add(Color.fromRGBO(53, 92, 125, 0.3));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradients = LinearGradient(colors: color, stops: stops);

    return MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Live update'),
            ),
            body: Container(
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.Hms(),
                      intervalType: DateTimeIntervalType.seconds,
                      zoomFactor: 0.2,
                      zoomPosition: 0.4
                  ),

                  crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        lineWidth: 1,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: true,
                        lineType: CrosshairLineType.both),

                  zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                      enablePinching: true
                  ),

                  series: <ChartSeries<OrdinalSales, DateTime>>[
                    AreaSeries<OrdinalSales, DateTime>(
                      dataSource: getChartData(),
                      borderColor: Colors.blueGrey,
                      borderWidth: 2,
                      borderDrawMode: BorderDrawMode.top,
                      gradient: gradients,
                      xValueMapper: (OrdinalSales sales, _) => sales.time,
                      yValueMapper: (OrdinalSales sales, _) => sales.sales,
                    )
                  ],
                )),
          ),
        ));
  }

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<OrdinalSales> getChartData() {
    int seconds= 0;
    List<OrdinalSales> chartData = [];
    DateTime date = DateTime(2019,1,1,1,1,0);
    for (int i =0; i<120; i++){
      chartData.add(OrdinalSales(date, getRandomInt(10, 100)));
      date =date.add(Duration(seconds:30));
      seconds +=30;
    }
    return chartData;
  }
}

class OrdinalSales {
  OrdinalSales(this.time, this.sales);
  final DateTime time;
  final int sales;
}
