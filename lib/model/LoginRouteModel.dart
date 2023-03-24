import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillResponse.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/BillAccountResponse.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/BillCategoryResponse.dart';
import 'package:lifekeeperforflutter/bean/account_book/shop/BillShopResponse.dart';
import 'package:lifekeeperforflutter/bean/plan/PlanResponse.dart';
import 'package:lifekeeperforflutter/bean/user/UserResponse.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginRouteModel {
  Future<bool> login(String phone, String password) async {
    Dio dio = Dio();
    Response<String> response = await dio.get(
        "http://104.245.40.124:8080/LifeKeeper/SelectUserByPhoneAndPassword?phone=$phone&password=${StringUtil.stringToMd5("$phone", "$password")}");
    Map<String, dynamic> obj = jsonDecode(response.data.toString());
    if ("${obj['responseCode']}" == "1") {
      if (obj['responseList'].length == 0) {
        return false;
      } else {
        await initDatabase(obj["responseList"]);
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> initDatabase(List list) async {
    bool result = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      //保存用户信息
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("objectId", list[0]["objectId"]);
      sp.setString("userId", list[0]["userId"]);
      sp.setString("userName", list[0]["userName"]);
      sp.setString("userPhone", list[0]["userPhone"]);
      sp.setString("userIconUrl", list[0]["userIconUrl"]);
      sp.setString("userBindWeibo", list[0]["userBindWeibo"]);
      sp.setString(
          "userBindWeiboAccessToken", list[0]["userBindWeiboAccessToken"]);
      sp.setString("userBindWeiboIcon", list[0]["userBindWeiboIcon"]);
      sp.setString(
          "userBindWeiboExpiresTime", list[0]["userBindWeiboExpiresTime"]);
      sp.setString("userBindWeiboId", list[0]["userBindWeiboId"]);
      sp.setString("userBindQQ", list[0]["userBindQQ"]);
      sp.setString("userBindQQOpenId", list[0]["userBindQQOpenId"]);
      sp.setString("userBindQQExpiresTime", list[0]["userBindQQExpiresTime"]);
      sp.setString("userBindQQAccessToken", list[0]["userBindQQAccessToken"]);
      sp.setString("userBindQQIcon", list[0]["userBindQQIcon"]);

      String userId = list[0]["userId"];
      //初始化数据库表
      await txn.execute("create table if not exists PlanTable(" +
          "ObjectId text primary key," +
          "PlanId text," +
          "GroupId text," +
          "IsAllDay integer," +
          "PlanName text," +
          "PlanDescription text," +
          "PlanLocation text," +
          "PlanUser text," +
          "StartTime integer," +
          "RepeatType integer," +
          "EndRepeatType integer," +
          "EndRepeatValue integer," +
          "AlarmTime integer," +
          "IsFinished integer," +
          "PlanStatus integer," +
          "PlanType integer," +
          "CreateTime integer," +
          "UpdateTime integer," +
          "FinishTime integer)");
      await txn.execute("create table if not exists Bill(" +
          "ObjectId text primary key," + //唯一标识
          "BillId text," + //账单ID
          "BillMoney real," + //账单金额
          "BillProperty integer," + //账单属性  1：收入  -1：支出"
          "BillCategory text," + //账单种类
          "BillAccount text," + //账单账户
          "BillRemark text," + //账单备注
          "BillUser text," + //账单用户
          "BillShop text," + //账单位置
          "BillStatus integer," + //账单状态  1:正常账单   -1：非正常账单
          "BillType integer," + //账单类型  0：正常  1：已删除  2：已修改"
          "BillDate integer," + //消费时间
          "CreateTime integer," + //创建时间
          "UpdateTime integer," + //更新时间
          "BillImage text)");
      await txn.execute("create table if not exists BillCategory(" +
          "ObjectId text primary key," + //ObjectId 唯一标识
          "CategoryId text," + //种类ID
          "CategoryUser text," + //创建种类的用户ID
          "CategoryName text," + //种类名称
          "IsIncome integer," + //是收入吗？  1：收入   -1：支出
          "CategoryStatus integer," + //种类状态  1：正常   -1：非正常
          "CategoryType integer," + //种类类型 0：正常    1：已删除   2：已修改
          "CreateTime integer," + //创建时间
          "UpdateTime integer," + //更新时间
          "OrderIndex integer)"); //排序下标
      await txn.execute("create table if not exists BillAccount(" +
          "ObjectId text primary key," + //ObjectId 唯一标识
          "AccountId text," + //账户ID
          "AccountUser text," + //创建账户的用户ID
          "AccountName text," + //账户名
          "AccountStatus integer," + //账户状态	1：正常  -1：非正常
          "AccountType integer," + //账户类型：	0：正常	1：已删除	2：已修改
          "CreateTime integer," + //创建时间
          "UpdateTime integer," + //更新时间
          "OrderIndex integer)"); //排序下标
      await txn.execute("create table if not exists BillShop(" +
          "ObjectId text primary key," + //ObjectId 唯一标识
          "ShopId text," + //商家ID
          "ShopName text," + //商家名称
          "ShopIcon text," + //商家图标
          "ShopUser text," + //创建商家的用户
          "ShopStatus integer," + //商家状态	1：正常  -1：非正常
          "ShopType integer," + //商家类型：	0：正常	1：已删除	2：已修改
          "CreateTime integer," + //创建时间
          "UpdateTime integer," +
          "OrderIndex integer)"); //更新时间
      await txn.execute("delete from PlanTable");
      await txn.execute("delete from Bill");
      await txn.execute("delete from BillCategory");
      await txn.execute("delete from BillAccount");
      await txn.execute("delete from BillShop");

      //获取数据
      Dio dio = Dio();

      Response response = await dio.get(
          "http://104.245.40.124:8080/LifeKeeper/SelectBillByUserId?userId=$userId");
      BillResponse billResponse = BillResponse.fromJson(response.data);
      if (billResponse.getResponseCode() == 1) {
        if (billResponse.getResponseList().length > 0) {
          List list = billResponse.getResponseList();
          List.generate(list.length, (index) async {
            await txn.insert(Constant.BILL_TABLE, list[index].toMap());
          });
        }
      }

      response = await dio.get(
          "http://104.245.40.124:8080/LifeKeeper/SelectBillAccountByUserId?userId=$userId");
      BillAccountResponse billAccountResponse =
          BillAccountResponse.fromJson(response.data);
      if (billAccountResponse.getResponseCode() == 1) {
        if (billAccountResponse.getResponseList().length > 0) {
          List list = billAccountResponse.getResponseList();
          List.generate(list.length, (index) async {
            await txn.insert(Constant.BILL_ACCOUNT_TABLE, list[index].toMap());
          });
        }
      }

      response = await dio.get(
          "http://104.245.40.124:8080/LifeKeeper/SelectBillCategoryByUserId?userId=$userId");
      BillCategoryResponse billCategoryResponse =
          BillCategoryResponse.fromJson(response.data);
      if (billCategoryResponse.getResponseCode() == 1) {
        if (billCategoryResponse.getResponseList().length > 0) {
          List list = billCategoryResponse.getResponseList();
          List.generate(list.length, (index) async {
            await txn.insert(Constant.BILL_CATEGORY_TABLE, list[index].toMap());
          });
        }
      }

      response = await dio.get(
          "http://104.245.40.124:8080/LifeKeeper/SelectBillShopByUserId?userId=$userId");
      BillShopResponse billShopResponse =
          BillShopResponse.fromJson(response.data);
      if (billShopResponse.getResponseCode() == 1) {
        if (billShopResponse.getResponseList().length > 0) {
          List list = billShopResponse.getResponseList();
          List.generate(list.length, (index) async {
            await txn.insert(Constant.BILL_SHOP_TABLE, list[index].toMap());
          });
        }
      }

      response = await dio.get(
          "http://104.245.40.124:8080/LifeKeeper/SelectPlanByUserId?userId=$userId");
      PlanResponse planResponse = PlanResponse.fromJson(response.data);
      if (planResponse.getCode() == 1) {
        if (planResponse.getList().length > 0) {
          List list = planResponse.getList();
          List.generate(list.length, (index) async {
            await txn.insert(Constant.PLAN_TABLE, list[index].toMap());
          });
        }
      }
      result = true;
    });
    database.close();
    return result;
  }

  Future<int> checkPhoneIsExists(String phone) async {
    Dio dio = Dio();
    Response response = await dio.get(
        "http://104.245.40.124:8080/LifeKeeper/SelectUserByPhone?phone=$phone");
    UserResponse userResponse = UserResponse.fromJson(response.data);
    if (userResponse.getResponseCode() > 0) {
      if (userResponse.getResponseList().length > 0) {
        return -2;
      } else {
        return 1;
      }
    } else {
      return -1;
    }
  }
}
