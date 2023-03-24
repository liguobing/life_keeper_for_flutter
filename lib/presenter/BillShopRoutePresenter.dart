import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/shop/SearchBillShop.dart';
import 'package:lifekeeperforflutter/model/BillShopRouteModel.dart';
import 'package:lifekeeperforflutter/view/route/BillShopRoute.dart';
import 'package:permission_handler/permission_handler.dart';

class BillShopRoutePresenter {
  BillShopRouteState view;
  BillShopRouteModel model;

  BillShopRoutePresenter(BillShopRouteState view) {
    this.view = view;
    model = BillShopRouteModel();
  }

  ///检查权限
  Future<int> checkPermission(PermissionStatus status) async {
    int permissionStatus = 0;
    switch (status) {
      //还没请求过
      case PermissionStatus.unknown:
        permissionStatus = 0;
        break;
      //已经通过权限申请
      case PermissionStatus.granted:
        permissionStatus = 1;
        break;
      //已经拒绝权限申请
      case PermissionStatus.denied:
        permissionStatus = -1;
        break;
      //已经拒绝，并选择用不提醒
      case PermissionStatus.neverAskAgain:
        permissionStatus = -2;
        break;
      //iOS专用
      default:
        permissionStatus = -3;
        break;
    }
    return permissionStatus;
  }

  ///关键字搜索商家
  void keyWordSearch(BuildContext context, String keyWord, int pageNum) async {
    view.showLoadingDialog(context, "请稍后...");
    try {
      List<SearchBillShop> list = List();
      final location = await AmapLocation.fetchLocation();
      if (location.latLng.latitude == 0) {
        view.showSnackBar(context, "请检查定位开关是否打开");
        view.hideDialog();
        view.hideDialog();
        return;
      }

      if (keyWord.length == 0) {
        view.showSnackBar(context, "没有输入关键字");
        view.hideDialog();
        view.hideDialog();
        return;
      }

      List<Poi> poiList = await AmapSearch.searchKeyword(keyWord,
          city: location.city, page: pageNum);

      poiList.forEach((element) {
        SearchBillShop shop = SearchBillShop();
        shop.setShopName(element.title);
        shop.setShopAddress(element.address);
        list.add(shop);
      });
      if (list.length < 20) {
        SearchBillShop shop = SearchBillShop();
        shop.setShopName("没有了");
        shop.setShopAddress("");
        list.add(shop);
      } else {
        SearchBillShop shop = SearchBillShop();
        shop.setShopName("下一页");
        shop.setShopAddress("");
        list.add(shop);
      }
      view.updateKeyWordSearchListView(list, pageNum, poiList.length >= 20);
    } on Exception {
      print(
          "========================= keyWordSearch catch exception =========================");
    } finally {
      view.hideDialog();
    }
  }

  ///根据选择的商家类型，更新 UI
  ///0.经常使用
  ///1.所有商家
  ///2.附近商家分类
  ///3.该分类下的附近商家
  void selectShopCategory(BuildContext context, int shopType) async {
    view.showLoadingDialog(context, "请稍后...");
    try {
      switch (shopType) {
        case 0:
          view.updateShopType(0);
          view.updateShopListView2(0, await model.getOftenUseShop(), 0, true);
          break;
        case 1:
          view.updateShopType(1);
          view.updateShopListView2(1, await model.getAllCustomShop(), 0, true);
          break;
        case 2:
          //如果选择的是附近商家，则先判断是否有定位权限并开启了定位开关
          PermissionStatus status = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.location);
          if (status != PermissionStatus.granted) {
            view.showSnackBar(context, "没有定位权限");
          } else {
            Location location = await AmapLocation.fetchLocation();
            if (location.latLng.latitude == 0 ||
                location.latLng.longitude == 0) {
              view.showSnackBar(context, "定位开关没有打开");
            } else {
              view.updateShopType(2);
              view.updateShopListView2(
                  2, await model.getNearShopCategory(), 0, true);
            }
          }
          break;
        case 3:
          //如果选择的是附近商家分类，则先判断是否有定位权限并开启了定位开关
          PermissionStatus status = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.location);
          if (status != PermissionStatus.granted) {
            view.showSnackBar(context, "没有定位权限");
          } else {
            Location location = await AmapLocation.fetchLocation();
            if (location.latLng.latitude == 0 ||
                location.latLng.longitude == 0) {
              view.showSnackBar(context, "定位开关没有打开");
            } else {
              view.updateShopType(2);
            }
          }
          break;
      }
    } on Exception {
      print(
          "========================= selectShopCategory catch exception =========================");
    } finally {
      view.hideDialog();
    }
  }

  void selectNearShop(
      BuildContext context, String categoryName, int pageNum) async {
    view.showLoadingDialog(context, "请稍后...");
    try {
      //如果选择的是附近商家分类，则先判断是否有定位权限并开启了定位开关
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);
      if (status != PermissionStatus.granted) {
        view.showSnackBar(context, "没有定位权限");
      } else {
        Location location = await AmapLocation.fetchLocation();
        if (location.latLng.latitude == 0 || location.latLng.longitude == 0) {
          view.showSnackBar(context, "定位开关没有打开");
        } else {
          view.updateShopType(2);
          view.updateShopListView2(
              3,
              await model.getNearPois(context, categoryName, pageNum),
              pageNum,
              true);
        }
      }
    } on Exception {
      print(
          "========================= selectNearShop catch exception =========================");
    } finally {
      view.hideDialog();
    }
  }

  void addNewShop(BuildContext context, String newShopName) async {
    if(newShopName.length == 0){
      view.showSnackBar(context, "商家名称不能为空");
      return;
    }
    view.showLoadingDialog(context, "请稍后...");
    try {
      bool exists = await model.shopIsExists(newShopName);
      if (exists) {
        view.showSnackBar(context, "该商家已经存在了");
      } else {
        bool saveSuccessful = await model.addNewShop(newShopName);
        if (saveSuccessful) {
          view.updateShopType(1);
          view.updateShopListView2(1, await model.getAllCustomShop(), 0, true);
          view.showSnackBar(context, "添加成功");
        } else {
          view.showSnackBar(context, "添加失败，请稍后重试");
        }
      }
    } on Exception {
      print(
          "========================= addNewShop catch exception =========================");
    } finally {
      view.hideDialog();
    }
  }
}
