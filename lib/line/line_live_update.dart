import 'dart:async';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class LineLiveUpdate extends StatefulWidget {
  const LineLiveUpdate({Key key}) : super(key: key);

  @override
  _LineLiveUpdateState createState() => _LineLiveUpdateState();
}

Timer timer;
bool canStopTimer = false;
int wave1;
int wave2, count = 1;

class _LineLiveUpdateState extends State<LineLiveUpdate> {

  _LineLiveUpdateState();
  Timer timer;

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LineLiveUpdate oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Syncfusion Live Data!'), ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FrontPanel(),
        )
    );
  }
}

class FrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel();



  @override
  _FrontPanelState createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel> {



  final List <Color> color = <Color>[];


  final List<double> stops = <double>[];

  LinearGradient gradients;



  _FrontPanelState(){
    gradients = LinearGradient(colors: color, stops: stops);
  }

  Timer timer;

  @override
  void initState() {
    color.add(Color.fromRGBO(53, 92, 125, 0.9));
    color.add(Color.fromRGBO(53, 92, 125, 0.7));
    color.add(Color.fromRGBO(53, 92, 125, 0.3));

    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timer = Timer.periodic(Duration(seconds: 1), updateData);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateData(Timer timer) {
    setState(() {
      chartData1.add(_ChartData(xAxis, generateNextRandomValue(chartData1.last.sales, 6)),);
      xAxis = xAxis.add(Duration(seconds: 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text('Features: Scroll, Pan&Zoom, tooltip, Crosshair'),
          SizedBox(height: 80.0),
          Text('Data point: ${chartData1.length}'),
          Expanded(flex: 1, child: Center(child: getLiveUpdateChart())),
        ],
      ),
    );
  }


  SfCartesianChart getLiveUpdateChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.Hms(),
          intervalType: DateTimeIntervalType.seconds,
          majorGridLines: MajorGridLines(width: 0)
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
      series: getLineSeries(),

      zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          zoomMode: ZoomMode.x,
          enablePanning: true),

      crosshairBehavior: CrosshairBehavior(
          enable: true,
          lineWidth: 1,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: true,
          lineType: CrosshairLineType.both),


      tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          canShowMarker: true,
          format: 'point.x / point.y'),

//        annotations: <CartesianChartAnnotation>[
//          CartesianChartAnnotation(
//            widget: Container(
//              child: const Text(
//                '---------------------------------',
//                style: TextStyle(
//                    color: Colors.green,
//                    // color: currentTheme == Brightness.light? const Color.fromRGBO(0, 0, 0, 0.15) : Color.fromRGBO(255, 255, 255, 0.3),
//                    fontWeight: FontWeight.bold,
//                    fontSize: 10),
//              ),
//            ),
//            coordinateUnit: CoordinateUnit.point,
//            region: AnnotationRegion.chart,
//            x: 40,
//            y: 1.02,
//          )
//        ]
    );
  }

  List<AreaSeries<_ChartData, DateTime>> getLineSeries() {
    return <AreaSeries<_ChartData, DateTime>>[
      AreaSeries<_ChartData, DateTime>(
        animationDuration: 300,
          dataSource: chartData1,
          xValueMapper: (_ChartData sales, _) => sales.time,
          yValueMapper: (_ChartData sales, _) => sales.sales,
        borderColor: Colors.blueGrey,
        borderWidth: 2,
        borderDrawMode: BorderDrawMode.top,
        gradient: gradients,),
    ];
  }

  DateTime xAxis = DateTime(2019, 10, 1, 1, 1, 45);

  List<_ChartData> chartData1 = <_ChartData>[
    _ChartData(DateTime(2019, 10, 1, 1, 1, 1), 40),
  ];

}


class _ChartData {
  _ChartData(this.time, this.sales);
  final DateTime time;
  final double sales;
}