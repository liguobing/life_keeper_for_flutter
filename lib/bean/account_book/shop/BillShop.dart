import 'package:json_annotation/json_annotation.dart';

part 'BillShop.g.dart';
/// 账单商家原型
///
/// @author LGB

@JsonSerializable()
class BillShop {
  /// ObjectId
  String objectId;

  /// 商家 ID
  String shopId;

  /// 商家名称
  String shopName;

  /// 商家图标
  String shopIcon;

  /// 商家用户
  String shopUser;

  /// 商家状态
  /// 1:正常商家   -1：非正常商家
  int shopStatus;

  /// 商家类型
  /// 0：正常  1：已删除  2：已修改
  int shopType;

  /// 创建时间
  int createTime;

  /// 更新时间
  int updateTime;

  ///排序下标
  int orderIndex;


  BillShop();

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String getShopId() {
    return shopId;
  }

  void setShopId(String shopId) {
    this.shopId = shopId;
  }

  String getShopName() {
    return shopName;
  }

  void setShopName(String shopName) {
    this.shopName = shopName;
  }

  String getShopIcon() {
    return shopIcon;
  }

  void setShopIcon(String shopIcon) {
    this.shopIcon = shopIcon;
  }

  String getShopUser() {
    return shopUser;
  }

  void setShopUser(String shopUser) {
    this.shopUser = shopUser;
  }

  int getShopStatus() {
    return shopStatus;
  }

  void setShopStatus(int shopStatus) {
    this.shopStatus = shopStatus;
  }

  int getShopType() {
    return shopType;
  }

  void setShopType(int shopType) {
    this.shopType = shopType;
  }

  int getCreateTime() {
    return createTime;
  }

  void setCreateTime(int createTime) {
    this.createTime = createTime;
  }

  int getUpdateTime() {
    return updateTime;
  }

  void setUpdateTime(int updateTime) {
    this.updateTime = updateTime;
  }

  int getOrderIndex() {
    return orderIndex;
  }

  void setOrderIndex(int orderIndex) {
    this.orderIndex = orderIndex;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "ObjectId": objectId,
      "ShopId": shopId,
      "ShopName": shopName,
      "ShopIcon": shopIcon,
      "ShopUser": shopUser,
      "ShopStatus": shopStatus,
      "ShopType": shopType,
      "CreateTime": createTime,
      "UpdateTime": updateTime,
      "OrderIndex": orderIndex,
    };
    return map;
  }

  factory BillShop.fromJson(Map<String, dynamic> json) =>
      _$BillShopFromJson(json);

  Map<String, dynamic> toJson() => _$BillShopToJson(this);
}
