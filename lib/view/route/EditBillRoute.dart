import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:lifekeeperforflutter/presenter/AddBillRoutePresenter.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';
import 'package:lifekeeperforflutter/view/custom_view/SaveDialog.dart';
import 'package:xfvoice/xfvoice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picker/picker.dart' as ImagePicker;

class EditBillRoute extends StatefulWidget {
  final BillBean billBean;

  EditBillRoute(this.billBean);

  @override
  State<EditBillRoute> createState() {
    return EditBillRouteState(billBean);
  }
}

class EditBillRouteState extends State<EditBillRoute> {
  final BillBean billBean;

  AddBillRoutePresenter presenter;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  //账单金额输入框 Controller
  TextEditingController billMoneyController = TextEditingController();

  //账单属性，收入/支出
  int billProperty;

  //AppBar Title
  String appBarTitle = "";

  //AppBar 颜色
  Color appBarColor = Colors.lightGreenAccent;

  //账单时间
  int billDate = 0;

  //账单时间按钮内容
  String billDateButtonTitle = "";

  //消费商家按钮内容
  String shopButtonTitle = "消费商家";

  //商家
  String shopName = "";

  //收入分类列表
  List<String> incomeCategory;

  //支出分类列表
  List<String> expendCategory;

  //消费账户列表
  List<String> account;

  //抽屉菜单标题
  String drawerTitle = "";

  //抽屉菜单数据 List
  List<String> drawerDataList = List();

  String accountContent = "";
  String billAccount = "";

  String categoryContent = "";
  String billCategory = "";

  //抽屉菜单显示的是什么内容：
  //1 分类
  //-1 账户
  int drawerListType = 0;

  //备注输入框 Controller
  TextEditingController remarkController = TextEditingController();

  //抽屉菜单输入框 Controller
  TextEditingController drawerInputController = TextEditingController();

  //是否具有相机权限
  //0.还没有申请过权限
  //1.有权限
  //-1.没有权限
  //-2.没有权限，并 Never ask
  int cameraPermission = -1;

  //是否具有录音权限
  //0.还没有申请过权限
  //1.有权限
  //-1.没有权限
  //-2.没有权限，并 Never ask
  int microphonePermission = -1;

  //讯飞语音输入
  XFJsonResult xfResult;

  //语音识别到的内容
  String voiceInput = "";

  //账单图片
  File _image;

  EditBillRouteState(this.billBean);

