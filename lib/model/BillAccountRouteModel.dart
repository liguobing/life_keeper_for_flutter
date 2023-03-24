import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/BillAccount.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/UpdateAccountBean.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BillAccountRouteModel {
  ///查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<List<BillAccount>> getBillAccounts() async {
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
        where: "AccountUser = ? and AccountStatus = 1",
        whereArgs: [userId],
        orderBy: "OrderIndex DESC");
    database.close();
    return List.generate(maps.length, (i) {
      BillAccount account = BillAccount();
      account.setObjectId(maps[i]["ObjectId"]);
      account.setAccountId(maps[i]["AccountId"]);
      account.setAccountUser(maps[i]["AccountUser"]);
      account.setAccountName(maps[i]["AccountName"]);
      account.setAccountStatus(maps[i]["AccountStatus"]);
      account.setAccountType(maps[i]["AccountType"]);
      account.setCreateTime(maps[i]["CreateTime"]);
      account.setUpdateTime(maps[i]["UpdateTime"]);
      account.setOrderIndex(maps[i]["OrderIndex"]);
      return account;
    });
  }

  Future<bool> accountIsExists(String name) async {
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
      where: "AccountUser = ? and AccountName = ? and AccountStatus = 1",
      whereArgs: [userId, name],
    );
    database.close();
    return maps.length > 0;
  }

  Future<bool> addAccount(String name) async {
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

  Future<bool> deleteAccount(String objectId) async {
    bool result = false;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update(Constant.BILL_ACCOUNT_TABLE,
          {"AccountStatus": -1, "AccountType": 1, "UpdateTime": currentTime},
          where: "ObjectId = ?", whereArgs: [objectId]);
      if (updateResult > 0) {
        Dio dio = Dio();
        Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
            "/LifeKeeper/DeleteBillAccount?objectId=$objectId&updateTime=$currentTime");
        result = resp.data;
      }
    });
    database.close();
    return result;
  }

  Future<bool> updateAccount(BillAccount account, String newName) async {
    bool result = false;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      int updateResult = await txn.update(Constant.BILL_ACCOUNT_TABLE,
          {"AccountStatus": -1, "AccountType": 2, "UpdateTime": currentTime},
          where: "ObjectId = ?", whereArgs: [account.getObjectId()]);
      if (updateResult > 0) {
        String objectId = StringUtil.getRandomString();
        BillAccount newAccount = BillAccount();
        newAccount.setObjectId(objectId);
        newAccount.setAccountId(account.getAccountId());
        newAccount.setAccountUser(account.getAccountUser());
        newAccount.setAccountName(newName);
        newAccount.setAccountStatus(1);
        newAccount.setAccountType(0);
        newAccount.setCreateTime(currentTime);
        newAccount.setUpdateTime(0);
        newAccount.setOrderIndex(account.getOrderIndex());
        int insertColumnCount =
            await txn.insert(Constant.BILL_ACCOUNT_TABLE, newAccount.toMap());
        if (insertColumnCount > 0) {
          UpdateAccountBean bean = UpdateAccountBean();
          bean.setOldBillAccountObjectId(account.getObjectId());
          bean.setOldBillAccountType(2);
          bean.setOldBillAccountUpdateTime(currentTime);
          bean.setNewBillAccount(newAccount);
          Dio dio = Dio();
          Response<bool> resp = await dio.post(
              "${Constant.CLOUD_ADDRESS}/LifeKeeper/UpdateBillAccount",
              data: json.encode(bean));
          result = resp.data;
        }
      }
    });
    database.close();
    return result;
  }
}
