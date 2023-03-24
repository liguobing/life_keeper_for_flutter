import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillImageResponse.dart';
import 'package:lifekeeperforflutter/model/UserCenterRouteModel.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/view/route/UserCenterRoute.dart';
import 'package:path/path.dart' as path;

class UserCenterRoutePresenter {
  UserCenterRouteState view;
  UserCenterRouteModel model;

  UserCenterRoutePresenter(UserCenterRouteState view) {
    this.view = view;
    model = UserCenterRouteModel();
  }

  ///更新用户信息
  void updateUserInfo() async {
    String userIconUrl = await model.getUserIcon();
    String userName = await model.getUserName();
    view.updateUserInfo(userIconUrl, userName);
  }

  ///修改密码
  void changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    if (oldPassword.length == 0) {
      view.showSnackBar(context, "旧密码不能为空");
      return;
    }
    if (newPassword.length == 0) {
      view.showSnackBar(context, "新密码不能为空");
      return;
    }

    if (newPassword.length < 6) {
      view.showSnackBar(context, "密码必须 6 位以上");
      return;
    }

    view.showLoadingDialog(context, "请稍后...");
    bool isRight = await model.oldPasswordIsRight(oldPassword);
    if (isRight) {
      bool changeResult = await model.changePassword(newPassword);
      view.hideDialog();
      if (changeResult) {
        view.showSnackBar(context, "修改成功");
      } else {
        view.showSnackBar(context, "修改失败，请稍后重试...");
      }
    } else {
      view.hideDialog();
      view.showSnackBar(context, "旧密码错误");
    }
  }

  ///修改用户名
  void changeUserName(BuildContext context, String name) async {
    if (name.length == 0) {
      view.showSnackBar(context, "新名称不能为空");
      return;
    }

    if (name.length < 3 || name.length > 10) {
      view.showSnackBar(context, "名称长度须为 3 ~ 10");
      return;
    }

    view.showLoadingDialog(context, "请稍后...");
    bool changeResult = await model.changeUserName(name);
    view.hideDialog();
    if (changeResult) {
      view.updateUserInfo(await model.getUserIcon(), name);
      view.showSnackBar(context, "修改成功");
    } else {
      view.showSnackBar(context, "修改失败，请稍后重试...");
    }
  }

  void logout(BuildContext context) async {
    view.showLoadingDialog(context, "退出中...");
    bool result = await model.logout();
    if (result) {
      view.hideDialog();
      view.logout();
    } else {
      view.hideDialog();
      view.showSnackBar(context, "退出登录失败，请稍后重试...");
    }
  }

  void uploadImage(BuildContext context, File file) async {
    view.showLoadingDialog(context, "请稍后...");
    BillImageResponse response = BillImageResponse();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            filename: path.basename(file.path)),
      });
      var uploadResponse = await dio.post(
          Constant.CLOUD_ADDRESS + "/LifeKeeper/UploadImage",
          data: formData);
      response = BillImageResponse.fromJson(uploadResponse.data);
    } catch (e, s) {
      print(e);
      print(s);
      response.setResultCode(-1);
    }
    if (response.getResultCode() > 0) {
      String userIconName = response.getImageName();
      bool result = await model.updateUserIconUrl(userIconName);
      if (result) {
        String userIconUrl = await model.getUserIcon();
        String userName = await model.getUserName();
        view.updateUserInfo(userIconUrl, userName);
        view.hideDialog();
        view.showSnackBar(context, "修改成功");
      } else {
        view.hideDialog();
        view.showSnackBar(context, "修改成功");
      }
    }
  }
}