  @override
  void initState() {
    super.initState();
    billMoneyController.text = "${billBean.getBillMoney()}";
    billProperty = billBean.getBillProperty();
    billDate = billBean.getBillDate();
    billDateButtonTitle = TimeUtil.doubleTimeToYearMonthDay(
        DateTime.fromMillisecondsSinceEpoch(billBean.getBillDate()));
    billBean.getBillShop() == null
        ? shopButtonTitle = "消费商家"
        : shopButtonTitle = billBean.getBillShop();
    billBean.getBillShop() == null
        ? shopName = "消费商家"
        : shopName = billBean.getBillShop();
    accountContent = billBean.getBillAccount();
    billAccount = billBean.getBillAccount();
    categoryContent = billBean.getBillCategory();
    billCategory = billBean.getBillCategory();
    if(billBean.getBillRemark() != null){
      remarkController.text = billBean.getBillRemark();
    }
    if(billBean.getBillRemark() != null){
      remarkController.text = billBean.getBillRemark();
    }
//    if(billBean.getBillImage() != null){
//      _image = File("billBean.getBillImage()");
//    }
    initData();
    checkPermission();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:
            billProperty > 0 ? Color(0xff15B7B9) : Color(0xfff26d5b),
        actions: [Text("")],
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: billProperty > 0 ? Text("收入") : Text("支出"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(38, 20, 30, 0),
            height: 73.33,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.bottomLeft,
                    child: TextField(
                      controller: billMoneyController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 50),
                      decoration: InputDecoration(
                        hintText: "0.0",
                        hintStyle:
                            TextStyle(fontSize: 50, color: Color(0xff989898)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      clickBillImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular((20.0)),
                        color: Color(0xffeaeaea),
                      ),
                      child: cameraPermission > 0
                          ? _image == null
                              ? Image.asset("assets/images/camera.png")
                              : Image.file(_image)
                          : Image.asset("assets/images/no_camera.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                drawerTitle = billProperty > 0 ? "收入分类" : "支出分类";
                drawerDataList =
                    billProperty > 0 ? incomeCategory : expendCategory;
                drawerListType = 1;
              });
              _scaffoldKey.currentState.openEndDrawer();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(38, 20, 30, 0),
              alignment: Alignment.bottomLeft,
              child: Text(
                categoryContent,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                drawerTitle = billProperty > 0 ? "收入账户" : "支出账户";
                drawerDataList = account;
                drawerListType = -1;
              });
              _scaffoldKey.currentState.openEndDrawer();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(38, 20, 30, 0),
              alignment: Alignment.bottomLeft,
              child: Text(
                accountContent,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(38, 20, 30, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: RaisedButton.icon(
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xff0FDEC2),
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      label: Text(
                        billDateButtonTitle,
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
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
                          if (value != null) {
                            if (TimeUtil.greaterCurrentDay(value)) {
                              showSnackBar(context, "不能添加未来订单哟");
                            } else {
                              billDate = TimeUtil.dateTimeToLong(value);
                              setState(() {
                                billDateButtonTitle =
                                    TimeUtil.doubleTimeToYearMonthDay(value);
                              });
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RaisedButton.icon(
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xff0FDEC2),
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Expanded(
                        child: Text(
                          shopButtonTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pushNamed(context, "BillShop").then((value) {
                          if (value != null) {
                            dynamic result = value;
                            setState(() {
                              shopName = result["Shop"];
                              shopButtonTitle = result["Shop"];
                            });
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(38, 20, 30, 0),
            child: TextField(
              maxLines: 5,
              minLines: 1,
              controller: remarkController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                  onTap: () {
                    clickMicrophone();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: microphonePermission > 0
                      ? Icon(Icons.mic)
                      : Icon(
                          Icons.mic_off,
                          color: Colors.red,
                        ),
                ),
                hintText: "备注",
                hintStyle: TextStyle(fontSize: 20, color: Color(0xff989898)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(38, 0, 38, 30),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                          color: Color(0xffCED8D9),
                          height: 60.0,
                          child: Text('重置'),
                          onPressed: () {
                            _reset();
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                          color: Color(0xffF6706F),
                          height: 60.0,
                          child: Text(
                            '保存',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            presenter.saveBill(
                              context,
                              billDate,
                              billMoneyController.text,
                              billProperty,
                              billCategory,
                              billAccount,
                              remarkController.text,
                              shopName,
                              _image,
                            );
                          },
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
      endDrawer: Drawer(
        child: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  leading: Text(""),
                  automaticallyImplyLeading: false,
                  expandedHeight: 150.0,
                  actions: [Text("")],
                  pinned: true,
                  floating: false,
                  snap: false,
                  backgroundColor:
                      billProperty > 0 ? Color(0xff15B7B9) : Color(0xfff26d5b),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(drawerTitle),
                    centerTitle: true,
                    background: Container(
                      color: billProperty > 0
                          ? Color(0xff15B7B9)
                          : Color(0xfff26d5b),
                    ),
                  ),
                ),
                // 列表内容
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (drawerListType > 0) {
                              if (billProperty > 0) {
                                categoryContent = incomeCategory[index];
                                billCategory = incomeCategory[index];
                              } else {
                                categoryContent = expendCategory[index];
                                billCategory = expendCategory[index];
                              }
                            } else {
                              accountContent = account[index];
                              billAccount = account[index];
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.black12,
                          height: 50,
                          alignment: Alignment.center,
                          child: Container(
                            height: 49,
                            width: 500,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("${drawerDataList[index]}"),
                          ),
                        ),
                      );
                    },
                    childCount: drawerDataList.length,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    color: Color(0xffF6706F),
                    height: 50.0,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      String title = "";
                      if (drawerListType > 0) {
                        if (billProperty > 0) {
                          title = "添加收入分类";
                        } else {
                          title = "添加支出分类";
                        }
                      } else {
                        title = "添加消费账户";
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(title),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            actionsPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            content: TextField(
                              controller: drawerInputController,
                            ),
                            actions: [
                              MaterialButton(
                                child: Text("保存"),
                                color: Colors.lightBlueAccent,
                                onPressed: () {
                                  Navigator.pop(context);
                                  presenter.saveCategoryOrAccount(
                                      context,
                                      billProperty,
                                      drawerListType,
                                      drawerInputController.text);
                                  drawerInputController.text = "";
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawerEdgeDragWidth: 0.0,
    );
  }

  Future<Null> showSaveDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return SaveDialog(50, Colors.lightGreenAccent, 45, Colors.white, 10);
      },
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

  //初始化分类和账户数据
  Future<void> initData() async {
    billDate = TimeUtil.dateTimeToLong(DateTime.now());

    List<String> incomeCategoryList = await presenter.getIncomeCategoryList();
    this.incomeCategory = incomeCategoryList;
    List<String> expendCategoryList = await presenter.getExpendCategoryList();
    this.expendCategory = expendCategoryList;
    List<String> accountList = await presenter.getAccountList();
    this.account = accountList;
    setState(() {});
  }

  //检查权限
  Future checkPermission() async {
    Future<int> camera = presenter.checkPermission(await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera));
    Future<int> microphone = presenter.checkPermission(await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone));
    camera.then((value) {
      setState(() {
        cameraPermission = value;
      });
    });
    microphone.then((value) {
      setState(() {
        microphonePermission = value;
        initXFParam();
      });
    });
  }

  //初始化讯飞语音识别参数
  void initXFParam() {
    final voice = XFVoice.shared;
    // 请替换成你的appid
    voice.init(appIdIos: '5abd1bb5', appIdAndroid: '5abd1bb5');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    // param.asr_ptt = '0';   //取消注释可去掉标点符号
    param.asr_audio_path = 'audio.pcm';
    param.result_type = 'json'; //可以设置plain
    final map = param.toMap();
    map['dwa'] = 'wpgs'; //设置动态修正，开启动态修正要使用json类型的返回格式
    voice.setParameter(map);
  }

  //点击相机按钮
  void clickBillImage() {
    switch (cameraPermission) {
      case 1:
        showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('从哪里添加图片？'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: const Text("相机"),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    // 返回2
                    Navigator.pop(context, 2);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: const Text("相册"),
                  ),
                ),
              ],
            );
          },
        ).then((value) {
          getImage(value);
        });
        break;
      case 0:
        requestCameraPermission();
        break;
      case -1:
        requestCameraPermission();
        break;
      case -2:
        requestCameraPermission();
        break;
    }
  }

  //请求相机权限
  void requestCameraPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    // 申请结果
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      setState(() {
        cameraPermission = 1;
      });
    } else {
      PermissionHandler().openAppSettings();
    }
  }

  //选择图片
  void getImage(int type) async {
    var image;
    if (type == 1) {
      image = ImagePicker.Picker.pickImage(
          source: ImagePicker.ImageSource.camera,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 75);
    } else if (type == 2) {
      image = ImagePicker.Picker.pickImage(
          source: ImagePicker.ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 75);
    }
    if (image != null) {
      image.then((value) {
        if (value != null) {
          print("选择了图片，图片路径为：${value.path}");
          setState(() {
            _image = value;
          });
        } else {
          print("选择照片为空");
        }
      });
    }
  }

  //点击麦克风按钮
  void clickMicrophone() {
    switch (microphonePermission) {
      case 1:
        startRecognizeVoice();
        break;
      case 0:
        requestMicrophonePermission();
        break;
      case -1:
        requestMicrophonePermission();
        break;
      case -2:
        requestMicrophonePermission();
        break;
    }
  }

  //请求麦克风权限
  void requestMicrophonePermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.microphone]);
    // 申请结果
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);

