import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillListItemTitleMoneyCount.dart';
import 'package:lifekeeperforflutter/model/AccountBookRouteModel.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/view/route/AccountBookRoute.dart';

class AccountBookRoutePresenter {
  AccountBookRouteState view;
  AccountBookRouteModel model;

  AccountBookRoutePresenter(AccountBookRouteState view) {
    this.view = view;
    model = AccountBookRouteModel();
  }

  ///获取账单数据
  void getBillData(BuildContext context, int year, int month) async {
    view.showLoadingDialog(context, "加载中...");
    List<BillBean> list = await model.getBills(year, month);
    double incomeCount = await model.getIncomeCount(year, month);
    double expendCount = await model.getExpendCount(year, month);
    int dayCount = TimeUtil.getDaysOfMonth(year, month);
    List<BillListItemTitleMoneyCount> moneyCountList = List();
    for (int i = 1; i <= dayCount; i++) {
      double incomeCount = await getMoneyCountOfDay(1, year, month, i);
      double expendCount = await getMoneyCountOfDay(-1, year, month, i);
      BillListItemTitleMoneyCount bean =
          BillListItemTitleMoneyCount(incomeCount, expendCount);
      moneyCountList.add(bean);
    }
    double wavePercent = 0.0;
    if (incomeCount == 0) {
      wavePercent = 0;
    } else {
      wavePercent = expendCount / incomeCount;
    }
    view.updateUI(list, incomeCount, expendCount, moneyCountList, wavePercent);
    view.hideDialog();
  }

  ///获取指定日期收入/支出总额
  Future<double> getMoneyCountOfDay(
      int billProperty, int year, int month, int day) async {
    if (billProperty > 0) {
      return await model.getIncomeCountOfDay(year, month, day);
    } else {
      return await model.getExpendCountOfDay(year, month, day);
    }
  }

  ///获取用户头像
  Future<void> getUserIconUrl() async {
    view.updateUserIcon(await model.getUserIconUrl());
  }

  ///删除账单
  void deleteBill(
      BuildContext context, String objectId, int year, int month) async {
    view.showLoadingDialog(context, "删除中...");
    bool deleteResult = await model.deleteBill(objectId);
    if (deleteResult) {
      List<BillBean> list = await model.getBills(year, month);
      double incomeCount = await model.getIncomeCount(year, month);
      double expendCount = await model.getExpendCount(year, month);
      int dayCount = TimeUtil.getDaysOfMonth(year, month);
      List<BillListItemTitleMoneyCount> moneyCountList = List();
      for (int i = 1; i <= dayCount; i++) {
        double incomeCount = await getMoneyCountOfDay(1, year, month, i);
        double expendCount = await getMoneyCountOfDay(-1, year, month, i);
        BillListItemTitleMoneyCount bean =
            BillListItemTitleMoneyCount(incomeCount, expendCount);
        moneyCountList.add(bean);
      }
      double wavePercent = 0.0;
      if (incomeCount == 0) {
        wavePercent = 0;
      } else {
        wavePercent = expendCount / incomeCount;
      }
      view.updateUI(
          list, incomeCount, expendCount, moneyCountList, wavePercent);
    }
    view.hideDialog();
    if (deleteResult) {
      view.showSnackBar(context, "删除成功");
    } else {
      view.showSnackBar(context, "删除失败，请稍后重试");
    }
  }
}
