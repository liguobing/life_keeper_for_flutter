import 'package:json_annotation/json_annotation.dart';

///账单账户原型
///@author LGB

part 'BillAccount.g.dart';

@JsonSerializable()
class BillAccount {
  // ObjectId
  String objectId;

  // 账户ID
  String accountId;

  // 账户用户
  String accountUser;

  // 账户名称
  String accountName;

  // 账户状态
  // 1:正常账户   -1：非正常账户
  int accountStatus;

  // 账户类别
  // 0：正常  1：已删除  2：已修改
  int accountType;

  // 创建时间
  int createTime;

  // 更新时间
  int updateTime;

  // 排序下标
  int orderIndex;

  BillAccount();

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String getAccountId() {
    return accountId;
  }

  void setAccountId(String accountId) {
    this.accountId = accountId;
  }

  String getAccountUser() {
    return accountUser;
  }

  void setAccountUser(String accountUser) {
    this.accountUser = accountUser;
  }

  String getAccountName() {
    return accountName;
  }

  void setAccountName(String accountName) {
    this.accountName = accountName;
  }

  int getAccountStatus() {
    return accountStatus;
  }

  void setAccountStatus(int accountStatus) {
    this.accountStatus = accountStatus;
  }

  int getAccountType() {
    return accountType;
  }

  void setAccountType(int accountType) {
    this.accountType = accountType;
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
      "AccountId": accountId,
      "AccountUser": accountUser,
      "AccountName": accountName,
      "AccountStatus": accountStatus,
      "AccountType": accountType,
      "CreateTime": createTime,
      "UpdateTime": updateTime,
      "OrderIndex": orderIndex,
    };
    return map;
  }

  factory BillAccount.fromJson(Map<String, dynamic> json) =>
      _$BillAccountFromJson(json);

  Map<String, dynamic> toJson() => _$BillAccountToJson(this);
}
