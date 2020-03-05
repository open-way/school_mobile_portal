import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartAsistencia extends StatelessWidget {
  final Text text;
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final double size;
  final double fontSize;
  const PieChartAsistencia(
      {Key key,
      this.text,
      this.dataMap,
      this.colorList,
      this.size,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        constraints: BoxConstraints(
            maxHeight: size, minHeight: size, maxWidth: size, minWidth: size),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            text,
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 0,
              chartRadius: constraints.maxHeight / 1.8,
              showChartValuesInPercentage: true,
              showChartValues: false,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[900],
              colorList: colorList,
              showLegends: false,
              legendPosition: LegendPosition.left,
              decimalPlaces: 0,
              showChartValueLabel: false,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
                fontSize: fontSize,
              ),
              chartType: ChartType.disc,
            )
          ]));
        }));
  }
}
