import 'BillAccount.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UpdateAccountBean.g.dart';


@JsonSerializable()
class UpdateAccountBean {
  /// 旧账单账户 ObjectId
  String oldBillAccountObjectId;

  /// 旧账单账户类别
  int oldBillAccountType;

  /// 旧账单账户更新时间
  int oldBillAccountUpdateTime;

  /// 新账单账户列表
  BillAccount newBillAccount;


  UpdateAccountBean();

  String getOldBillAccountObjectId() {
    return oldBillAccountObjectId;
  }

  void setOldBillAccountObjectId(String oldBillAccountObjectId) {
    this.oldBillAccountObjectId = oldBillAccountObjectId;
  }

  int getOldBillAccountType() {
    return oldBillAccountType;
  }

  void setOldBillAccountType(int oldBillAccountType) {
    this.oldBillAccountType = oldBillAccountType;
  }

  int getOldBillAccountUpdateTime() {
    return oldBillAccountUpdateTime;
  }

  void setOldBillAccountUpdateTime(int oldBillAccountUpdateTime) {
    this.oldBillAccountUpdateTime = oldBillAccountUpdateTime;
  }

  BillAccount getNewBillAccount() {
    return newBillAccount;
  }

  void setNewBillAccount(BillAccount newBillAccount) {
    this.newBillAccount = newBillAccount;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "OldBillAccountObjectId": oldBillAccountObjectId,
      "OldBillAccountType": oldBillAccountType,
      "OldBillAccountUpdateTime": oldBillAccountUpdateTime,
      "NewBillAccount": newBillAccount,
    };
    return map;
  }

  factory UpdateAccountBean.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccountBeanFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccountBeanToJson(this);
}
