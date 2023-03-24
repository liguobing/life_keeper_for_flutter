import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lifekeeperforflutter/bean/account_book/shop/BillShop.dart';
import 'package:lifekeeperforflutter/bean/account_book/shop/SearchBillShop.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BillShopRouteModel {
  ///查找用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  ///获取常用商家
  Future<List<String>> getOftenUseShop() async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(Constant.BILL_TABLE,
        distinct: true,
        columns: ["BillShop"],
        where: "BillStatus = 1 and BillUser = ? and BillShop is not null",
        whereArgs: [userId]);
    database.close();
    return List.generate(maps.length, (i) {
      return maps[i]["BillShop"];
    });
  }

  ///获取自定义商家
  Future<List<String>> getAllCustomShop() async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_SHOP_TABLE,
        distinct: true,
        columns: ["ShopName"],
        where: "ShopStatus = 1 and ShopUser = ?",
        whereArgs: [userId]);
    database.close();
    return List.generate(maps.length, (i) {
      return maps[i]["ShopName"];
    });
  }

  ///获取附近商家分类
  Future<List<String>> getNearShopCategory() async {
    List<String> nearPoiCategoryList = List();
    nearPoiCategoryList.add("汽车服务");
    nearPoiCategoryList.add("汽车销售");
    nearPoiCategoryList.add("汽车维修");
    nearPoiCategoryList.add("摩托车服务");
    nearPoiCategoryList.add("餐饮服务");
    nearPoiCategoryList.add("购物服务");
    nearPoiCategoryList.add("生活服务");
    nearPoiCategoryList.add("体育休闲服务");
    nearPoiCategoryList.add("医疗保健服务");
    nearPoiCategoryList.add("住宿服务");
    nearPoiCategoryList.add("风景名胜");
    nearPoiCategoryList.add("商务住宅");
    nearPoiCategoryList.add("政府机构及社会团体");
    nearPoiCategoryList.add("科教文化服务");
    nearPoiCategoryList.add("交通设施服务");
    nearPoiCategoryList.add("金融保险服务");
    nearPoiCategoryList.add("公司企业");
    nearPoiCategoryList.add("道路附属设施");
    nearPoiCategoryList.add("地名地址信息");
    nearPoiCategoryList.add("公共设施");
    nearPoiCategoryList.add("事件活动");
    nearPoiCategoryList.add("室内设施");
    nearPoiCategoryList.add("通行设施");
    return nearPoiCategoryList;
  }

  ///附近商家
  Future<List<String>> getNearPois(
      BuildContext context, String type, int pageNum) async {
    List<String> list = List();
    try {
      final location = await AmapLocation.fetchLocation();
      List<Poi> pois = await AmapSearch.searchAround(
        location.latLng,
        type: type,
        page: pageNum,
      );
      pois.forEach((element) {
        list.add(element.title);
      });
    } on Exception {
      print(
          "========================= getNearPois catch exception =========================");
    }
    return list;
  }

  Future<bool> shopIsExists(String newShopName) async {
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> maps = await database.query(
        Constant.BILL_SHOP_TABLE,
        distinct: true,
        columns: ["ObjectId"],
        where: "ShopUser = ? and ShopStatus = 1 and ShopName = ?",
        whereArgs: [userId, newShopName]);
    database.close();
    return maps.length > 0;
  }

  Future<bool> addNewShop(String newShopName) async {
    bool result = false;
    String userId = await getUserId();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async{
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      BillShop shop = BillShop();
      shop.setObjectId(StringUtil.getRandomString());
      shop.setShopId(StringUtil.getRandomString());
      shop.setShopName(newShopName);
      shop.setShopUser(userId);
      shop.setShopStatus(1);
      shop.setShopType(0);
      shop.setCreateTime(currentTime);
      shop.setUpdateTime(0);
      int insertColumnCount = await txn.insert(Constant.BILL_SHOP_TABLE, shop.toMap());
      if(insertColumnCount>0){
        List<BillShop> list = List();
        list.add(shop);
        Dio dio = Dio();
        Response<bool> resp = await dio.post(
            "${Constant.CLOUD_ADDRESS}/LifeKeeper/AddBillShop",
            data: json.encode(list));
        result = resp.data;
      }
    });
    database.close();
    return result;
  }
}
