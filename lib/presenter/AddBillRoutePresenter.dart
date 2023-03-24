import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/event/DialogEvent.dart';
import 'package:lifekeeperforflutter/model/AddBillRouteModel.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/view/route/AddBillRoute.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBillRoutePresenter {

  AddBillRouteState view;

  AddBillRouteModel model;

  AddBillRoutePresenter(AddBillRouteState view) {
    this.view = view;
    model = AddBillRouteModel();
  }

  //返回时间按钮格式化内容
  String getCurrentFormatTime(DateTime time) {
    return TimeUtil.doubleTimeToYearMonthDay(time);
  }

  //返回收入分类
  Future<List<String>> getIncomeCategoryList() async {
    return model.getIncomeCategoryList();
  }

  //返回支出分类
  Future<List<String>> getExpendCategoryList() async {
    return model.getExpendCategoryList();
  }

  //返回账户
  Future<List<String>> getAccountList() async {
    return model.getAccountList();
  }

  //检查权限
  Future<int> checkPermission(PermissionStatus status) async {
    int permissionStatus = 0;
    switch (status) {
      //还没请求过
      case PermissionStatus.unknown:
        permissionStatus = 0;
        break;
      //已经通过权限申请
      case PermissionStatus.granted:
        permissionStatus = 1;
        break;
      //已经拒绝权限申请
      case PermissionStatus.denied:
        permissionStatus = -1;
        break;
      //已经拒绝，并选择用不提醒
      case PermissionStatus.neverAskAgain:
        permissionStatus = -2;
        break;
      //iOS专用
      default:
        permissionStatus = -3;
        break;
    }
    return permissionStatus;
  }

  //保存账单分类或者账户
  void saveCategoryOrAccount(BuildContext context, int billProperty,
      int drawerListType, String name) async {
    if (name.length == 0) {
      Navigator.pop(context);
      view.showSnackBar(context, "添加内容不能为空");
    } else {
      view.showLoadingDialog(context, "正在保存");
      if (drawerListType > 0) {
        bool isExists =
            await model.categoryIsExists(context, name, billProperty);
        if (isExists) {
          Navigator.pop(context);
          Navigator.pop(context);
          view.showSnackBar(context, "该分类名称已经存在");
        } else {
          bool addResult = await model.addCategory(context, name, billProperty);
          if (addResult) {
//            Navigator.pop(context);
//            Navigator.pop(context);
            view.hideDialog();
            view.hideDialog();
            view.showSnackBar(context, "添加成功");
          } else {
//            Navigator.pop(context);
//            Navigator.pop(context);
            view.hideDialog();
            view.hideDialog();
            view.showSnackBar(context, "添加失败，请稍后重试");
          }
        }
      } else {
        bool isExists = await model.accountIsExists(context, name);
        if (isExists) {
//          Navigator.pop(context);
//          Navigator.pop(context);
          view.hideDialog();
          view.hideDialog();
          view.showSnackBar(context, "该分类名称已经存在");
        } else {
          bool addResult = await model.addAccount(context, name);
          if (addResult) {
//            Navigator.pop(context);
//            Navigator.pop(context);
            view.hideDialog();
            view.hideDialog();
            view.showSnackBar(context, "添加成功");
          } else {
//            Navigator.pop(context);
//            Navigator.pop(context);
            view.hideDialog();
            view.hideDialog();
            view.showSnackBar(context, "添加失败，请稍后重试");
          }
        }
      }
      view.initData();
    }
  }

  void show(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text("我就测试一下"),
        );
      },
    );
  }

  void saveBill(
      BuildContext context,
      int billDate,
      String billMoney,
      int billProperty,
      String billCategory,
      String billAccount,
      String billRemark,
      String shopName,
      File image) async {
    if (billMoney.length <= 0) {
      view.showSnackBar(context, "金额不能为空");
      return;
    }
    if (double.parse(billMoney) < 0) {
      view.showSnackBar(context, "金额不能是负数");
      return;
    }
    if (billCategory.length <= 0) {
      view.showSnackBar(context, "账单分类还没设置呢");
      return;
    }
    if (billAccount.length <= 0) {
      view.showSnackBar(context, "账单账户还没设置呢");
      return;
    }
    view.showSaveDialog(context).then((value) {
      Navigator.pop(context);
    });
    bool saveResult = await model.addBill(
        context,
        billDate,
        double.parse(billMoney),
        billProperty,
        billCategory,
        billAccount,
        billRemark,
        shopName,
        image);
    if (saveResult) {
      eventBus.fire(DialogEvent(1));
    } else {
      eventBus.fire(DialogEvent(-1));
    }
  }
}
