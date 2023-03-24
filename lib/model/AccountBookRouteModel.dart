import 'package:dio/dio.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AccountBookRouteModel {
  ///查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<String> getUserIconUrl() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userIconUrl");
  }

  Future<List<BillBean>> getBills(int year, int month) async {
    int start = TimeUtil.getStartOfDay(year, month, 1);
    int end =
        TimeUtil.getEndOfDay(year, month, TimeUtil.getDaysOfMonth(year, month));

    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(Constant.BILL_TABLE,
        distinct: true,
        where: "BillUser = ? and BillStatus=1 and BillDate>= ? and BillDate<=?",
        whereArgs: [userId, start, end],
        orderBy: "BillDate DESC");
    database.close();
    return List.generate(maps.length, (i) {
      BillBean bean = BillBean();
      bean.setObjectId(maps[i]['ObjectId']);
      bean.setBillId(maps[i]['BillId']);
      bean.setBillDate(maps[i]['BillDate']);
      bean.setBillMoney(maps[i]['BillMoney']);
      bean.setBillProperty(maps[i]['BillProperty']);
      bean.setBillCategory(maps[i]['BillCategory']);
      bean.setBillAccount(maps[i]['BillAccount']);
      bean.setBillRemark(maps[i]['BillRemark']);
      bean.setBillUser(maps[i]['BillUser']);
      bean.setBillShop(maps[i]['BillShop']);
      bean.setBillStatus(maps[i]['BillStatus']);
      bean.setBillType(maps[i]['BillType']);
      bean.setBillImage(maps[i]['BillImage']);
      bean.setCreateTime(maps[i]['CreateTime']);
      bean.setUpdateTime(maps[i]['UpdateTime']);
      return bean;
    });
  }

  Future<double> getIncomeCount(int year, int month) async {
    int start = TimeUtil.getStartOfDay(year, month, 1);
    int end =
        TimeUtil.getEndOfDay(year, month, TimeUtil.getDaysOfMonth(year, month));
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
      Constant.BILL_TABLE,
      distinct: true,
      columns: ["sum(BillMoney) as moneyCount"],
      where:
          "BillUser = ? and BillProperty > 0 and BillStatus =1 and BillDate>=? and BillDate <=?",
      whereArgs: [userId, start, end],
    );
    database.close();
    return maps[0]["moneyCount"] == null ? 0.0 : maps[0]["moneyCount"];
  }

  Future<double> getExpendCount(int year, int month) async {
    int start = TimeUtil.getStartOfDay(year, month, 1);
    int end =
        TimeUtil.getEndOfDay(year, month, TimeUtil.getDaysOfMonth(year, month));
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
      Constant.BILL_TABLE,
      distinct: true,
      columns: ["sum(BillMoney) as moneyCount"],
      where:
          "BillUser = ? and BillProperty < 0 and BillStatus =1 and BillDate>=? and BillDate <=?",
      whereArgs: [userId, start, end],
    );
    database.close();
    return maps[0]["moneyCount"] == null ? 0.0 : maps[0]["moneyCount"];
  }

  Future<double> getIncomeCountOfDay(int year, int month, int day) async {
    int start = TimeUtil.getStartOfDay(year, month, day);
    int end = TimeUtil.getEndOfDay(year, month, day);
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
      Constant.BILL_TABLE,
      distinct: true,
      columns: ["sum(BillMoney) as moneyCount"],
      where:
          "BillUser = ? and BillProperty > 0 and BillStatus =1 and BillDate>=? and BillDate <=?",
      whereArgs: [userId, start, end],
    );
    database.close();
    return maps[0]["moneyCount"] == null ? 0.0 : maps[0]["moneyCount"];
  }

  Future<double> getExpendCountOfDay(int year, int month, int day) async {
    int start = TimeUtil.getStartOfDay(year, month, day);
    int end = TimeUtil.getEndOfDay(year, month, day);
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
      Constant.BILL_TABLE,
      distinct: true,
      columns: ["sum(BillMoney) as moneyCount"],
      where:
          "BillUser = ? and BillProperty < 0 and BillStatus =1 and BillDate>=? and BillDate <=?",
      whereArgs: [userId, start, end],
    );
    database.close();
    return maps[0]["moneyCount"] == null ? 0.0 : maps[0]["moneyCount"];
  }

  Future<bool> deleteBill(String objectId) async {
    bool deleteResult = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    await database.transaction((txn) async {
      int updateResult = await txn.update(Constant.BILL_TABLE,
          {"BillStatus": -1, "BillType": 1, "UpdateTime": currentTime},
          where: "ObjectId = ?", whereArgs: [objectId]);
      if(updateResult>0){
        Dio dio = Dio();
        Response<bool> resp = await dio.get(Constant.CLOUD_ADDRESS +
            "/LifeKeeper/DeleteBill?updateTime=$currentTime&objectId=$objectId");
        deleteResult = resp.data;
      }
    });
    database.close();
    return deleteResult;
  }
}
