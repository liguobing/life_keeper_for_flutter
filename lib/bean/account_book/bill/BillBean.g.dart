// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillBean _$BillBeanFromJson(Map<String, dynamic> json) {
  return BillBean()
    ..objectId = json['objectId'] as String
    ..billId = json['billId'] as String
    ..billDate = json['billDate'] as int
    ..billMoney = (json['billMoney'] as num)?.toDouble()
    ..billProperty = json['billProperty'] as int
    ..billCategory = json['billCategory'] as String
    ..billAccount = json['billAccount'] as String
    ..billRemark = json['billRemark'] as String
    ..billUser = json['billUser'] as String
    ..billShop = json['billShop'] as String
    ..billStatus = json['billStatus'] as int
    ..billType = json['billType'] as int
    ..billImage = json['billImage'] as String
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int;
}

Map<String, dynamic> _$BillBeanToJson(BillBean instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'billId': instance.billId,
      'billDate': instance.billDate,
      'billMoney': instance.billMoney,
      'billProperty': instance.billProperty,
      'billCategory': instance.billCategory,
      'billAccount': instance.billAccount,
      'billRemark': instance.billRemark,
      'billUser': instance.billUser,
      'billShop': instance.billShop,
      'billStatus': instance.billStatus,
      'billType': instance.billType,
      'billImage': instance.billImage,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
