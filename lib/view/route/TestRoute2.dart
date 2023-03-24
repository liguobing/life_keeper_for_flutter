import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lifekeeperforflutter/presenter/BillChartRoutePresenter.dart';
import 'package:lifekeeperforflutter/presenter/TestPresenter.dart';

class LineChartSample2 extends StatefulWidget {
  @override
  LineChartSample2State createState() => LineChartSample2State();
}

class LineChartSample2State extends State<LineChartSample2> {
  ///折线图收入线颜色
  List<Color> incomeColors = [
    Colors.lightGreenAccent,
    Colors.lightGreenAccent,
  ];

  ///折线图支出线颜色
  List<Color> expendColors = [
    Colors.red,
    Colors.red,
  ];

  ///折线图收入数据
  List<double> lineChartIncomeData = List();

  ///折线图支出数据
  List<double> lineChartExpendData = List();

  @override
  void initState() {
    super.initState();

    lineChartIncomeData.add(0.0);
    lineChartExpendData.add(0.0);

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 2248,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                width: 2248,
                child: AspectRatio(
                  aspectRatio: 1.70,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  updateLineChart(List<double> data) {
    setState(() {
      this.lineChartIncomeData = data;
    });
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(color: Color(0xff68737d), fontSize: 10),
          getTitles: (value) {
            return getTitle(value.toInt());
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1000:
                return '1K';
              case 5000:
                return '5K';
              case 10000:
                return '1W';
              case 15000:
                return '1.5W';
              case 20000:
                return '2W';
              case 30000:
                return '3W';
              case 40000:
                return '4W';
              case 50000:
                return '5W';
              case 60000:
                return '6W';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 31,
      minY: 0,
      maxY: lineChartIncomeData.reduce(max) + 1000,
      lineBarsData: [
        LineChartBarData(
          spots: getIncomeSpot(),
          colors: expendColors,
          barWidth: 1,
        ),
      ],
    );
  }

  List<FlSpot> getIncomeSpot() {
    List<FlSpot> list = List();
    for (int i = 0; i < lineChartIncomeData.length; i++) {
      list.add(FlSpot(double.parse("$i") + 1, lineChartIncomeData[i]));
    }
    return list;
  }
  List<FlSpot> getExpendSpot() {
    List<FlSpot> list = List();
    for (int i = 0; i < lineChartExpendData.length; i++) {
      list.add(FlSpot(double.parse("$i") + 1, lineChartExpendData[i]));
    }
    return list;
  }

  String getTitle(int index) {
    switch (index) {
      case 1:
        return "1日";
      case 2:
        return "2:日";
      case 3:
        return "3日";
      case 4:
        return "4日";
      case 5:
        return "5日";
      case 6:
        return "6日";
      case 7:
        return "7日";
      case 8:
        return "8日";
      case 9:
        return "9日";
      case 10:
        return "10日";
      case 11:
        return "11日";
      case 12:
        return "12日";
      case 13:
        return "13日";
      case 14:
        return "14日";
      case 15:
        return "15日";
      case 16:
        return "16日";
      case 17:
        return "17日";
      case 18:
        return "18日";
      case 19:
        return "19日";
      case 10:
        return "20日";
      case 21:
        return "21日";
      case 22:
        return "22日";
      case 23:
        return "23日";
      case 24:
        return "24日";
      case 25:
        return "25日";
      case 26:
        return "26日";
      case 27:
        return "27日";
      case 28:
        return "28日";
      case 29:
        return "29日";
      case 30:
        return "30日";
      case 31:
        return "31日";
      default:
        return "";
    }
  }
}
