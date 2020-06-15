import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class LineDefault extends StatefulWidget {
  const LineDefault({Key key}) : super(key: key);

  @override
  _LineDefaultState createState() => _LineDefaultState();
}

class _LineDefaultState extends State<LineDefault> {
  _LineDefaultState();
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
    super.dispose();
  }

  @override
  void didUpdateWidget(LineDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return FrontPanel();
  }
}

class FrontPanel extends StatefulWidget {

  FrontPanel();

  @override
  _FrontPanelState createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState();
  bool enableTooltip = true;
  bool enableMarker = true;
  bool enableDatalabel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Syncfusion Line Chart with crosshair'),),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Container(child: getDefaultLineChart(false)),
      ),
    );
  }
}


SfCartesianChart getDefaultLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: 'Click on the Chart to show crosshair'),
    legend: Legend(
        isVisible: isTileView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 2,
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent)),
    series: getLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
    zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        zoomMode: ZoomMode.x,
        enablePanning: true),
    crosshairBehavior: CrosshairBehavior(
        enable: true,
        lineWidth: 1,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: isTileView ? true : true,
        lineType: isTileView ? CrosshairLineType.both : CrosshairLineType.both),
  );
}

List<LineSeries<_ChartData, num>> getLineSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData(2005, 21, 28),
    _ChartData(2006, 24, 44),
    _ChartData(2007, 36, 48),
    _ChartData(2008, 38, 50),
    _ChartData(2009, 54, 66),
    _ChartData(2010, 57, 78),
    _ChartData(2011, 70, 84),
    _ChartData(2012, 70, 70),
    _ChartData(2013, 70, 92)
  ];
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
//        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'Germany',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
//        animationDuration: 2500,
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        name: 'England',
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}