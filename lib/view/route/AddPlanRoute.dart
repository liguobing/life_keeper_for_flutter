import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/presenter/AddPlanRoutePresenter.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';

class AddPlanRoute extends StatefulWidget {
  @override
  AddPlanRouteState createState() {
    return AddPlanRouteState();
  }
}

class AddPlanRouteState extends State {
  List<String> weeksEnglish = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  AddPlanRoutePresenter presenter;

  //计划标题输入框控制器
  TextEditingController planTitleController = new TextEditingController();

  //计划备注输入框控制器
  TextEditingController planRemarkController = new TextEditingController();

  //计划地点输入框控制器
  TextEditingController planLocationController = new TextEditingController();

  //是否是全天计划
  bool isAllDay = false;

  //开始日期
  int startDate;

  //UI显示的开始日期
  String startDateStr;

  //开始时间
  int startTime;

  //UI 显示的开始时间
  String startTimeStr;

  //重复模式，默认为一次性
  int repeatType = 0;

  //UI 显示的重复模式
  String repeatTypeStr = "一次性活动";

  //结束重复模式，默认为次数
  int endRepeatType = 1;

  //结束重复的值，默认为 30 次
  int endRepeatValue = 30;

  //UI 显示的结束重复值
  String endRepeatValueStr = "30 次（默认）";

  //闹钟时间，默认不提醒
  int alarmTime = -1;

  //UI 显示的提醒时间
  String alarmTimeStr = "默认不提醒";

  //是否有闹钟提示
  bool hasAlarm = false;

  int currentYear = 0;
  int currentMonth = 0;
  int currentDay = 0;
  int currentHour = 0;
  int currentMinute = 0;
  int currentSecond = 0;

