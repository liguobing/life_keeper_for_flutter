import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/BillCategory.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/UpdateCategoryBean.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BillCategoryRouteModel {
  ///查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<List<BillCategory>> getIncomeCategories() async {
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
        where: "CategoryUser = ? and CategoryStatus = 1 and IsIncome = 1",
        whereArgs: [userId],
        orderBy: "OrderIndex DESC");
    database.close();
    return List.generate(maps.length, (i) {
      BillCategory category = BillCategory();
      category.setObjectId(maps[i]["ObjectId"]);
      category.setCategoryId(maps[i]["CategoryId"]);
      category.setCategoryUser(maps[i]["CategoryUser"]);
      category.setCategoryName(maps[i]["CategoryName"]);
      category.setIsIncome(maps[i]["IsIncome"]);
      category.setCategoryStatus(maps[i]["CategoryStatus"]);
      category.setCategoryType(maps[i]["CategoryType"]);
      category.setCreateTime(maps[i]["CreateTime"]);
      category.setUpdateTime(maps[i]["UpdateTime"]);
      category.setOrderIndex(maps[i]["OrderIndex"]);
      return category;
    });
  }

  Future<List<BillCategory>> getExpendCategories() async {
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
        where: "CategoryUser = ? and CategoryStatus = 1 and IsIncome = -1",
        whereArgs: [userId],
        orderBy: "OrderIndex DESC");
    database.close();
    return List.generate(maps.length, (i) {
      BillCategory category = BillCategory();
      category.setObjectId(maps[i]["ObjectId"]);
      category.setCategoryId(maps[i]["CategoryId"]);
      category.setCategoryUser(maps[i]["CategoryUser"]);
      category.setCategoryName(maps[i]["CategoryName"]);
      category.setIsIncome(maps[i]["IsIncome"]);
      category.setCategoryStatus(maps[i]["CategoryStatus"]);
      category.setCategoryType(maps[i]["CategoryType"]);
      category.setCreateTime(maps[i]["CreateTime"]);
      category.setUpdateTime(maps[i]["UpdateTime"]);
      category.setOrderIndex(maps[i]["OrderIndex"]);
      return category;
    });
  }

  Future<bool> categoryIsExists(int isIncome, String categoryName) async {
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
      where:
          "CategoryName = ? and CategoryUser = ? and IsIncome = ? and CategoryStatus=1",
      whereArgs: [categoryName, userId, "$isIncome"],
    );
    database.close();
    return maps.length > 0;
  }

  Future<bool> addCategory(int isIncome, String categoryName) async {
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
      category.setCategoryName(categoryName);
      category.setIsIncome(isIncome);
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

  Future<bool> deleteCategory(String objectId) async {
    bool result = false;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update(Constant.BILL_CATEGORY_TABLE,
          {"CategoryStatus": -1, "CategoryType": 1, "UpdateTime": currentTime},
          where: "ObjectId = ?", whereArgs: [objectId]);
      if (updateResult > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
            "/LifeKeeper/DeleteBillCategory?objectId=$objectId&updateTime=$currentTime");
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  Future<bool> updateCategory(BillCategory category, String newName) async {
    bool result = false;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update(Constant.BILL_CATEGORY_TABLE,
          {"CategoryStatus": -1, "CategoryType": 2, "UpdateTime": currentTime},
          where: "ObjectId = ?", whereArgs: [category.getObjectId()]);
      if (updateResult > 0) {
        String objectId = StringUtil.getRandomString();
        BillCategory newCategory = BillCategory();
        newCategory.setObjectId(objectId);
        newCategory.setCategoryId(category.getCategoryId());
        newCategory.setCategoryUser(category.getCategoryUser());
        newCategory.setCategoryName(newName);
        newCategory.setIsIncome(category.isIncome);
        newCategory.setCategoryStatus(1);
        newCategory.setCategoryType(0);
        newCategory.setCreateTime(currentTime);
        newCategory.setUpdateTime(0);
        newCategory.setOrderIndex(category.getOrderIndex());
        int insertColumnCount =
            await txn.insert(Constant.BILL_CATEGORY_TABLE, newCategory.toMap());
        if (insertColumnCount > 0) {
          UpdateCategoryBean bean = UpdateCategoryBean();
          bean.setOldBillCategoryObjectId(category.getObjectId());
          bean.setOldBillCategoryType(2);
          bean.setOldBillCategoryUpdateTime(currentTime);
          bean.setNewBillCategory(newCategory);
          Dio dio = Dio();
          Response<bool> resp = await dio.post(
              "${Constant.CLOUD_ADDRESS}/LifeKeeper/UpdateBillCategory",
              data: json.encode(bean));
          result = resp.data;
        }
      }
    });
    database.close();
    return result;
  }
}
