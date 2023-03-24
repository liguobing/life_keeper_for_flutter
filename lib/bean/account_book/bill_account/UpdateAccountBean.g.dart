// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateAccountBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAccountBean _$UpdateAccountBeanFromJson(Map<String, dynamic> json) {
  return UpdateAccountBean()
    ..oldBillAccountObjectId = json['oldBillAccountObjectId'] as String
    ..oldBillAccountType = json['oldBillAccountType'] as int
    ..oldBillAccountUpdateTime = json['oldBillAccountUpdateTime'] as int
    ..newBillAccount = json['newBillAccount'] == null
        ? null
        : BillAccount.fromJson(json['newBillAccount'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateAccountBeanToJson(UpdateAccountBean instance) =>
    <String, dynamic>{
      'oldBillAccountObjectId': instance.oldBillAccountObjectId,
      'oldBillAccountType': instance.oldBillAccountType,
      'oldBillAccountUpdateTime': instance.oldBillAccountUpdateTime,
      'newBillAccount': instance.newBillAccount,
    };
