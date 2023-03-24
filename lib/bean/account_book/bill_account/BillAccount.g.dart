// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillAccount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillAccount _$BillAccountFromJson(Map<String, dynamic> json) {
  return BillAccount()
    ..objectId = json['objectId'] as String
    ..accountId = json['accountId'] as String
    ..accountUser = json['accountUser'] as String
    ..accountName = json['accountName'] as String
    ..accountStatus = json['accountStatus'] as int
    ..accountType = json['accountType'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int
    ..orderIndex = json['orderIndex'] as int;
}

Map<String, dynamic> _$BillAccountToJson(BillAccount instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'accountId': instance.accountId,
      'accountUser': instance.accountUser,
      'accountName': instance.accountName,
      'accountStatus': instance.accountStatus,
      'accountType': instance.accountType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'orderIndex': instance.orderIndex,
    };
