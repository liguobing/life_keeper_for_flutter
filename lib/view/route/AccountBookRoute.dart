import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillListItemTitleMoneyCount.dart';
import 'package:lifekeeperforflutter/presenter/AccountBookRoutePresenter.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:waveprogressbar_flutter/waveprogressbar_flutter.dart';

import 'AddBillRoute.dart';

class AccountBookRoute extends StatefulWidget {
  AccountBookRouteState createState() {
    return AccountBookRouteState();
  }
}

class AccountBookRouteState extends State<AccountBookRoute> {
  AccountBookRoutePresenter presenter;

  ///status bar 高度
  double statusBarHeight;

  /// Scaffold Key
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///波浪进度条进度
  double wavePercent = 0.0;

  ///当前年分
  int currentYear = 0;

  ///当前月份
  int month = 0;

  ///显示年分
  int year = 0;

  ///收入金额
  double incomeMoney = 0.0;

  ///支出金额
  double expendMoney = 0.0;

  ///账单 ListView 数据
  List<BillBean> billList = List();

  ///用户头像链接
  String userIconUrl;

  @override
  void initState() {
    super.initState();
    presenter = AccountBookRoutePresenter(this);
    DateTime currentTime = DateTime.now();
    year = currentTime.year;
    currentYear = currentTime.year;
    month = currentTime.month;

    presenter.getUserIconUrl();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      presenter.getBillData(context, year, month);
    });
  }

  WaterController waterController = WaterController();

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "收入",
            backgroundColor: Colors.greenAccent,
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AddBillRoute(1);
                }),
              ).then((value){
                presenter.getBillData(context, year, month);
              });
            },
            child: Icon(Icons.add))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AddBillRoute(-1);
                }),
              ).then((value){
                presenter.getBillData(context, year, month);
              });
            },
            heroTag: "支出",
            backgroundColor: Colors.redAccent,
            mini: true,
            child: Icon(Icons.remove))));

    statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.monetization_on),
          childButtons: childButtons),
      body: Column(
        children: [
          SizedBox(
            height: 200 + statusBarHeight,
            child: Container(
              color: Color(0xff1A85D0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20 + statusBarHeight),
                            child: GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10 + statusBarHeight),
                            child: Container(
                              alignment: Alignment.center,
                              child: WaveProgressBar(
                                heightController: waterController,
                                flowSpeed: 2.0,
                                waveDistance: 45.0,
                                waterColor: Colors.white,
                                percentage: wavePercent,
                                size: Size(100, 100),
                                textStyle: TextStyle(
                                    color: Color(0x15000000),
                                    fontSize: 0.1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              month = month - 1;
                              if (month == 0) {
                                month = 12;
                                year = year - 1;
                              }
                              presenter.getBillData(context, year, month);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$month 月收入",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "￥$incomeMoney",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: currentYear == year
                                ? Text("")
                                : Text(
                                    "$year 年",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$month 月支出",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "￥$expendMoney",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              month = month + 1;
                              if (month == 13) {
                                month = 1;
                                year = year + 1;
                              }
                              presenter.getBillData(context, year, month);
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      showBillDetail(index);
                    },
                    child: getItem(index),
                  );
                },
                itemCount: billList.length,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xff1A85D0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30 + statusBarHeight, 0, 0),
                child: ClipOval(
                  child: getUserIcon(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30 + statusBarHeight, 0, 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "BillCategory");
                    },
                    child: Text(
                      "账单分类",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30 + statusBarHeight, 0, 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "BillAccount");
                    },
                    child: Text(
                      "账单账户",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30 + statusBarHeight, 0, 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "BillChart");
                    },
                    child: Text(
                      "图表",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BillListItemTitleMoneyCount> moneyCountList;

  void updateUI(List<BillBean> list, double incomeCount, double expendCount,
      List<BillListItemTitleMoneyCount> moneyCountList, double wavePercent) {
    setState(() {
      this.billList.clear();
      this.billList.addAll(list);
      this.incomeMoney = incomeCount;
      this.expendMoney = expendCount;
      this.moneyCountList = moneyCountList;
      this.wavePercent = wavePercent;
    });
    waterController.changeWaterHeight(wavePercent);
  }

  void updateUserIcon(String userIconUrl) {
    setState(() {
      print("URL = ${this.userIconUrl}");
      this.userIconUrl = userIconUrl;
    });
  }

  Widget getUserIcon() {
    if (this.userIconUrl == null) {
      return Image.asset(
        "assets/images/login___viewpager___login___user_icon.webp",
        width: 80,
      );
    } else {
      return Image.network(
        userIconUrl,
        width: 80,
      );
    }
  }

  Widget getItem(int index) {
    if (index == 0) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(billList[index].getBillDate());
      BillListItemTitleMoneyCount moneyCount = moneyCountList[dateTime.day - 1];
      String date = TimeUtil.doubleTimeToYearMonthDayWeek(dateTime);
      return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            SizedBox(
              height: 25,
              child: Container(
                color: Color(0xffF5F5F5),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "$date",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text(""),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        "收入：${moneyCount.incomeCountOfDay}      支出：${moneyCount.expendCountOfDay}",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: billList[index].getBillProperty() > 0
                  ? Image.asset(
                      "assets/images/account_book___listview_item___income_icon.webp")
                  : Image.asset(
                      "assets/images/account_book___listview_item___expend_icon.webp"),
              title: Text("${billList[index].getBillCategory()}"),
              trailing: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("${billList[index].getBillMoney()}"),
              ),
            )
          ],
        ),
      );
    } else {
      if (DateTime.fromMillisecondsSinceEpoch(billList[index].getBillDate()) ==
          DateTime.fromMillisecondsSinceEpoch(
              billList[index - 1].getBillDate())) {
        return Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: ListTile(
            leading: billList[index].getBillProperty() > 0
                ? Image.asset(
                    "assets/images/account_book___listview_item___income_icon.webp")
                : Image.asset(
                    "assets/images/account_book___listview_item___expend_icon.webp"),
            title: Text("${billList[index].getBillCategory()}"),
            trailing: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text("${billList[index].getBillMoney()}"),
            ),
          ),
        );
      } else {
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(billList[index].getBillDate());
        BillListItemTitleMoneyCount moneyCount =
            moneyCountList[dateTime.day - 1];
        String date = TimeUtil.doubleTimeToYearMonthDayWeek(dateTime);
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              SizedBox(
                height: 25,
                child: Container(
                  color: Color(0xffF5F5F5),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "$date",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Expanded(
                        child: Text(""),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          "收入：${moneyCount.incomeCountOfDay}      支出：${moneyCount.expendCountOfDay}",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: billList[index].getBillProperty() > 0
                    ? Image.asset(
                        "assets/images/account_book___listview_item___income_icon.webp")
                    : Image.asset(
                        "assets/images/account_book___listview_item___expend_icon.webp"),
                title: Text("${billList[index].getBillCategory()}"),
                trailing: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text("${billList[index].getBillMoney()}"),
                ),
              )
            ],
          ),
        );
      }
    }
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

  Future<void> showSnackBar(BuildContext context, String message) async {
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

  void showBillDetail(int index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Container(
                    margin: EdgeInsets.only(right: 40),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("确定删除该账单？"),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          presenter.deleteBill(
                                              context,
                                              billList[index].getObjectId(),
                                              year,
                                              month);
                                        },
                                        child: Text("确定"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("金额"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: billList[index].getBillProperty() > 0
                              ? Text(
                                  "${billList[index].getBillMoney()}",
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                  ),
                                )
                              : Text(
                                  "-${billList[index].getBillMoney()}",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 20,
                                  ),
                                ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("分类"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(billList[index].getBillCategory()),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("账户"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(billList[index].getBillAccount()),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("时间"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(TimeUtil.doubleTimeToYearMonthDayWeek(
                              DateTime.fromMillisecondsSinceEpoch(
                                  billList[index].getBillDate()))),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("商家"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: billList[index].getBillShop() == null
                              ? Text("")
                              : Text(billList[index].getBillShop()),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("备注"),
                          margin: EdgeInsets.only(left: 50),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: billList[index].getBillRemark() == null
                              ? Text("")
                              : Text(
                                  billList[index].getBillRemark(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 50),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 50,
            child: Container(
              height: 80,
              width: 80,
              child: billList[index].getBillImage() == null
                  ? Image.asset("assets/images/bill_detail___bill_image.webp")
                  : Image.network(billList[index].getBillImage()),
            ),
          ),
        ],
      ),
    );
  }
}
