// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillShopResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillShopResponse _$BillShopResponseFromJson(Map<String, dynamic> json) {
  return BillShopResponse()
    ..responseCode = json['responseCode'] as int
    ..responseList = (json['responseList'] as List)
        ?.map((e) =>
            e == null ? null : BillShop.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BillShopResponseToJson(BillShopResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseList': instance.responseList,
    };
