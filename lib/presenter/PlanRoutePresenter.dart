import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanBean.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanListDateMenuItem.dart';
import 'package:lifekeeperforflutter/model/PlanRouteModel.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/view/route/PlanRoute.dart';

class PlanRoutePresenter {
  PlanRouteState view;
  PlanRouteModel model;
  List<String> weeksEnglish = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  PlanRoutePresenter(PlanRouteState view) {
    this.view = view;
    model = new PlanRouteModel();
  }

  void updateUi(int year, int month, int day) async {
    //获取当月日期 List,并选中当日
    List<PlanListDateMenuItem> dateMenuList = List();
    int dayCount = TimeUtil.getDaysOfMonth(year, month);
    DateTime time;
    for (int i = 1; i <= dayCount; i++) {
      PlanListDateMenuItem item = PlanListDateMenuItem();
      if (i == day) {
        item.setCheckStatus(true);
      } else {
        item.setCheckStatus(false);
      }
      item.setDay(i);
      time = DateTime(year, month, i);
      item.setWeek(weeksEnglish[time.weekday - 1]);
      dateMenuList.add(item);
    }
    //获取当日数据 List
    List<PlanBean> planList =
        await model.getPlans(await getUserId(), year, month, day);
    //获取日期按钮 Title
    DateTime dateTime = DateTime(year, month, day);
    String monthStr = month > 9 ? "$month" : "0$month";
    String dayStr = day > 9 ? "$day" : "0$day";
    String dateButtonTitle = "$year" +
        "-" +
        monthStr +
        "-" +
        dayStr +
        " " +
        weeksEnglish[dateTime.weekday - 1];
    //通知 UI 更新
    view.updateAll(dateMenuList, planList, dateButtonTitle);
  }

//  void updateUi(BuildContext context, int year, int month, int day) async {
//    view.showWaitDialog(context);
//    String userId = await getUserId();
//    List<PlanBean> plans = await model.getPlans(userId, year, month, day);
//    view.updatePlanList(plans);
//    DateTime dateTime = DateTime(year, month, day);
//    String monthStr = month > 9 ? "$month" : "0$month";
//    String dayStr = day > 9 ? "$day" : "0$day";
//    String dateButtonTitle = "$year" +
//        "-" +
//        monthStr +
//        "-" +
//        dayStr +
//        " " +
//        weeksEnglish[dateTime.weekday - 1];
////    view.updateDateButton(dateButtonTitle);
//
//    List<PlanListDateMenuItem> dateMenuList = new List();
//    int dayCount = TimeUtil.getDaysOfMonth(year, month);
//    DateTime time;
//    for (int i = 1; i <= dayCount; i++) {
//      PlanListDateMenuItem item = PlanListDateMenuItem();
//      if (i == day) {
//        item.setCheckStatus(true);
//      } else {
//        item.setCheckStatus(false);
//      }
//      item.setDay(i);
//      time = DateTime(year, month, i);
//      item.setWeek(weeksEnglish[time.weekday - 1]);
//      dateMenuList.add(item);
//    }
////    view.updateDateList(dateMenuList);
//    view.hideWaitDialog(context);
//  }

  ///获取用户 ID
  Future<String> getUserId() async {
    String userId = await model.getUserId();
    return userId;
  }

  ///获取特定年月日计划
  Future<List<PlanBean>> getPlans(int year, int month, int day) async {
    String userId = await getUserId();
    return model.getPlans(userId, year, month, day);
  }

  ///撤销已完成的计划
  void unFinishPlan(BuildContext context, PlanBean bean) async {
    bool result = await model.unFinishPlan(bean);
    if (result) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(bean.getStartTime());
      List<PlanBean> planList = await model.getPlans(
          await getUserId(), time.year, time.month, time.day);
      view.updatePlanList(planList);
    } else {
      view.showSnackBar(context, "出错了，请稍后重试");
    }
  }

  ///完成计划
  void finishPlan(BuildContext context, PlanBean bean) async {
    bool result = await model.finishPlan(bean);
    if (result) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(bean.getStartTime());
      List<PlanBean> planList = await model.getPlans(
          await getUserId(), time.year, time.month, time.day);
      view.updatePlanList(planList);
    } else {
      view.showSnackBar(context, "出错了，请稍后重试");
    }
  }

  ///添加闹钟
  void addAlarm(BuildContext context, PlanBean planBean, alarmTime) async {
    model.addAlarm(planBean, alarmTime).then((value) async {
      if (value) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(planBean.getStartTime());
        List<PlanBean> planList = await model.getPlans(
            await getUserId(), time.year, time.month, time.day);
        view.updatePlanList(planList);
      } else {
        view.showSnackBar(context, "出错了，请稍后重试");
      }
    });
  }

  ///去除闹钟
  void removeAlarm(BuildContext context, PlanBean planBean) async {
    model.removeAlarm(context, planBean).then((value) async {
      if (value) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(planBean.getStartTime());
        List<PlanBean> planList = await model.getPlans(
            await getUserId(), time.year, time.month, time.day);
        view.updatePlanList(planList);
      } else {
        view.showSnackBar(context, "出错了，请稍后重试");
      }
    });
  }

  ///删除单个计划
  void deletePlanByObjectId(BuildContext context, PlanBean planBean) async {
    model.deletePlanByObjectId(context, planBean).then((value) async {
      if (value) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(planBean.getStartTime());
        List<PlanBean> planList = await model.getPlans(
            await getUserId(), time.year, time.month, time.day);
        view.updatePlanList(planList);
      } else {
        view.showSnackBar(context, "出错了，请稍后重试");
      }
    });
  }

  ///删除整组计划
  void deletePlanByGroupId(BuildContext context, PlanBean planBean) {
    model.deletePlanByGroupId(context, planBean).then((value) async {
      if (value) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(planBean.getStartTime());
        List<PlanBean> planList = await model.getPlans(
            await getUserId(), time.year, time.month, time.day);
        view.updatePlanList(planList);
      } else {
        view.showSnackBar(context, "出错了，请稍后重试");
      }
    });
  }
}
