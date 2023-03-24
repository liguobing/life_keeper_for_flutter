import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanBean.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';

class PlanRouteModel {
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    return database;
  }

  Future<List<PlanBean>> getPlans(
      String userId, int year, int month, int day) async {
    num startTime = TimeUtil.getStartOfDay(year, month, day);
    num endTime = TimeUtil.getEndOfDay(year, month, day);
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> unFinishedPlans = await database.query(
        "PlanTable",
        where:
            "PlanUser = ? and PlanStatus = 1 and StartTime >= ? and StartTime <= ? and isFinished = -1",
        whereArgs: [userId, "$startTime", "$endTime"]);
    List<Map<String, dynamic>> finishedPlans = await database.query("PlanTable",
        where:
            "PlanUser = ? and PlanStatus = 1 and StartTime >= ? and StartTime <= ? and isFinished = 1",
        whereArgs: [userId, "$startTime", "$endTime"]);
    List<PlanBean> list = List();
    unFinishedPlans.forEach((element) {
      PlanBean bean = PlanBean();
      bean.setObjectId(element["ObjectId"]);
      bean.setPlanId(element["PlanId"]);
      bean.setGroupId(element["GroupId"]);
      bean.setIsAllDay(element["IsAllDay"]);
      bean.setPlanName(element["PlanName"]);
      bean.setPlanDescription(element["PlanDescription"]);
      bean.setPlanUser(element["PlanUser"]);
      bean.setPlanLocation(element["PlanLocation"]);
      bean.setStartTime(element["StartTime"]);
      bean.setAlarmTime(element["AlarmTime"]);
      bean.setIsFinished(element["IsFinished"]);
      bean.setPlanStatus(element["PlanStatus"]);
      bean.setPlanType(element["PlanType"]);
      bean.setCreateTime(element["CreateTime"]);
      bean.setUpdateTime(element["UpdateTime"]);
      bean.setFinishTime(element["FinishTime"]);
      bean.setRepeatType(element["RepeatType"]);
      bean.setEndRepeatType(element["EndRepeatType"]);
      bean.setEndRepeatValue(element["EndRepeatValue"]);
      list.add(bean);
    });
    finishedPlans.forEach((element) {
      PlanBean bean = PlanBean();
      bean.setObjectId(element["ObjectId"]);
      bean.setPlanId(element["PlanId"]);
      bean.setGroupId(element["GroupId"]);
      bean.setIsAllDay(element["IsAllDay"]);
      bean.setPlanName(element["PlanName"]);
      bean.setPlanDescription(element["PlanDescription"]);
      bean.setPlanUser(element["PlanUser"]);
      bean.setPlanLocation(element["PlanLocation"]);
      bean.setStartTime(element["StartTime"]);
      bean.setAlarmTime(element["AlarmTime"]);
      bean.setIsFinished(element["IsFinished"]);
      bean.setPlanStatus(element["PlanStatus"]);
      bean.setPlanType(element["PlanType"]);
      bean.setCreateTime(element["CreateTime"]);
      bean.setUpdateTime(element["UpdateTime"]);
      bean.setFinishTime(element["FinishTime"]);
      bean.setRepeatType(element["RepeatType"]);
      bean.setEndRepeatType(element["EndRepeatType"]);
      bean.setEndRepeatValue(element["EndRepeatValue"]);
      list.add(bean);
    });
    database.close();
    return list;
  }

  Future<bool> unFinishPlan(PlanBean bean) async {
    bool result = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    int currTime = DateTime.now().millisecondsSinceEpoch;
    await database.transaction((txn) async {
      int columnCount = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 2, "UpdateTime": currTime},
          where: "ObjectId = ?", whereArgs: [bean.getObjectId()]);
      String newObjectId = StringUtil.getRandomString();
      if (columnCount > 0) {
        //添加新计划
        PlanBean newPlan = PlanBean();
        newPlan.setObjectId(newObjectId);
        newPlan.setPlanId(bean.getPlanId());
        newPlan.setGroupId(bean.getGroupId());
        newPlan.setIsAllDay(bean.getIsAllDay());
        newPlan.setPlanName(bean.getPlanName());
        newPlan.setPlanDescription(bean.getPlanDescription());
        newPlan.setPlanLocation(bean.getPlanLocation());
        newPlan.setPlanUser(bean.getPlanUser());
        newPlan.setStartTime(bean.getStartTime());
        newPlan.setRepeatType(bean.getRepeatType());
        newPlan.setEndRepeatType(bean.getEndRepeatType());
        newPlan.setEndRepeatValue(bean.getEndRepeatValue());
        newPlan.setAlarmTime(bean.getAlarmTime());
        newPlan.setIsFinished(-1);
        newPlan.setPlanStatus(bean.getPlanStatus());
        newPlan.setPlanType(bean.getPlanType());
        newPlan.setCreateTime(currTime);
        newPlan.setUpdateTime(0);
        newPlan.setFinishTime(0);
        int columnCount = await txn.insert("PlanTable", newPlan.toMap());
        if (columnCount > 0) {
          Dio dio = Dio();
          Response response = await dio.get(Constant.CLOUD_ADDRESS +
              "/LifeKeeper/UnFinishPlan?objectId=" +
              bean.getObjectId() +
              "&updateTime=$currTime&newObjectId=" +
              newObjectId);
          String respStr = response.data.toString();
          if (respStr == "true") {
            result = true;
          }
        }
      }
    });
    database.close();
    return result;
  }

  Future<bool> finishPlan(PlanBean bean) async {
    bool result = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    int currTime = DateTime.now().millisecondsSinceEpoch;
    await database.transaction((txn) async {
      int columnCount = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 2, "UpdateTime": currTime},
          where: "ObjectId = ?", whereArgs: [bean.getObjectId()]);
      String newObjectId = StringUtil.getRandomString();
      if (columnCount > 0) {
        //添加新计划
        PlanBean newPlan = PlanBean();
        newPlan.setObjectId(newObjectId);
        newPlan.setPlanId(bean.getPlanId());
        newPlan.setGroupId(bean.getGroupId());
        newPlan.setIsAllDay(bean.getIsAllDay());
        newPlan.setPlanName(bean.getPlanName());
        newPlan.setPlanDescription(bean.getPlanDescription());
        newPlan.setPlanLocation(bean.getPlanLocation());
        newPlan.setPlanUser(bean.getPlanUser());
        newPlan.setStartTime(bean.getStartTime());
        newPlan.setRepeatType(bean.getRepeatType());
        newPlan.setEndRepeatType(bean.getEndRepeatType());
        newPlan.setEndRepeatValue(bean.getEndRepeatValue());
        newPlan.setAlarmTime(bean.getAlarmTime());
        newPlan.setIsFinished(1);
        newPlan.setPlanStatus(bean.getPlanStatus());
        newPlan.setPlanType(bean.getPlanType());
        newPlan.setCreateTime(currTime);
        newPlan.setUpdateTime(0);
        newPlan.setFinishTime(0);
        int columnCount = await txn.insert("PlanTable", newPlan.toMap());
        if (columnCount > 0) {
          String objectId = bean.getObjectId();
          String groupId = bean.getGroupId();
          Dio dio = Dio();
          Response response = await dio.get(Constant.CLOUD_ADDRESS +
              "/LifeKeeper/FinishPlan?objectId=" +
              objectId +
              "&groupId=" +
              groupId +
              "&updateTime=$currTime&newObjectId=" +
              newObjectId);
          String respStr = response.data.toString();
          if (respStr == "true") {
            result = true;
          }
        }
      }
    });
    database.close();
    return result;
  }

  ///添加闹钟
  Future<bool> addAlarm(PlanBean bean, alarmTime) async {
    bool result = false;
    int currTime = DateTime.now().millisecondsSinceEpoch;
    String newObjectId = StringUtil.getRandomString();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 2, "UpdateTime": currTime},
          where: "ObjectId = ?", whereArgs: [bean.getObjectId()]);
      if (updateResult > 0) {
        PlanBean newPlan = PlanBean();
        newPlan.setObjectId(newObjectId);
        newPlan.setPlanId(bean.getPlanId());
        newPlan.setGroupId(bean.getGroupId());
        newPlan.setIsAllDay(bean.getIsAllDay());
        newPlan.setPlanName(bean.getPlanName());
        newPlan.setPlanDescription(bean.getPlanDescription());
        newPlan.setPlanLocation(bean.getPlanLocation());
        newPlan.setPlanUser(bean.getPlanUser());
        newPlan.setStartTime(bean.getStartTime());
        newPlan.setRepeatType(bean.getRepeatType());
        newPlan.setEndRepeatType(bean.getEndRepeatType());
        newPlan.setEndRepeatValue(bean.getEndRepeatValue());
        newPlan.setAlarmTime(alarmTime);
        newPlan.setIsFinished(bean.getIsFinished());
        newPlan.setPlanStatus(bean.getPlanStatus());
        newPlan.setPlanType(bean.getPlanType());
        newPlan.setCreateTime(currTime);
        newPlan.setUpdateTime(0);
        newPlan.setFinishTime(0);
        int columnCount = await txn.insert("PlanTable", newPlan.toMap());
        if (columnCount > 0) {
          Dio dio = Dio();
          Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
              "/LifeKeeper/AddAlarm?objectId=${bean.getObjectId()}&newObjectId=$newObjectId&updateTime=$currTime&alarmTime=$alarmTime");
          result = resp.data;
        }
      }
    });
    database.close();
    return result;
  }

  Future<bool> removeAlarm(BuildContext context, PlanBean bean) async {
    bool result = false;
    int currTime = DateTime.now().millisecondsSinceEpoch;
    String newObjectId = StringUtil.getRandomString();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 2, "UpdateTime": currTime},
          where: "ObjectId = ?", whereArgs: [bean.getObjectId()]);
      if (updateResult > 0) {
        PlanBean newPlan = PlanBean();
        newPlan.setObjectId(newObjectId);
        newPlan.setPlanId(bean.getPlanId());
        newPlan.setGroupId(bean.getGroupId());
        newPlan.setIsAllDay(bean.getIsAllDay());
        newPlan.setPlanName(bean.getPlanName());
        newPlan.setPlanDescription(bean.getPlanDescription());
        newPlan.setPlanLocation(bean.getPlanLocation());
        newPlan.setPlanUser(bean.getPlanUser());
        newPlan.setStartTime(bean.getStartTime());
        newPlan.setRepeatType(bean.getRepeatType());
        newPlan.setEndRepeatType(bean.getEndRepeatType());
        newPlan.setEndRepeatValue(bean.getEndRepeatValue());
        newPlan.setAlarmTime(-1);
        newPlan.setIsFinished(bean.getIsFinished());
        newPlan.setPlanStatus(bean.getPlanStatus());
        newPlan.setPlanType(bean.getPlanType());
        newPlan.setCreateTime(currTime);
        newPlan.setUpdateTime(0);
        newPlan.setFinishTime(0);
        int columnCount = await txn.insert("PlanTable", newPlan.toMap());
        if (columnCount > 0) {
          Dio dio = Dio();
          Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
              "/LifeKeeper/RemoveAlarm?objectId=${bean.getObjectId()}&newObjectId=$newObjectId&updateTime=$currTime");
          result = resp.data;
        }
      }
    });
    database.close();
    return result;
  }

  ///删除单个计划
  Future<bool> deletePlanByObjectId(BuildContext context, PlanBean bean) async {
    bool result = false;
    int currTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 1, "UpdateTime": currTime},
          where: "ObjectId = ?", whereArgs: [bean.getObjectId()]);
      if (updateResult > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
            "/LifeKeeper/DeletePlanByObjectId?objectId=${bean.getObjectId()}&groupId=${bean.getGroupId()}&updateTime=$currTime");
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  ///删除整组计划
  Future<bool> deletePlanByGroupId(BuildContext context, PlanBean bean) async {
    bool result = false;
    int currTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update("PlanTable",
          {"PlanStatus": -1, "PlanType": 1, "UpdateTime": currTime},
          where: "GroupId = ? and PlanStatus = 1", whereArgs: [bean.getGroupId()]);
      if (updateResult > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
            "/LifeKeeper/DeletePlanByGroupId?groupId=${bean.getGroupId()}&updateTime=$currTime");
        result = resp.data;
      }
    });
    database.close();
    return result;
  }
}
