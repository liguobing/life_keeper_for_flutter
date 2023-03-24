import 'package:fl_chart/fl_chart.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_chart/BillChartOverViewBean.dart';
import 'package:lifekeeperforflutter/util/ColorUtil.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/TimeUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BillChartRouteModel {
  ///查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  Future<BillChartOverViewBean> getOverViewData(int year, int month) async {
    int start = TimeUtil.getStartOfMonth(year, month);
    int end = TimeUtil.getEndOfMonth(year, month);
    BillChartOverViewBean bean = new BillChartOverViewBean();
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(Constant.BILL_TABLE,
        columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
        where:
        "BillUser = ? and BillStatus = 1 and BillProperty = 1 and BillDate >= ? and BillDate <=?",
        whereArgs: [userId, "$start", "$end"]);
    double income = maps[0]["BillMoney"];
    maps = await database.query(Constant.BILL_TABLE,
        columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
        where:
        "BillUser = ? and BillStatus = 1 and BillProperty = -1 and BillDate >= ? and BillDate <= ?",
        whereArgs: [userId, "$start", "$end"]);
    await database.close();
    print("=================== ${maps[0]["BillMoney"]}");
    double expend = maps[0]["BillMoney"];
    bean.setIncome(income);
    bean.setExpend(expend);
    bean.setBalance(bean.getIncome() - bean.getExpend());
    bean.setEvaluate(bean.getExpend() / TimeUtil.getDaysOfMonth(year, month));
    return bean;
  }

  Future<List<PieChartSectionData>> getPieData(int billProperty, int year,
      int month) async {
    int start = TimeUtil.getStartOfMonth(year, month);
    int end = TimeUtil.getEndOfMonth(year, month);
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(Constant.BILL_TABLE,
        columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
        where:
        "BillUser = ? and BillProperty = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ?",
        whereArgs: [userId, "$billProperty", "$start", "$end"]);
    double moneyCount = maps[0]["BillMoney"];
    if (moneyCount == 0) {
      database.close();
      return List();
    } else {
      maps = await database.query(Constant.BILL_TABLE,
          columns: ["ifnull(sum(BillMoney),0.0) as BillMoney", "BillCategory"],
          where:
          "BillUser = ? and BillProperty = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ?",
          whereArgs: [userId, "$billProperty", "$start", "$end"],
          groupBy: "BillCategory");
      database.close();
      return List.generate(maps.length, (i) {
        String categoryName = maps[i]["BillCategory"];
        double billMoney = maps[i]["BillMoney"];
        return PieChartSectionData(
          color: billProperty > 0 ? ColorUtil.getPieChartColor(1, i) : ColorUtil
              .getPieChartColor(-1, i),
          value: billMoney,
          title: "$categoryName",
          radius: 120,
        );
      });
    }
  }

  Future<List<double>> getLineChartData(int billProperty, int year,
      int month) async {
    int currYear = DateTime
        .now()
        .year;
    int currMonth = DateTime
        .now()
        .month;
    int currDay = DateTime
        .now()
        .day;

    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );

    List<double> dataList = List();

    if (year == currYear && month == currMonth) {
      for (int i = 1; i <= currDay; i++) {
        int start = TimeUtil.getStartOfDay(currYear, currMonth, i);
        int end = TimeUtil.getEndOfDay(currYear, currMonth, i);
        List<Map<String, dynamic>> result = await database.query(
            Constant.BILL_TABLE,
            columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
            where:
            "BillUser = ? and BillProperty = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ?",
            whereArgs: [userId, "$billProperty", "$start", "$end"]);
        List.generate(result.length, (index) {
          dataList.add(result[index]["BillMoney"]);
        });
      }
    } else {
//      await database.transaction((txn)async{
//        for (int i = 1; i <= TimeUtil.getDaysOfMonth(year, month); i++) {
//
//          print("=========================== $i");
//
//          int start = TimeUtil.getStartOfDay(year, month, i);
//          int end = TimeUtil.getEndOfDay(year, month, i);
//          List<Map<String, dynamic>> result = await txn.query(
//              Constant.BILL_TABLE,
//              columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
//              where:
//              "BillUser = ? and BillProperty = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ?",
//              whereArgs: [userId, "$billProperty", "$start", "$end"]);
//          List.generate(result.length, (index){
//            dataList.add(result[index]["BillMoney"]);
//          });
//        }
//      });
      for (int i = 1; i <= TimeUtil.getDaysOfMonth(year, month); i++) {
        int start = TimeUtil.getStartOfDay(year, month, i);
        int end = TimeUtil.getEndOfDay(year, month, i);
        List<Map<String, dynamic>> result = await database.query(
            Constant.BILL_TABLE,
            columns: ["ifnull(sum(BillMoney),0.0) as BillMoney"],
            where:
            "BillUser = ? and BillProperty = ? and BillStatus = 1 and BillDate >= ? and BillDate <= ?",
            whereArgs: [userId, "$billProperty", "$start", "$end"]);
        List.generate(result.length, (index) {
          dataList.add(result[index]["BillMoney"]);
        });
      }
    }
    database.close();
    return dataList;
  }
}
