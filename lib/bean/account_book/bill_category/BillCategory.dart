import 'package:json_annotation/json_annotation.dart';



part 'BillCategory.g.dart';

///
///账单分类原型
///@author LGB
///
///

@JsonSerializable()
class BillCategory {
  // ObjectId 唯一标识
  String objectId;

  // 分类 ID
  String categoryId;

  // 分类用户
  String categoryUser;

  // 分类名称
  String categoryName;

  // 收入/支出
  int isIncome;

  // 分类状态
  // 1:正常账单   -1：非正常账单
  int categoryStatus;

  // 分类类别
  // 0：正常  1：已删除  2：已修改
  int categoryType;

  // 创建时间
  int createTime;

  // 修改时间
  int updateTime;

  // 排序下标
  int orderIndex;


  BillCategory();

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String getCategoryId() {
    return categoryId;
  }

  void setCategoryId(String categoryId) {
    this.categoryId = categoryId;
  }

  String getCategoryUser() {
    return categoryUser;
  }

  void setCategoryUser(String categoryUser) {
    this.categoryUser = categoryUser;
  }

  String getCategoryName() {
    return categoryName;
  }

  void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }

  int getIsIncome() {
    return isIncome;
  }

  void setIsIncome(int isIncome) {
    this.isIncome = isIncome;
  }

  int getCategoryStatus() {
    return categoryStatus;
  }

  void setCategoryStatus(int categoryStatus) {
    this.categoryStatus = categoryStatus;
  }

  int getCategoryType() {
    return categoryType;
  }

  void setCategoryType(int categoryType) {
    this.categoryType = categoryType;
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
      "CategoryId": categoryId,
      "CategoryUser": categoryUser,
      "CategoryName": categoryName,
      "IsIncome": isIncome,
      "CategoryStatus": categoryStatus,
      "CategoryType": categoryType,
      "CreateTime": createTime,
      "UpdateTime": updateTime,
      "OrderIndex": orderIndex,
    };
    return map;
  }

  factory BillCategory.fromJson(Map<String, dynamic> json) =>
      _$BillCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BillCategoryToJson(this);
}
