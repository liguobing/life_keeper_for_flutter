import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_chart/BillChartOverViewBean.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanListDateDialogYearItem.dart';
import 'package:lifekeeperforflutter/presenter/BillChartRoutePresenter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';

class BillChartRoute extends StatefulWidget {
  @override
  State<BillChartRoute> createState() {
    return BillChartRouteState();
  }
}

class BillChartRouteState extends State<BillChartRoute> {
  BillChartRoutePresenter presenter;

  ///日期 dialog 月份
  List<int> dateDialogMonthsList = List();

  ///日期 dialog 年份
  List<PlanListDateDialogYearItem> dateDialogYearsList = List();

  ///图表年份
  int year;

  ///图表月份
  int month;

  ///收支概览 - 收入金额
  double incomeMoney = 0.00;

  ///收支概览 - 支出金额
  double expendMoney = 0.00;

  ///收支概览 - 结余金额
  double balanceMoney = 0.00;

  ///收支概览 - 日均支出
  double evaluateMoney = 0.00;

  ///饼状图数据
  List<PieChartSectionData> pieChartData = List();

  ///饼状图收入按钮颜色
  Color pieIncomeButtonColor = Color(0xff888888);

  ///饼状图支出按钮颜色
  Color pieExpendButtonColor = Colors.white;

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

  ///折线图形式
  ///1.收入
  ///2.支出
  ///3.收入和支出
  int lineChartDataType = 1;

  ///折线图收入按钮颜色
  Color lineIncomeButtonColor = Color(0xff888888);

  ///折线图支出按钮颜色
  Color lineExpendButtonColor = Colors.white;

  ///折线图全部按钮颜色
  Color lineAllButtonColor = Colors.white;

  @override
  void initState() {
    super.initState();

    lineChartIncomeData.add(0.0);
    lineChartExpendData.add(0.0);

    presenter = BillChartRoutePresenter(this);

    year = DateTime.now().year;
    month = DateTime.now().month;

    presenter.getData(context, year, month);

    //为时间选择 Dialog 的年份 List 赋值
    for (int i = year - 15; i <= year; i++) {
      PlanListDateDialogYearItem item = PlanListDateDialogYearItem();
      item.year = i;
      if (i == year) {
        item.isCheck = true;
      } else {
        item.isCheck = false;
      }
      dateDialogYearsList.add(item);
    }
    //为时间选择 Dialog 的月份 List 赋值
    for (int i = 1; i <= 12; i++) {
      dateDialogMonthsList.add(i);
    }
  }

  void updateUi(
      BillChartOverViewBean bean, List<PieChartSectionData> pieChartData) {
    setState(() {
      incomeMoney = bean.getIncome();
      expendMoney = bean.getExpend();
      balanceMoney = bean.getBalance();
      evaluateMoney = double.parse(bean.getEvaluate().toStringAsFixed(2));
      this.pieChartData = pieChartData;
    });
  }

  void updatePieChart(List<PieChartSectionData> pieChartData) {
    setState(() {
      this.pieChartData = pieChartData;
    });
  }

  updateLineChart(List<double> incomeData, List<double> expendData) {
    setState(() {
      this.lineChartIncomeData = incomeData;
      this.lineChartExpendData = expendData;
    });
  }

  showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context, //BuildContext对象
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(
          //调用对话框
          text: message,
        );
      },
    );
  }

  void hideDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "图表",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$year年$month月",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  child: StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: SimpleDialog(
                          children: [
                            SizedBox(
                              width: 313,
                              height: 38,
                              child: ListView.builder(
                                controller: ScrollController(
                                    initialScrollOffset: 55.0 * 4),
                                itemCount: dateDialogYearsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 55,
                                    height: 38,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          for (int i = 0;
                                              i < dateDialogYearsList.length;
                                              i++) {
                                            if (i == index) {
                                              dateDialogYearsList[i].isCheck =
                                                  true;
                                            } else {
                                              dateDialogYearsList[i].isCheck =
                                                  false;
                                            }
                                          }
                                        });
                                        year = dateDialogYearsList[index].year;
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        decoration: new UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color:
                                                    dateDialogYearsList[index]
                                                            .isCheck
                                                        ? Colors.redAccent
                                                        : Colors.white),
                                            insets: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${dateDialogYearsList[index].year}",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            SizedBox(
                              width: 313,
                              height: 162,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 1,
                                ),
                                itemCount: dateDialogMonthsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      month = dateDialogMonthsList[index];
                                      presenter.getData(context, year, month);
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: 80,
                                      height: 53,
                                      child: Center(
                                        child: Text(
                                          "${dateDialogMonthsList[index]} 月",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              child: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
      body: Container(
        color: Color(0xffF1F1F1),
        padding: EdgeInsets.only(left: 15, right: 15),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                width: 335,
                height: 210,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "收支概览",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("收入"),
                                          Text("$incomeMoney"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("支出"),
                                          Text("$expendMoney"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("结余"),
                                          Text("$balanceMoney"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("日均支出"),
                                          Text("$evaluateMoney"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: 335,
                height: 490,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "分类账单统计",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: pieChartData.length == 0
                            ? Center(
                                child: Text("无数据"),
                              )
                            : PieChart(
                                PieChartData(
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: pieChartData,
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 10),
                                child: MaterialButton(
                                  color: pieIncomeButtonColor,
                                  height: 30.0,
                                  child: Text('收入'),
                                  onPressed: () {
                                    presenter.getPieChartData(
                                        context, 1, year, month);
                                    setState(() {
                                      pieIncomeButtonColor = Color(0xff888888);
                                      pieExpendButtonColor = Colors.white;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: MaterialButton(
                                  color: pieExpendButtonColor,
                                  height: 30.0,
                                  child: Text('支出'),
                                  onPressed: () {
                                    presenter.getPieChartData(
                                        context, -1, year, month);
                                    setState(() {
                                      pieIncomeButtonColor = Colors.white;
                                      pieExpendButtonColor = Color(0xff888888);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: 2248,
                height: 415,
                child: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "每日收支波动图",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
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
                                          right: 18.0,
                                          left: 12.0,
                                          top: 24,
                                          bottom: 12),
                                      child: LineChart(
                                        getChartData(lineChartDataType),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 5),
                                child: MaterialButton(
                                  color: lineIncomeButtonColor,
                                  height: 30.0,
                                  child: Text('收入'),
                                  onPressed: () {
                                    setState(() {
                                      lineChartDataType = 1;
                                      presenter.getLineChartData(
                                          context, 1, year, month);
                                      lineIncomeButtonColor = Color(0xff888888);
                                      lineExpendButtonColor = Colors.white;
                                      lineAllButtonColor = Colors.white;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  color: lineExpendButtonColor,
                                  height: 30.0,
                                  child: Text('支出'),
                                  onPressed: () {
                                    setState(() {
                                      lineChartDataType = 2;
                                      presenter.getLineChartData(
                                          context, 2, year, month);
                                      lineIncomeButtonColor = Colors.white;
                                      lineExpendButtonColor = Color(0xff888888);
                                      lineAllButtonColor = Colors.white;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.centerLeft,
                                child: MaterialButton(
                                  color: lineAllButtonColor,
                                  height: 30.0,
                                  child: Text('全部'),
                                  onPressed: () {
                                    setState(() {
                                      lineChartDataType = 3;
                                      presenter.getLineChartData(
                                          context, 3, year, month);
                                      lineIncomeButtonColor = Colors.white;
                                      lineExpendButtonColor = Colors.white;
                                      lineAllButtonColor = Color(0xff888888);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData getChartData(int type) {
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
      lineBarsData: getLineChartData(type),
    );
  }

  List<LineChartBarData> getLineChartData(int type) {
    List<LineChartBarData> list = List();
    switch (type) {
      case 1:
        list.add(getIncomeLineChartData());
        break;
      case 2:
        list.add(getExpendLineChartData());
        break;
      case 3:
        list.add(getIncomeLineChartData());
        list.add(getExpendLineChartData());
        break;
    }
    return list;
  }

  LineChartBarData getIncomeLineChartData() {
    return LineChartBarData(
      spots: getIncomeSpot(),
      colors: incomeColors,
      barWidth: 1,
    );
  }

  LineChartBarData getExpendLineChartData() {
    return LineChartBarData(
      spots: getExpendSpot(),
      colors: expendColors,
      barWidth: 1,
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
        return "2日";
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
