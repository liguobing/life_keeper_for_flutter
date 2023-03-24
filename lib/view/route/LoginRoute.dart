import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/presenter/LoginRoutePresenter.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';

class LoginRoute extends StatefulWidget {
  LoginRouteState createState() {
    return LoginRouteState();
  }
}

class LoginRouteState extends State<LoginRoute> {
  LoginRoutePresenter presenter;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  PageController pageViewController = PageController();
  TextEditingController loginPhoneController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController registerUserNameController = TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  TextEditingController registerCodeController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();

  String getCodeButtonTitle = "获取验证码";

  bool getCodeButtonClickable = true;

  @override
  void initState() {
    super.initState();
    presenter = LoginRoutePresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/large.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30, top: 30 + statusBarHeight),
              child: Icon(Icons.arrow_back),
            ),
            SizedBox(
              height: 500,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageViewController,
                children: [
                  loginWidget(),
                  registerWidget(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: CustomPaint(
                  size: Size(double.infinity, double.infinity), //指定画布大小
                  painter: MyPainter(),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("或者"),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Container(
                                    child: Image.asset(
                                        "assets/images/personal_information___weibo_icon.webp"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Container(
                                    child: Image.asset(
                                        "assets/images/personal_information___qq_icon.png"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Container(
                                    child: Image.asset(
                                        "assets/images/personal_information___weixin_icon.png"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (pageIndex == 0) {
                              pageViewController.jumpToPage(1);
                              setState(() {
                                pageIndex = 1;
                              });
                            } else {
                              pageViewController.jumpToPage(0);
                              setState(() {
                                pageIndex = 0;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Text(
                                  pageIndex == 0 ? "没有账号，点我注册" : "有账号，直接登录"),
                            ),
                          ),
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

  Widget loginWidget() {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 50),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 32,
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            maxLength: 11,
            controller: loginPhoneController,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
              fillColor: Colors.white,
              filled: true,
              hintText: '输入手机号',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: TextField(
            controller: loginPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
              fillColor: Colors.white,
              filled: true,
              hintText: '请输入密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(""),
              ),
              Expanded(
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      presenter.login(context, loginPhoneController.text,
                          loginPasswordController.text);
                      loginPasswordController.text = "";
                      loginPhoneController.text = "";
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffFFEB3C),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 15,
                      ),
                      child: Text("Login"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget registerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          "Register",
          style: TextStyle(color: Colors.white, fontSize: 50),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 32,
          ),
          child: TextField(
            controller: registerUserNameController,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
              fillColor: Colors.white,
              filled: true,
              hintText: '输入用户名',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            maxLength: 11,
            controller: registerPhoneController,
            decoration: InputDecoration(
              counterText: '',
              contentPadding:
                  EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
              fillColor: Colors.white,
              filled: true,
              hintText: '请输入手机号码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: registerCodeController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '输入验证码',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      if (getCodeButtonClickable) {
                        presenter.requestCode(
                            context, registerPhoneController.text);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffFFEB3C),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 15,
                      ),
                      child: Text("$getCodeButtonTitle"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: TextField(
            obscureText: true,
            controller: registerPasswordController,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 22.5, bottom: 22.5, left: 30),
              fillColor: Colors.white,
              filled: true,
              hintText: '请输入密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 10,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(""),
              ),
              Expanded(
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      presenter.register(
                          context,
                          registerUserNameController.text,
                          registerPhoneController.text,
                          registerCodeController.text,
                          registerPasswordController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffFFEB3C),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 15,
                      ),
                      child: Text("Register"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  void timeCountDown() {
    int time = 60;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (time == 0) {
          timer.cancel();
          getCodeButtonTitle = "获取验证码";
          getCodeButtonClickable = true;
        } else {
          getCodeButtonClickable = false;
          getCodeButtonTitle = "$time s";
          time--;
        }
      });
    });
  }

  void updatePageIndex(int index){
    setState(() {
      pageIndex = index;
    });
    pageViewController.jumpToPage(index);
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(Offset(size.width / 2, size.height), size.height, paint);
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  MyPainter() {
    init();
  }

  Path path;

  void init() {
    path = Path();
  }
}
