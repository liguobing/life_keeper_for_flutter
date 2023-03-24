import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillImageResponse.dart';
import 'package:lifekeeperforflutter/presenter/UserCenterRoutePresenter.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserCenterRoute extends StatefulWidget {
  UserCenterRouteState createState() => UserCenterRouteState();
}

class UserCenterRouteState extends State<UserCenterRoute> {
  UserCenterRoutePresenter presenter;
  String userIcon = "http://104.245.40.124:8080/UserIcon/user.png";
  String userName = "";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);

    presenter = UserCenterRoutePresenter(this);
    presenter.updateUserInfo();
  }

  void updateUserInfo(String userIconUrl, String userName) {
    setState(() {
      this.userIcon = userIconUrl;
      this.userName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/persional_infomation___background.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomPaint(
          size: Size(double.infinity, double.infinity), //指定画布大小
          painter: MyPainter(),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Container(
                  padding: EdgeInsets.only(left: 40),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                width: double.infinity,
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 350,
                    height: 240,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 35),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                30,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 70,
                              ),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              Row(
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
                            ],
                          ),
                        ),
                        Positioned(
                          left: 135,
                          right: 135,
                          child: Hero(
                            tag: "UserIcon",
                            child: ClipOval(
                              child: GestureDetector(
                                onTap: (){
                                  startPickImage();
                                },
                                child: Image.network(
                                  userIcon,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    showChangePasswordBottomSheet();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 17, bottom: 17),
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings),
                        Text("  修改密码"),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    showChangeNameBottomSheet();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 17, bottom: 17),
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text("  修改名称"),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                child: GestureDetector(
                  onTap: () {
                    showLogoutDialog();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 17, bottom: 17),
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          30,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new),
                        Text("  注销登录"),
                      ],
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

  ///显示修改密码 BottomSheet
  void showChangePasswordBottomSheet() {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // !important
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // !important
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom), // !important
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: TextField(
                              decoration: InputDecoration(hintText: "请输入旧密码"),
                              controller: oldPasswordController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              autofocus: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, bottom: 30),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "请输入新密码",
                              ),
                              controller: newPasswordController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          presenter.changePassword(
                              context,
                              oldPasswordController.text,
                              newPasswordController.text);
                        },
                        child: Icon(Icons.check_circle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///显示修改名称 BottomSheet
  void showChangeNameBottomSheet() {
    TextEditingController nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom), // !important
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, bottom: 30),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "请输入新名称",
                              ),
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          presenter.changeUserName(
                              context, nameController.text);
                        },
                        child: Icon(Icons.check_circle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
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

  void showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("确定退出登录？"),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  presenter.logout(context);
                },
                child: Text("退出"),
              ),
            ],
            actionsPadding: EdgeInsets.only(right: 30, bottom: 10),
          );
        });
  }

  void logout() {
    Navigator.pop(context, {"Logout": true});
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

  void startPickImage() {
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
      if(value != null){
        getImage(value);
      }
    });
  }

  Future getImage(int type) async {
    if (type == 1) {
      await ImagePicker.pickImage(source: ImageSource.camera)
          .then((image) => cropImage(image));
    }

    if (type == 2) {
      await ImagePicker.pickImage(source: ImageSource.gallery)
          .then((image) => cropImage(image));
    }
  }

  void cropImage(File originalImage) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: originalImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '头像剪裁',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: true,
          lockAspectRatio: true),
    );
    if (croppedFile != null) {
      presenter.uploadImage(context, croppedFile);
    }else{
      print("取消了"
          "");
    }
  }

  //上传图片到云端
  Future<BillImageResponse> uploadFileToCloud(
      BuildContext context, File file) async {
    BillImageResponse billImageResponse = BillImageResponse();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            filename: path.basename(file.path)),
      });
      var response = await dio.post(
          Constant.CLOUD_ADDRESS + "/LifeKeeper/UploadImage",
          data: formData);
      billImageResponse = BillImageResponse.fromJson(response.data);
    } catch (e, s) {
      print(e);
      print(s);
      billImageResponse.setResultCode(-1);
    }
    return billImageResponse;
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color(0xAAffffff);
    path.moveTo(0, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 2 - size.height / 2 / 4);
    path.close();
    canvas.drawPath(path, paint);
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