  @override
  void initState() {
    super.initState();
    presenter = AddPlanRoutePresenter(this);
    DateTime dateTime = DateTime.now();
    startDateStr = TimeUtil.doubleTimeToYearMonthDayWeek(dateTime);
    startDate = TimeUtil.dateTimeToLong(dateTime);
    startTimeStr = TimeUtil.doubleTimeToHourMinute(dateTime);
    startTime = 3600000 * dateTime.hour + 60000 * dateTime.minute;

    currentYear = dateTime.year;
    currentMonth = dateTime.month;
    currentDay = dateTime.day;
    currentHour = dateTime.hour;
    currentMinute = dateTime.minute;
    currentSecond = dateTime.second;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          //toolbar
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(35, 46, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/images/add_plan___cancel.webp",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 46, 0, 0),
                  alignment: Alignment.center,
                  child: Text(
                    "添加计划",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 46, 35, 0),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    presenter.savePlan(
                        context,
                        isAllDay,
                        planTitleController.text,
                        planRemarkController.text,
                        planLocationController.text,
                        startDate + startTime,
                        repeatType,
                        endRepeatType,
                        endRepeatValue,
                        alarmTime);
                  },
                  child: Image.asset(
                    "assets/images/add_plan___save_plan_btn.webp",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //标题输入框
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 14, 0, 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEDEDED), width: 0.5),
                      color: Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.fromLTRB(35, 20, 35, 0),
                    child: TextField(
                      controller: planTitleController,
                      decoration: InputDecoration.collapsed(
                        hintText: '请输入计划标题',
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  //全天事件
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 20, 35, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              "全天事件",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                          child: Container(
                            child: Switch(
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay = !isAllDay;
                                  if (isAllDay) {
                                    showSnackBar(context, "全天事件的提醒是每个小时提醒一次哦~");
                                    startTimeStr = "当天早 8 点";
                                    startTime = 3600000 * 8;
                                  } else {
                                    DateTime dateTime = DateTime.now();
                                    startTimeStr =
                                        TimeUtil.doubleTimeToHourMinute(
                                            dateTime);
                                    startTime = 3600000 * dateTime.hour +
                                        60000 * dateTime.minute;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //开始日期
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(35, 33, 0, 0),
                        child: Text(
                          "开始日期",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            DateTime firstDate = DateTime(1970, 1, 1);
                            DateTime lastDate = DateTime(3000, 1, 1);
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: firstDate,
                              lastDate: lastDate,
                              locale: Locale("zh"),
                            ).then((value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              startDate = TimeUtil.dateTimeToLong(value);
                              setState(() {
                                startDateStr =
                                    TimeUtil.doubleTimeToYearMonthDayWeek(
                                        value);
                                getPlanRepeat();
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 33, 35, 0),
                            alignment: Alignment.centerRight,
                            child: Text(startDateStr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //开始时间
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(35, 33, 0, 0),
                        child: Text(
                          "开始时间",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: 0,
                                  minute: 0,
                                )).then((value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String hour = value.hour > 9
                                  ? "${value.hour}"
                                  : "0${value.hour}";
                              String minute = value.minute > 9
                                  ? "${value.minute}"
                                  : "0${value.minute}";
                              startTime =
                                  3600000 * value.hour + 60000 * value.minute;
                              setState(() {
                                startTimeStr = "$hour:$minute";
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 33, 35, 0),
                            alignment: Alignment.centerRight,
                            child: Text(startTimeStr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //重复
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(35, 33, 0, 0),
                        child: Text(
                          "重复",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "PlanRepeat",
                                    arguments: (startDate + startTime))
                                .then((value) {
                              if (value != null) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  dynamic result = value;
                                  repeatType = result["result"];
                                  getPlanRepeat();
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 33, 35, 0),
                            alignment: Alignment.centerRight,
                            child: Text(repeatTypeStr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //结束重复
                  repeatType > 0
                      ? Row(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(35, 33, 0, 0),
                              child: Text(
                                "结束重复",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "PlanEndRepeat")
                                      .then(
                                    (value) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      setState(() {
                                        if (value == null) {
                                          print("直接关闭的");
                                        } else {
                                          dynamic result = value;
                                          endRepeatType =
                                              result["EndRepeatType"];
                                          if (endRepeatType == 0) {
                                            endRepeatValue =
                                                result["EndRepeatValue"];
                                            print(
                                                "endRepeatValue = $endRepeatValue");
                                            DateTime time = DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    endRepeatValue);
                                            int year = time.year;
                                            String month = time.month > 9
                                                ? "${time.month}"
                                                : "0${time.month}";
                                            String day = time.day > 9
                                                ? "${time.day}"
                                                : "0${time.day}";
                                            endRepeatValueStr =
                                                "$year-$month-$day 结束";
                                          } else {
                                            var resultCount =
                                                result["EndRepeatValue"];
                                            endRepeatValue = resultCount[0];
                                            endRepeatValueStr =
                                                "$endRepeatValue 次";
                                          }
                                        }
                                      });
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 33, 35, 0),
                                  alignment: Alignment.centerRight,
                                  child: Text(endRepeatValueStr),
                                ),
                              ),
                            )
                          ],
                        )
                      : Text(""),
                  //分割线
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 15, 35, 15),
                    color: Colors.black12,
                    height: 2,
                  ),
                  //提醒
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text(
                          "提醒",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "PlanAlarm")
                                .then((value) {
                              if (value != null) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  dynamic result = value;
                                  alarmTime = result["AlarmTime"];
                                  alarmTimeStr = result["AlarmTitle"];
                                  alarmTime >= 0
                                      ? hasAlarm = true
                                      : hasAlarm = false;
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 35, 0),
                            alignment: Alignment.centerRight,
                            child: Text(alarmTimeStr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //闹钟提醒
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 33, 35, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              "闹钟提醒",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                          child: Container(
                            child: Switch(
                              value: hasAlarm,
                              onChanged: (value) {
                                setState(() {
                                  hasAlarm = !hasAlarm;
                                  if (value) {
                                    alarmTime = 0;
                                    alarmTimeStr = "活动开始时";
                                  } else {
                                    alarmTime = -1;
                                    alarmTimeStr = "不提醒";
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //分割线
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 15, 35, 15),
                    color: Colors.black12,
                    height: 2,
                  ),
                  //地点输入框
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 14, 0, 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEDEDED), width: 0.5),
                      color: Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: TextField(
                      controller: planLocationController,
                      decoration: InputDecoration.collapsed(
                        hintText: '请输入地点',
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  //备注输入框
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 14, 0, 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEDEDED), width: 0.5),
                      color: Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.fromLTRB(35, 20, 35, 35),
                    child: TextField(
                      controller: planRemarkController,
                      decoration: InputDecoration.collapsed(
                        hintText: '请输入备注',
                        hintStyle: TextStyle(fontSize: 20),
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

  void updateWaitDialog() {}

  void hideWaitDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
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

  void getPlanRepeat() {
    switch (repeatType) {
      case 0:
        repeatTypeStr = "一次性活动";
        break;
      case 1:
        repeatTypeStr = "每天";
        break;
      case 2:
        DateTime dt =
            DateTime.fromMillisecondsSinceEpoch(startDate + startTime);
        repeatTypeStr = "每周(每周的${weeksEnglish[dt.weekday - 1]})";
        break;
      case 3:
        DateTime dt =
            DateTime.fromMillisecondsSinceEpoch(startDate + startTime);
        repeatTypeStr = "每月(每月的${dt.day}号)";
        break;
      case 4:
        DateTime dt =
            DateTime.fromMillisecondsSinceEpoch(startDate + startTime);
        repeatTypeStr = "每年(${dt.month}月${dt.day}日)";
        break;
    }
  }
}
