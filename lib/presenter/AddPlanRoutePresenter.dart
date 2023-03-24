import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanBean.dart';
import 'package:lifekeeperforflutter/model/AddPlanRouteModel.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:lifekeeperforflutter/view/route/AddPlanRoute.dart';

class AddPlanRoutePresenter {
  AddPlanRouteState view;
  AddPlanRouteModel model;

  AddPlanRoutePresenter(AddPlanRouteState view) {
    this.view = view;
    model = new AddPlanRouteModel();
  }

  void savePlan(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planRemark,
      String planLocation,
      int startTime,
      int repeatType,
      int endRepeatType,
      int endRepeatValue,
      int alarmTime) async {
    if (planTitle.isEmpty) {
      view.showSnackBar(context, "标题不能为空");
    } else {
      if (endRepeatType == 0 && endRepeatValue < startTime) {
        view.showSnackBar(context, "结束时间不能大于开始时间");
      } else {
        view.showWaitDialog(context);
        List<PlanBean> list = List();
        switch (repeatType) {
          case 0:
            list = await getOneTimePlanList(context, isAllDay, planTitle,
                planRemark, planLocation, startTime, alarmTime);
            break;
          case 1:
            list = await getDailyPlanList(
                context,
                isAllDay,
                planTitle,
                planRemark,
                planLocation,
                startTime,
                endRepeatType,
                endRepeatValue,
                alarmTime);
            break;
          case 2:
            list = await getWeeklyPlanList(
                context,
                isAllDay,
                planTitle,
                planRemark,
                planLocation,
                startTime,
                endRepeatType,
                endRepeatValue,
                alarmTime);
            break;
          case 3:
            list = await getMonthlyPlanList(
                context,
                isAllDay,
                planTitle,
                planRemark,
                planLocation,
                startTime,
                endRepeatType,
                endRepeatValue,
                alarmTime);
            break;
          case 4:
            list = await getYearlyPlanList(
                context,
                isAllDay,
                planTitle,
                planRemark,
                planLocation,
                startTime,
                endRepeatType,
                endRepeatValue,
                alarmTime);
            break;
        }
        bool addResult = await model.addPlan(context, list);
        if (addResult) {
          view.hideWaitDialog(context);
          Navigator.pop(context);
        } else {
          view.hideWaitDialog(context);
          view.showSnackBar(context, "保存出错，请稍后重试");
        }
      }
    }
  }

  Future<List<PlanBean>> getOneTimePlanList(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planDescription,
      String planLocation,
      int startTime,
      int alarmTime) async {
    String userId = await model.getUserId();
    PlanBean planBean = PlanBean();
    planBean.setObjectId(StringUtil.getRandomString());
    planBean.setPlanId(StringUtil.getRandomString());
    planBean.setGroupId(StringUtil.getRandomString());
    planBean.setIsAllDay(isAllDay ? 1 : -1);
    planBean.setPlanName(planTitle);
    planBean.setPlanDescription(planDescription);
    planBean.setPlanLocation(planLocation);
    planBean.setPlanUser(userId);
    planBean.setStartTime(startTime);
    planBean.setRepeatType(0);
    planBean.setEndRepeatType(-1);
    planBean.setEndRepeatValue(-1);
    planBean.setAlarmTime(alarmTime);
    planBean.setIsFinished(-1);
    planBean.setPlanStatus(1);
    planBean.setPlanType(0);
    planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
    planBean.setUpdateTime(0);
    planBean.setFinishTime(0);
    List<PlanBean> list = List();
    list.add(planBean);
    return list;
  }

  Future<List<PlanBean>> getDailyPlanList(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planDescription,
      String planLocation,
      int startTime,
      int endRepeatType,
      int endRepeatValue,
      int alarmTime) async {
    List<PlanBean> list = List();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    String groupId = StringUtil.getRandomString();
    String userId = await model.getUserId();
    if (endRepeatType == 0) {
      do {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setAlarmTime(alarmTime);
        planBean.setRepeatType(1);
        planBean.setEndRepeatType(0);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day + 1,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一天
      } while (dateTime.millisecondsSinceEpoch <= endRepeatValue);
    } else {
      for (int i = 0; i < endRepeatValue; i++) {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(1);
        planBean.setEndRepeatType(1);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day + 1,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一天
      }
    }
    return list;
  }

  Future<List<PlanBean>> getWeeklyPlanList(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planDescription,
      String planLocation,
      int startTime,
      int endRepeatType,
      int endRepeatValue,
      int alarmTime) async {
    List<PlanBean> list = List();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    String groupId = StringUtil.getRandomString();
    String userId = await model.getUserId();
    if (endRepeatType == 0) {
      do {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(2);
        planBean.setEndRepeatType(0);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day + 7,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一周
      } while (dateTime.millisecondsSinceEpoch <= endRepeatValue);
    } else {
      for (int i = 0; i < endRepeatValue; i++) {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(2);
        planBean.setEndRepeatType(1);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day + 7,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一周
      }
    }
    return list;
  }

  Future<List<PlanBean>> getMonthlyPlanList(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planDescription,
      String planLocation,
      int startTime,
      int endRepeatType,
      int endRepeatValue,
      int alarmTime) async {
    List<PlanBean> list = List();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    String groupId = StringUtil.getRandomString();
    String userId = await model.getUserId();
    if (endRepeatType == 0) {
      do {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(3);
        planBean.setEndRepeatType(0);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month + 1,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond);
      } while (dateTime.millisecondsSinceEpoch <= endRepeatValue);
    } else {
      for (int i = 0; i < endRepeatValue; i++) {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(3);
        planBean.setEndRepeatType(1);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year,
            dateTime.month + 1,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一周
      }
    }
    return list;
  }

  Future<List<PlanBean>> getYearlyPlanList(
      BuildContext context,
      bool isAllDay,
      String planTitle,
      String planDescription,
      String planLocation,
      int startTime,
      int endRepeatType,
      int endRepeatValue,
      int alarmTime) async {
    String userId = await model.getUserId();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    String groupId = StringUtil.getRandomString();
    List<PlanBean> list = List();
    if (endRepeatType == 0) {
      do {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(4);
        planBean.setEndRepeatType(0);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year + 1,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一年
      } while (dateTime.millisecondsSinceEpoch <= endRepeatValue);
    } else {
      for (int i = 0; i < endRepeatValue; i++) {
        PlanBean planBean = PlanBean();
        planBean.setObjectId(StringUtil.getRandomString());
        planBean.setPlanId(StringUtil.getRandomString());
        planBean.setGroupId(groupId);
        planBean.setIsAllDay(isAllDay ? 1 : -1);
        planBean.setPlanName(planTitle);
        planBean.setPlanDescription(planDescription);
        planBean.setPlanLocation(planLocation);
        planBean.setPlanUser(userId);
        planBean.setStartTime(dateTime.millisecondsSinceEpoch);
        planBean.setRepeatType(4);
        planBean.setEndRepeatType(1);
        planBean.setEndRepeatValue(endRepeatValue);
        planBean.setAlarmTime(alarmTime);
        planBean.setIsFinished(-1);
        planBean.setPlanStatus(1);
        planBean.setPlanType(0);
        planBean.setCreateTime(DateTime.now().millisecondsSinceEpoch);
        planBean.setUpdateTime(0);
        planBean.setFinishTime(0);
        list.add(planBean);
        dateTime = DateTime(
            dateTime.year + 1,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond,
            dateTime.microsecond); //增加一年
      }
    }
    return list;
  }
}
