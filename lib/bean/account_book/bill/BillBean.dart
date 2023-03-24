import 'package:json_annotation/json_annotation.dart';

part 'BillBean.g.dart';
// 账单原型
// @author LGB

@JsonSerializable()
class BillBean {
  // ObjectId
  String objectId;

  // 账单 ID
  String billId;

  // 账单日期
  int billDate;

  // 账单金额
  double billMoney;

  // 账单属性：
  // 1 ： 收入；-1 ： 支出
  int billProperty;

  // 账单分类
  String billCategory;

  // 账单账户
  String billAccount;

  // 账单备注
  String billRemark;

  // 账单用过户
  String billUser;

  // 账单商家
  String billShop;

  // 账单状态
  // 1:正常账单   -1：非正常账单
  int billStatus;

  // 账单类型
  // 0：正常  1：已删除  2：已修改
  int billType;

  // 账单图片
  String billImage;

  // 创建日期
  int createTime;

  // 修改日期
  int updateTime;


  BillBean();

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String getBillId() {
    return billId;
  }

  void setBillId(String billId) {
    this.billId = billId;
  }

  int getBillDate() {
    return billDate;
  }

  void setBillDate(int billDate) {
    this.billDate = billDate;
  }

  double getBillMoney() {
    return billMoney;
  }

  void setBillMoney(double billMoney) {
    this.billMoney = billMoney;
  }

  int getBillProperty() {
    return billProperty;
  }

  void setBillProperty(int billProperty) {
    this.billProperty = billProperty;
  }

  String getBillCategory() {
    return billCategory;
  }

  void setBillCategory(String billCategory) {
    this.billCategory = billCategory;
  }

  String getBillAccount() {
    return billAccount;
  }

  void setBillAccount(String billAccount) {
    this.billAccount = billAccount;
  }

  String getBillRemark() {
    return billRemark;
  }

  void setBillRemark(String billRemark) {
    this.billRemark = billRemark;
  }

  String getBillUser() {
    return billUser;
  }

  void setBillUser(String billUser) {
    this.billUser = billUser;
  }

  String getBillShop() {
    return billShop;
  }

  void setBillShop(String billShop) {
    this.billShop = billShop;
  }

  int getBillStatus() {
    return billStatus;
  }

  void setBillStatus(int billStatus) {
    this.billStatus = billStatus;
  }

  int getBillType() {
    return billType;
  }

  void setBillType(int billType) {
    this.billType = billType;
  }

  String getBillImage() {
    return billImage;
  }

  void setBillImage(String billImage) {
    this.billImage = billImage;
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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "ObjectId": objectId,
      "BillId": billId,
      "BillDate": billDate,
      "BillMoney": billMoney,
      "BillProperty": billProperty,
      "BillCategory": billCategory,
      "BillAccount": billAccount,
      "BillRemark": billRemark,
      "BillUser": billUser,
      "BillShop": billShop,
      "BillStatus": billStatus,
      "BillType": billType,
      "BillImage": billImage,
      "CreateTime": createTime,
      "UpdateTime": updateTime,
    };
    return map;
  }

  factory BillBean.fromJson(Map<String, dynamic> json) =>
      _$BillBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BillBeanToJson(this);

}
