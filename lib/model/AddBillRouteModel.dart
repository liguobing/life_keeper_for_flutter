import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillImageResponse.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/BillAccount.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/BillCategory.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class AddBillRouteModel {
  //查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  //查找收入分类
  Future<List<String>> getIncomeCategoryList() async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_CATEGORY_TABLE,
        distinct: true,
        columns: ["CategoryName"],
        where: "CategoryUser = ? and CategoryStatus = 1 and IsIncome = 1",
        whereArgs: [userId]);
    database.close();
    return List.generate(maps.length, (i) {
      return maps[i]["CategoryName"];
    });
  }

  //查找支出分类
  Future<List<String>> getExpendCategoryList() async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_CATEGORY_TABLE,
        distinct: true,
        columns: ["CategoryName"],
        where: "CategoryUser = ? and CategoryStatus = 1 and IsIncome = -1",
        whereArgs: [userId]);
    database.close();
    return List.generate(maps.length, (i) {
      return maps[i]["CategoryName"];
    });
  }

  //查找账户
  Future<List<String>> getAccountList() async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_ACCOUNT_TABLE,
        distinct: true,
        columns: ["AccountName"],
        where: "AccountUser = ? and AccountStatus = 1",
        whereArgs: [userId]);
    database.close();
    return List.generate(maps.length, (i) {
      return maps[i]["AccountName"];
    });
  }

  //分类是否已经存在
  Future<bool> categoryIsExists(
      BuildContext context, String name, int billProperty) async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_CATEGORY_TABLE,
        columns: ["ObjectId"],
        where: "CategoryUser = ? and CategoryName = ? and IsIncome = ?",
        whereArgs: [userId, name, "$billProperty"]);
    database.close();
    return maps.length > 0;
  }

  //账户是否已经存在
  Future<bool> accountIsExists(BuildContext context, String name) async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_ACCOUNT_TABLE,
        columns: ["ObjectId"],
        where: "AccountUser = ? and AccountName = ?",
        whereArgs: [userId, name]);
    database.close();
    return maps.length > 0;
  }

  //添加分类
  Future<bool> addCategory(
      BuildContext context, String name, int billProperty) async {
    bool result = false;
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      List<Map<String, dynamic>> maxOrder = await txn.query(
          Constant.BILL_CATEGORY_TABLE,
          columns: ["OrderIndex"],
          where: "CategoryUser = ?",
          whereArgs: [userId],
          orderBy: "OrderIndex DESC");
      int orderIndex = 0;
      if (maxOrder.length > 0) {
        orderIndex = maxOrder[0]["OrderIndex"];
      }
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      BillCategory category = BillCategory();
      category.setObjectId(StringUtil.getRandomString());
      category.setCategoryId(StringUtil.getRandomString());
      category.setCategoryUser(await getUserId());
      category.setCategoryName(name);
      category.setIsIncome(billProperty);
      category.setCategoryStatus(1);
      category.setCategoryType(0);
      category.setCreateTime(currentTime);
      category.setUpdateTime(0);
      category.setOrderIndex(orderIndex + 1);
      int insertColumnCount =
          await txn.insert(Constant.BILL_CATEGORY_TABLE, category.toMap());
      List<BillCategory> list = List();
      list.add(category);
      if (insertColumnCount > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.post(
            "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddBillCategory",
            data: json.encode(list));
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  //添加分类
  Future<bool> addAccount(BuildContext context, String name) async {
    bool result = false;
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      List<Map<String, dynamic>> maxOrder = await txn.query(
          Constant.BILL_ACCOUNT_TABLE,
          columns: ["OrderIndex"],
          where: "AccountUser = ?",
          whereArgs: [userId],
          orderBy: "OrderIndex DESC");
      int orderIndex = 0;
      if (maxOrder.length > 0) {
        orderIndex = maxOrder[0]["OrderIndex"];
      }
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      BillAccount account = BillAccount();
      account.setObjectId(StringUtil.getRandomString());
      account.setAccountId(StringUtil.getRandomString());
      account.setAccountUser(await getUserId());
      account.setAccountName(name);
      account.setAccountStatus(1);
      account.setAccountType(0);
      account.setCreateTime(currentTime);
      account.setUpdateTime(0);
      account.setOrderIndex(orderIndex + 1);
      int insertColumnCount =
          await txn.insert(Constant.BILL_ACCOUNT_TABLE, account.toMap());
      List<BillAccount> list = List();
      list.add(account);
      if (insertColumnCount > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.post(
            "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddBillAccount",
            data: json.encode(list));
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  Future<bool> addBill(
      BuildContext context,
      int billDate,
      double billMoney,
      int billProperty,
      String billCategory,
      String billAccount,
      String billRemark,
      String shopName,
      File image) async {
    bool result = false;
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    await database.transaction((txn) async {
      BillBean billBean = BillBean();
      billBean.setObjectId(StringUtil.getRandomString());
      billBean.setBillId(StringUtil.getRandomString());
      billBean.setBillDate(billDate);
      billBean.setBillMoney(billMoney);
      billBean.setBillProperty(billProperty);
      billBean.setBillCategory(billCategory);
      billBean.setBillAccount(billAccount);
      if (billRemark.length > 0) {
        billBean.setBillRemark(billRemark);
      }
      billBean.setBillUser(userId);
      if (shopName.length > 0) {
        billBean.setBillShop(shopName);
      }
      billBean.setBillStatus(1);
      billBean.setBillType(0);
      if (image != null) {
        BillImageResponse billImageResponse = await uploadFileToCloud(context, image);
        if(billImageResponse.getResultCode() > 0){
          billBean.setBillImage(billImageResponse.getImageName());
        }
      }
      billBean.setCreateTime(currentTime);
      billBean.setUpdateTime(0);
      List<BillBean> list = List();
      list.add(billBean);
      int column = await txn.insert(Constant.BILL_TABLE, billBean.toMap());
      if(column > 0){
        Dio dio = Dio();
        Response<bool> resp = await dio.post(
            "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddBill",
            data: json.encode(list));
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  //上传图片到云端
  Future<BillImageResponse> uploadFileToCloud(
      BuildContext context, File file) async {
    BillImageResponse billImageResponse = BillImageResponse();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            filename: path.basename(file.path)),
      });
      var response = await dio.post(
          Constant.CLOUD_ADDRESS + "/LifeKeeper/UploadImage",
          data: formData);
      print("==================================$response");
      print("==================================${response.data}");
      print("==================================${response.runtimeType}");
      print("==================================${response.data.runtimeType}");
      billImageResponse = BillImageResponse.fromJson(response.data);
    } catch (e, s) {
      print(e);
      print(s);
      billImageResponse.setResultCode(-1);
    }
    return billImageResponse;
  }


}
