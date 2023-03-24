// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SearchBillShop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchBillShop _$SearchBillShopFromJson(Map<String, dynamic> json) {
  return SearchBillShop()
    ..objectId = json['objectId'] as String
    ..shopId = json['shopId'] as String
    ..shopName = json['shopName'] as String
    ..shopAddress = json['shopAddress'] as String
    ..shopIcon = json['shopIcon'] as String
    ..shopUser = json['shopUser'] as String
    ..shopStatus = json['shopStatus'] as int
    ..shopType = json['shopType'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int;
}

Map<String, dynamic> _$SearchBillShopToJson(SearchBillShop instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'shopAddress': instance.shopAddress,
      'shopIcon': instance.shopIcon,
      'shopUser': instance.shopUser,
      'shopStatus': instance.shopStatus,
      'shopType': instance.shopType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
