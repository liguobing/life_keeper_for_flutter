// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillShop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillShop _$BillShopFromJson(Map<String, dynamic> json) {
  return BillShop()
    ..objectId = json['objectId'] as String
    ..shopId = json['shopId'] as String
    ..shopName = json['shopName'] as String
    ..shopIcon = json['shopIcon'] as String
    ..shopUser = json['shopUser'] as String
    ..shopStatus = json['shopStatus'] as int
    ..shopType = json['shopType'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int
    ..orderIndex = json['orderIndex'] as int;
}

Map<String, dynamic> _$BillShopToJson(BillShop instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'shopIcon': instance.shopIcon,
      'shopUser': instance.shopUser,
      'shopStatus': instance.shopStatus,
      'shopType': instance.shopType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'orderIndex': instance.orderIndex,
    };
