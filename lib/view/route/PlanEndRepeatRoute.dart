import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

///结束重复 Route，分为时间和次数两种
class PlanEndRepeatRoute extends StatefulWidget {
  @override
  PlanEndRepeatRouteState createState() {
    return PlanEndRepeatRouteState();
  }
}

class PlanEndRepeatRouteState extends State<PlanEndRepeatRoute> {
  //结束重复的选项
  List<String> list = ["时间", "次数"];

  //当前年分，用于日期选择器中的年分不会出现今年之前
  int currentYear = 2000;

  @override
  void initState() {
    super.initState();
    DateTime time = DateTime.now();
    currentYear = time.year;
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
          "结束重复",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Picker(
                  hideHeader: false,
                  adapter: DateTimePickerAdapter(
                    yearBegin: currentYear,
                    type: 7,
                  ),
                  title: Text("结束日期"),
                  selectedTextStyle: TextStyle(color: Colors.blue),
                  onConfirm: (Picker picker, List value) {
                    DateTime selectTime =
                        (picker.adapter as DateTimePickerAdapter).value;
                    if (selectTime.millisecondsSinceEpoch <
                        DateTime.now().millisecondsSinceEpoch) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("结束时间必须超过今天"),
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
                    } else {
                      Navigator.pop(
                        context,
                        {
                          "EndRepeatType": 0,
                          "EndRepeatValue": selectTime.millisecondsSinceEpoch
                        },
                      );
                    }
                  },
                ).showModal(context);
              } else {
                Picker(
                  adapter: NumberPickerAdapter(
                    data: [
                      NumberPickerColumn(
                        begin: 1,
                        end: 99,
                      ),
                    ],
                  ),
                  hideHeader: false,
                  title: Text("循环次数"),
                  selectedTextStyle: TextStyle(color: Colors.blue),
                  onConfirm: (Picker picker, List value) {
                    print("value = $value");
                    Navigator.pop(
                      context,
                      {
                        "EndRepeatType": 1,
                        "EndRepeatValue": picker.getSelectedValues()
                      },
                    );
                  },
                ).showModal(context);
              }
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
