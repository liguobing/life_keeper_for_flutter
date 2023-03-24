import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanAlarmRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanAlarmRouteState();
  }
}

class PlanAlarmRouteState extends State {
  List<int> alarmTimeList = [-1, 0, 5, 10, 15, 30, 60];
  List<String> alarmTitleList = [
    "不提醒",
    "计划开始时",
    "5 分钟前",
    "10 分钟前",
    "15 分钟前",
    "30 分钟前",
    "60 分钟前"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
        title: Text(
          "提醒设置",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                "AlarmTime": alarmTimeList[index],
                "AlarmTitle": alarmTitleList[index]
              });
            },
            child: ListTile(
              title: Text(alarmTitleList[index]),
            ),
          );
        },
        itemCount: alarmTitleList.length,
      ),
    );
  }
}
