import 'package:lifekeeperforflutter/bean/account_book/UpdateAccountBookCardBean.dart';
import 'package:lifekeeperforflutter/bean/plan/UpdatePlanCardBean.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IndexRouteModel {
  ///获取用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  ///获取计划 Card 数据
  Future<UpdatePlanCardBean> getPlanCardData(String userId) async {
    num currDayStartTime = TimeUtil.getStartOfCurrentDay();
    num currDayEndTime = TimeUtil.getEndOfCurrentDay();
    num currMonthStartTime = TimeUtil.getStartOfCurrentMonth();
    num currMonthEndTime = TimeUtil.getEndOfCurrentMonth();

    int dailyPlanCount = 0;
    int monthlyPlanCount = 0;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute("create table if not exists PlanTable(" +
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
    });

    List<Map<String, dynamic>> dailyQueryResult = await database.query(
        "PlanTable",
        columns: ["ObjectId"],
        where:
            "PlanUser = ? and PlanStatus = 1 and StartTime >= ? and StartTime <= ? ",
        whereArgs: [userId, "$currDayStartTime", "$currDayEndTime"]);
    dailyPlanCount = dailyQueryResult.length;

    List<Map<String, dynamic>> monthlyQueryResult = await database.query(
        "PlanTable",
        columns: ["ObjectId"],
        where:
            "PlanUser = ? and PlanStatus = 1 and StartTime >= ? and StartTime <= ? ",
        whereArgs: [userId, "$currMonthStartTime", "$currMonthEndTime"]);
    monthlyPlanCount = monthlyQueryResult.length;
    UpdatePlanCardBean bean =
        UpdatePlanCardBean(dailyPlanCount, monthlyPlanCount);
    database.close();
    return bean;
  }

  ///获取账本 Card 数据
  Future<UpdateAccountBookCardBean> getAccountBookCardData(
      String userId) async {
    num currMonthStartTime = TimeUtil.getStartOfCurrentMonth();
    num currMonthEndTime = TimeUtil.getEndOfCurrentMonth();

    double incomeCount = 0;
    double expendCount = 0;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
          db.execute("create table if not exists Bill(" +
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
          db.execute("create table if not exists BillCategory(" +
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
          db.execute("create table if not exists BillAccount(" +
              "ObjectId text primary key," + //ObjectId 唯一标识
              "AccountId text," + //账户ID
              "AccountUser text," + //创建账户的用户ID
              "AccountName text," + //账户名
              "AccountStatus integer," + //账户状态	1：正常  -1：非正常
              "AccountType integer," + //账户类型：	0：正常	1：已删除	2：已修改
              "CreateTime integer," + //创建时间
              "UpdateTime integer," + //更新时间
              "OrderIndex integer)"); //排序下标
          db.execute("create table if not exists BillShop(" +
              "ObjectId text primary key," + //ObjectId 唯一标识
              "ShopId text," + //商家ID
              "ShopName text," + //商家名称
              "ShopIcon text," + //商家图标
              "ShopUser text," + //创建商家的用户
              "ShopStatus integer," + //商家状态	1：正常  -1：非正常
              "ShopType integer," + //商家类型：	0：正常	1：已删除	2：已修改
              "CreateTime integer," + //创建时间
              "UpdateTime integer," + //更新时间
              "OrderIndex integer)"); //排序下标
        });
    List<Map<String, dynamic>> incomeQueryResult = await database.query("Bill",
        columns: ["ifnull (sum(billMoney),0.0) as IncomeCount"],
        where:
            "BillUser = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ? and BillProperty = 1",
        whereArgs: [userId, "$currMonthStartTime", "$currMonthEndTime"]);
    incomeCount = incomeQueryResult[0]["IncomeCount"];

    List<Map<String, dynamic>> expendQueryResult = await database.query("Bill",
        columns: ["ifnull (sum(billMoney),0.0) as ExpendCount"],
        where:
            "BillUser = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ? and BillProperty = -1",
        whereArgs: [userId, "$currMonthStartTime", "$currMonthEndTime"]);
    expendCount = expendQueryResult[0]["ExpendCount"];
    UpdateAccountBookCardBean bean =
        UpdateAccountBookCardBean(incomeCount, expendCount);
    database.close();
    return bean;
  }
}
