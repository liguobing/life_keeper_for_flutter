import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/BillAccount.dart';
import 'package:lifekeeperforflutter/model/BillAccountRouteModel.dart';
import 'package:lifekeeperforflutter/view/route/BillAccountRoute.dart';

class BillAccountRoutePresenter {
  BillAccountRouteModel model;
  BillAccountRouteState view;

  BillAccountRoutePresenter(BillAccountRouteState view) {
    this.view = view;
    this.model = BillAccountRouteModel();
  }

  ///获取账单账户
  void getBillAccounts() async {
    List<BillAccount> accounts = await model.getBillAccounts();
    view.updateAccounts(accounts);
  }

  ///添加账单账户
  void addBillAccount(
      BuildContext context, String accountName) async {
    if (accountName.length == 0) {
      view.showSnackBar(context, "名称不能为空");
      return;
    }
    view.showLoadingDialog(context, "请稍后...");
    bool isExists = await model.accountIsExists(accountName);
    if (isExists) {
      view.hideDialog();
      view.showSnackBar(context, "该账户名称已经存在");
    } else {
      bool addSuccessful = await model.addAccount( accountName);
      if (addSuccessful) {
        getBillAccounts();
        view.showSnackBar(context, "添加成功");
        view.hideDialog();
      } else {
        view.showSnackBar(context, "添加失败，请稍后重试");
        view.hideDialog();
      }
    }
  }

  void deleteAccount(BuildContext context, String objectId) async {
    view.showLoadingDialog(context, "请稍后...");
    bool deleteSuccessful = await model.deleteAccount(objectId);
    if (deleteSuccessful) {
      getBillAccounts();
      view.showSnackBar(context, "删除成功");
      view.hideDialog();
    } else {
      view.showSnackBar(context, "删除失败，请稍后重试");
      view.hideDialog();
    }
  }

  void updateAccount(
      BuildContext context, BillAccount account, String newName) async {
    if (newName.length == 0) {
      view.showSnackBar(context, "新账户名称不能为空");
      return;
    }

    view.showLoadingDialog(context, "请稍后...");
    bool isExists = await model.accountIsExists(newName);
    if (isExists) {
      view.hideDialog();
      view.showSnackBar(context, "该名称已经存在了");
    } else {
      bool updateSuccessful = await model.updateAccount(account, newName);
      if (updateSuccessful) {
        getBillAccounts();
        view.hideDialog();
        view.showSnackBar(context, "更新成功");
      } else {
        view.hideDialog();
        view.showSnackBar(context, "更新失败，请稍后重试");
      }
    }
  }
}
