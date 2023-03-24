// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillResponse _$BillResponseFromJson(Map<String, dynamic> json) {
  return BillResponse()
    ..responseCode = json['responseCode'] as int
    ..responseList = (json['responseList'] as List)
        ?.map((e) =>
            e == null ? null : BillBean.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BillResponseToJson(BillResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseList': instance.responseList,
    };
