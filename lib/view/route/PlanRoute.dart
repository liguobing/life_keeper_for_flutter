import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanBean.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanListDateDialogYearItem.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanListDateMenuItem.dart';
import 'package:lifekeeperforflutter/presenter/PlanRoutePresenter.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';

class PlanRoute extends StatefulWidget {
  PlanRouteState createState() {
    return PlanRouteState();
  }
}

class PlanRouteState extends State<PlanRoute> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> weeksEnglish = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  List<PlanListDateMenuItem> dateMenuList = List();
  List<PlanListDateDialogYearItem> dateDialogYearsList = List();
  List<int> dateDialogMonthsList = List();
  List<PlanBean> planList = List();

  int currentYear = 0;
  int currentMonth = 0;
  int currentDay = 0;

  int showDataYear = 0;
  int showDataMonth = 0;
  int showDataDay = 0;

  int dialogYearScrollIndex = 4;

  String dateButtonTitle;

  SlidableController slidableController = SlidableController();

  PlanRoutePresenter presenter;

  @override
  void initState() {
    super.initState();
//    presenter = PlanRoutePresenter(this);
    presenter = PlanRoutePresenter(this);
    DateTime dateTime = DateTime.now();
    //显示数据的时间
    showDataYear = dateTime.year;
    showDataMonth = dateTime.month;
    showDataDay = dateTime.day;
    //当前时间
    currentYear = dateTime.year;
    currentMonth = dateTime.month;
    currentDay = dateTime.day;
    //为时间选择 Dialog 的年份 List 赋值
    for (int i = dateTime.year - 5; i <= dateTime.year + 5; i++) {
      PlanListDateDialogYearItem item = PlanListDateDialogYearItem();
      item.year = i;
      if (i == currentYear) {
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

    presenter.updateUi(showDataYear, showDataMonth, showDataDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          //Title
          Container(
            margin: EdgeInsets.fromLTRB(19, 45.67, 0, 9.33),
            child: Text(
              "计划列表",
              style: TextStyle(fontSize: 22.22),
            ),
          ),
          //日期 ListView
          Container(
            color: Colors.white,
            height: 60,
            margin: EdgeInsets.fromLTRB(0, 75.67, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dateMenuList.length,
              controller:
                  ScrollController(initialScrollOffset: showDataDay * 50.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      //更新显示
                      showDataDay = index + 1;
                      presenter.updateUi(
                          showDataYear, showDataMonth, showDataDay);
                      SlidableState state = slidableController.activeState;
                      if (state != null) {
                        state.close();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: dateMenuList[index].getCheckStatus()
                          ? Colors.lightGreenAccent
                          : Colors.white,
                      radius: 25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateMenuList[index].getWeek(),
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "${dateMenuList[index].getDay()}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          //计划 ListView
          Container(
            margin: EdgeInsets.fromLTRB(0, 128, 0, 0),
            child: ListView.builder(
              itemCount: planList.length,
              itemBuilder: (context, index) {
                return planList[index].isFinished > 0
                    ? getFinishedItem(context, index)
                    : getUnFinishedItem(index);
              },
            ),
          ),
          //日期/添加 按钮组
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        height: 50,
                        onPressed: () {
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SizedBox(
                                              width: 55,
                                              height: 38,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    for (int i = 0;
                                                        i <
                                                            dateDialogYearsList
                                                                .length;
                                                        i++) {
                                                      if (i == index) {
                                                        dateDialogYearsList[i]
                                                            .isCheck = true;
                                                      } else {
                                                        dateDialogYearsList[i]
                                                            .isCheck = false;
                                                      }
                                                    }
                                                  });
                                                  showDataYear =
                                                      dateDialogYearsList[index]
                                                          .year;
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 5),
                                                  decoration: new UnderlineTabIndicator(
                                                      borderSide: BorderSide(
                                                          width: 2.0,
                                                          color:
                                                              dateDialogYearsList[
                                                                          index]
                                                                      .isCheck
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .white),
                                                      insets:
                                                          EdgeInsets.fromLTRB(
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
                                          itemCount:
                                              dateDialogMonthsList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showDataMonth =
                                                    dateDialogMonthsList[index];
                                                if (showDataYear !=
                                                        currentYear ||
                                                    showDataMonth !=
                                                        currentMonth) {
                                                  showDataDay = 1;
                                                }
                                                presenter.updateUi(showDataYear,
                                                    showDataMonth, showDataDay);
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
                        color: Color(0xFFA8C573),
                        child: Text(
                          "$dateButtonTitle",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  currentYear == showDataYear &&
                          currentMonth == showDataMonth &&
                          currentDay == showDataDay
                      ? Text("")
                      : Expanded(
                          child: GestureDetector(
                            onTap: () {
                              DateTime dateTime = DateTime.now();
                              showDataYear = dateTime.year;
                              showDataMonth = dateTime.month;
                              showDataDay = dateTime.day;
                              presenter.updateUi(
                                  showDataYear, showDataMonth, showDataDay);
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFFE4181),
                              child: Text(
                                "今天",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "AddPlan").then((value) {
                          presenter.updateUi(
                              showDataYear, showDataMonth, showDataDay);
                        });
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFFE4181),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateAll(List<PlanListDateMenuItem> dateList, List<PlanBean> planList,
      String dateButtonTitle) {
    showWaitDialog(context);
    setState(() {
      this.planList = planList;
      this.dateMenuList = dateList;
      this.dateButtonTitle = dateButtonTitle;
    });
    hideWaitDialog(context);
  }

  void updatePlanList(List<PlanBean> planList) {
    showWaitDialog(context);
    setState(() {
      this.planList = planList;
    });
    hideWaitDialog(context);
  }

  void showWaitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text("正在加载，请稍后..."),
              )
            ],
          ),
        );
      },
    );
  }

  void hideWaitDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void showSnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        elevation: 20,
        action: new SnackBarAction(
          label: "知道了",
          onPressed: () {
            Scaffold.of(context).removeCurrentSnackBar();
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget getUnFinishedItem(int index) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Slidable(
        controller: slidableController,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("该计划已经完成了吗？"),
                        actions: <Widget>[
                          MaterialButton(
                            child: Text("取消"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          MaterialButton(
                            child: Text("确定"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              presenter.finishPlan(context, planList[index]);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image.asset(
                    "assets/images/plan_list___unfinished_plan.webp"),
              ),
            ),
            title: Text(planList[index].getPlanName()),
            subtitle: Text(
                TimeUtil.doubleTimeToString(planList[index].getStartTime())),
            trailing: Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  if (planList[index].getAlarmTime() >= 0) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("确定取消提醒吗？"),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child: Text("确定"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                presenter.removeAlarm(context, planList[index]);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pushNamed(context, "PlanAlarm").then((value) {
                      if (value != null) {
                        dynamic result = value;
                        presenter.addAlarm(
                            context, planList[index], result["AlarmTime"]);
                      }
                    });
                  }
                },
                child: planList[index].getAlarmTime() >= 0
                    ? Image.asset("assets/images/plan_list___alarm.webp")
                    : Image.asset("assets/images/plan_list___unalarm.webp"),
              ),
            ),
          ),
        ),
        secondaryActions: <Widget>[
          SlideAction(
            child: Image.asset(
                "assets/images/plan_list___item___delete_button.webp"),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    content: Text("删除单个计划还是删除整组计划？"),
                    actions: <Widget>[
                      MaterialButton(
                        child: Text("删除单个"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          presenter.deletePlanByObjectId(context,planList[index]);
                        },
                      ),
                      MaterialButton(
                        child: Text("删除整组"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          presenter.deletePlanByGroupId(context,planList[index]);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SlideAction(
            child: Image.asset(
                "assets/images/plan_list___item___edit_button.webp"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget getFinishedItem(BuildContext itemContext, int index) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Slidable(
        controller: slidableController,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset("assets/images/plan_list___finished_plan.png"),
            ),
            title: Text(planList[index].getPlanName()),
          ),
        ),
        secondaryActions: <Widget>[
          SlideAction(
            closeOnTap: false,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: Text("撤销完成计划？"),
                        actions: <Widget>[
                          MaterialButton(
                            child: Text("撤销"),
                            onPressed: () {
                              SlidableState state =
                                  slidableController.activeState;
                              state.close();
                              presenter.unFinishPlan(context, planList[index]);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              label: Text("撤销"),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
