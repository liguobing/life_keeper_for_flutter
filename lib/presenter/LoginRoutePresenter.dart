import 'dart:convert';

import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/user/User.dart';
import 'package:lifekeeperforflutter/model/LoginRouteModel.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:lifekeeperforflutter/view/route/LoginRoute.dart';

class LoginRoutePresenter {
  LoginRouteState view;
  LoginRouteModel model;

  LoginRoutePresenter(LoginRouteState view) {
    this.view = view;
    model = LoginRouteModel();
  }

  void login(BuildContext context, String phone, String password) async {
    if (phone.length == 0) {
      view.showSnackBar(context, "手机号不能为空");
      return;
    }
    if (password.length == 0) {
      view.showSnackBar(context, "密码不能为空");
      return;
    }

    if (!StringUtil.isPhone(phone)) {
      view.showSnackBar(context, "手机号不合法");
      return;
    }

    view.showLoadingDialog(context, "登录中...");
    bool loginResult = await model.login(phone, password);
    if (loginResult) {
      Navigator.pop(context);
      Navigator.pop(context, {"Login": true});
    } else {
      view.hideDialog();
      view.showSnackBar(context, "登录失败，请稍后重试");
    }
  }

  ///请求验证码
  void requestCode(BuildContext context, String phone) async {
    if (phone.length == 0) {
      view.showSnackBar(context, "手机号码不能为空");
      return;
    }

    if (!StringUtil.isPhone(phone)) {
      view.showSnackBar(context, "手机号不合法");
      return;
    }

    view.showLoadingDialog(context, "请求验证码");
    int checkResult = await model.checkPhoneIsExists(phone);
    if (checkResult > 0) {
      BmobSms bmobSms = BmobSms();
      bmobSms.template = "";
      bmobSms.mobilePhoneNumber = phone;
      bmobSms.sendSms().then((BmobSent bmobSent) {
        view.timeCountDown();
        view.hideDialog();
        view.showSnackBar(context, "请求成功，请注意查收短信");
      }).catchError((e) {
        print("发送失败:" + BmobError.convert(e).error);
        view.hideDialog();
        view.showSnackBar(context, "请求失败，请检查后重试");
      });
    } else {
      if (checkResult == -1) {
        view.hideDialog();
        view.showSnackBar(context, "请求失败，请检查后重试");
      } else if (checkResult == -2) {
        view.hideDialog();
        view.showSnackBar(context, "该手机号已注册过，可以直接登录");
      }
    }
  }

  void register(BuildContext context, String userName, String phone,
      String code, String password) async {
    if (userName.length == 0) {
      view.showSnackBar(context, "用户名不能为空");
      return;
    }

    if (phone.length == 0) {
      view.showSnackBar(context, "手机号码不能为空");
      return;
    }

    if (!StringUtil.isPhone(phone)) {
      view.showSnackBar(context, "手机号不合法");
      return;
    }

    if (code.length == 0) {
      view.showSnackBar(context, "用户名不能为空");
      return;
    }

    if (password.length == 0) {
      view.showSnackBar(context, "密码不能为空");
      return;
    }

    if (password.length < 6) {
      view.showSnackBar(context, "密码必须 6 位以上");
      return;
    }

    view.showLoadingDialog(context, "请稍后...");
    try {
      BmobUser bmobUserRegister = BmobUser();
      bmobUserRegister.mobilePhoneNumber = phone;
      await bmobUserRegister.loginBySms(code);
      User user = User();
      user.setObjectId(StringUtil.getRandomString());
      user.setUserId(StringUtil.getRandomString());
      user.setUserPhone(phone);
      user.setUserName(userName);
      user.setUserPassword(StringUtil.stringToMd5(phone, password));
      user.setUserIconUrl("http://104.245.40.124:8080/UserIcon/user.png");
      user.setUserStatus(1);
      user.setUserType(0);
      user.setCreateTime(DateTime.now().millisecondsSinceEpoch);
      user.setUpdateTime(0);
      List list = List();
      list.add(user);
      Dio dio = Dio();
      Response<bool> resp = await dio.post(
          "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddUser",
          data: json.encode(list));
      if (resp.data) {
        view.hideDialog();
        view.updatePageIndex(0);
        view.showSnackBar(context, "注册成功");
      } else {
        view.hideDialog();
        view.showSnackBar(context, "注册失败，请稍后重试");
      }
    } catch (e) {
      view.hideDialog();
      view.showSnackBar(context, "注册出错，请稍后重试");
      print("验证码验证出错    " + e.toString());
      print("   --" + BmobError.convert(e).error);
    }
  }
}
