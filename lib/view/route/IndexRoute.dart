import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lifekeeperforflutter/presenter/IndexRoutePresenter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui';

class IndexRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexRouteState();
  }
}

class IndexRouteState extends State<IndexRoute> {
  IndexRoutePresenter presenter;

  ///是否已经登录
  bool isLogin = true;

  ///当前时间
  String currentTime;

  ///当天计划总数
  int dailyPlanCount = 0;

  ///当月计划总数
  int monthlyPlanCount = 0;

  ///本月收入总数
  double incomeCount = 0.0;

  ///本月支出总数
  double expendCount = 0.0;

  ///用户头像（当用户已经登录并且没有设置个人头像的时候使用）
  String userIcon = "http://104.245.40.124:8080/UserIcon/user.png";

  ///用户名
  String userName = "";

  ///是否需要同步
  bool needSync = false;

  @override
  void initState() {
    super.initState();

    updateCurrentTime();

    presenter = IndexRoutePresenter(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      presenter.initData();
    });
  }

  ///更新当前时间
  void updateCurrentTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        String formatted = formatter.format(now);
        currentTime = formatted;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2248)..init(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 80),
            child: Row(
              children: [
                Text(
                  "当前时间:",
                  style: TextStyle(fontSize: ScreenUtil().setSp(60)),
                ),
                Text(
                  "$currentTime",
                  style: TextStyle(fontSize: ScreenUtil().setSp(60)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              isLogin
                  ? Navigator.pushNamed(context, "Plan").then((value) {
                      presenter.getPlanCardData();
                    })
                  : Navigator.pushNamed(context, "Login").then((value) {
                      if (value != null) {
                        presenter.initData();
                      }
                    });
            },
            child: planCardWidget(isLogin),
          ),
          GestureDetector(
            onTap: () {
              isLogin
                  ? Navigator.pushNamed(context, "AccountBook").then((value) {
                      presenter.getAccountBookCardData();
                    })
                  : Navigator.pushNamed(context, "Login").then((value) {
                      if (value != null) {
                        presenter.initData();
                      }
                    });
            },
            child: billCardWidget(isLogin),
          ),
          isLogin
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "UserCenter").then((value) {
                      presenter.initData();
                    });
                  },
                  child: userInfo(),
                )
              : loginTile(),
          Expanded(
            child: Text(""),
          ),
          needSync
              ? SizedBox(
                  height: 90,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                            blurRadius: 5.0,
                            spreadRadius: 1.0),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text("有数据需要同步，点我同步"),
                  ),
                )
              : Text("")
        ],
      ),
    );
  }

  ///计划卡片 Widget
  Widget planCardWidget(bool isLogin) {
    return isLogin
        ? Container(
            margin: EdgeInsets.only(top: 20, left: 19, right: 19),
            child: SizedBox(
              height: 95,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("今天有 $dailyPlanCount 项计划"),
                    Text("本月有 $monthlyPlanCount 项计划"),
                  ],
                ),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 20, left: 19, right: 19),
            child: SizedBox(
              height: 95,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffFF9D9D),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  "您还没有登录",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ),
          );
  }

  ///账单卡片 Widget
  Widget billCardWidget(bool isLogin) {
    return isLogin
        ? Container(
            margin: EdgeInsets.only(top: 32, left: 19, right: 19),
            child: SizedBox(
              height: 95,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("本月收入：￥$incomeCount"),
                    Text("本月收入：￥$expendCount"),
                  ],
                ),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 32, left: 19, right: 19),
            child: SizedBox(
              height: 95,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffFF9D9D),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  "您还没有登录",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ),
          );
  }

  ///登录/注册链接
  Widget loginTile() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "您还没有登录，点击登录",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "没有账号？点击注册",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  ///用户信息
  Widget userInfo() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Hero(
            tag: "UserIcon",
            child: ClipOval(
              child: Image.network(
                userIcon,
                width: 80,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "$userName",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void updatePlanCardView(int dailyPlanCount, monthlyPlanCount) {
    setState(() {
      this.dailyPlanCount = dailyPlanCount;
      this.monthlyPlanCount = monthlyPlanCount;
    });
  }

  void updateBillCardView(double income, double expend) {
    setState(() {
      this.incomeCount = income;
      this.expendCount = expend;
    });
  }

  void updateUserInfo(String userIconUrl, String userName) {
    setState(() {
      this.userIcon = userIconUrl;
      this.userName = userName;
    });
  }

  void updateLoginStatus(bool status) {
    setState(() {
      this.isLogin = status;
    });
  }
}
