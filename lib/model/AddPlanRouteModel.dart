import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanBean.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';

class AddPlanRouteModel {
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<bool> addPlan(BuildContext context, List<PlanBean> list) async {
    bool result = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      for (int i = 0; i < list.length; i++) {
        txn.insert("PlanTable", list[i].toMap());
      }
      Dio dio = Dio();
      Response<bool> resp = await dio.post(
          "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddPlan",
          data: json.encode(list));
      result = resp.data;
    });
    database.close();
    return result;
  }
}
