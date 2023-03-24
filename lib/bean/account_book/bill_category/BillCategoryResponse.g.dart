// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillCategoryResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillCategoryResponse _$BillCategoryResponseFromJson(Map<String, dynamic> json) {
  return BillCategoryResponse()
    ..responseCode = json['responseCode'] as int
    ..responseList = (json['responseList'] as List)
        ?.map((e) =>
            e == null ? null : BillCategory.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BillCategoryResponseToJson(
        BillCategoryResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseList': instance.responseList,
    };
