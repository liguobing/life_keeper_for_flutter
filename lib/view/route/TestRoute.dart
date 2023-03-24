import 'dart:io';

import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillImageResponse.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:path/path.dart' as path;

class TestRoute extends StatefulWidget {
  MyApp createState() => MyApp();
}

class MyApp extends State<TestRoute> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: MaterialButton(

        ),
      ),
    );
  }

  void requestCode() {
    _sendSms(BuildContext context) {

    }
  }

  void verifyCode(String text) {
    _loginBySms(BuildContext context) {

    }
  }
}
