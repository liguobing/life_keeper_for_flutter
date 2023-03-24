import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanRepeatRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanRepeatRouteState();
  }
}

class PlanRepeatRouteState extends State {
  List<String> weeksEnglish = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int time = ModalRoute.of(context).settings.arguments;
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(time);
    List<String> list = List();
    list.add("一次性活动");
    list.add("每天");
    list.add("每周(每周的${weeksEnglish[dt.weekday - 1]})");
    list.add("每月(每月的${dt.day}号)");
    list.add("每年(${dt.month}月${dt.day}日)");
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
          "重复",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, {"result": index});
            },
            child: ListTile(
              title: Text(list[index]),
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
