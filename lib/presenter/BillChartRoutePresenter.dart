import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_chart/BillChartOverViewBean.dart';
import 'package:lifekeeperforflutter/model/BillChartRouteModel.dart';
import 'package:lifekeeperforflutter/view/route/BillChartRoute.dart';
import 'package:lifekeeperforflutter/view/route/TestRoute2.dart';

class BillChartRoutePresenter {
  BillChartRouteState view;
  BillChartRouteModel model;

  BillChartRoutePresenter(BillChartRouteState view) {
    this.view = view;
    this.model = BillChartRouteModel();
  }

  void getData(BuildContext context, int year, int month) async {
    view.showLoadingDialog(context, "请稍后...");
    BillChartOverViewBean bean = await model.getOverViewData(year, month);
    List<PieChartSectionData> pieChartData =
        await model.getPieData(1, year, month);
    view.updateUi(bean, pieChartData);

    List<double> incomeData = await model.getLineChartData(1, year, month);
    List<double> expendData = await model.getLineChartData(-1, year, month);
    view.updateLineChart(incomeData, expendData);
    view.hideDialog();
  }

  void getPieChartData(
      BuildContext context, int billProperty, int year, int month) async {
    view.showLoadingDialog(context, "请稍后...");
    List<PieChartSectionData> pieChartData =
        await model.getPieData(billProperty, year, month);
    view.updatePieChart(pieChartData);
    view.hideDialog();
  }

  void getLineChartData(
      BuildContext context, int type, int year, int month) async {
    view.showLoadingDialog(context, "请稍后...");
    List<double> incomeData = await model.getLineChartData(1, year, month);
    List<double> expendData = await model.getLineChartData(-1, year, month);
    view.updateLineChart(incomeData, expendData);
    view.hideDialog();
  }
}