    if (permission == PermissionStatus.granted) {
      setState(() {
        microphonePermission = 1;
        initXFParam();
      });
    } else {
      PermissionHandler().openAppSettings();
    }
  }

  //开始识别声音
  void startRecognizeVoice() {
    //先弹出提示 Dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return WillPopScope(
          child: SimpleDialog(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/voice.png",
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Text("正在识别语音..."),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          onWillPop: () async {
            return Future.value(false);
          },
        );
      },
    );
    //开始识别
    final listen = XFVoiceListener(
        onVolumeChanged: (volume) {},
        onBeginOfSpeech: () {
          xfResult = null;
        },
        onResults: (String result, isLast) {
          if (xfResult == null) {
            xfResult = XFJsonResult(result);
            voiceInput = xfResult.resultText();
            setState(() {
              remarkController.text = voiceInput;
            });
          } else {
            final another = XFJsonResult(result);
            xfResult.mix(another);
          }
        },
        onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
          setState(() {});
        },
        onEndOfSpeech: () {
          Navigator.pop(context);
        },
        onCancel: () {});
    XFVoice.shared.start(listener: listen);
  }

  //停止识别声音
  void stopRecognizeVoice() {
    XFVoice.shared.stop();
  }

  void _reset() {
    setState(() {
      billMoneyController.text = "0.0";
      _image = null;
      billDate = TimeUtil.dateTimeToLong(DateTime.now());
      categoryContent = "分类";
      billCategory = "";
      accountContent = "账户";
      billAccount = "";
      remarkController.text = "备注";
      shopName = "消费商家";
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopRecognizeVoice();
  }
}
